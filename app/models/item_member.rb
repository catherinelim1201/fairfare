class ItemMember < ApplicationRecord
  belongs_to :item
  belongs_to :member

  validates :member, uniqueness: { scope: :item }
end
