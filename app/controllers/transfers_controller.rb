class TransfersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

	def create
		@giving = Giving.find_by_id(params[:giving_id])
		@transfer = @giving.transfers.create(transfer_params)

		@check = Transfer.find_by_from_id_and_to_id_and_conversation(current_user.id, 
																params[:transfer][:recipient],
																params[:transfer][:conversation])

		if @check.nil? then
			@transfer.from_id = current_user.id
			@transfer.to_id = params[:transfer][:recipient]
			@transfer.conversation = params[:transfer][:conversation]

			@transfer.is_active = true
			@transfer.save

			@giving.prospective_user = @transfer.to_id
			@giving.status = 1 # Agreed to give
			@giving.save

			@recipient = User.find_by_id(@transfer.to_id)
		    UserMailer.send_accept_notification(@recipient, current_user, @giving).deliver_now

		    # also auto-generate a reply to conversation
		    @conversation = current_user.mailbox.conversations.find(@transfer.conversation)
		    current_user.reply_to_conversation(@conversation, "<RequestAcceptedToken>")

			redirect_to :back
		else
			redirect_to :back, notice: "This request is already accepted."
		end
	end

	private
	def transfer_params
		params.require(:transfer).permit(:to)
	end

	def get_months(giving)
		@months = 1.month
		if @giving.wish == 20
			@months = 3.months
		elsif @giving.wish == 30
			@months = 6.months
		end
		return @months
	end
end
