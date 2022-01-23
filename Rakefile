require 'active_record'
require 'yaml'
require 'readline'

task :default => :migrate

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :console => :environment do
  # debugger
  # puts "kinda like console"
end

task :experiment1 => :environment do
  file = File.open('data/experiment1', 'a')
  count = 0
  matches = 0
  Corpus.all.each do |word|
    begin
      count += 1
      jp_word = t(word.word)
      dissection = Katakana.dissect(jp_word)
      text = "#{word.word} - #{dissection.join} - #{dissection.join(' ')}"
      puts text
      file.puts text
      matches += 1
    rescue
    end
    puts "Total words: #{count} / Total matches: #{matches} / Ratio: #{matches / count.to_f}"
  end
  file.puts "Total words: #{count} / Total matches: #{matches} / Ratio: #{matches / count.to_f}" 
end

task :experiment2 => :environment do
  ap = Phoneme.find_by_phone("AH0") 
  bp = Phoneme.find_by_phone("B")
  matches = Katakana.find_a_match([ap, bp])
  puts matches
end

task :guess => :environment do 
  
  while line = Readline.readline('Enter the word to guess > ', true)
    exit if line == 'quit' || line == 'exit' || line == 'q'
    word = Corpus.find_by_word(line.upcase)
    if word.nil?
      puts "Word doesn't exist in Corpus"
    else
      katakana = word.japanese_corpus
      guess = Katakana.guess(line.upcase)
      puts "== #{line} =="
      puts "== PHONETIC : #{word.phonemes}"
      if katakana.nil?
        puts "== ACTUAL KATAKANA : Word has no real katakana equivalent"
      else
        puts "== ACTUAL KATAKANA : #{katakana.word}"
        puts "== ACTUAL PRONOUNCIATION : #{Katakana.print_sounds(katakana.word)}"
        Intersection.map(Phoneme.dissect(word.phonemes), Katakana.dissect(katakana.word))
      end
      puts "== GUESSED KATAKANA : #{guess}"
      puts "== GUESSED PRONOUNCIATION : #{Katakana.print_sounds(guess)}"
    end
  end

end

task :train => :environment do
  times = ENV['TIMES'].to_i || 1000
  words = []
  times.times do
    word = JapaneseCorpus.find((rand * (JapaneseCorpus.count + 1)).to_i)
    phonemes = Phoneme.dissect(word.corpus.phonemes)
    kanas = Katakana.dissect(word.word)

    Intersection.map(phonemes, kanas)
    words << word.corpus.word
  end
  puts "Trained with #{words.uniq.sort.join(', ')}"
end

task :environment do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))
  ActiveRecord::Base.logger = Logger.new(File.open('logs/database.log', 'a'))
  Dir.glob(File.join(File.dirname(__FILE__), '/models/*.rb')).each {|f| require f }
end
