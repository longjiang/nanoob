namespace :db do
  namespace :maintenance do
  
    desc "after migration 20161007104622"
    task :after_migration_20161007104622 => :environment do |t, args|
      begin
        if ActiveRecord::Migrator.current_version.eql?(20161007104622) && Business::Language.find_by_name('french').nil?
          %w(french italian).each do |language|
            Business::Language.create(name: language, isocode: language[0,2])
          end
          french = Business::Language.find_by_name('french')
          Business.update_all business_language_id: french.id
          %w(a à ai aie aient aies ait alors as au aucuns aura aurai auraient aurais aurait auras aurez auriez aurions aurons auront aussi autre aux avaient avais avait avant avec avez aviez avions avoir avons ayant ayez ayons bon c ça car ce ceci cela celà ces cet cette ceux chaque ci comme comment d dans de début dedans dehors depuis des devrait doit donc dos du elle elles en encore es essai est et étaient étais était étant état été étée étées êtes étés étiez étions être eu eue eues eûmes eurent eus eusse eussent eusses eussiez eussions eut eût eûtes eux fait faites fois font fûmes furent fus fusse fussent fusses fussiez fussions fut fût fûtes hors ici il ils j je juste l la là le les leur leurs lui m ma maintenant mais me même mes mine moi moins mon mot n ne ni nommés nos notre nous on ont ou où par parce pas peu peut plupart pour pourquoi qu quand que quel quelle quelles quels qui s sa sans se sera serai seraient serais serait seras serez seriez serions serons seront ses seulement si sien soi soient sois soit sommes son sont sous soyez soyons suis sujet sur t ta tandis te tellement tels tes toi ton tous tout très trop tu un une voient vont vos votre vous vu y).each do |stop_word|
            french.stop_words.create(word: stop_word, source: 'http://snowball.tartarus.org/algorithms/french/stop.txt')
          end
        end
      rescue Exception => e
        puts "Something unexpected happened : #{e}"
      end
    end
    
    
    
  end
end