namespace :db do
  namespace :maintenance do
  
    desc "after migration 20160927090915"
    task :after_migration_20160927090915 => :environment do |t, args|
      begin
        johary = People::User.find_by_username('johary')
        if ActiveRecord::Migrator.current_version.eql?(20160927090915) && johary.nil?
          print "changing Posts type..."
          Blog::Content.where(type: nil).update_all type: 'Blog::Contents::Post'
          puts " ok!"
          print "changing Category type..."
          Blog::Taxonomy.where(type: nil).update_all type: 'Blog::Taxonomies::Category'
          puts " ok!"
          print "adding roles..."
          nanou = People::User.find_by_username('nanou')
          gilles = People::User.find_by_username('gilles')
          admin = People::User.find_by_username('admin') 
          ireti = People::User.find_by_username('ireti')
          david = People::User.find_by_username('david')
          johary = People::User.create(username: 'johary', email: 'johary@example.org', password: (0...50).map { ('a'..'z').to_a[rand(26)] }.join)
          nanou.add_role(:editor)
          nanou.save
          gilles.add_role(:editor)
          gilles.save
          admin.add_role(:admin)
          admin.save
          ireti.add_role(:blogger)
          ireti.save
          david.add_role(:editor)
          david.save
          johary.add_role(:blogger)
          johary.save
          puts " ok!"
          print "changing posts users..."
          Blog::Contents::Post.all.each do |p|
            p.owner = gilles
            p.writer = johary
            p.editor = nanou
            p.optimizer = ireti
            p.save(touch: false)
          end
          puts " ok !"
          puts "*** DONE ***"
        end
      rescue Exception => e
        puts "Something unexpected happened : #{e}"
      end
    end
  end
end