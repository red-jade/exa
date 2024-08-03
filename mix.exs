defmodule Exa.D.MixProject do
  use Mix.Project

  def project do
    [
      app: :exa_project,
      name: "Exa Project",
      version: "0.1.0",
      elixir: "~> 1.15",
      erlc_options: [:verbose, :report_errors, :report_warnings, :export_all],
      start_permanent: Mix.env() == :prod,
      deps: deps_release()++deps_support(),
      docs: docs(),
      test_pattern: "*_test.exs",
      dialyzer: [flags: [:no_improper_lists]]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def docs do
    [
      main: "readme",
      output: "doc/api",
      assets: %{"assets" => "assets"},
      extras: ["README.md"]
    ]
  end

  # building, documenting, testing 
  defp deps_support do
    [
      # typechecking
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},

      # documentation
      {:ex_doc, "~> 0.30", only: [:dev, :test], runtime: false},

      # benchmarking
      {:benchee, "~> 1.0", only: [:dev, :test]}
    ]
  end

  # runtime code dependencies in tagged releases
  defp deps_release do
    [
      {:exa,       git: "https://github.com/red-jade/exa_core.git",  tag: "v0.1.5"},
      {:exa_std,   git: "https://github.com/red-jade/exa_std.git",   tag: "v0.1.6"},
      {:exa_space, git: "https://github.com/red-jade/exa_space.git", tag: "v0.1.5"},
      {:exa_csv,   git: "https://github.com/red-jade/exa_csv.git",   tag: "v0.1.5"},
      {:exa_json,  git: "https://github.com/red-jade/exa_json.git",  tag: "v0.1.5"},
      {:exa_gis,   git: "https://github.com/red-jade/exa_gis.git",   tag: "v0.1.0"},
      {:exa_dot,   git: "https://github.com/red-jade/exa_dot.git",   tag: "v0.1.2"},
      {:exa_dig,   git: "https://github.com/red-jade/exa_dig.git",   tag: "v0.1.2"},
      {:exa_color, git: "https://github.com/red-jade/exa_color.git", tag: "v0.1.5"},
      {:exa_image, git: "https://github.com/red-jade/exa_image.git", tag: "v0.1.7"}
    ] 
  end 
end
