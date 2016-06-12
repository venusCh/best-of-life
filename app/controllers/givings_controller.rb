class GivingsController < ApplicationController
  before_action :authenticate_user!, only: [:new,:create,:destroy,:regive]

  def index
    @givings = Giving.paginate(:page => params[:page], :per_page => 20)
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

    redirect_to :back, notice: "Successfully re-given! You will now start recieving requests for this."
  end

  def create 
    @giving = current_user.givings.build(giving_params)
    @giving.current_holder = current_user.id
    @giving.status = 0 # Available
    @giving.save

    redirect_to @giving, notice: "Successfully posted your giving!"
  end

  def show
    @giving = Giving.find_by_id(params[:id])
    @sentbox = current_user.mailbox.sentbox.find_by_subject(params[:id])

    @already_asked = false
    @already_asked_at = nil

    if (current_user != nil && 
      current_user.id != @giving.user_id) then
      if (@sentbox.recipients[0].id == @giving.user_id &&
          @sentbox.subject == @giving.id.to_s) then
        @already_asked = true
        @already_asked_at = @sentbox.updated_at
      end
    end

  end

  private
  def giving_params
    params.require(:giving).permit(:name,:image,:desc,:wish)
  end
  
end
