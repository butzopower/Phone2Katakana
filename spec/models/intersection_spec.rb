require 'minitest/autorun'
require_relative '../../models/intersection'

describe 'mapping phones to kanas' do
  specify 'maps nothing if no phones or kanas' do
    mapping = Intersection.map_intersections_before_save([], [])
    expect(mapping).must_equal([])
  end

  specify 'one phone to one kana' do
    mapping = Intersection.map_intersections_before_save(['a'], ['ア'])
    expect(mapping).must_equal(
      [
        {kana: 'ア', intersections: ['a']}
      ]
    )
  end

  specify 'two phones to one kana' do
    mapping = Intersection.map_intersections_before_save(%w[a b], ['ア'])
    expect(mapping).must_equal(
      [
        {kana: 'ア', intersections: %w[a b] }
      ]
    )
  end

  specify 'two phones to two kana' do
    mapping = Intersection.map_intersections_before_save(%w[a b], %w[ア ビ])
    expect(mapping).must_equal(
      [
        {kana: 'ア', intersections: %w[a] },
        {kana: 'ビ', intersections: %w[b a] }
      ]
    )
  end

  specify 'three phones to two kana' do
    mapping = Intersection.map_intersections_before_save(%w[a b c], %w[ア ビ])
    expect(mapping).must_equal(
      [
        {kana: 'ア', intersections: %w[a b] },
        {kana: 'ビ', intersections: %w[b c] }
      ]
    )
  end

  specify 'three phones to three kana' do
    mapping = Intersection.map_intersections_before_save(%w[a b c], %w[ア ビ ツ])
    expect(mapping).must_equal(
      [
        {kana: 'ア', intersections: %w[a] },
        {kana: 'ビ', intersections: %w[b] },
        {kana: 'ツ', intersections: %w[c] },
      ]
    )
  end

  specify 'six phones to three kana' do
    mapping = Intersection.map_intersections_before_save(%w[a b c d e f], %w[ア ビ ツ])
    expect(mapping).must_equal(
      [
        {kana: 'ア', intersections: %w[a b] },
        {kana: 'ビ', intersections: %w[c d] },
        {kana: 'ツ', intersections: %w[e f] },
      ]
    )
  end

  specify 'seven phones to three kana' do
    mapping = Intersection.map_intersections_before_save(%w[a b c d e f g], %w[ア ビ ツ])
    expect(mapping).must_equal(
      [
        {kana: 'ア', intersections: %w[a b c] },
        {kana: 'ビ', intersections: %w[c d e] },
        {kana: 'ツ', intersections: %w[e f g] },
      ]
    )
  end

  specify 'nine phones to three kana' do
    mapping = Intersection.map_intersections_before_save(%w[a b c d e f g h i], %w[ア ビ ツ])
    expect(mapping).must_equal(
      [
        {kana: 'ア', intersections: %w[a b c] },
        {kana: 'ビ', intersections: %w[d e f] },
        {kana: 'ツ', intersections: %w[g h i] },
      ]
    )
  end

  specify 'three phones to nine kana' do
    mapping = Intersection.map_intersections_before_save(%w[a b c], %w[ア カ サ タ ナ ハ マ ヤ ラ])
    expect(mapping).must_equal(
      [
        {kana: 'ア', intersections: %w[a] },
        {kana: 'カ', intersections: %w[a] },
        {kana: 'サ', intersections: %w[a] },
        {kana: 'タ', intersections: %w[b] },
        {kana: 'ナ', intersections: %w[b] },
        {kana: 'ハ', intersections: %w[b] },
        {kana: 'マ', intersections: %w[c] },
        {kana: 'ヤ', intersections: %w[c] },
        {kana: 'ラ', intersections: %w[c] },
      ]
    )
  end
end