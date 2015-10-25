class AsksController < ApplicationController
	def create
		@giving = Giving.find(params[:giving_id])
		@ask = @giving.asks.create(ask_params)
		@ask.user_id = current_user.id
		@ask.save
		redirect_to @giving
	end

	private
	def ask_params
		params.require(:ask).permit(:comment)
	end
end
