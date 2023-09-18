class Bill < ApplicationRecord
  belongs_to :split

  # has_many :bill_members, dependent: :destroy
  # has_many :payers, through: :bill_members, class_name: 'Member'

  has_many :payers, dependent: :destroy
  has_many :members, through: :payers
  has_many :items, dependent: :destroy
  has_one_attached :photo

  # validates :merchant, presence: true
  # added by cl (15-09)
  accepts_nested_attributes_for :items

  def scraping_data?
    photo.present? && receipt_data.nil?
  end

  def total_bill
    return ":)" unless receipt_data.present?

    receipt_data["document"]["inference"]["pages"][0]["prediction"]["total_amount"]["value"]
  end

  def total_tax
    return ":)" unless receipt_data.present?

    receipt_data["document"]["inference"]["pages"][0]["prediction"]["total_tax"]["value"]
  end

  def merchant_name
    return ":)" unless receipt_data.present?

    receipt_data["document"]["inference"]["pages"][0]["prediction"]["supplier_name"]["value"]
  end
end

# @bill.paid_by => [<member>,<member>]
