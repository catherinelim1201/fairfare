class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def index
    @splits = Split.all
    @contacts = Contact.all
  end

  # def show
  #   @bill = Bill.find(params[:id])
  # end

  def home
    if user_signed_in?
      render 'pages/dashboard'
    else
      render 'pages/home'
    end
  end

  def owed_money_amount
    @split = Split.find(params[:split_id])
  end
end
