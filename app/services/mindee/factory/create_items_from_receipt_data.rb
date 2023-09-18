module Mindee
  module Factory
    class CreateItemsFromReceiptData < ApplicationService
      def initialize(bill:, receipt_data:)
        @bill = bill
        @receipt_data = receipt_data
      end

      def call
        create_line_items
      end

      private

      attr_reader :bill, :receipt_data

      def create_line_items
        date = receipt_data["document"]["inference"]["pages"][0]["prediction"]["date"]

        line_items = receipt_data["document"]["inference"]["pages"][0]["prediction"]["line_items"]

        line_items.map do |item|
          item_name = item["description"]
          units = item["quantity"]
          price_per_unit = item["unit_price"]
          total_price = item["total_amount"]

          Item.create(
            name: item_name,
            quantity: units,
            price: total_price,
            bill:
            )
        end
      end
    end
  end
end
