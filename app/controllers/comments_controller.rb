class CommentsController < ApplicationController
    def create
          
        @comment = current_user.comments.new(comment_params)
        if !@comment.save
        flash[:notice] = @comment.errors.full_messages.to_sentence
         end
         redirect_to submission_path(params[:submission_id])

    end

    def upvotec
        comment = Comment.find_by(id: params[:id])
      
        if current_user.upvotecd?(comment)
          current_user.remove_votec(comment)
        else
          current_user.upvotec(comment)
        end
      
        redirect_to root_path
    end

    private

    def comment_params
        params.require(:comment).permit(:content, :parent_id ).merge(submission_id: params[:submission_id])
    end
end
