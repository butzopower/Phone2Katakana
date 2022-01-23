class AddIndexToJapaneseCorpus < ActiveRecord::Migration[6.1]
  def self.up
    transaction do
      add_index :japanese_corpus, :corpus_id
    end
  end

  def self.down
    transaction do
      remove_index :japanese_corpus, :corpus_id
    end
  end
end
