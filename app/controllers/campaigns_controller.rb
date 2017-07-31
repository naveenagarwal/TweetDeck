class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]

  # GET /campaigns
  # GET /campaigns.json
  def index
    @campaign = Campaign.new
    @campaigns = current_user.campaigns.all
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
  end

  # GET /campaigns/1/edit
  def edit
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = current_user.campaigns.new(campaign_params)
    document = @campaign.build_document(upload_doc: params[:document],
        user_id: current_user.id,
        resource_type: "Campaign"
      )
    respond_to do |format|
      if @campaign.save
        job_id = CampaignDocumentWorker.perform_async(@campaign.document.id)
        @campaign.document.update(job_id: job_id, queue_name: Campaign::QUEUE_NAME)
        format.html { redirect_to campaigns_path, notice: 'Campaign was successfully created.' }
        #format.json { render :show, status: :created, location: @campaign }
      else
        format.html {
          @campaigns = current_user.campaigns.all
          render :index
        }
        #format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = current_user.campaigns.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params[:campaign][:start_at] = params[:campaign][:start_at].to_time.localtime if params[:campaign][:start_at].present?
      params.require(:campaign).permit(:name, :start_at, :interval, :interval_type)
    end
end
