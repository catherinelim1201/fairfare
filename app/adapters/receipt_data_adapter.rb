class ReceiptDataAdapter
  def initialize(receipt_data)
    @receipt_data = receipt_data
  end

  attr_reader :receipt_data

  def ready?
    receipt_data.present?
  end

  def line_items
    return "Loading" unless receipt_data

    line_items = receipt_data["document"]["inference"]["pages"][0]["prediction"]["line_items"]

    line_items.map do |item|
      item_name = item["description"]
      units = item["quantity"]
      price_per_unit = item["unit_price"]
      total_price = item["total_amount"]

      Item.new(
        name: item_name,
        quantity: units,
        price: total_price,
      )
    end
  end

  def total_bill
    receipt_data["document"]["inference"]["pages"][0]["prediction"]["line_items"]
  end

  def total_tax
    receipt_data["document"]["inference"]["pages"][0]["prediction"]["total_tax"]["value"]
  end

  def merchant_name
    receipt_data["document"]["inference"]["pages"][0]["prediction"]["supplier_name"]["value"]
  end
end
