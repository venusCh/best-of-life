class AsksController < ApplicationController
  before_action :authenticate_user!, only: [:create,:edit]

	def create
		@giving = Giving.find_by_id(params[:giving_id])
		@ask = @giving.asks.create(ask_params)
		@ask.user_id = current_user.id
		@ask.save
		redirect_to @giving
	end

	def edit
		@ask = Ask.find_by_id(params[:id])
		@ask.status = 1
		@ask.save

		puts :giving_id
		@giving = Giving.find_by_id(params[:giving_id])
		redirect_to @giving
	end

	private
	def ask_params
		params.require(:ask).permit(:comment)
	end

end
