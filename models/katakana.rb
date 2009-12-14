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
                  ピャ ピュ ピョ

                       イィ 
                  ヴァ ヴィ ヴ ヴェ ヴォ
                  シェ
                  ジェ
                  チェ
                  スァ スィ スゥ スェ スォ
                  ズァ ズィ ズゥ ズェ ズォ
                  ツァ ツィ      ツェ ツォ
                  テァ ティ テゥ テェ テォ
                  デァ ディ デゥ デェ デォ
                  トァ トィ トゥ トェ トォ
                  ドァ ドィ ドゥ ドェ ドォ
                  ファ フィ ホゥ フェ フォ
                       リィ      リェ
                       ウィ      ウェ ウォ
                  クァ クィ クゥ クェ クォ
                  グァ グィ グゥ グェ グォ
                  ムァ ムィ ムゥ ムェ ムォ 
                  ).reverse
  SOUNDS = {
          'ア' => 'A',
          'イ' => 'I', 
          'ウ' => 'U',  
          'エ' => 'E', 
          'オ' => 'O',
          'カ' => 'KA',
          'キ' => 'KI',
          'ク' => 'KU',
          'ケ' => 'KE', 
          'コ' => 'KO',
          'サ' => 'SA',
          'シ' => 'SHI', 
          'ス' => 'SU',
          'セ' => 'SE', 
          'ソ' => 'SO',
          'タ' => 'TA',
          'チ' => 'CHI',
          'ツ' => 'TSU',
          'テ' => 'TE',
          'ト' => 'TO', 
          'ナ' => 'NA', 
          'ニ' => 'NI', 
          'ヌ' => 'NU',
          'ネ' => 'NE', 
          'ノ' => 'NO', 
          'ハ' => 'HA',
          'ヒ' => 'HI',
          'フ' => 'FU',
          'ヘ' => 'HE',
          'ホ' => 'HO', 
          'マ' => 'MA',
          'ミ' => 'MI',
          'ム' => 'MU', 
          'メ' => 'ME',
          'モ' => 'MO',
          'ヤ' => 'YA',
          'ユ' => 'YU',
          'ヨ' => 'YO', 
          'ラ' => 'RA', 
          'リ' => 'RI',
          'ル' => 'RU', 
          'レ' => 'RE', 
          'ロ' => 'RO', 
          'ワ' => 'WA',
          'ガ' => 'GA', 
          'ギ' => 'GI', 
          'グ' => 'GU', 
          'ゲ' => 'GE', 
          'ゴ' => 'GO', 
          'ザ' => 'ZA', 
          'ジ' => 'JI', 
          'ズ' => 'ZU', 
          'ゼ' => 'ZE', 
          'ゾ' => 'ZO',
          'ダ' => 'DA',
          'デ' => 'DE', 
          'ド' => 'DO',
          'バ' => 'BA', 
          'ビ' => 'BI', 
          'ブ' => 'BU', 
          'ベ' => 'BE', 
          'ボ' => 'BO',
          'パ' => 'PA', 
          'ピ' => 'PI', 
          'プ' => 'PU', 
          'ペ' => 'PE', 
          'ポ' => 'PO'}
  LONG = 'ー'
  DOUBLE = 'ッ'
  # japanese n sound is special, since it has no vowel and suppliments other characters
  N = 'ン'

  PHONES = CHARACTERS.map{|x| "#{DOUBLE + x}"} | CHARACTERS.map{|x| "#{x + LONG}"} | CHARACTERS | [N]

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

  def self.find_matches(phonemes)
    groups = []
    results = []
    [*phonemes].each do |phoneme|
      groups << phoneme.intersections.map {|x| [x.katakana.phone, phoneme.probability(x.katakana)] }
    end
    
    if groups.size == 1
      results = groups[0]
    else
      groups[0].each do |x|
        begin
          prob = x[1]
          groups[1..-1].each do |y|
            pair = y.find{|z| z[0] == x[0]}
            raise if pair.nil?
            prob *= pair[1]   
          end
          results << [x[0], prob]
        rescue 
          # do nothing
        end
      end
    end
       
    return results.sort_by{|x| x[1]}.last(5).map{|x| x[0]}
  end

  def self.guess(word)
    phoneme = Corpus.find_by_word(word).phonemes
    phonemes = Phoneme.dissect(phoneme)
    result = []
    while !phonemes.empty?
      if phonemes.size >= 3
        current = phonemes.first(3).map{|x| Phoneme.find_by_phone(x)}
        first = find_matches(current[0])
        last = find_matches(current[2]) 
        first_group = find_matches([current[0], current[1]])
        last_group = find_matches([current[1], current[2]])
        three_match = (first & last_group) & (last & first_group)
        unless three_match.empty?
          result << three_match[0] 
          phonemes = phonemes.last(phonemes.size - 3)
        else
          all_three = find_matches([current[0], current[1], current[2]])
          two_match = first & all_three
          unless two_match.empty?
            result << two_match[0]
            phonemes = phonemes.last(phonemes.size - 2)
          else
            other_two_match = first & first_group
            unless other_two_match.empty?
              result << other_two_match[0]
              phonemes = phonemes.last(phonemes.size - 2)
            else
              result << first[0]
              phonemes = phonemes.last(phonemes.size - 1)
            end
          end
        end
      elsif phonemes.size >= 2
        current = phonemes.first(2).map{|x| Phoneme.find_by_phone(x)}
        first = find_matches(current[0])
        first_group = find_matches([current[0], current[1]])
        two_match = first & first_group
        unless two_match.empty?
          result << two_match[0]
          phonemes = phonemes.last(phonemes.size - 2)
        else
          result << first[0]
          phonemes = phonemes.last(phonemes.size - 1)
        end
      elsif phonemes.size == 1
        result << find_matches(Phoneme.find_by_phone(phonemes[0])).last
        phonemes = []
      end
    end
    result
  end
  
  has_many :intersections
  has_many :phonemes, :through => :intersections

end
