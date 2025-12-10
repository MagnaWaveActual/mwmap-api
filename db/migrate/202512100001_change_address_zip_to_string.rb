class ChangeAddressZipToString < ActiveRecord::Migration[6.1]
  def change
    change_column :locations, :address_zip, :string
  end
end
