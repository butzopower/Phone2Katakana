class CreateJapaneseCorpus < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :japanese_corpus, :id => nil do |t|
        t.column :word, :string
        t.column :corpus_id, :integer
      end
    end
  end

  def self.down
    drop_table :japanese_corpus
  end
end
