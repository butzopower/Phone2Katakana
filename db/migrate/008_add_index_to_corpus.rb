class AddIndexToCorpus < ActiveRecord::Migration[6.1]
  def self.up
    transaction do
      add_index :corpus, :word
    end
  end

  def self.down
    transaction do
      remove_index :corpus, :word
    end
  end
end
