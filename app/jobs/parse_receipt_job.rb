class ParseReceiptJob < ApplicationJob
  queue_as :default

  def perform(bill)
    url = Cloudinary::Utils.cloudinary_url("#{ENV["RAILS_ENV"]}/#{bill.photo.key}", quality: "auto:low")

    receipt_data = Mindee::ExtractDataFromReceipt.(url:)
    Mindee::Factory::CreateItemsFromReceiptData.(bill:, receipt_data:)

    bill.update(receipt_data:)
  end
end
