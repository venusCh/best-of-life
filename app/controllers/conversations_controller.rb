class ConversationsController < ApplicationController
 	before_action :authenticate_user!
 	before_action :get_mailbox
	before_action :get_conversation, except: [:index, :empty_trash]

 	def index

		@new_messages = current_user.unread_inbox_count
 		@all_conversations = @mailbox.inbox
    	@show_sentbox = false
		@show_aggregate = true

 		if params[:sent] == "true" then
 			@new_messages = 0
 			@all_conversations = @mailbox.sentbox
    		@show_sentbox = true

    		# get list of objects on which you initiated the conversation
    		@originatedConversations = @all_conversations.select { |c| c.originator == current_user }
 			@grouped_convos = @originatedConversations.group_by(&:subject)
 		else
	 		# get list of objects that user can give/regive
	 	    @myGivings = Giving.where('user_id = ? OR (current_holder = ? AND status = 0)', current_user.id, current_user.id)
	 	    @myGivings = @myGivings.sort_by(&:updated_at).reverse
	    	@mySecondaryGivings = Giving.joins(:transfers).where('transfers.from_id = ?', current_user.id)
	    	@myGivings |= @mySecondaryGivings

	 	    # get list of conversations which others sent to you
	    	@receivedConversations = @all_conversations.select { |c| c.originator != current_user }

	    	# group conversations by giving
			@grouped_convos = @receivedConversations.group_by(&:subject)
			@standbyGivings = @myGivings.select { |g| @grouped_convos["#{g.id}"] == nil }
			@standbyGivings = Hash[@standbyGivings.collect { |g| ["#{g.id}", nil] }]

			# append givings with no current interests at the end of givings with conversations
			@grouped_convos = @grouped_convos.merge(@standbyGivings)
	 	end

 		# Conversations page on an object
 		if !params[:topic_id].nil? then
	    	@temp_convos = @grouped_convos[params[:topic_id]]
	    	@today = Time.now.to_date

	    	@topic_convos = @temp_convos.sort { |a, b| 
				@regivenCountA = Transfer.where(["to_id = ? and is_active = 'f'", a.originator.id]).count
		        @overdueCountA = Transfer.where(["to_id = ? and is_active = 't' and due_date > ?", a.originator.id, @today]).count

				@regivenCountB = Transfer.where(["to_id = ? and is_active = 'f'", b.originator.id]).count
		        @overdueCountB = Transfer.where(["to_id = ? and is_active = 't' and due_date > ?", b.originator.id, @today]).count

		        if @regivenCountA < @regivenCountB then
		        	-1
		        else
		        	1
		        end
	    	}
    	end
 	end

	def show
		@show_sentbox = false
 		if params[:sent] == "true" then
 			@show_sentbox = true
 		end
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
