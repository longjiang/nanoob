class Blog::TaxonomiesController < CrudController
  
  self.permitted_attrs = [:business_website_id, :name, :slug, :hide_website_col]
  self.filtering_params = [:business_website_id ]
  self.sortable_attrs   = [ :name, :posts_count ]
  
  before_action :find_website
  skip_before_action :decorate_entry
  skip_before_action :entry, only: [:show]

  private
  
  def add_menu_items
    link_params = current_user.last_filters['blog/contents/posts'].blank? ? {mine: current_user.id, business_id: current_user.business_id, business_website_id: current_user.website_id} : current_user.last_filters['blog/contents/posts']
    @menu.update do |menu|
      menu.update I18n.t("menu.blog/contents/posts"), blog_contents_posts_path(link_params), 'posts', {icon: Blog::Contents::Post.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.blog/contents/post.all"), blog_contents_posts_path, {icon: false}
        submenu.add I18n.t("menu.blog/contents/post.add_new"), new_blog_contents_post_path(business_website_id: current_user.website_id), {icon: false}
        submenu.add I18n.t("menu.blog/taxonomies/categories.all"), blog_taxonomies_categories_path(business_website_id: @website ? @website.id : current_user.website_id), {icon: false}
        submenu.add I18n.t("menu.blog/taxonomies/tags.all"), blog_taxonomies_tags_path(business_website_id: @website ? @website.id : current_user.website_id), {icon: false}
      end
    end
  end
    
end