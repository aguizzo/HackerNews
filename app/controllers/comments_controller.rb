class CommentsController < ApplicationController
    def create
          
        @comment = current_user.comments.new(comment_params)
        if !@comment.save
          flash[:notice] = @comment.errors.full_messages.to_sentence
        end
        redirect_to submission_path(params[:submission_id])

    end

    def createComment
      @comment = Comment.new(comment_params)
      @comment.user_id = @user[0].id
      @comment.submission_id = params[:id]
      if @comment.text.empty?
        render :json => {:error => "The text is empty"}
      else
        @comment.save
        render json: @comment
      end
    end

    def upvotec
        comment = Comment.find_by(id: params[:id])
      
        if current_user.upvotecd?(comment)
          current_user.remove_votec(comment)
        else
          current_user.upvotec(comment)
        end
      
        @s = Submission.find_by_id(comment.submission_id)
        redirect_to @s
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
        params.require(:comment).permit(:content, :parent_id ).merge(submission_id: params[:submission_id])
    end
end
