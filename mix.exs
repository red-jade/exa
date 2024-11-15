defmodule ExaProject do
  use Mix.Project

  def project do
    [
      app: :exa,
      name: "Exa Project",
      version: "0.3.2",
      elixir: "~> 1.17",
      erlc_options: [:verbose, :report_errors, :report_warnings, :export_all],
      deps: [],
      docs: docs(),
    ]
  end

  def application do
    []
  end

  defp docs do
    [
      main: "readme",
      output: "doc/api",
      assets: %{"assets" => "assets"},
      extras: ["README.md", "BUILD.md"]
    ]
  end
end
