require 'uri'
require 'net/http'
require 'net/https'
require 'mime/types'
require 'open-uri'

class ExtractTextFromReceipt < ApplicationService
  MINDEE_API = "https://api.mindee.net/v1/products/mindee/expense_receipts/v5/predict"

  def initialize(url:)
    @url = url
  end

  def call
    api = URI(MINDEE_API)

    http = Net::HTTP.new(api.host, api.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(api)
    request["Authorization"] = "Token #{ENV['RECEIPT_KEY']}"
    request.set_form([['document', URI.open(@url)]], 'multipart/form-data')

    response = http.request(request)
    JSON.parse(response.read_body)
  end
end
