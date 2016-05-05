class TransfersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

	def create
		@giving = Giving.find(params[:giving_id])
		@transfer = @giving.transfers.create(transfer_params)

		@transfer.from = current_user.id
		@transfer.to = params[:transfer][:recipient]
		@transfer.conversation = params[:transfer][:conversation]

		@transfer.save

		@giving.status = 1 # In-use
		@giving.save

		@recipient = User.find(@transfer.to)
	    UserMailer.send_accept_notification(@recipient, current_user, @giving).deliver_now

		redirect_to :back
	end

	private
	def transfer_params
		params.require(:transfer).permit(:to)
	end
end
