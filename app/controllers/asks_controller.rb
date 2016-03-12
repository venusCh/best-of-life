class AsksController < ApplicationController

	def create
		@giving = Giving.find(params[:giving_id])
		@ask = @giving.asks.create(ask_params)

		if current_user == nil
			sign_in_and_redirect @giving
			return
		end

		@ask.user_id = current_user.id
		@ask.save
		redirect_to @giving
	end

	def edit
		@ask = Ask.find(params[:id])
		@ask.status = 1
		@ask.save

		puts :giving_id
		@giving = Giving.find(params[:giving_id])
		redirect_to @giving
	end

	private
	def ask_params
		params.require(:ask).permit(:comment)
	end

end
