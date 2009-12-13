class Katakana < ActiveRecord::Base
  # need to reverse, otherwise we'll match non-combinations first
  CHARACTERS = %w(ア イ ウ エ オ 
                  カ キ ク ケ コ 
                  サ シ ス セ ソ 
                  タ チ ツ テ ト 
                  ナ ニ ヌ ネ ノ 
                  ハ ヒ フ ヘ ホ 
                  マ ミ ム メ モ 
                  ヤ    ユ    ヨ 
                  ラ リ ル レ ロ 
                  ワ          ウ
                  ガ ギ グ ゲ ゴ 
                  ザ ジ ズ ゼ ゾ 
                  ダ       デ ド 
                  バ ビ ブ ベ ボ 
                  パ ピ プ ペ ポ
                  キャ キュ キョ 
                  シャ シュ ショ 
                  チャ チュ チョ 
                  ニャ ニュ ニョ 
                  ヒャ ヒュ ヒョ 
                  ミャ ミュ ミョ 
                  リャ リュ リョ
                  ギャ ギュ ギョ 
                  ジャ ジュ ジョ 
                  ビャ ビュ ビョ 
                  ピャ ピュ ピョ).reverse
  LONG = 'ー'
  DOUBLE = 'ッ'

  PHONES = CHARACTERS.map{|x| "#{DOUBLE + x}"} | CHARACTERS.map{|x| "#{x + LONG}"} | CHARACTERS

  # dissect a katakana string into it's parts
  def self.dissect(word)
    return [] if word.blank?
    PHONES.each do |char|
      if (word =~ /#{char}/) == 0
        rest = word.sub(char, '')
        return [char, self.dissect(rest)].flatten
      end
    end
    raise 'Word is not katakana'
  end
end
