class SplitMember < ApplicationRecord
  belongs_to :split
  belongs_to :member

  validates :member, uniqueness: { scope: :split }
end
