class ConversationsController < ApplicationController
 	before_action :authenticate_user!
 	before_action :get_mailbox
	before_action :get_conversation, except: [:index, :empty_trash]

 	def index
		@conversations = @mailbox.inbox.paginate(page: params[:page], per_page: 20)
		@grouped_convos = @conversations.group_by(&:subject)

		@new_messages = current_user.unread_inbox_count
		@groups = @grouped_convos.count

		@MESSAGE_LIMIT = 7
		@GROUP_LIMIT = 2

		@show_aggregate = false
		if @new_messages >= @MESSAGE_LIMIT &&
 			@groups >= @GROUP_LIMIT then
 			@show_aggregate = true
 		end

 		if !params[:topic_id].nil? then
	    	@topic_convos = @grouped_convos[params[:topic_id]]
    	end
 	end

	def show
	end

	def reply
		current_user.reply_to_conversation(get_conversation, params[:message][:body])
		redirect_to conversation_path(get_conversation)
	end

	def destroy
		@conversation.move_to_trash(current_user)
		flash[:success] = 'The conversation was moved to trash.'
		redirect_to conversations_path
	end

	private
	def get_mailbox
		@mailbox ||= current_user.mailbox
	end

	def get_conversation
		@conversation ||= @mailbox.conversations.find_by_id(params[:id])
	end

	def restore
		@conversation.untrash(current_user)
		flash[:success] = 'The conversation was restored.'
		redirect_to conversations_path
	end
end
