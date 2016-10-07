namespace :seo do
  namespace :tests do
  
    desc "recherche de mots vides"
    task :empty_words => :environment do |t, args|
      
      posts = Blog::Contents::Post
      posts = Business::Website.find(3).posts
      
      stats = {}
      
      %w(1 3).each do |website_id|
        
        website = Business::Website.find(website_id)
        posts = website.posts
      
        total = posts.count
        idx = 0
        words = {}
        densities = {}
        frequencies = {}
        average_frequencies = {}
        most_frequents = {}
        # Blog::Contents::Post.all.each do |post|
   #        idx += 1
   #        STDOUT.write "processing #{post.id.to_s.ljust(4)} (#{(100*idx/total.to_f).round(2).to_s.rjust(6)}%)"
   #        post.counter.token_density(precision: 5).each do |word, density|
   #          _ = words[word] || []
   #          words[word] = _ << density if density > 0.02
   #        end
   #        STDOUT.write "  Words Size: #{words.size}\r"
   #      end
   #      puts "\n"
   #
   #      idx = 0
   #      words.each do |word, densities|
   #        idx += 1
   #        STDOUT.write "processing #{word.ljust(50)} (#{(100*idx/densities.size.to_f).round(2).to_s.rjust(6)}%)\r"
   #        average = densities.inject(0.0) { |sum, el| sum + el } / densities.size
   #        avg_densities[word] = average
   #      end
        posts.each do |post|
          idx += 1
          STDOUT.write "processing #{post.id.to_s.ljust(4)} (#{(100*idx/total.to_f).round(2).to_s.rjust(6)}%)"
            post.counter.token_frequency.each do |word, frequency|
              if frequency > 0
                words[word] = (words[word] || 0) + 1
                frequencies[word] = (frequencies[word] || []) << frequency
                mf = most_frequents[word] || [0,0]
                if frequency > mf[0]
                  most_frequents[word] = [frequency, post.id]
                end
              end
            end
            STDOUT.write "  Words Size: #{words.size}\r "
          end
          puts "\n"
        
        
          words.each do |word, occurences|
            densities[word] = [(occurences * 100 / total.to_f).round(3)]
          end
          #densities = densities.sort{ |a,b| a[1] <=> b[1]}.reverse
        
         
          frequencies.each do |word, frequencies|
            densities[word] << (frequencies.inject(0.0) { |sum, el| sum + el } / frequencies.size).round(1)
          end
        
          most_frequents.each do |word, stats|
            densities[word] << stats[0]
            densities[word] << stats[1]
          end
        
      
        densities = densities.sort{ |a,b| a[1] <=> b[1]}.reverse
        
        stats[website.host] = densities
        
      end
      
      densities_0 = stats["lemarchedurideau.com"].select{|d| d[1][1] > 2}.first(50).collect{|d| d[0]}
      densities_1 = stats["lapoigneedemain.com"].select{|d| d[1][1] > 2}.first(50).collect{|d| d[0]}
     
      empty_words = (densities_0 & densities_1)
      
      stats.each do |k,v|
        puts "****"
        puts k
      v.select{|d| !empty_words.include?(d[0]) && d[1][0] > 20}.each do |word, stats|
         puts "#{word}\t#{stats[0]}\t#{stats[1]}\t#{stats[2]}\t#{stats[3]}"
       end
     end
       
       

      # densities.select{|d| d[1][1] > 1}.first(100).each do |word, stats|
 #        puts "#{word}\t#{stats[0]}\t#{stats[1]}\t#{stats[2]}\t#{stats[3]}"
 #      end
     # puts average_frequencies.inspect
    end
  end
end