class RemoveColumnsFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :services
    remove_column :users, :address_l1
    remove_column :users, :address_l2
    remove_column :users, :address_city
    remove_column :users, :address_state
    remove_column :users, :address_zip
    remove_column :users, :rank
    remove_column :users, :purchased_lead_count
    remove_column :users, :delivered_lead_count
    remove_column :users, :next_purchased_lead_count
    remove_column :users, :cms_id
    remove_column :users, :location_active

  end
end
