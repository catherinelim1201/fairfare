class Member < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name_and_phone,
                  against: [ :name, :phone_number ],
                  using: {
                    tsearch: { prefix: true }
                  }

  belongs_to :user, optional: true
  has_many :split_members
  has_many :splits, through: :split_members
  has_many :payers
  has_many :item_members
  has_many :items, through: :item_members

  validates :name, presence: true
  validates :phone_number, presence: true, length: { minimum: 8, maximum: 8 }

  def registered?
    !user.nil?
  end

  def full_name
  end
end
