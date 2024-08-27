defmodule Exa.MixUtil do

  # ---------------------------
  # ***** EXA boilerplate *****
  # shared by all EXA libraries
  # ---------------------------

  # -----------
  # local types
  # -----------

  @typep scope() :: :local | :main | :tag
  @typep lib() :: atom()
  @typep dep() :: {atom(), Keyword.t()}

  # ---------
  # constants
  # ---------

  # exa dependency github tag version

  @exa_tags %{
    :exa_core => "v0.2.2",
    :exa_space => "v0.2.2",
    :exa_color => "v0.2.2",
    :exa_std => "v0.2.2",
    :exa_csv => "v0.2.2",
    :exa_json => "v0.2.2",
    :exa_gis => "v0.2.2",
    :exa_graf => "v0.2.2",
    :exa_image => "v0.2.2"
  }

  # default set of support libraries

  @sup_deps [
    # typechecking
    {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},

    # documentation
    {:ex_doc, "~> 0.30", only: [:dev, :test], runtime: false},

    # benchmarking
    {:benchee, "~> 1.0", only: [:dev, :test]}
  ]

  @sup_libs Enum.map(@sup_deps, &elem(&1, 0))

  # ----------------
  # public interface
  # ----------------

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

  # -----------------
  # private functions
  # -----------------

  defp do_clean() do
    Enum.each([:local, :main, :tag], fn s -> s |> deps_file() |> File.rm() end)
    []
  end

  defp do_deps(cmd, name, libs) do
    scope = arg_build()
    deps_path = deps_file(scope)

    if not File.exists?(deps_path) do
      write_deps_file(scope, libs, deps_path)
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

  # write the 'scope'_deps.ex file for dependencies
  defp write_deps_file(scope, libs, deps_path) do
    exas = Enum.filter(libs, &is_map_key(@exa_tags, &1))
    sups = Enum.filter(libs, &(&1 in @sup_libs))
    IO.puts("EXA build '#{scope}'")
    IO.puts("EXA libraries: #{inspect(exas)}")
    IO.puts("EXA support:   #{inspect(sups)}")
    exa_deps = Enum.map(exas, &lib2dep(scope, &1))
    sup_deps = Enum.filter(@sup_deps, fn dep -> elem(dep, 0) in sups end)
    deps = exa_deps ++ sup_deps
    text = inspect(deps, charlists: :as_lists, limit: :infinity, pretty: true)
    File.write!(deps_path, text)
  end

  # convert a library atom key to a mix dependency
  @spec lib2dep(scope(), lib()) :: dep()
  defp lib2dep(:local, lib), do: {lib, [path: path(lib), app: false]}
  defp lib2dep(:tag, lib),   do: {lib, [git: repo(lib), tag: tag(lib), app: false]}
  defp lib2dep(:main, lib),  do: {lib, [git: repo(lib), branch: "main", app: false]}

  # local path checked-out in sibling directory
  @spec path(lib()) :: String.t()
  defp path(lib), do: "../#{lib}"

  # github repo for exa library
  @spec repo(lib()) :: String.t()
  defp repo(lib), do: "https://github.com/red-jade/#{lib}.git"

  # look-up the github tag
  @spec tag(lib()) :: String.t()
  defp tag(lib), do: Map.fetch!(@exa_tags, lib)

  # the deps literal file written by this mix task
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
