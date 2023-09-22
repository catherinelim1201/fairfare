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
    converted_params = bill_params
    converted_params[:items_attributes].each do |item|
      item[1][:price] = item[1][:price].to_f * 100
    end
    converted_params[:taxes] = converted_params[:taxes].to_f * 100
    converted_params[:discount] = converted_params[:discount].to_f * 100
    converted_params[:service_charge] = converted_params[:service_charge].to_f * 100
    converted_params[:total_amount] = converted_params[:total_amount].to_f * 100
    @bill = Bill.new(converted_params)
    @bill.split = @split

    if @bill.save
      @bill.update_total_bill if @bill.total_amount.nil? || @bill.total_amount.zero?

      redirect_to split_bill_items_path(@split, @bill)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @bill = Bill.find(params[:bill_id])
    @items = Item.all.where(bill_id: @bill.id)
    # raise
  end

  def update
    @bill = Bill.find(params[:id])

    # @items = Item.where(bill: @bill)

    # @items.each do |item|
    #   item.attributes = bill_params
    #   item.save
    # end

    @bill.update(bill_params)
    # temp comment out line 79 on 21-09 @8.58pm
    # redirect_to split_bill_items_path(@split)

    respond_to do |format|
      format.html { redirect_to split_bill_items_path(@split) }
      format.text { render plain: 'testtt' }
    end
  end

  # added on 21-09 @ 9.36pm
  def items
    @split = Split.find(params[:split_id])
    @bill = Bill.find(params[:bill_id])
    @items = Item.where(bill_id: @bill.id)

    @items.update(item_params)
    @bill.update_total_bill if @bill.total_amount.nil? || @bill.total_amount.zero?

    redirect_to split_bill_items_path(@split)
  end

  # def items
  #   @split = Split.find(params[:split_id])
  #   @bill = Bill.find(params[:bill_id])
  #   item.bill = @bill
  # end


  # def destroy
  #   @item = Item.find(params[:id])
  #   @bill = @item.bill
  #   @item.destroy
  #   # redirect_to edit_bill_path(@bill)
  # end

  private

  def bill_params
    # params.require(:bill).permit(:merchant, items_attributes: %i[name price quantity])
    params.require(:bill).permit(:merchant, :date, :discount, :service_charge, :taxes, items_attributes: %i[name price quantity])
  end
end
