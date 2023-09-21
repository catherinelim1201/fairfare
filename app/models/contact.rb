class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :member

  def phone_number
    member.phone_number
  end
end
