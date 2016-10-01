class AddProfileImageToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :profile_image_id, :string
  end
end
