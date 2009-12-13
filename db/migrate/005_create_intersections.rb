class CreateIntersections < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :intersections do |t|
        t.column :phoneme_id, :integer
        t.column :katakana_id, :integer
        t.column :times_matched, :integer
      end
    end
  end
  
  def self.down
    drop_table :intersections
  end
end
