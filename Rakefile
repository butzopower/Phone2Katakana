require 'rake/testtask'
require 'active_record'
require 'yaml'
require 'readline'
require_relative 'db/import'

task :default => :migrate

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :environment do
  ActiveRecord::MigrationContext.new(["db/migrate/"], ActiveRecord::Base.connection.schema_migration).migrate

  Import.import_english_corpus
  Import.import_japanese_corpus
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
  include WithProgressTracker

  times = ENV['TIMES'].to_i || 1000
  words = []

  puts "Searching for #{times} words"

  all_japanese_corpus_ids = (1..JapaneseCorpus.count).to_a
  ids_to_train_on = all_japanese_corpus_ids.sample(times)
  japanese_words = JapaneseCorpus
                     .where(id: ids_to_train_on)
                     .includes(:corpus)

  puts "Found words to train on"

  with_progress_tracker(japanese_words) do |batch|
    batch.each do |word|
      phonemes = Phoneme.dissect(word.corpus.phonemes)
      kanas = Katakana.dissect(word.word)

      Intersection.map(phonemes, kanas)
      words << word.corpus.word
    end
  end

  puts "Trained with #{words.uniq.sort.join(', ')}"
end

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
end
desc "Run tests"

task :environment do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))
  ActiveRecord::Base.logger = Logger.new(File.open('logs/database.log', 'a'))
  Dir.glob(File.join(File.dirname(__FILE__), '/models/*.rb')).each {|f| require f }

  if (ENV['LOG_SQL'] || 'false') == 'true'
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end
end
