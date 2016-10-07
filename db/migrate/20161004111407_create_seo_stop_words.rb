class CreateSeoStopWords < ActiveRecord::Migration[5.0]
  def change
    create_table :seo_stop_words do |t|
      t.string :excludable_type
      t.integer :excludable_id
      t.string :word
      t.string :source
      t.timestamps
    end
    add_index :seo_stop_words, [:excludable_type, :excludable_id, :word], unique: true, name: 'index_seo_stop_words_on_excludable_and_word'
  end
end
