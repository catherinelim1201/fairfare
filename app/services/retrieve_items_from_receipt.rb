class RetrieveItemsFromReceipt < ApplicationService
  def initialize(json_data:, bill:)
    @json_data = json_data
    @bill = bill
  end

  def call
    data = @json_data["document"]["inference"]["pages"][0]["prediction"]

    date = data.dig("date", "value")
    taxes = data.dig("taxes", 0, "value")
    total_amount = data.dig("total_amount", "value")

    items = data["line_items"]
    merchant_name = data.dig("supplier_name", "value")

    @bill.update(
      merchant: merchant_name,
      date:,
      taxes:,
      total_amount:
    )

    items.map do |item|
      item_name = item["description"]
      quantity = item["quantity"]
      total_item_cost = item["total_amount"]

      Item.create!(
        bill_id: @bill.id,
        name: item_name,
        quantity:,
        price: (total_item_cost / quantity)
      )
    end
  end
end
