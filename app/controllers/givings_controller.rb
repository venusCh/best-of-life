class GivingsController < ApplicationController
  before_action :authenticate_user!, only: [:new,:created,:destroy]

  def index
    @givings = Giving.all
  end

  def new
    @giving = current_user.givings.build
  end

  def destroy
    @giving = current_user.givings.find(params[:id])
    @giving.destroy
    redirect_to givings_path
  end

  def create 
    @giving = current_user.givings.build(giving_params)
    @giving.save

    redirect_to @giving, notice: "Successfully posted your giving!"
  end

  def show
    @giving = Giving.find(params[:id])

    @already_asked = false
    @timestamp = nil

    if current_user != nil && 
      current_user.id != @giving.user_id
      @giving.asks.each do |ask|
        if ask.user_id == current_user.id
          @already_asked = true
          @timestamp = ask.created_at
        end
      end
    end

  end

  private
  def giving_params
    params.require(:giving).permit(:name,:image,:desc,:wish)
  end
  
end
