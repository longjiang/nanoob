class AddTypeToBlogTaxonomies < ActiveRecord::Migration[5.0]
  def change
    add_column :blog_taxonomies, :type, :string
  end
end
