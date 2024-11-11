defmodule Exa.MixUtil do

  # ---------------------------
  # ***** EXA boilerplate *****
  # shared by all EXA libraries
  # ---------------------------

  # -----------
  # local types
  # -----------

  # scopes define where dependencies come from:
  # - local: sibling repo directories in the local filesystem
  # - main:  github main branches (but problems with caching)
  # - tag:   explicit tagged versions specified in this file
  # - rel:   versions written in the checked-in deps.ex file
  #          which is over-written by the 'tag' phase

  @typep scope() :: :local | :main | :tag | :rel
  @typep lib() :: atom()
  @typep dep() :: {atom(), Keyword.t()}

  # ---------
  # constants
  # ---------

  # exa dependency github tag version

  @exa_tags %{
    :exa_core => "v0.3.1",
    :exa_space => "v0.3.1",
    :exa_color => "v0.3.1",
    :exa_std => "v0.3.1",
    :exa_csv => "v0.3.1",
    :exa_json => "v0.3.1",
    :exa_gis => "v0.3.1",
    :exa_graf => "v0.3.1",
    :exa_image => "v0.3.1"
  }

  # default set of support libraries

  @sup_deps [
    # typechecking
    {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},

    # documentation
    {:ex_doc, "~> 0.30", only: [:dev, :test], runtime: false},

    # benchmarking
    {:benchee, "~> 1.0", only: [:dev, :test], runtime: false}
  ]

  @sup_libs Enum.map(@sup_deps, &elem(&1, 0))

  # this umbrella project
  @exa {:exa,
        git: "https://github.com/red-jade/exa.git",
        branch: "main",
        only: [:dev, :test],
        runtime: false}

  # ----------------
  # public interface
  # ----------------

  # main entry point for dependencies
  @spec exa_deps(lib(), [lib()]) :: [dep()]
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

  @spec do_clean() :: []
  defp do_clean() do
    Enum.each([:local, :main, :tag], fn s -> s |> deps_file() |> File.rm() end)
    []
  end

  @spec do_deps(String.t(), lib(), [lib()]) :: [dep()]
  defp do_deps(cmd, name, libs) do
    scope = arg_build()
    deps_path = deps_file(scope)

    if scope != :rel and not File.exists?(deps_path) do
      write_deps_file(scope, libs, deps_path)
    end

    if not File.exists?(deps_path) do
      IO.puts("No exa dependency file: #{deps_path}")
      []
    else
      deps = deps_path |> Code.eval_file() |> elem(0) |> add_exa(scope)

      if String.starts_with?(cmd, ["deps", "compile"]) and cmd != "deps.tree" do
        IO.inspect(deps, label: "#{name} #{scope}")
      else
        deps
      end
    end
  end

  # prepend this exa project if it is not a release build
  defp add_exa(deps,:rel), do: deps
  defp add_exa(deps,_), do: [@exa|deps]

  # write the 'scope' deps.ex file for dependencies
  @spec write_deps_file(scope(), [lib()], String.t()) :: :ok
  defp write_deps_file(scope, libs, deps_path) do
    exas = Enum.filter(libs, &is_map_key(@exa_tags, &1))
    sups = Enum.filter(libs, &(&1 in @sup_libs))
    IO.puts("EXA build '#{scope}'")
    IO.puts("EXA libraries:  #{inspect(exas)}")
    IO.puts("EXA support:    #{inspect(sups)}")
    IO.puts("EXA write file: #{deps_path}")
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
  # transient files are written to deps subdirectory
  # release file is read/written to the top-level deps.ex
  @spec deps_file(scope()) :: String.t()
  defp deps_file(:rel), do: Path.join([".", "deps.ex"])
  defp deps_file(:tag), do: Path.join([".", "deps.ex"])
  defp deps_file(scope), do: Path.join([".", "deps", "deps_#{scope}.ex"])

  # parse the build scope from:
  # - mix command line --build option
  # - EXA_BUILD system environment variable
  # - default to "rel"
  @spec arg_build() :: scope()
  defp arg_build() do
    default =
      case System.fetch_env("EXA_BUILD") do
        :error -> "rel"
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
