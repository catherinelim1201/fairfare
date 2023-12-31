class ItemsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @split = Split.find(params[:split_id])
    @bill = Bill.find(params[:bill_id])
    @items = Item.all.where(bill_id: @bill.id)
    @split_members = @split.members
    @payer = Payer.new
    @item_member = ItemMember.new
    # @contacts = Contact.all.where(member_id: )

    render :index
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
    pp 'zonghan'
    pp item_params
    @item = Item.find(params[:id])
    @item.update(item_params)

    @item.bill.update_total_bill

    respond_to do |format|
      format.text { head :ok }
    end
  end

  def items
    @split = Split.find(params[:split_id])
    @bill = Bill.find(params[:bill_id])

  end

  def destroy
    @item = Item.find(params[:id])
    @bill = @item.bill
    @item.destroy
    # redirect_to edit_bill_path(@bill)
  end

  private

  def item_params
    params.require(:item).permit(:name, :quantity, :price, :price_in_dollars)
  end
end
