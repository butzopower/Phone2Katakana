module Helpers
  def translate(word)
    Translate.t(word, "ENGLISH", "JAPANESE")
  end
  
  alias t translate
end

include Helpers
