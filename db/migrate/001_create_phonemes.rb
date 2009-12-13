class CreatePhonemes < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :phonemes do |t|
        t.column :phone, :string, :null => false
      end
    end
  end
  
  def self.down
    drop_table :phonemes
  end
end
