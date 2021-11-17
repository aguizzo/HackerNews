class SubmissionsController < ApplicationController
  before_action :set_submission, only:[:show, :edit, :update, :destroy, :upVotes, :upvote]

  # GET /submissions or /submissions.json
  def index
    @submissions = Submission.all
  #  @submissions = Submission.all.sort_by{|s| s.upVotes}.reverse
  end

  def ask
    @submissions = Submission.all
  #  @submissions = Submission.all.sort_by{|s| s.upVotes}.reverse
  end

  def newest
    @submissions = Submission.all.order('created_at DESC')
  end

  # GET /submissions/1 or /submissions/1.json
  def show
    
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
    @submission.user = current_user
    
    #pendent d'acabar
    submission = Submission.where(url: submission_params[:url])
    if submission.exists?
      s = Submission.where(url: submission_params[:url]).select(:id)
      s.to_s
      redirect_to submission_path
    else
      respond_to do |format|
        if @submission.save
          format.html { redirect_to @submission, notice: "Submission was successfully created." }
          format.json { render :show, status: :created, location: @submission }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @submission.errors, status: :unprocessable_entity }
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
  
    redirect_to root_path
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
