class Split < ApplicationRecord
  belongs_to :user

  has_many :split_members, dependent: :destroy
  has_many :members, through: :split_members
  has_many :bills, dependent: :destroy

  validates :name, presence: true
  validates :date, presence: true
  validates :status, presence: true



  def split_stats
    split_settlements = []

    bills.each do |bill|
      bill.settlement.each do |settlement|
        # settlement : {total:, member:}
        member_settlement = split_settlements.find { |hash| hash[:member] == settlement[:member] }
        # check if SS has this member
        if member_settlement
          # add to the total
          member_settlement[:total] += settlement[:total]
        else
          # create a new item
          split_settlements << settlement
        end
      end
    end

    return split_settlements
  end

  def sort_split_stats
    # bills.map(&:settlement)
    payer_negative = []
    payee_positive = []
      # bill.uniq.members.each do |member|
      # bills.each do |bill|
      split_stats.each do |settlement|

        if settlement[:total].positive?
          to_pay = {
            member: settlement[:member],
            amount: settlement[:total]
          }
          payee_positive << to_pay
        else
          payer = {
            member: settlement[:member],
            amount: settlement[:total]
          }
          payer_negative << payer
        end
      end
      return {
        payers: payer_negative.sort_by { |payer| payer[:amount] },
        payees: payee_positive.sort_by { |payee| payee[:amount] }.reverse
      }
      # end
  end

  def final_calculation
    outstanding_payer = sort_split_stats[:payers][0][:member][:phone_number]
    outstanding_payer_amount = sort_split_stats[:payers][0][:amount]

    payee = sort_split_stats[:payees][0][:member][:phone_number]
    payee_amount = sort_split_stats[:payees][0][:amount]


  end
end
