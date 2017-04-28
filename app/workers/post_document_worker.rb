class PostDocumentWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(docuemnt_id)
    begin
      document = Document.find(docuemnt_id)
      document.update(status: 'in progress')
      records_processed = 0
      posts_added = 0
      posts_rejected = 0
      filename = document.upload_doc.file.file
      profile = document.user.profiles.where(provider: 'twitter').first
      CSV.open(document.output_filename, "w") do |row|
        headers = CSV.open(filename, 'r') { |csv| csv.first } +  ['remarks']
        row << headers

        CSV.foreach(filename, headers: true) do |csv|
          records_processed += 1
          data = []
          begin
            scheduled_at = nil
            if csv['schedule at'].present?
              scheduled_at = csv['schedule at'].squish.downcase == "now" ?
                Time.now : csv['schedule at'].to_time.localtime rescue nil
            end

            if scheduled_at.blank? && profile.default_iterval_present?
              scheduled_at = profile.default_time_from_now
            end

            post = Post.create!(
              content: csv['content'].squish,
              state: (csv['state'] || 'drafted').squish,
              scheduled_at: scheduled_at,
              document_id: document.id,
              user_id: document.user_id,
              campaign_id: document.campaign_id
            )
            data = csv.to_h.values
            if post.valid?
              post.schedule(profile, DEFAULT_QUEUE)
              data << 'post created successfully'
              posts_added += 1
            else
              data << "error - #{post.errors.full_messages.join(' - ')}"
              posts_rejected += 1
            end
          rescue Exception => e
            data << "error - #{e.message}"
            posts_rejected += 1
          end
          row << data
        end
      end

      document.update(
        status: 'processed',
        records_processed: records_processed,
        posts_added: posts_added,
        posts_rejected: posts_rejected
      )
    rescue Exception => e
      document.update(status: "Error-#{e.message}")
    end
  end
end
