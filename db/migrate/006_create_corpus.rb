class CreateCorpus < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :corpus, :id => nil do |t|
        t.column :word, :string
        t.column :phonemes, :string
      end
    end
  end

  def self.down
    drop_table :corpus
  end
end
