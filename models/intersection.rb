class Intersection < ActiveRecord::Base
  belongs_to :phoneme
  belongs_to :katakana
end
