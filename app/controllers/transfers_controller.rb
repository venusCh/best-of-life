class TransfersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

	def create
		@giving = Giving.find(params[:giving_id])
		@transfer = @giving.transfers.create(transfer_params)
		@transfer.from = current_user.id
		@transfer.to = params[:to]

		# TODO: need to figure out how to do the following
		# @convo = Conversation.find(params[:conversation])
		
		redirect_to conversations_path, notice: "You accepted the request for this book! Please arrange the exchange. "
	end

	private
	def transfer_params
		params.require(:transfer).permit(:to)
	end
end
