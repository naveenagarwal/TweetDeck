class DocumentController < ApplicationController

  def index
    page = params[:page] || 1
    @documents = current_user.documents.page page
  end

  def create
    @document = current_user.documents.new
    @document.upload_doc = params[:file]
    @document.resource_type = params[:resource_type]

    respond_to do |format|
      if @document.save
        job_id = PostDocumentWorker.perform_async(@document.id)
        @document.update(job_id: job_id, queue_name: 'default')
        format.html { redirect_to posts_path, notice: 'Document enqueued for processing.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { redirect_to posts_path, alert: "Error in docuemnt. #{@document.errors.full_messages.join(', ')}" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end
end
