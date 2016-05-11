class ProfilesController < ApplicationController
	before_action :authenticate_user!, only: [:show]

	def show
		@user = User.find_by_id(params[:id])
		@user_givings = @user.givings.paginate(:page => params[:page], :per_page => 7)

	end
end
