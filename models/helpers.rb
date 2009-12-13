module Helpers
  def translate(word)
    Translate.t(word.upcase, "ENGLISH", "JAPANESE")
  end
  
  alias t translate
end

include Helpers
