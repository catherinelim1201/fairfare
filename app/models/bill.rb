class Bill < ApplicationRecord
  belongs_to :split

  # has_many :bill_members, dependent: :destroy
  # has_many :payers, through: :bill_members, class_name: 'Member'

  has_many :payers, dependent: :destroy
  has_many :members, through: :payers
  has_many :items, dependent: :destroy
  has_many :item_members, through: :item
  has_one_attached :photo

  # added by cl (15-09)
  accepts_nested_attributes_for :items

  def scraping_data
    photo.present? && receipt_data.nil?
  end
end

# @bill.paid_by => [<member>,<member>]
