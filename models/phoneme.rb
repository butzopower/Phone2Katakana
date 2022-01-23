class Phoneme < ActiveRecord::Base
  has_many :intersections
  has_many :katakanas, :through => :intersections
  
  def self.dissect(word)
    word.split(' ')
  end
  
  def probability(katakana) 
    intersection = intersections.where(katakana_id: katakana.id).first
    return 0 if intersection.nil?
    prob = intersection.times_matched.to_f / intersections.sum(:times_matched)
    # need to make this hueristic, since N comes up a lot when it shouldn't
    if katakana.phone == Katakana::N
      if self.phone == 'N'
        return prob
      else
        return prob / 10.0
      end
    else
      prob 
    end
  end

end
