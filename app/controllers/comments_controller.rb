class CommentsController < ApplicationController

	def create
	    @user = User.find(params[:user_id])
	    @comment = @user.comments.create(comment_params)
	    @comment.commenter = current_user.id
	    @comment.save

	    redirect_to :back, notice: "Thanks for adding your comments"
	end
 
  	private
    def comment_params
    	params.require(:comment).permit(:body)
    end

end
