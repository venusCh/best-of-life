class GivingsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :created]

  def index
  	@givings = Giving.all
  end

  def new
  	@giving = current_user.givings.build
  end

  def create 
  	@giving = current_user.givings.build(giving_params)
  	@giving.save

  	redirect_to @giving, notice: "Successfully posted your giving!"
  end

  def show
  	@giving = Giving.find(params[:id])
  end

  private
  def giving_params
  	params.require(:giving).permit(:name,:desc)
  end

end
