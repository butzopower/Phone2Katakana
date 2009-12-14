class ImportCorpus < ActiveRecord::Migration
  def self.up
    transaction do
      File.open('lib/cmudict.0.7a').each do |line|
        unless line =~ /^;;;/
          line =~ /^(\w*) (.*)$/
          unless $1.nil? or $2.nil?
            Corpus.create(:word => $1, :phonemes => $2)
          end
        end
      end
    end
  end

  def self.down
    Corpus.delete_all
  end

end
