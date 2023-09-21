class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # to allow new registration form to render phone_number field
  attr_accessor :phone_number

  has_many :messages

  has_many :splits, dependent: :destroy
  # has_many :contacts, ->(user) { where.not(id: user.member_id).distinct }, through: :splits, source: :members
  has_many :contacts, dependent: :destroy

  belongs_to :member

  before_save :make_admin
  # before_validation :assign_or_create_member

  def assign_or_create_member
    member = Member.find_or_create_by(phone_number:)
    self.member_id = member.id
  end

  def make_admin
    self.admin = true
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
