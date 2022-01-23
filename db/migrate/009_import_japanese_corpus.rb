class ImportJapaneseCorpus < ActiveRecord::Migration[6.1]
  def self.up
    transaction do
      File.open('lib/experiment1').each do |line|
        line =~ /^(\w+) - (.+?) - (.+)/
        unless $1.nil? or $2.nil?
          corpus = Corpus.find_by_word($1)
          JapaneseCorpus.create(corpus: corpus, word: $2)
        end
      end
    end
  end

  def self.down
    JapaneseCorpus.delete_all
  end

end
