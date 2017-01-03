defmodule Mecab do
  @moduledoc """
  Elixir bindings for MeCab, a Japanese morphological analyzer.

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

  Note: To distinguish things clearly, we call this module "Mecab" and
  a mecab command either "MeCab" or "mecab".
  """

  @doc """
  Parse given string and returns an list of map.

  Options can also be supplied:

   - `:mecab_option` --
    specify MeCab options <br>(e.g. `"-d /usr/local/lib/mecab/dic/ipadic"`)

  ## Examples

      iex> Mecab.parse("今日は晴れです")
      [%{"conjugation" => "",
         "conjugation_form" => "",
         "lexical_form" => "今日",
         "part_of_speech" => "名詞",
         "part_of_speech_subcategory1" => "副詞可能",
         "part_of_speech_subcategory2" => "",
         "part_of_speech_subcategory3" => "",
         "pronunciation" => "キョー",
         "surface_form" => "今日",
         "yomi" => "キョウ"},
       %{"conjugation" => "",
         "conjugation_form" => "",
         "lexical_form" => "は",
         "part_of_speech" => "助詞",
         "part_of_speech_subcategory1" => "係助詞",
         "part_of_speech_subcategory2" => "",
         "part_of_speech_subcategory3" => "",
         "pronunciation" => "ワ",
         "surface_form" => "は",
         "yomi" => "ハ"},
       %{"conjugation" => "",
         "conjugation_form" => "",
         "lexical_form" => "晴れ",
         "part_of_speech" => "名詞",
         "part_of_speech_subcategory1" => "一般",
         "part_of_speech_subcategory2" => "",
         "part_of_speech_subcategory3" => "",
         "pronunciation" => "ハレ",
         "surface_form" => "晴れ",
         "yomi" => "ハレ"},
       %{"conjugation" => "基本形",
         "conjugation_form" => "特殊・デス",
         "lexical_form" => "です",
         "part_of_speech" => "助動詞",
         "part_of_speech_subcategory1" => "",
         "part_of_speech_subcategory2" => "",
         "part_of_speech_subcategory3" => "",
         "pronunciation" => "デス",
         "surface_form" => "です",
         "yomi" => "デス"},
       %{"conjugation" => "",
         "conjugation_form" => "",
         "lexical_form" => "",
         "part_of_speech" => "",
         "part_of_speech_subcategory1" => "",
         "part_of_speech_subcategory2" => "",
         "part_of_speech_subcategory3" => "",
         "pronunciation" => "",
         "surface_form" => "EOS",
         "yomi" => ""}]

  """

  @spec parse(String.t, Keyword.t) :: [Map.t, ...]

  def parse(str, option \\ []) do
    read_from_file = option[:from_file]
    mecab_option = option[:mecab_option]

    command =
      case read_from_file do
        true ->
          "mecab '#{str}' #{mecab_option}"
        x when x == nil or x == false ->
          """
          cat <<EOS.907a600613b96a88c04a | mecab #{mecab_option}
          #{str}
          EOS.907a600613b96a88c04a
          """
      end

    command
    |> to_char_list
    |> :os.cmd
    |> to_string
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn line ->
        Regex.named_captures(~r/
          ^
          (?<surface_form>[^\t]+)
          (?:
            \s
            (?<part_of_speech>[^,]+),
            \*?(?<part_of_speech_subcategory1>[^,]*),
            \*?(?<part_of_speech_subcategory2>[^,]*),
            \*?(?<part_of_speech_subcategory3>[^,]*),
            \*?(?<conjugation_form>[^,]*),
            \*?(?<conjugation>[^,]*),
            (?<lexical_form>[^,]*)
            (?:
              ,(?<yomi>[^,]*)
              ,(?<pronunciation>[^,]*)
            )?
          )?
          $
          /x, line)
      end)
  end


  @doc """
  Parse given file and returns an list of map.

  In addition to Mecab.parse(path, from_file: true),
  this function checks if a given path is exists.

  Options can also be supplied:

   - `:mecab_option` --
    specify MeCab options <br>(e.g. `"-d /usr/local/lib/mecab/dic/ipadic"`)

  ## Examples

      iex> File.read!("sample.txt")
      "今日は晴れです。\\n明日は雨でしょう。\\n"

      iex> Mecab.read("sample.txt")
      {:ok,
       [%{"surface_form" => "今日", "part_of_speech" => "名詞", ...},
        %{"surface_form" => "は", "part_of_speech" => "助詞", ...},
        %{"surface_form" => "晴れ", "part_of_speech" => "名詞", ...},
        %{"surface_form" => "です", "part_of_speech" => "助動詞", ...},
        %{"surface_form" => "。", "part_of_speech" => "記号", ...},
        %{"surface_form" => "EOS", ...},
        %{"surface_form" => "明日", "part_of_speech" => "名詞", ...},
        %{"surface_form" => "は", "part_of_speech" => "助詞", ...},
        %{"surface_form" => "雨", "part_of_speech" => "名詞", ...},
        %{"surface_form" => "でしょ", "part_of_speech" => "助動詞", ...},
        %{"surface_form" => "う", "part_of_speech" => "助動詞", ...},
        %{"surface_form" => "。", "part_of_speech" => "記号", ...},
        %{"surface_form" => "EOS", ...}]}

      iex> Mecab.read("not_found.txt")
      {:error, "no such a file or directory: not_found.txt"}
  """

  @spec read(String.t, Keyword.t) :: {:ok, [Map.t, ...]} | {:error, String.t}

  def read(path, option \\ []) do
    case File.exists?(path) do
      true ->
        {:ok, parse(path, [from_file: true] ++ option)}
      false ->
        {:error, "no such a file or directory: #{path}"}
    end
  end


  @doc """
  Parse given file and returns an list of map.

  In addition to Mecab.parse(path, from_file: true),
  this function checks if a given path is exists.

  Options can also be supplied:

   - `:mecab_option` --
    specify MeCab options <br>(e.g. `"-d /usr/local/lib/mecab/dic/ipadic"`)

  ## Examples

      iex> File.read!("sample.txt")
      "今日は晴れです。\\n明日は雨でしょう。\\n"

      iex> Mecab.read!("sample.txt")
      [%{"surface_form" => "今日", "part_of_speech" => "名詞", ...},
       %{"surface_form" => "は", "part_of_speech" => "助詞", ...},
       %{"surface_form" => "晴れ", "part_of_speech" => "名詞", ...},
       %{"surface_form" => "です", "part_of_speech" => "助動詞", ...},
       %{"surface_form" => "。", "part_of_speech" => "記号", ...},
       %{"surface_form" => "EOS", ...},
       %{"surface_form" => "明日", "part_of_speech" => "名詞", ...},
       %{"surface_form" => "は", "part_of_speech" => "助詞", ...},
       %{"surface_form" => "雨", "part_of_speech" => "名詞", ...},
       %{"surface_form" => "でしょ", "part_of_speech" => "助動詞", ...},
       %{"surface_form" => "う", "part_of_speech" => "助動詞", ...},
       %{"surface_form" => "。", "part_of_speech" => "記号", ...},
       %{"surface_form" => "EOS", ...}]
  """

  @spec read!(String.t, Keyword.t) :: [Map.t, ...]

  def read!(path, option \\ []) do
    if !File.exists?(path) do
      raise "no such a file or directory: #{path}"
    end
    parse(path, [from_file: true] ++ option)
  end

end
