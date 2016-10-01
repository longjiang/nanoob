class WebmasterRole < AccessGranted::Role
  def configure
    can :manage, People::Author
    can :manage, Business::Website
    can :manage, Blog::Taxonomies::Tag
    can :manage, Blog::Taxonomies::Category
    can :publish, Blog::Contents::Page do |page| 
      !page.published? 
    end
    can :unpublish, Blog::Contents::Page do |page| 
      page.published?
    end
  end
end