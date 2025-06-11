class AddColumnsToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :services, :string
    add_column :locations, :address_l1, :string
    add_column :locations, :address_l2, :string
    add_column :locations, :address_state, :string
    add_column :locations, :address_city, :string
    add_column :locations, :address_zip, :integer
    add_column :locations, :rank, :integer
    add_column :locations, :purchased_lead_count, :integer
    add_column :locations, :delivered_lead_count, :integer
    add_column :locations, :next_purchased_lead_count, :integer
    add_column :locations, :cms_id, :integer
    add_column :locations, :location_active, :boolean
  end
end
