class CreateKatakanas < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :katakanas do |t|
        t.column :characters, :string, :null => false
      end
    end
  end
  
  def self.down
    drop_table :katakanas
  end
end
