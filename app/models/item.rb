class Item < ApplicationRecord
  belongs_to :bill

  has_many :item_members, dependent: :destroy
  has_many :items, through: :item_members

  validates :name, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
  has_many :members, through: :item_members

end
