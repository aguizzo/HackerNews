class SubmissionsController < ApplicationController
  before_action :set_submission, only:[:show, :edit, :update, :destroy, :upVotes, :upvote]

  # GET /submissions or /submissions.json
  def index
  #  @submissions = Submission.all
    @submissions = Submission.all.sort_by{|s| s.upvotes}.reverse
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
  end

  # GET /submissions/1 or /submissions/1.json
  def show
    respond_to do |format|
      format.html {render :show}
      format.json {render json: @submission}
    end
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  def usersubmissions
      @user = User.find(params[:user])
      @submissions = Submission.where("user_id=?", params[:user]).order("created_at DESC")
  end

  def userasks
    @user = User.find(params[:user])
    @submissions = Submission.where("user_id=?", params[:user]).order("created_at DESC")
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
        format.html {redirect_to submission_path(@submission2.first)}
        format.json {render json: @submission2.first}
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
    submission = Submission.find_by(id: params[:id])
  
    if current_user.upvoted?(submission)
      current_user.remove_vote(submission)
    else
      current_user.upvote(submission)
    end
    redirect_back(fallback_location: root_path)
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
