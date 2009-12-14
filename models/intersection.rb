class Intersection < ActiveRecord::Base
  belongs_to :phoneme
  belongs_to :katakana

  def self.map(phonemes, katakanas)
    if phonemes.size > katakanas.size
      0.upto(katakanas.size - 1) do |index|
        front = phonemes[(index * phonemes.size) / katakanas.size]
        back = phonemes[(((index + 1) * phonemes.size) -1) / katakanas.size]
        if front == back
          find_or_create_intersection(front, katakanas[index])
        else
          find_or_create_intersection(front, katakanas[index])
          find_or_create_intersection(back, katakanas[index])
        end
      end
    end
  end

  def self.find_or_create_intersection(phone, katakana)
    p = Phoneme.find_by_phone(phone)
    k = Katakana.find_by_phone(katakana)
    i = find(:first, :conditions => {:phoneme_id => p.id, :katakana_id => k.id})
    if i.nil?
      create(:phoneme_id => p.id, :katakana_id => k.id, :times_matched => 1)
    else
      i.times_matched += 1
      i.save
    end
  end
end
