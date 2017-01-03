defmodule Mecab.Mixfile do
  use Mix.Project

  def project do
    [app: :mecab,
     version: "1.0.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev}]
  end


  defp description do
    """
    Elixir bindings for MeCab, a Japanese morphological analyzer.
    """
  end

  defp package do
    [# These are the default files included in the package
    name: :mecab,
    files: ~w(lib mix.exs README.md LICENSE),
    maintainers: ["tex2e"],
    licenses: ["MIT"],
    links: %{"GitHub" => "https://github.com/tex2e/mecab-elixir"}]
  end
end
