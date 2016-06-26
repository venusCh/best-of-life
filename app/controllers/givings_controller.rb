class GivingsController < ApplicationController
  before_action :authenticate_user!, only: [:new,:create,:destroy,:regive, 
                      :confirm_giving, :confirm_getting, :add_bookmark, :remove_bookmark]

  def index
    puts "\n\n **** Inside index of Givings..****\n\n"

    if (params[:givings] === "true") then
      @myGivings = Giving.where(:user_id => current_user.id)
      if @myGivings.count === 0 then
        redirect_to :back, notice: "You haven't given anything yet. Click on Give below to get started!"
      end
    elsif (params[:holdings] === "true") then
      @myHoldings = Giving.where("current_holder = ? and status != ?", current_user.id, 0)
      if @myHoldings.count === 0 then
        redirect_to :back, notice: "You currently don't hold any givings."
      end
    elsif (params[:favorites] === "true") then
      @myFavorites = current_user.find_up_voted_items
      if @myFavorites.count === 0 then
        redirect_to :back, notice: "You haven't marked any favorites yet."
      end
    else
      @givings = Giving.paginate(:page => params[:page], :per_page => 20)
    end
  end

  def new
    @giving = current_user.givings.build
  end

  def destroy
    @giving = current_user.givings.find_by_id(params[:id])

    if (current_user.id != @giving.user_id)
        return
    end
    
    if (@giving.transfers.count == 0)
      @giving.destroy
      redirect_to givings_path
    else
      redirect_to :back, notice: "Sorry, those already given can't be deleted. "
    end
  end

  def regive
    @giving = Giving.find_by_id(params[:id])
    @giving.status = 0
    @giving.save

    @transfer = Transfer.find_by_giving_id_and_to_and_is_active(params[:id], current_user.id, true)
    @transfer.is_active = false;
    @transfer.save

    redirect_to :back, notice: "Successfully re-given! You will now start recieving requests for this."

    # this isn't a scalable solution; move to sheduled tasks
    if (false) 
      @usersToUpdate = @giving.votes_for(:vote_scope => 'bookmark').up.by_type(User).voters

      @usersToUpdate.each do |user|
        UserMailer.send_wishlist_item_available(user, @giving).deliver_now
      end
    end

  end

  def confirm_giving
    @giving = Giving.find_by_id(params[:id])
    @transfer = Transfer.find_by_from_and_to_and_conversation(current_user.id, 
                                                              params[:recipient],
                                                              params[:id])
    if (@giving.status >= 1)
      @giving.status += 10
    end
    @giving.save

    redirect_to :back, notice: "Thanks for confirming your giving!"
  end

  def confirm_getting
    @giving = Giving.find_by_id(params[:id])
    @transfer = Transfer.find_by_from_and_to_and_conversation(current_user.id, 
                                                              params[:recipient],
                                                              params[:id])
    if (@giving.status >= 1)
      @giving.status += 100
    end
    @giving.save

    redirect_to :back, notice: "Thanks for confirming your receiving!"
  end

  def create 
    @giving = current_user.givings.build(giving_params)
    @giving.current_holder = current_user.id
    @giving.status = 0 # Available
    @giving.save

    redirect_to @giving, notice: "Successfully posted your giving!"
  end

  def show
    puts "\n\n **** inside show of controller **** \n"
    @giving = Giving.find_by_id(params[:id])
    if (!current_user.nil?)
      @sentbox = current_user.mailbox.sentbox.find_by_subject(params[:id])
    end

    @already_asked = false
    @already_asked_at = nil

    if (current_user != nil && 
      current_user.id != @giving.current_holder) then
      if (!@sentbox.nil? && 
          @sentbox.recipients[0].id == @giving.current_holder &&
          @sentbox.subject == @giving.id.to_s) then
        @already_asked = true
        @already_asked_at = @sentbox.updated_at
      end
    end

    @bookmarked = false;
    if (!current_user.nil?)
      @bookmarked = current_user.voted_up_on? @giving, vote_scope: 'bookmark'
    end
  end

  def add_bookmark
    @giving = Giving.find_by_id(params[:id])
    @giving.vote_by :voter => current_user, :vote_scope => 'bookmark'

    @transfer = Transfer.find_by_id(25)
    UserMailer.send_lastday_reminder(current_user, @giving, @transfer).deliver_now
    redirect_to :back
  end

  def remove_bookmark
    @giving = Giving.find_by_id(params[:id])
    @giving.downvote_from current_user, :vote_scope => 'bookmark'
    redirect_to :back
  end

  private
  def giving_params
    params.require(:giving).permit(:name,:image,:desc,:wish)
  end
  
end
