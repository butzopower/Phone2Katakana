require 'active_record'

module Import
  extend self

  def import_english_corpus
    puts "Importing English Corpus"

    lines = File.open('lib/cmudict.0.7a').map {|line| line}

    ActiveRecord::Base.transaction do
      with_progress_tracker(lines) do |batch|
        records_to_create = []
        batch.each do |line|
          unless line =~ /^;;;/
            line =~ /^(\w*) (.*)$/
            unless $1.nil? or $2.nil?
              records_to_create << {
                word: $1,
                phonemes: $2,
              }
            end
          end
        end

        Corpus.insert_all!(records_to_create)
      end

      puts "Done"
    end
  end

  def import_japanese_corpus
    puts "Importing Japanese Corpus"

    lines = File.open('lib/experiment1').map {|line| line}

    ActiveRecord::Base.transaction do
      with_progress_tracker(lines) do |batch|
        records_to_create = []

        batch.each do |line|
          line =~ /^(\w+) - (.+?) - (.+)/
          unless $1.nil? or $2.nil?
            corpus = Corpus.find_by_word($1)
            records_to_create << {corpus_id: corpus.id, word: $2}
          end
        end

        JapaneseCorpus.insert_all!(records_to_create)
      end
    end
  end

  private

  def with_progress_tracker(list)
    list.each_slice(list.size / 10).with_index do |subset, index|
      puts "#{index * 10}% Done"

      yield subset
    end
  end
end