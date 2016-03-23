class ConversationsController < ApplicationController
 	before_action :authenticate_user!
 	before_action :get_mailbox
	before_action :get_conversation, except: [:index, :empty_trash]

 	def index
    	@conversations = @mailbox.inbox.paginate(page: params[:page], per_page: 10)
 	end

	def show
	end
	
	private

	def get_mailbox
		@mailbox ||= current_user.mailbox
	end

	def get_conversation
		@conversation ||= @mailbox.conversations.find(params[:id])
	end

	def destroy
		@conversation.move_to_trash(current_user)
		flash[:success] = 'The conversation was moved to trash.'
		redirect_to conversations_path
	end

	def restore
		@conversation.untrash(current_user)
		flash[:success] = 'The conversation was restored.'
		redirect_to conversations_path
	end

end
