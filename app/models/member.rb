class Member < ApplicationRecord
  has_one :user, dependent: :destroy
  has_many :split_members, dependent: :destroy
  has_many :splits, through: :split_members
  has_many :payers
  has_many :item_members
  has_many :items, through: :item_members

  validates :phone_number, presence: true, uniqueness: true

  def registered?
    !user.nil?
  end

  def given_nickname(current_user)
    contact = Contact.find_by(
      member: self,
      user: current_user
    )
    contact ? contact.nickname : 'No nickname???'
  end

  def payer?(bill)
    payer = Payer.find_by(
      member: self,
      bill:
    )
    return payer ? true : false
    # code method to find out if member has payer for bill
    # contact ? contact.nickname : 'No nickname'
  end

  def payer_id(bill)
    payer = Payer.find_by(
      member: self,
      bill:
    )
    return payer.id
  end

  def payer(bill)
    payer = Payer.find_by(
      member: self,
      bill:
    )
    return payer
  end

  # need to separate out a method that returns payer id. same for item_member.
  # change data value for respective ids in index erb

  def item_member?(item)
    item_member = ItemMember.find_by(
      member: self,
      item:,
    )
    return item_member ? true : false
  end

  def item_member_id(item)
    item_member = ItemMember.find_by(
      member: self,
      item:,
    )
    return item_member.id
  end

  def consumed_items_amount
    total_amount = 0

    bill.items.each do |item|
      if item.member == current_user
        total_amount += item.quantity
      end
    end
  end

  def amount_owed(current_user)
    owe = 0
    splits = current_user.member.splits
    splits.each do |split|
      stats = split.get_split_stats
      stats.each do |stat|
        if stat[:payer_member].id == current_user.member.id
          owe += stat[:amount]
        end
      end
    end
    owe/100.00
  end

  def amount_to_pay(current_user)
    owe = 0
    splits = current_user.member.splits
    splits.each do |split|
      stats = split.get_split_stats
      stats.each do |stat|
        if stat[:payee_member].id == current_user.member.id
          owe += stat[:amount]
        end
      end
    end
    owe/100.00
  end

  # ---------------------

  def amount_paid(bill)
    return 0 unless bill.payers.map(&:member).include? self

    bill.total_amount / bill.payers.count
  end

  def total_consumed(bill)
    total = 0
    # get all the items i am a part of
    items = Item.where(bill: bill).joins(:item_members).where(item_members: { member: self })

    items.each do |item|
      price = item.price
      quantity = item.quantity
      share = (price * quantity) / (item.members.count > 0 ? item.members.count : bill.members.count)
      total += share
    end
    # for each item
    # get the total item price
    # get the total item members
    # get my own share

    # return sum of all my shares
    total = (total - amount_paid(bill)) + bill.even_split_tax
    return { total:, member: self }
  end
end
