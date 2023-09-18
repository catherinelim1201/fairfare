class ItemsController < ApplicationController
  def index
    @split = Split.find(params[:split_id])
    @bill = Bill.find(params[:bill_id])
    @items = Item.all.where(bill_id: @bill.id)
    @split_members = @split.members
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
    redirect_to edit_bill_path(@bill)
  end

  # def assign_members
  #   pp params
  #   @item = Item.find(params[:id])
  #   @bill = @item.bill
  #   @split = @bill.split
  #   @split_members = @split.members
  #
  #   pp "test"
  #   pp item_params[:member_ids]
  #
  #   @item.update(item_params)
  #
  #
  #   render partial: "bills/item_members_form",
  #          locals: { item: @item },
  #          formats: [:html]
  # end
  def assign_members
    pp params
    @item = Item.find(params[:id])
    @bill = @item.bill
    @split = @bill.split
    @split_members = @split.members
    @member = Member.find(params[:member_id])

    if params[:remove] == "false"
      @item.members << @member
    elsif params[:remove] == "true"
      @item.members.delete(@member)
    end

    @item.reload

    BillRoomChannel.broadcast_to(
      @bill,
      {
        member_id: @member.id,
        item_id: @item.id,
        item_members_form_html: render_to_string(
          partial: "bills/item_members_form_content",
          locals: { item: @item },
          formats: [:html]),
        member_tag_html: render_to_string(
          partial: "bills/item_members",
          locals: { item: @item },
          formats: [:html])
      }
    )
    head :ok
  end

  private

  def item_params
    params.require(:item).permit(:name, :quantity, :price, member_ids: [])
  end
end
