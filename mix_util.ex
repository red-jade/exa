defmodule Exa.MixUtil do

  # ---------------------------
  # ***** EXA boilerplate *****
  # shared by all EXA libraries
  # ---------------------------

  # main entry point for dependencies
  def exa_deps(name, libs) do
    case System.argv() do
      ["exa" | _] -> []
      ["format" | _] -> []
      ["deps.get", "exa" | _] -> []
      ["deps.clean" | _] -> do_clean()
      [cmd | _] -> do_deps(cmd, name, libs)
    end 
  end

  defp do_clean() do
    Enum.each([:local, :main, :tag], fn s -> s |> deps_file() |> File.rm() end)
    []
  end

  defp do_deps(cmd, name, libs) do
    scope = arg_build()
    deps_path = deps_file(scope)

    if not File.exists?(deps_path) do
      # invoke the exa project mix task to generate dependencies
      exa_args = Enum.map([:exa, scope | libs], &to_string/1)
      System.cmd("mix", exa_args)
    end

    if not File.exists?(deps_path) do
      IO.puts("No exa dependency file: #{deps_path}")
      []
    else
      deps = deps_path |> Code.eval_file() |> elem(0)
      
      if String.starts_with?(cmd, ["deps", "compile"]) do
        IO.inspect(deps, label: "#{name} #{scope}")
      else
        deps
      end
    end
  end

  # the deps literal file to be written for each scope
  defp deps_file(scope), do: Path.join([".", "deps", "deps_#{scope}.ex"])

  # parse the build scope from:
  # - mix command line --build option
  # - MIX_BUILD system environment variable
  # - default to "tag"
  defp arg_build() do
    default =
      case System.fetch_env("MIX_BUILD") do
        :error -> "tag"
        {:ok, mix_build} -> mix_build
      end

    System.argv()
    |> tl()
    |> OptionParser.parse(strict: [build: :string])
    |> elem(0)
    |> Keyword.get(:build, default)
    |> String.to_atom()
  end
end
