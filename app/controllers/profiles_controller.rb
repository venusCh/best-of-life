class ProfilesController < ApplicationController
	def show
		@user = User.find(params[:id])
		@user_givings = @user.givings.paginate(:page => params[:page], :per_page => 7)

	end
end
