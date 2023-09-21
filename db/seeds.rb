# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'
require 'open-uri'
require 'date'
require 'securerandom'
require 'pry-byebug'

seed_members = true
seed_users = true
seed_splits = true
seed_bills_and_items = true
# seed_payers = true
# seed_items = true

ItemMember.destroy_all
Payer.destroy_all
Contact.destroy_all
Item.destroy_all
Bill.destroy_all
SplitMember.destroy_all
Split.destroy_all
Member.destroy_all
User.destroy_all


if seed_members
  puts "\n\n===== Creating members =====\n"

  puts 'Clearing old data...'
  # phone_no = "#{["8","9"].sample}#{7.times { rand(9).to_s }}"
  # phone_no = (8..9).to_a.sample.to_s + rand((10**6)..((10**7) - 1)).to_s

  members_with_accounts = []
  puts "Creating Zohan member..."
  zohan_member = Member.create!(
    phone_number: "91231239"
  )
  puts "Created John Doe.\n\n"

  puts "Creating 10 Members with accounts"
  10.times do
    member = Member.create!(
      phone_number: rand(90_000_000..99_999_999).to_s
    )
    members_with_accounts << member
    puts "Created member."
  end

  members_without_accounts = []
  puts "Creating 10 Members without accounts"
  10.times do
    member = Member.create!(
      phone_number: rand(90_000_000..99_999_999).to_s
    )
    members_without_accounts << member
    puts "Created member."
  end
end

# # -------------------------------------------------------

if seed_users
  puts "===== Creating Users =====\n\n"

  puts 'Clearing old data'

  users = []

  zohan_user = User.create!(
    member: zohan_member,
    username: "Test1",
    email: "test123@gmail.com",
    first_name: "Zohan",
    last_name: "Goh",
    password: "password"
  )
  puts "Created #{zohan_user.username}."

  10.times do |index|
    user = User.create!(
      member: members_with_accounts[index],
      username: "User#{index}",
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: "password"
    )
    users << user
    puts "Created #{user.username}."
  end
end
# # ----------------------------------------------------

puts "\n\n===== Creating Contacts =====\n"
puts 'Clearing old data...'

puts 'Adding Zohan into contacts...'
Contact.create!(
  user: zohan_user,
  member: zohan_member,
  nickname: 'The Zohan'
)

members_with_accounts.first(3).each_with_index do |member, index|
  puts 'Adding contacts with accounts...'
  Contact.create!(
    user: zohan_user,
    member:,
    nickname: "friend with account #{index + 1}"
  )
end

members_without_accounts.first(3).each_with_index do |member, index|
  puts 'Adding contacts without accounts...'
  Contact.create!(
    user: zohan_user,
    member:,
    nickname: "friend with no account #{index + 1}"
  )
end
# # ----------------------------------------------------

if seed_splits
  puts "\n\n===== Creating splits =====\n"

  puts 'Clearing old data...'

  def split_date
    Date.today + rand(10).days
  end

  def six_digit_code
    rand(1_000_000).to_s.rjust(6, '0')
  end
  # statuses = ["draft", "pending", "complete"]

  split1 = Split.create!(
    user: zohan_user,
    status: "draft",
    name: "my first split",
    date: split_date,
    invite_code: six_digit_code
  )
  puts "Created #{split1.name}."

  split2 = Split.create!(
    user: zohan_user,
    status: "pending",
    name: "lunch meal",
    date: split_date,
    invite_code: six_digit_code
  )
  puts "created #{split2.name}."

  split3 = Split.create!(
    user: zohan_user,
    status: "complete",
    name: "dinner meal",
    date: split_date,
    invite_code: six_digit_code
  )
  puts "created #{split3.name}."



  Split.all.each do |split|
    split.members << split.user.member
    members = Member.where.not(user:split.user).sample(2)
    members.each do |member|
      split.members << member
    end
  end
end

# ----------------------------------------------------

if seed_bills_and_items
  def create_items(bill)
    puts "   creating items..."
    rand(1..5).times do
      item = Item.create!(
        name: Faker::Food.dish,
        bill:,
        quantity: rand(1..3),
        price: rand(100..10_000)
      )
      puts "   - created #{item.name}"
    end
  end

  def create_payers(bill)
    puts "    adding payers"
    bill_members = bill.split.members

    rand(1..3).times do
      payer = Payer.create!(
        bill:,
        member: bill_members[(rand(bill_members.count))]
      )
      puts "    -created payers"
    end
  end

  def assign_members_to_items(bill)
    puts "    adding members (consumers) to items"
    bill_members = bill.split.members
    items = bill.items
    items.each do |item|
      rand(1..3).times do
        item_member = ItemMember.create!(
          item:,
          member: bill_members[rand(bill_members.count)]
        )
        puts "    -created member for item #{item.name}"
      end
    end
  end

  def create_bills(split)
    puts "\nCreating bills for split: #{split.name}..."
    rand(1..3).times do
      merchant = Faker::Restaurant.name
      puts "Creating Bill for #{merchant}"
      bill = Bill.create!(merchant:, split:)
      create_items(bill)
      create_payers(bill)
      assign_members_to_items(bill)
      puts "created Bill for #{merchant}\n\n"
    end
  end

  puts "\n\n===== Creating bills & items =====\n"

  puts 'clearing old data...'


  Split.all.each { |split| create_bills(split) }

end

# ----------------------------------------------------

# THIS IS JUST FOR TESTING THE O$P$ CALCULATON LOGIC (in splits#show) - CAN BE REMOVED IF NOT NEEDED

# Create users for members
users = []
4.times do
  users << User.create(email: Faker::Internet.email,
                      password: 'password',
                      password_confirmation: 'password')
end

# Create members
members = []
users.each do |user|
  members << Member.create(user: user, phone_number: Faker::PhoneNumber.cell_phone)
end

# Create contacts for members
members.each do |member|
  other_members = members.reject { |m| m.id == member.id }
  other_members.each do |contact_member|
    Contact.create(nickname: Faker::Name.first_name, user: member.user, member: contact_member)
  end
end

# Create split with one of the members
split = Split.create(name: Faker::Lorem.word, date: Date.today, user: users.first)

puts "\n[10 / 11] Creating items"
# items
item1 = Item.create!(
  bill: bill2,
  name: 'Chicken Rice',
  price: 1090,
  quantity: 1
)
puts "          - Created item"

item2 = Item.create!(
  bill: bill2,
  name: 'Curry Chicken',
  price: 1390,
  quantity: 1
)
puts "          - Created item"

item3 = Item.create!(
  bill: bill2,
  name: 'Honey Lemon',
  price: 390,
  quantity: 1
)
puts "          - Created item"

item4 = Item.create!(
  bill: bill2,
  name: 'White rice',
  price: 150,
  quantity: 1
)
puts "          - Created item"

puts "\n[11 / 11] Assigning members to items"
split.members.first(2).each { |member| item1.members << member }
split.members.last(3).each { |member| item2.members << member }
item3.members << split.members[1]
item4.members << split.members[2]
split.members.each { |member| item5.members << member }

puts "Done"

# if seed_splits
#   puts "\n\n===== Creating splits =====\n"

#   puts 'Clearing old data...'

  def split_date
    Date.today + rand(10).days
  end

  def six_digit_code
    rand(1_000_000).to_s.rjust(6, '0')
  end
  # statuses = ["draft", "pending", "complete"]

  split1 = Split.create!(
    user: zohan_user,
    status: "draft",
    name: "my first split",
    date: split_date,
    invite_code: six_digit_code
  )
  puts "Created #{split1.name}."

  split2 = Split.create!(
    user: zohan_user,
    status: "pending",
    name: "lunch meal",
    date: split_date,
    invite_code: six_digit_code
  )
  puts "created #{split2.name}."

  split3 = Split.create!(
    user: zohan_user,
    status: "complete",
    name: "dinner meal",
    date: split_date,
    invite_code: six_digit_code
  )
  puts "created #{split3.name}."



  Split.all.each do |split|
    split.members << split.user.member
    members = Member.where.not(user:split.user).sample(2)
    members.each do |member|
      split.members << member
    end
  end
end

# # ----------------------------------------------------

# if seed_bills_and_items
#   def create_items(bill)
#     puts "   creating items..."
#     rand(1..5).times do
#       item = Item.create!(
#         name: Faker::Food.dish,
#         bill:,
#         quantity: rand(1..3),
#         price: rand(100..10_000)
#       )
#       puts "   - created #{item.name}"
#     end
#   end

#   def create_payers(bill)
#     puts "    adding payers"
#     bill_members = bill.split.members

#     rand(1..3).times do
#       payer = Payer.create!(
#         bill:,
#         member: bill_members[(rand(bill_members.count))]
#       )
#       puts "    -created payers"
#     end
#   end

#   def assign_members_to_items(bill)
#     puts "    adding members (consumers) to items"
#     bill_members = bill.split.members
#     items = bill.items
#     items.each do |item|
#       rand(1..3).times do
#         item_member = ItemMember.create!(
#           item:,
#           member: bill_members[rand(bill_members.count)]
#         )
#         puts "    -created member for item #{item.name}"
#       end
#     end
#   end

#   def create_bills(split)
#     puts "\nCreating bills for split: #{split.name}..."
#     rand(1..3).times do
#       merchant = Faker::Restaurant.name
#       puts "Creating Bill for #{merchant}"
#       bill = Bill.create!(merchant:, split:)
#       create_items(bill)
#       create_payers(bill)
#       assign_members_to_items(bill)
#       puts "created Bill for #{merchant}\n\n"
#     end
#   end

#   puts "\n\n===== Creating bills & items =====\n"

#   puts 'clearing old data...'


#   Split.all.each { |split| create_bills(split) }

# end

# # ----------------------------------------------------

# # THIS IS JUST FOR TESTING THE O$P$ CALCULATON LOGIC (in splits#show) - CAN BE REMOVED IF NOT NEEDED

# # Create users for members
# users = []
# 4.times do
#   users << User.create(email: Faker::Internet.email,
#                       password: 'password',
#                       password_confirmation: 'password')
# end

# # Create members
# members = []
# users.each do |user|
#   members << Member.create(user: user, phone_number: Faker::PhoneNumber.cell_phone)
# end

# # Create contacts for members
# members.each do |member|
#   other_members = members.reject { |m| m.id == member.id }
#   other_members.each do |contact_member|
#     Contact.create(nickname: Faker::Name.first_name, user: member.user, member: contact_member)
#   end
# end

# # Create split with one of the members
# split = Split.create(name: Faker::Lorem.word, date: Date.today, user: users.first)

# # Connect split with members
# members.each do |member|
#   SplitMember.create(split: split, member: member)
# end

# # Create 5 bills
# bills = []
# 5.times do
#   bill = Bill.create(merchant: Faker::Company.name,
#                     split: split,
#                     date: Date.today,
#                     total_amount: 0)

#   # Create 3 items for each bill
#   3.times do
#     item = Item.create(name: Faker::Commerce.product_name,
#                       quantity: rand(1..5),
#                       price: rand(100..10000),
#                       bill: bill)

#     #Updating total_amount in bill after adding each item
#     bill.total_amount += item.price * item.quantity
#     bill.save

#     # Connect item with random member
#     ItemMember.create(item: item, member: members.sample)
#   end

#   # Assign bill payers randomly
#   payers = members.sample(rand(1..4))
#   payers.each do |payer|
#     Payer.create!(bill: bill, member: payer)
#   end

  bills << bill
end

puts "Seeding is complete. Created #{Split.count} split with #{Bill.count} bills and #{Item.count} items. Created #{Member.count} members with #{Contact.count} contacts."
