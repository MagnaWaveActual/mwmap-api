class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :services, :string
    add_column :users, :address_l1, :string
    add_column :users, :address_l2, :string
    add_column :users, :address_state, :string
    add_column :users, :address_city, :string
    add_column :users, :address_zip, :integer
    add_column :users, :rank, :integer
    add_column :users, :purchased_lead_count, :integer
    add_column :users, :delivered_lead_count, :integer
    add_column :users, :next_purchased_lead_count, :integer
    add_column :users, :cms_id, :integer
    add_column :users, :location_active, :boolean
  end
end
