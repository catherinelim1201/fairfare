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

  # def show
  #   @split = Split.find(params[:split_id])
  #   @bill = Bill.find(params[:bill_id])
  #   @items = Item.all.where(bill_id: @bill.id)
  # end

  def edit
    @items = Item.all
    @items.each do |item|
      @item = item
    end
    # @item = Item.find(params[:item_id])
    # @split = Split.find(params[:split_id])
    # @bill = Bill.find(params[:bill_id])
    # @items = Item.all.where(bill_id: @bill.id)

  end

  def update
    # @split = Split.find(params[:split_id])
    # @bill = Bill.find(params[:bill_id])
    # @items = Item.all.where(bill_id: @bill.id)
    @item = Item.find(params[:item_id])
    raise
    # @item.update(item_params)

    # redirect_to split_bill_items_path(@split)
  end

  def destroy
    @item = Item.find(params[:id])
    @bill = @item.bill
    @item.destroy
    # redirect_to edit_bill_path(@bill)
  end

  private

  def item_params
    params.require(:item).permit(:name, :quantity, :price)
  end
end
