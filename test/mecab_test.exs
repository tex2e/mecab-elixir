defmodule MecabTest do
  use ExUnit.Case
  # doctest Mecab

  @sentence1 "今日は晴れです。"
  @analysis1 [
    %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "今日", "part_of_speech" => "名詞", "part_of_speech_subcategory1" => "副詞可能", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "キョー", "surface_form" => "今日", "yomi" => "キョウ"},
    %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "は", "part_of_speech" => "助詞", "part_of_speech_subcategory1" => "係助詞", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "ワ", "surface_form" => "は", "yomi" => "ハ"},
    %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "晴れ", "part_of_speech" => "名詞", "part_of_speech_subcategory1" => "一般", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "ハレ", "surface_form" => "晴れ", "yomi" => "ハレ"},
    %{"conjugation" => "基本形", "conjugation_form" => "特殊・デス", "lexical_form" => "です", "part_of_speech" => "助動詞", "part_of_speech_subcategory1" => "", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "デス", "surface_form" => "です", "yomi" => "デス"},
    %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "。", "part_of_speech" => "記号", "part_of_speech_subcategory1" => "句点", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "。", "surface_form" => "。", "yomi" => "。"},
    %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "", "part_of_speech" => "", "part_of_speech_subcategory1" => "", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "", "surface_form" => "EOS", "yomi" => ""}]

  @sentence2 "明日は雨でしょう。"
  @analysis2 [
    %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "明日", "part_of_speech" => "名詞", "part_of_speech_subcategory1" => "副詞可能", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "アシタ", "surface_form" => "明日", "yomi" => "アシタ"},
    %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "は", "part_of_speech" => "助詞", "part_of_speech_subcategory1" => "係助詞", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "ワ", "surface_form" => "は", "yomi" => "ハ"},
    %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "雨", "part_of_speech" => "名詞", "part_of_speech_subcategory1" => "一般", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "アメ", "surface_form" => "雨", "yomi" => "アメ"},
    %{"conjugation" => "未然形", "conjugation_form" => "特殊・デス", "lexical_form" => "です", "part_of_speech" => "助動詞", "part_of_speech_subcategory1" => "", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "デショ", "surface_form" => "でしょ", "yomi" => "デショ"},
    %{"conjugation" => "基本形", "conjugation_form" => "不変化型", "lexical_form" => "う", "part_of_speech" => "助動詞", "part_of_speech_subcategory1" => "", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "ウ", "surface_form" => "う", "yomi" => "ウ"},
    %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "。", "part_of_speech" => "記号", "part_of_speech_subcategory1" => "句点", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "。", "surface_form" => "。", "yomi" => "。"},
    %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "", "part_of_speech" => "", "part_of_speech_subcategory1" => "", "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "", "pronunciation" => "", "surface_form" => "EOS", "yomi" => ""}]

  test "Mecab.parse" do
    assert(Mecab.parse(@sentence1) == @analysis1)
  end

  test "Mecab.read" do
    assert get_in(Mecab.read("not-found.txt"), [Access.elem(0)]) == :error
    assert Mecab.read("test/sample.txt") == {:ok, @analysis1 ++ @analysis2}
  end

  test "Mecab.read!" do
    assert_raise RuntimeError, fn -> Mecab.read!("not-found.txt") end
    assert Mecab.read!("test/sample.txt") == @analysis1 ++ @analysis2
  end
end
