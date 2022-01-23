module WithProgressTracker
  extend self

  def with_progress_tracker(list)
    list.each_slice(list.size / 10).with_index do |subset, index|
      puts "#{index * 10}% Done"

      yield subset
    end
  end
end
