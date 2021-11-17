class CommentsController < ApplicationController
    def create
          
        @comment = current_user.comments.new(comment_params)
        if !@comment.save
        flash[:notice] = @comment.errors.full_messages.to_sentence
         end
         redirect_to submission_path(params[:submission_id])

    end
    private

    def comment_params
        params.require(:comment).permit(:content, :parent_id ).merge(submission_id: params[:submission_id])
    end
end
