class CreateCorpus < ActiveRecord::Migration[6.1]
  def self.up
    transaction do
      create_table :corpus do |t|
        t.column :word, :string
        t.column :phonemes, :string
      end
    end
  end

  def self.down
    drop_table :corpus
  end
end
