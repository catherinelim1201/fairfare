class ItemsController < ApplicationController
  def index
    @split = Split.find(params[:split_id])
    @bill = Bill.find(params[:bill_id])
    @items = Item.all.where(bill_id: @bill.id)
    @split_members = @split.members
    @payer = Payer.new
    @item_member = ItemMember.new
    # @contacts = Contact.all.where(member_id: )

    if @bill.scraping_data
      render :scraping
    else
      render :index
    end
  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy
    @item = Item.find(params[:id])
    @bill = @item.bill
    @item.destroy
    # redirect_to edit_bill_path(@bill)
  end
end
