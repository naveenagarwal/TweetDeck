class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  before_action :check_if_editable, only: [:edit, :update]
  # GET /posts
  # GET /posts.json
  def index
    page = params[:page] || 1
    @posts = current_user.posts.page page
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @seralized_post = PostSeralizer.new(@post, 'twitter')
  end

  # GET /posts/new
  def new
    content = current_user.posts.find_by(id: params[:template]).try(:content)
    @post = Post.new(content: content)
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        @post.schedule(current_user.profile('twitter'), DEFAULT_QUEUE) if @post.ready? &&
          @post.scheduled_at.present?

        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        @post.schedule(current_user.profile('twitter'), DEFAULT_QUEUE) if @post.ready? &&
          @post.scheduled_at.present?
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_update
    bulk_permitted_params
    current_user.posts.where(id: params[:ids].map(&:to_i)).update_all(
        scheduled_at: params[:data][:scheduled_at]
      )
    current_user.posts.where(id: params[:ids].map(&:to_i), state: "tweeted").update_all(
        state: "retweet_ready"
      )
    profile = current_user.profiles.where(provider: 'twitter').first
    current_user.posts.where(id: params[:ids]).each do |post|
      post.schedule(profile, DEFAULT_QUEUE)
    end
    render json: { message: 'Posts were successfully updated.' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = current_user.posts.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params[:post][:user_id] = current_user.id
      params[:post][:scheduled_at] = params[:post][:scheduled_at].to_time.localtime if params[:post][:scheduled_at].present?
      params[:post][:scheduled_at] = Time.now if params[:tweet_now] == "on"
      # params.require(:post).permit(:content, :state, :scheduled_at, :user_id, media_attributes: [:upload_doc])
      params.require(:post).permit!
    end

    def bulk_permitted_params
      params[:data][:scheduled_at] = params[:data][:scheduled_at].to_time.localtime if params[:data][:scheduled_at].present?
      params.require(:data).permit(:scheduled_at)
    end

    def check_if_editable
      return redirect_to @post, alert: "You can not edit this post" unless @post.editable?
    end
end
