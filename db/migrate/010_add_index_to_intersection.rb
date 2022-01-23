class AddIndexToIntersection < ActiveRecord::Migration[6.1]
  def self.up
    transaction do
      add_index :intersections, [:phoneme_id, :katakana_id]
      add_index :intersections, :phoneme_id
      add_index :intersections, :katakana_id
    end
  end

  def self.down
    transaction do
      remove_index :intersections, [:phoneme_id, :katakana_id]
      remove_index :intersections, :phoneme_id
      remove_index :intersections, :katakana_id
    end
  end
end
