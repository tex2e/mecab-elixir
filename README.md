# Mecab

[![hex.pm version](https://img.shields.io/hexpm/v/mecab.svg)](https://hex.pm/packages/mecab)
[![hex.pm](https://img.shields.io/hexpm/l/mecab.svg)](https://github.com/tex2e/mecab-elixir/blob/master/LICENSE)

Elixir bindings for MeCab, a Japanese morphological analyzer.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `mecab` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:mecab, "~> 1.0.0"}]
    end
    ```

  2. Ensure `mecab` command is available for your environment:

    ```
    # MacOS
    brew install mecab mecab-ipadic
    ```

## Usage

Further information is available at
[Hex Online Documentation](https://hexdocs.pm/mecab/Mecab.html)

The way of parsing given string is as follows:

    iex> Mecab.parse("今日は晴れです")
    [%{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "今日",
       "part_of_speech" => "名詞", "part_of_speech_subcategory1" => "副詞可能",
       "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "",
       "pronunciation" => "キョー", "surface_form" => "今日", "yomi" => "キョウ"},
     %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "は",
       "part_of_speech" => "助詞", "part_of_speech_subcategory1" => "係助詞",
       "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "",
       "pronunciation" => "ワ", "surface_form" => "は", "yomi" => "ハ"},
     %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "晴れ",
       "part_of_speech" => "名詞", "part_of_speech_subcategory1" => "一般",
       "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "",
       "pronunciation" => "ハレ", "surface_form" => "晴れ", "yomi" => "ハレ"},
     %{"conjugation" => "基本形", "conjugation_form" => "特殊・デス", "lexical_form" => "です",
       "part_of_speech" => "助動詞", "part_of_speech_subcategory1" => "",
       "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "",
       "pronunciation" => "デス", "surface_form" => "です", "yomi" => "デス"},
     %{"conjugation" => "", "conjugation_form" => "", "lexical_form" => "",
       "part_of_speech" => "", "part_of_speech_subcategory1" => "",
       "part_of_speech_subcategory2" => "", "part_of_speech_subcategory3" => "",
       "pronunciation" => "", "surface_form" => "EOS", "yomi" => ""}]


The way of parsing given file is as follows:

    iex> Mecab.read!("sentences.txt")


Each parser function returns a list of map.
The map's keys meanings is as follows.

- `surface_form`: 表層形
- `part_of_speech`: 品詞
- `part_of_speech_subcategory1`: 品詞細分類1
- `part_of_speech_subcategory2`: 品詞細分類2
- `part_of_speech_subcategory3`: 品詞細分類3
- `conjugation_form`: 活用形
- `conjugation`: 活用型
- `lexical_form`: 原形
- `yomi`: 読み
- `pronunciation`: 発音


See Also
-------------

- [Hex Mecab](https://hex.pm/packages/mecab)
- [Online Documentation](https://hexdocs.pm/mecab/Mecab.html)

