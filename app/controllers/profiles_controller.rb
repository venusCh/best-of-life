class ProfilesController < ApplicationController
	before_action :authenticate_user!, only: [:show]

	def show
		@user = User.find_by_id(params[:id])
		@user_givings = @user.givings.paginate(:page => params[:page], :per_page => 9)

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

		@ratedPositive = false
		@ratedNegative = false
		if (!current_user.nil?)
      		@ratedPositive = current_user.voted_up_on? @user, vote_scope: 'user_rating'
      		@ratedNegative = current_user.voted_down_on? @user, vote_scope: 'user_rating'
    	end

    	@today = Time.now.to_date
    	@regivenCount = Transfer.where(["to_id = ? and is_active = 'f'", @user.id]).count
    	@overdueCount = Transfer.where(["to_id = ? and is_active = 't' and due_date > ?", @user.id, @today]).count
	end

  def rate_positive
    @user = User.find_by_id(params[:id])
    @user.vote_by :voter => current_user, :vote_scope => 'user_rating'
    redirect_to :back
  end

  def rate_negative
    @user = User.find_by_id(params[:id])
    @user.downvote_from current_user, :vote_scope => 'user_rating'
    redirect_to :back
  end

end
