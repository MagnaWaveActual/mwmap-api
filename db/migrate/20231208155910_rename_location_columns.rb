class RenameLocationColumns < ActiveRecord::Migration[6.1]
  def change
    rename_column :locations, :insta, :social_one
    rename_column :locations, :faceb, :social_two
    add_column :locations, :description, :string
  end
end
