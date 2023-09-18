class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages

  has_many :splits, dependent: :destroy
  has_many :contacts, ->(user) {
    where.not(user_id: user.id)
         .or(where(user_id: nil))
         .distinct
  }, through: :splits, source: :members

  has_one :member

  before_save :make_admin

  after_create :assign_member

  def assign_member
    Member.find_or_create_by(phone_number:).tap do |member|
      member.update(
        user_id: id,
        name:
      )
    end
  end

  def make_admin
    self.admin = true
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  # use this instead of email_changed? for Rails = 5.1.x
  def will_save_change_to_email?
    false
  end
end
