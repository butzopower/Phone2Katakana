class ImportPhonemes < ActiveRecord::Migration[6.1]
  def self.up
    transaction do
      File.open('lib/cmudict.0.7a.phones').read.split("\n").each do |phone|
        Phoneme.create(:phone => phone)
      end
    end
  end

  def self.down
    Phoneme.delete_all    
  end
end
