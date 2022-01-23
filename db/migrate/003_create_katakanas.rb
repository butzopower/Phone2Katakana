class CreateKatakanas < ActiveRecord::Migration[6.1]
  def self.up
    transaction do
      create_table :katakanas do |t|
        t.column :phone, :string, :null => false
      end
    end
  end
  
  def self.down
    drop_table :katakanas
  end
end
