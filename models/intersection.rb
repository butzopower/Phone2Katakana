class Intersection < ActiveRecord::Base
  belongs_to :phoneme
  belongs_to :katakana

  # this looks at the edges, and doesn't add anything that isn't at the edges
  # need a good way to get everything between that is also fast
  def self.map(phonemes, katakanas)
    if phonemes.size > katakanas.size
      0.upto(katakanas.size - 1) do |index|
        intersections = [phonemes[(index * phonemes.size) / katakanas.size]]
        # trying this as a means to get non edge intersections
        1.upto(3) do |x| 
          intersections << phonemes[(((index + x/3.0) * phonemes.size) -1) / katakanas.size]
        end
        intersections.uniq.each do |intersection|
          find_or_create_intersection(intersection, katakanas[index])
        end
      end
    end
  end

  def self.find_or_create_intersection(phone, katakana)
    p = Phoneme.find_by_phone(phone)
    k = Katakana.find_by_phone(katakana)
    i = find_or_initialize_by(phoneme_id: p.id, katakana_id: k.id)
    i.times_matched = (i.times_matched || 0 ) + 1
    i.save
  end
end
