class CreateJapaneseCorpus < ActiveRecord::Migration[6.1]
  def self.up
    transaction do
      create_table :japanese_corpus do |t|
        t.column :word, :string
        t.column :corpus_id, :integer
      end
    end
  end

  def self.down
    drop_table :japanese_corpus
  end
end
