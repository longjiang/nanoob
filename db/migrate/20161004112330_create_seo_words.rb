class CreateSeoWords < ActiveRecord::Migration[5.0]
  def change
    create_table :seo_words do |t|
      t.string :word_countable_type
      t.integer :word_countable_id
      t.string :word
      t.integer :frequency
      t.timestamps
    end
    add_index :seo_words, [:word_countable_type, :word_countable_id], name: 'index_seo_words_on_word_countable'
    add_index :seo_words, [:word_countable_type, :word_countable_id, :word], unique: true, name: 'index_seo_words_on_word_countable_and_word'
  end
end
