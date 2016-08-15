namespace :db do
  namespace :data_migration do
  
    desc "migrate clearDB posts"
    task :wp, [:website] => :environment do |t, args|
    
      case args[:website]
      when "lemarchedurideau"
        mysql_url = ENV['CLEARDB_DATABASE_URL_production_lemarchedurideau']
        website = Business::Website.find_by_url('http://lemarchedurideau.com')
        user = User.last
      when "lapoigneedemain"
        mysql_url = ENV['CLEARDB_DATABASE_URL_production_lapoigneedemain']
        website = Business::Website.find_by_url('http://lapoigneedemain.com')
        user = User.first
      else
        puts "Unknown Website. Available values : lemarchedurideau, lapoigneedemain"
      end
    
      if mysql_url && website && user

        uri = URI.parse(mysql_url)
        hostname = uri.host
        username = uri.user
        password = uri.password
        database = uri.path[1..30]
        
        puts "Connecting to ClearDB..."
        db = Mysql2::Client.new(host: hostname, username: username, password: password, database: database, encoding: 'utf8')
        puts "Connected to ClearDB."
        
        
        # POSTS
        
        puts "Querying..."
        query    = "select id, post_parent, post_type, post_date, post_name, post_content, post_title, post_status, guid from wp_posts where post_type in ('post', 'attachment') order by post_type desc, id asc"
        results = db.query(query)
        puts "Results ok."
        statuses_mapping = {'draft' => :draft, 'publish' => :published}
        ids_mapping = {}
        ids_attachments = {}
        search = %w(Ã€ Ã‡ Å“ â‚¬ â€˜ â€™ â€¦ Ã‰ â€“ â€Ž)
        replace = %w(&Agrave; &Ccedil; &oelig; &euro; ' ' ... &Eacute; &ndash; ")


        results.each_with_index do |row, row_num|
          
          type = row['post_type']
          slug = row['post_name']
          date = row['post_date']
          body = row['post_content']
          title = row['post_title']
          status = statuses_mapping[row['post_status']]
          
          puts "Processing #{row_num} (#{type})"
          
          if type.eql?('post')
            if status
              search.each_with_index do |s, idx|
                body = body.gsub(s, replace[idx])
                title = title.gsub(s, replace[idx])
              end
              body = body.encode('iso-8859-1').force_encoding('utf-8')
              title = title.encode('iso-8859-1').force_encoding('utf-8')
              post = Blog::Post.create!(owner: user,
                  website: website,
                  title: title,
                  body: body,
                  slug: slug,
                  status: status,
                  published_at: date,
                  created_at: date,
                  updated_at: date
                )
                ids_mapping[row['id']] = post.id
                puts "Post '#{title}' created!"
            else
              puts "Skipped (status #{row['post_status']})"
            end
          else
            ids_attachments[row['id']] = row['post_parent'] 
          end
        end
        # end of post loop
        
        # attachments
        require 'php_serialize'
        puts "Querying..."
        query = "select post_id, meta_value from wp_postmeta where meta_key = 'amazonS3_info' and post_id in (#{ids_attachments.keys.join(',')})"
        puts query
        results = db.query(query)
        puts "Results ok."
        
        results.each_with_index do |row, row_num|
        
          puts "Processing #{row_num}"
        
          begin
            attachment_parent = ids_attachments[row['post_id']]
            post_id = ids_mapping[attachment_parent]
            post = Blog::Post.find_by_id(post_id) if post_id
            if post_id && post
              meta = row['meta_value'].encode('iso-8859-1').force_encoding('utf-8')
              meta = PHP.unserialize(meta)
              url = "http://#{meta['bucket']}/#{meta['key']}"
              url = URI.escape(url)
              print "attaching file..."
              post.remote_featured_image_url = url
              post.save!
              puts "done!... \n"
            else
              puts "WARNING : cant find any post with #{row['post_id']} -> #{attachment_parent} -> #{post_id}"
            end
          rescue Exception => e
            debugger
            puts "ERROR : #{row} can't be processed (#{e})"
          end
        end
      end
    end 
  end
end


