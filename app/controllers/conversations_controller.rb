class ConversationsController < ApplicationController
 	before_action :authenticate_user!
 	before_action :get_mailbox
	before_action :get_conversation, except: [:index, :empty_trash]

 	def index

		@new_messages = current_user.unread_inbox_count
 		@all_conversations = @mailbox.inbox

		@MESSAGE_LIMIT = 7
		@GROUP_LIMIT = 2

 		if params[:sent] == "true" then
 			@new_messages = 0
 			@all_conversations = @mailbox.sentbox
 			@MESSAGE_LIMIT = 1
 			@GROUP_LIMIT = 1
 		end

		@grouped_convos = @all_conversations.group_by(&:subject)
		@show_aggregate = false

		if params[:group] == "true" ||
			(@new_messages >= @MESSAGE_LIMIT &&
 			@grouped_convos.count >= @GROUP_LIMIT) then
 			@show_aggregate = true
 		else
 			@conversations = @all_conversations.paginate(page: params[:page], per_page: 20)
 		end

 		if !params[:topic_id].nil? then
	    	@topic_convos = @grouped_convos[params[:topic_id]]
    	end

    	# pass the parameters back to view
    	if params[:group] == "true" then
    		@group_by_givings = true
    	else
    		@group_by_givings = false
    	end

    	if params[:sent] == "true" then
    		@show_sentbox = true
    	else
    		@show_sentbox = false
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
