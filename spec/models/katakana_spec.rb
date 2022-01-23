require 'minitest/autorun'
require_relative '../../models/katakana'

describe 'printing katakana sounds' do
  it 'can print vowels' do
    a = Katakana.print_sounds('ア')
    e = Katakana.print_sounds('エ')
    i = Katakana.print_sounds('イ')
    o = Katakana.print_sounds('オ')
    u = Katakana.print_sounds('ウ')

    expect(a).must_equal('A')
    expect(e).must_equal('E')
    expect(i).must_equal('I')
    expect(o).must_equal('O')
    expect(u).must_equal('U')
  end

  it 'can print long vowels' do
    a = Katakana.print_sounds('アー')
    e = Katakana.print_sounds('エー')
    i = Katakana.print_sounds('イー')
    o = Katakana.print_sounds('オー')
    u = Katakana.print_sounds('ウー')

    expect(a).must_equal('AA')
    expect(e).must_equal('EE')
    expect(i).must_equal('II')
    expect(o).must_equal('OO')
    expect(u).must_equal('UU')
  end

  it 'can print small ya yu yo' do
    nya = Katakana.print_sounds('ニャ')
    nyu = Katakana.print_sounds('ニュ')
    nyo = Katakana.print_sounds('ニョ')

    expect(nya).must_equal('NYA')
    expect(nyu).must_equal('NYU')
    expect(nyo).must_equal('NYO')
  end
end