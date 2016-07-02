class ProfilesController < ApplicationController
	before_action :authenticate_user!, only: [:show]

	def show
		@user = User.find_by_id(params[:id])
		@user_givings = @user.givings.paginate(:page => params[:page], :per_page => 7)

		@canComment = false
		@transfer = Transfer.where(["from_id = ? and to_id = ?", params[:id].to_i, current_user.id]).last
		if (@transfer.nil?)
			@transfer = Transfer.where(["from_id = ? and to_id = ?", current_user.id, params[:id].to_i]).last
		end

		if (!@transfer.nil? &&
			@transfer.updated_at > 30.days.ago)
			@canComment = true
		end

		@existingComment = Comment.find_by_commenter_and_user_id(current_user.id, params[:id])
		if (!@existingComment.nil?)
			@canComment = false
		end
	end
end
