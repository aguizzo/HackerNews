class CommentsController < ApplicationController
    # def create
          
    #     @comment = current_user.comments.new(comment_params)
    #     if !@comment.save
    #       flash[:notice] = @comment.errors.full_messages.to_sentence
    #     end
    #     redirect_to submission_path(params[:submission_id])

    # end

    def create
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
      @comment = us.comments.new(comment_params)
      if @comment.content.empty?
        render :json => {:error => "The text is empty"}
      else
        @comment.save
        respond_to do |format|
          format.html {redirect_to submission_path(params[:submission_id])}
          format.json {render json: @comment, status: :created}
        end
      end
    end

  def upvotec
    @comment = Comment.find_by(id: params[:id])
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
      if us.upvotecd?(@comment)
        us.remove_votec(@comment)
      else
        us.upvotec(@comment)
      end
    @s = Submission.find_by_id(@comment.submission_id)
    respond_to do |format|
        format.html { redirect_to @s }
        format.json { render json: @comment }
      end
  end

    def show
      respond_to do |format|
        format.html {render :show}
        format.json {render json: @comment}
      end
    end

    def userComments
      @user = User.find(params[:id])
      if @user.nil? 
        render :json => {"Error": "User not found"}
      else 
        @comments = Comment.where("user_id=?", params[:id]).order("created_at DESC")
        if @comments[0] == nil
          render :json => {"Error": "Comments not found"}
        else
          render json: @comments
        end
      end
    end



    private

    def comment_params
        params.require(:comment).permit(:content, :parent_id, :submission_id ).merge(submission_id: params[:submission_id])
    end
end
