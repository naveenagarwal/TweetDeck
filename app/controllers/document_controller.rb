class DocumentController < ApplicationController
  def create
    @document = current_user.documents.new
    @document.upload_doc = params[:file]
    @document.resource_type = params[:resource_type]

    respond_to do |format|
      if @document.save
        PostDocumentWorker.perform_async(@document.id)

        format.html { redirect_to posts_path, notice: 'Document enqueued for processing.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { redirect_to posts_path, alert: "Error in docuemnt. #{@document.errors.full_messages.join(', ')}" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end
end
