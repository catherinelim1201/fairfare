class CreateContactProxy < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_proxies do |t|
      t.references :member, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
