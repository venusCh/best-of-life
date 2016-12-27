class ConversationsController < ApplicationController
 	before_action :authenticate_user!
 	before_action :get_mailbox
	before_action :get_conversation, except: [:index, :empty_trash]

 	def index

		@new_messages = current_user.unread_inbox_count
 		@all_conversations = @mailbox.inbox

 		if params[:sent] == "true" then
 			@new_messages = 0
 			@all_conversations = @mailbox.sentbox
 		end

 		# 1. get list of objects that give/regive
 		# 2. filter grouped_convos by these giving names
 	    @myGivings = Giving.where('user_id = ? OR (current_holder = ? AND status = 0)', current_user.id, current_user.id)
    	@myGivings |= Giving.joins(:transfers).where('transfers.from_id = ?', current_user.id)

		@grouped_convos = @all_conversations.group_by(&:subject)
		@hashGivings = Hash[@myGivings.collect { |g| [g.id, @grouped_convos["#{g.id}"]] }]

		print "\n\n================"
		print @grouped_convos
		print "\n\n================"
		print @hashGivings
		print "------\n"

		@grouped_convos = @hashGivings
		@show_aggregate = false

		if params[:sent] == "true" then
 			@conversations = @all_conversations.paginate(page: params[:page], per_page: 20)
 		else
 			@show_aggregate = true
 		end

 		# Conversations page on an object
 		if !params[:topic_id].nil? then
	    	@topic_convos = @grouped_convos[params[:topic_id]]
    	end

    	# TODO: Do I need this?
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
