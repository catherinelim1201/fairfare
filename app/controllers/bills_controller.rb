class BillsController < ApplicationController
  # def show
  #   @bill = Bill.find(params[:id])
  #   data = @bill.receipt_data

  #   items = []
  #   items << Item.new(...)

  #   puts items

  #   render json: { data: } # this is to show the json code on the webpage in local
  # remember that price will need to be converted to cents
  # transfer this to the items controller #index method instead and list out the items on the html.erb file
  # end

  def receipt
    @split = Split.find(params[:split_id])
  end

  def upload
    @bill = Bill.create(split_id: params[:split_id])
    @bill.photo = params[:image]

    if @bill.save
      # schedule a background job
      ParseReceiptJob.perform_later(@bill)

      redirect_to split_bill_items_path(@bill.split, @bill)
      # check sidekiq background jobs on what to do when the json is obtained from ocr
    else
      raise
    end
  end

  def select
    @split = Split.find(params[:split_id])
  end

  def index
    @bills = Bill.all
  end

  def show
    @bill = Bill.find(params[:id])
  end

  def new
    @split = Split.find(params[:split_id])
    @bill = Bill.new
    @bill.items.build
  end

  def create
    @split = Split.find(params[:split_id])
    @bill = Bill.new(bill_params)
    @bill.split = @split

    if @bill.save
      redirect_to split_bill_items_path(@split, @bill)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @split = Split.find(params[:split_id])
    @bill = Bill.find(params[:bill_id])
  end

  def update
    @split = Split.find(params[:split_id])
    @bill = Bill.find(params[:bill_id])
  end

  # def destroy
  #   @item = Item.find(params[:id])
  #   @bill = @item.bill
  #   @item.destroy
  #   # redirect_to edit_bill_path(@bill)
  # end

  private

  def bill_params
    params.require(:bill).permit(:merchant, items_attributes: [:name, :price, :quantity])
  end
end
