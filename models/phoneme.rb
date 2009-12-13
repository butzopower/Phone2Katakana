class Phoneme < ActiveRecord::Base
  has_many :intersections
  has_many :katakanas, :through => :intersections
end
