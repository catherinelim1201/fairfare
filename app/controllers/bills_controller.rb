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

      redirect_to split_bill_path(@bill.split, @bill) # change to loading page
      # check sidekiq background jobs on what to do when the json is obtained from ocr
    else
      raise
    end
  end

  def index
    @bills = Bill.all
  end

  def show
    @bill = Bill.find(params[:id])

    if @bill.scraping_data?
      render :scraping
    else
      render :show
    end
  end

  def scraping
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
      redirect_to :show
    else
      render :new
    end
  end

  def edit
    @bill = Bill.find(params[:id])
    @split = @bill.split
  end

  def update
    @bill = Bill.find(params[:id])
    @split = @bill.split
    if @bill.update(bill_params)
      redirect_to split_bill_path(@bill.split, @bill)
    else
      render :edit, notice: "Something went wrong", status: :unprocessable_entity
    end
  end

  private

  def bill_params
    params.require(:bill).permit(:merchant, items_attributes: [:name, :price, :quantity])
  end
end
