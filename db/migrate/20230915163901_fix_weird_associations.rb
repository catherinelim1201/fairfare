class FixWeirdAssociations < ActiveRecord::Migration[7.0]
  def change
    add_reference :members, :user, null: true, foreign_key: true
    remove_reference :users, :member, index: true, foreign_key: true

    add_column :members, :name, :string
    remove_column :members, :first_name, :string
    remove_column :members, :last_name, :string
    remove_column :users, :email, :string
    remove_column :users, :username, :string
    add_column :users, :phone_number, :string
    add_column :users, :name, :string

    add_reference :bills, :payer, null: true, foreign_key: true
    add_column :bills, :resolved, :boolean
  end
end
