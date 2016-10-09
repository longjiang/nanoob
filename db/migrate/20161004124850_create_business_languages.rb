class CreateBusinessLanguages < ActiveRecord::Migration[5.0]
  def change
    create_table :business_languages do |t|
      t.string :name
      t.string :isocode
      t.timestamps
    end
    rename_column :businesses, :language, :business_language_id
  end
end
