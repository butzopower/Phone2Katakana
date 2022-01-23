class AddIndexToPhones < ActiveRecord::Migration[6.1]
  def self.up
    transaction do
      add_index :phonemes, :phone
      add_index :katakanas, :phone
    end
  end

  def self.down
    transaction do
      remove_index :phonemes, :phone
      remove_index :katakanas, :phone
    end
  end
end
