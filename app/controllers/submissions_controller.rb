class SubmissionsController < ApplicationController
  before_action :set_submission, only:[:show, :edit, :update, :destroy, :upVotes, :upvote]

  # GET /submissions or /submissions.json
  def index
  #  @submissions = Submission.all
  @submissions = Submission.where.not(url: "").all.sort_by{|s| s.upvotes}.reverse
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @submissions}
      end
    end

  def ask
  #  @submissions = Submission.all
    @submissions = Submission.where(url: "").all.sort_by{|s| s.upvotes}.reverse
    respond_to do |format|
      format.html {render :ask}
      format.json {render json: @submissions}
    end
  end

  def newest
    @submissions = Submission.all.order('created_at DESC')
    respond_to do |format|
      format.html {render :newest}
      format.json {render json: @submissions}
    end
  end

  # GET /submissions/1 or /submissions/1.json
  def show
    respond_to do |format|
      format.html {render :show}
      format.json {render json: @submission}
    end
  end

  def submissionComments
    @comments = Comment.where(submission_id: params[:id]).order("created_at DESC")
    if @comments[0] == nil
      render :json => {"Error": "Comments not found"}
    else
      render json: @comments
    end
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  def usersubmissions
      @user = User.find(params[:user])
      @submissions = Submission.where("user_id=?", params[:user]).order("created_at DESC")
      respond_to do |format|
        format.html {  render :usersubmissions}
        format.json { render json: @submission}
      end
  end

  def apiUserSubmissions
    begin
      @user = User.find(params[:id])
      if @user.nil? 
        render :json => {"Error": "User not found"}
      else 
        @submissions = Submission.where("user_id=?", params[:id]).order("created_at DESC")
        if @submissions[0] == nil
          render :json => {"Error": "Comments not found"}
        else
          render json: @submissions
        end
      end
    rescue ActiveRecord::RecordNotFound
      render :json => {"Error": "User not found"}, status: :not_found
    end
  end

  def userasks
    @user = User.find(params[:user])
    @submissions = Submission.where("user_id=?", params[:user]).order("created_at DESC")
    respond_to do |format|
      format.html {  render :userasks}
      format.json { render json: @submission}
    end
  end
 
  def uservoted
    @user = User.find(params[:user])
    @votes = Vote.where("user_id=?", params[:user])
    @submissions = Submission.where(current_user.upvoted?)
  end

  # GET /submissions/1/edit
  def edit
    
  end

  # POST /submissions or /submissions.json
  def create
    
    @submission = Submission.new(submission_params)
    key = request.headers[:HTTP_X_API_KEY]
    tmp = nil
    if key
      tmp = User.where("token=?", key).first
      if tmp
        @submission.user = tmp
      end
    else 
      @submission.user = current_user
    end
    @submission2 = Submission.where(url: submission_params[:url])
    if @submission2.exists? && !@submission2.first[:url].blank?
      respond_to do |format|
        if key
          if tmp 
            format.html {redirect_to submission_path(@submission2.first)}
            format.json {render json: @submission2.first}
          else
            format.json { head :forbidden }
          end
        elsif current_user
          format.html {redirect_to submission_path(@submission2.first)}
          format.json {render json: @submission2.first}
        else 
          format.json { head :unauthorized}
        end
      end
    else
      if !submission_params[:url].blank? && !submission_params[:text].blank?
        @submission.text = ""
        @comment = Comment.new
        @comment.content = submission_params[:text]
        @comment.user_id = @submission.user_id
       end
      respond_to do |format|
        if @submission.save
          if !submission_params[:url].blank? && !submission_params[:text].blank?
            @comment.submission_id = @submission.id
            @comment.save
          end
          format.html { redirect_to @submission, notice: "Submission was successfully created." }
          format.json { render :show, status: :created, location: @submission }
        else
          format.html { render :new, status: :unprocessable_entity }
          if tmp
            format.json { render json: @submission.errors, status: :bad_request }
          else
            format.json { head :forbidden }
          end
        end
      end
    end

  end

  def upvote
    @submission = Submission.find_by(id: params[:id])
    key = request.headers[:HTTP_X_API_KEY]
    tmp = nil
    us = nil
    if key
      tmp = User.where("token=?", key).first
      if tmp
        us = tmp
      end
    else 
      us = current_user
    end

    if !us.upvoted?(@submission)
      us.upvote(@submission)
      @submission.upVotes = @submission.upVotes + 1
      @submission.save
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.json { render json: @submission }
        end
    else
      render :json => {"Error": "Submission ja votada"}, status: :bad_request
    end
  end

  def downvote
    @submission = Submission.find_by(id: params[:id])
    key = request.headers[:HTTP_X_API_KEY]
    tmp = nil
    us = nil
    if key
      tmp = User.where("token=?", key).first
      if tmp
        us = tmp
      end
    else 
      us = current_user
    end
    if us.upvoted?(@submission)
      us.remove_vote(@submission)
      @submission.upVotes = @submission.upVotes - 1
      @submission.save
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.json { render json: @submission }
        end
    else
      render :json => {"Error": "No pots desvotar una submission que no has votat"}, status: :bad_request
    end
  end

  # PATCH/PUT /submissions/1 or /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: "Submission was successfully updated." }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1 or /submissions/1.json
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, notice: "Submission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def submission_params
      params.require(:submission).permit(:title, :url, :text)
    end
end
