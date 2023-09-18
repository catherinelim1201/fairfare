class Split < ApplicationRecord
  belongs_to :user

  has_many :split_members, dependent: :destroy
  has_many :members, through: :split_members
  has_many :bills, dependent: :destroy

  validates :name, presence: true
  validates :date, presence: true
  validates :status, presence: true

  def members_excluding_current_user
    members.filter { |member| member.user_id != current_user.id }
  end
end
