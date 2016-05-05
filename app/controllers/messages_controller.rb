 class MessagesController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    recipients = User.where(id: params['recipients']).first
    conversation = current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation
    flash[:success] = "Message has been sent!"
    object = Giving.find(params[:message][:subject])
    msg = params[:message][:body]

    UserMailer.send_request_notification(recipients, current_user, object, msg).deliver_now
    redirect_to conversation_path(conversation)
  end
end
