namespace :statistics do  
  
    desc "update views count"
    task :trackables_count_views => :environment do |t, args|
      
      Ahoy::Event.trackables
        .select("properties ->> 'trackable_type' as a, properties ->> 'trackable_id' as b, count(*)")
        .group("a, b")
        .collect { |_| [_.a, _.b, _.count] }
        .sort { |a,b| b[2] <=> a[2] }.each {|_| _[0].constantize.find(_[1]).update_attributes(views_count: _[2])}
          
    end
    
    desc "count words for all posts - run once"
    task :posts_init_statistics => :environment do |t, args|
      Blog::Contents::Post.order(created_at: :asc).all.each { |_| _.init_statistics }
    end
    
    desc "count words for websites - run once a day"
    task :websites_word_count => :environment do |t, args|
      Business::Website.nanoob.each { |_| _.count_words }
    end
    
  end