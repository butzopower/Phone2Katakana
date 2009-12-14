class JapaneseCorpus < ActiveRecord::Base
  belongs_to :corpus
  
  def map_to_corpus
    Intersection.map(Phoneme.dissect(corpus.phonemes), Katakana.dissect(word))
  end
end
