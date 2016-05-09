class GivingsController < ApplicationController
  before_action :authenticate_user!, only: [:new,:create,:destroy,:regive]

  def index
    @givings = Giving.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @giving = current_user.givings.build
  end

  def destroy
    @giving = current_user.givings.find(params[:id])

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
    @giving = Giving.find(params[:id])
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
    @giving = Giving.find(params[:id])

    @already_asked = false
    @ask_accepted = false
    @timestamp = nil

    if current_user != nil && 
      current_user.id != @giving.user_id
      @giving.asks.each do |ask|
        if ask.user_id == current_user.id
          @already_asked = true
          @timestamp = ask.created_at
          if ask.status == 1
            @ask_accepted = true
            @timestamp = ask.updated_at
          end
        end
      end
    end

  end

  private
  def giving_params
    params.require(:giving).permit(:name,:image,:desc,:wish)
  end
  
end
