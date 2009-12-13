class ImportKatakanas < ActiveRecord::Migration
  def self.up
    transaction do
      
      Katakana::PHONES.each do |katakana|
        Katakana.create(:characters => katakana)
      end

    end
  end

  def self.down
    Katakana.delete_all    
  end
end
