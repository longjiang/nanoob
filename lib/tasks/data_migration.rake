class Datamigration 
  
  class WebsiteNotFound < StandardError; end 
  class DatabaseNotFound < StandardError; end 
  
  class WpPost
    attr_accessor :id, :parent_id, :type, :date, :name, :body, :title, :status
  end

  MYSQL_URLS = { lemarchedurideau: 'CLEARDB_DATABASE_URL_production_lemarchedurideau', lapoigneedemain: 'CLEARDB_DATABASE_URL_production_lapoigneedemain'}
  WEBSITE_URLS = { lemarchedurideau: 'http://lemarchedurideau.com', lapoigneedemain: 'http://lapoigneedemain.com'}

  QUERY_POSTS = "select id as post_id, post_parent as post_parent_id, post_type, post_date, post_name, post_content as post_body, post_title, post_status from wp_posts where post_type = 'post' and post_status in ('draft','publish') order by post_type desc, post_id asc"
  QUERY_FEATURED_IMAGES = "SELECT a.post_id , b.meta_value FROM `wp_postmeta` a join `wp_postmeta` b on a.meta_value = b.post_id and b.meta_key = 'amazonS3_info' where a.meta_key = '_thumbnail_id' and a.post_id in (**POST_IDS**)"
  QUERY_CATEGORIES = "SELECT a.object_id as post_id, c.name, c.slug, b.taxonomy, b.description FROM `wp_term_relationships` a join wp_term_taxonomy b on a.term_taxonomy_id = b.term_taxonomy_id join wp_terms c on b.term_id = c.term_id where b.taxonomy='category' and a.object_id in (**POST_IDS**)"

  attr_accessor :website_slug, :website, :ids_mapping, :wp_posts, :wp_featured_images, :wp_categories
  
  
  def initialize(website_slug)
    @website_slug = website_slug
    find_website
  end
  
  def last_successful_step
    website.get_meta(:data_migration_step) || 0
  end
  
  def migrate_wp_posts
    statuses_mapping = {'draft' => :draft, 'publish' => :published}
    @ids_mapping = {}
    owner = website.owner
    total = wp_posts.count
    puts "================="
    puts "Starting #{website.decorate.host} WordPress Posts Migration."
    puts "#{total} rows to process..."
    puts "=====\n"
    
    wp_posts.each_with_index do |row, row_num|
      wpPost = WpPost.new
      %w(id parent_id type date name body title status).each do |attr|
        wpPost.send("#{attr}=", row["post_#{attr}"])
      end
      wpPost.status = statuses_mapping[wpPost.status]
      puts "Processing row ##{row_num +1}/#{total}  (ID: #{wpPost.id}, Status: #{wpPost.status}, Title: #{wpPost.title})" 
      post = Blog::Post.create!(owner: owner, website: website, title: recoding(wpPost.title), body: recoding(wpPost.body), slug: wpPost.name, status: wpPost.status, published_at: wpPost.date, created_at: wpPost.date, updated_at: wpPost.date)
      @ids_mapping[wpPost.id.to_s] = post.id
    end
    website.set_meta(:ids_mapping, @ids_mapping)
    website.set_meta(:data_migration_step, 1)
    website.save!
    puts "====="
    puts "DONE.\n\n"
  end

  def migrate_wp_featured_images
    require 'php_serialize'
    total = wp_featured_images.count
    puts "================="
    puts "Starting #{website.decorate.host} WordPress Featured Images Migration."
    puts "#{total} rows to process..."
    puts "=====\n"
    
    errors = 0
    wp_featured_images.each_with_index do |row, row_num| 
      begin
        wpPost_id     = row['post_id']
        wpMeta_value  = recoding(row['meta_value'])
        puts "Processing row ##{row_num +1}/#{total} (PostID: #{wpPost_id}, Meta: #{wpMeta_value})"
        wpMeta_value  = PHP.unserialize(wpMeta_value)
        url     = "http://#{wpMeta_value['bucket']}/#{wpMeta_value['key']}"
        url = URI.escape(url)
        post = Blog::Post.find_by_id!(ids_mapping[wpPost_id.to_s])
        print "    attaching file..."
        post.remote_featured_image_url = url
        post.save!(touch: false)
        puts " OK! \n"
      rescue Exception => e
        errors += 1
        puts "KO! \n"
      end
    end
    puts "====="
    if errors > 0
      puts "WARNING : #{errors} errors\n\n"
    else
      puts "DONE.\n\n"
    end
    website.set_meta(:data_migration_step, 2)
    website.save!
  end
  
  def migrate_wp_categories
    total = wp_categories.count
    puts "================="
    puts "Starting #{website.decorate.host} WordPress Categories Migration."
    puts "#{total} rows to process..."
    puts "=====\n"
    
    wp_categories.each_with_index do |row, row_num|
      wpPost_id       = row['post_id']
      wpCategory_name = row['name']
      puts "Processing row ##{row_num +1}/#{total} (PostID: #{wpPost_id}, Category: #{wpCategory_name})"
      category = find_category_or_create_by_name(recoding(wpCategory_name))
      post = Blog::Post.find_by_id!(ids_mapping[wpPost_id.to_s])
      post.categories << category unless post.categories.include?(category)
    end
    puts "====="
    puts "DONE.\n\n"
    website.set_meta(:data_migration_step, 3)
    website.save!
  end

  private
  
  def find_website
    raise WebsiteNotFound, "Unknown Website. Available values : #{WEBSITE_URLS.keys.join(', ')}" unless WEBSITE_URLS.keys.include?(website_slug.to_sym)
    @website = Business::Website.find_by_url!(WEBSITE_URLS[website_slug.to_sym])
  end
  
  def mysql_connect
    mysql_url = ENV[MYSQL_URLS[website_slug.to_sym]]
    raise DatabaseNotFound, "Unknown MySql Database. Available values : #{MYSQL_URLS.keys.join(', ')}" unless mysql_url.present?
    uri = URI.parse(mysql_url)
    hostname = uri.host
    username = uri.user
    password = uri.password
    database = uri.path[1..30]
    Mysql2::Client.new(host: hostname, username: username, password: password, database: database, encoding: 'utf8')
  end
  
  def query(query)
    print "Connecting to MySQL..."
    db = mysql_connect
    puts "ok."
    print "Querying..."
    results = db.query(query)
    puts "ok"
    db.close
    results
  end
  
  def ids_mapping
    @ids_mapping ||= website.get_meta(:ids_mapping)
  end
  
  def wp_posts
    @wp_posts ||= query(QUERY_POSTS)
  end
  
  def wp_featured_images
    @wp_featured_images ||= query(QUERY_FEATURED_IMAGES.gsub('**POST_IDS**', ids_mapping.keys.join(',')))
  end
  
  def wp_categories
    @wp_categories ||= query(QUERY_CATEGORIES.gsub('**POST_IDS**', ids_mapping.keys.join(',')))
  end
  
  def recoding(string)
    search = %w(Ã€ Ã‡ Å“ â‚¬ â€˜ â€™ â€¦ Ã‰ â€“ â€Ž)
    replace = %w(&Agrave; &Ccedil; &oelig; &euro; ' ' ... &Eacute; &ndash; ")
    search.each_with_index do |s, idx|
      string = string.gsub(s, replace[idx])
    end
    string.encode('iso-8859-1').force_encoding('utf-8')
  end
  
  def find_category_or_create_by_name(name)
    website.categories.find_or_create_by(name: name.try(:humanize))
  end
  
end

namespace :db do
  namespace :data_migration do
  
    desc "migrate clearDB posts"
    task :wp, [:website, :starts_at_step] => :environment do |t, args|
      begin
        dm = Datamigration.new(args[:website])
        if args[:starts_at_step]
          starts_at_step = args[:starts_at_step].to_i
        else
          starts_at_step = dm.last_successful_step
        end
        dm.migrate_wp_posts if starts_at_step <= 1
        dm.migrate_wp_featured_images  if starts_at_step <= 2
        dm.migrate_wp_categories  if starts_at_step <= 3
      rescue Exception => e
        puts "Something unexpected happened : #{e}"
      end
    end
  end
end


