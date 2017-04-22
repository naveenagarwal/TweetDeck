class PostDocumentWorker
  include Sidekiq::Worker

  def perform(docuemnt_id)
    # Do something
  end
end
