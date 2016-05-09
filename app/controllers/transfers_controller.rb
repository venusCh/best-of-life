class TransfersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

	def create
		@giving = Giving.find(params[:giving_id])
		@transfer = @giving.transfers.create(transfer_params)

		@check = Transfer.find_by_from_and_to_and_conversation(current_user.id, 
																params[:transfer][:recipient],
																params[:transfer][:conversation])

		if @check.nil? then
			@transfer.from = current_user.id
			@transfer.to = params[:transfer][:recipient]
			@transfer.conversation = params[:transfer][:conversation]

			@transfer.save

			@giving.current_holder = @transfer.to
			@giving.status = 1 # In-use
			@giving.save

			@recipient = User.find(@transfer.to)
		    UserMailer.send_accept_notification(@recipient, current_user, @giving).deliver_now

			redirect_to :back
		else
			redirect_to :back, notice: "This request is already accepted."
		end
	end

	private
	def transfer_params
		params.require(:transfer).permit(:to)
	end
end
