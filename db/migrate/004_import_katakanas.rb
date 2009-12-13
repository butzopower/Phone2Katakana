class ImportKatakanas < ActiveRecord::Migration
  def self.up
    transaction do
      
      Katakana::PHONES.each do |katakana|
        Katakana.create(:phone => katakana)
      end

    end
  end

  def self.down
    Katakana.delete_all    
  end
end
