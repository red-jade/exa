defmodule Mix.Tasks.Exa do
  @moduledoc """
  A task to enable configurable builds of the EXA project.

  The task manages the current set of consistent tags
  for the EXA github repos, and also 3 common support libraries.

  ### Command Line

  The task takes a _scope_ for the build
  and a list of libraries (EXA + support).
  It returns a list of dependencies for mix project.

  The syntax is: `mix exa ` _scope_ `all |` _libraries_ 

  The _scope_ must be one of the following:
  - `local` builds using the current local versions 
            checked-out in sibling directories
  - `main`  builds from github main branches
  - `tag`   builds from github tagged releases

  Libraries can be the value `all` 
  or a list containing `exa_xxx` libraries
  and default support libraries.

  The current set of default support libraries is:
  - `dialyxir` typechecking
  - `ex_doc` documentation
  - `benchee` benchmarking
  """

  use Mix.Task

  # -----------
  # local types
  # -----------

  @scopes ["local", "main", "tag"]

  @typep scope() :: :local | :main | :tag
  @typep lib() :: atom()
  @typep build() :: {scope(), [lib()]}
  @typep dep() :: {atom(), Keyword.t()}

  # ---------
  # constants
  # ---------

  # exa dependency github tag version

  @exa_tags %{
    :exa_core => "v0.2.0",
    :exa_space => "v0.2.0",
    :exa_color => "v0.2.0",
    :exa_std => "v0.2.0",
    :exa_csv => "v0.2.0",
    :exa_json => "v0.2.0",
    :exa_gis => "v0.2.0",
    :exa_graf => "v0.2.0",
    :exa_image => "v0.2.0"
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

  # ----
  # task
  # ----

  @impl Mix.Task
  def run(args) do
    {scope, libs, sups} = arg_task(args)
    IO.puts("EXA build '#{scope}'")
    IO.puts("EXA libraries: #{inspect(libs)}")
    IO.puts("EXA support:   #{inspect(sups)}")
    exa_deps = Enum.map(libs, &lib2dep(scope, &1))
    sup_deps = Enum.filter(@sup_deps, fn dep -> elem(dep, 0) in sups end)
    deps = exa_deps ++ sup_deps
    text = inspect(deps, charlists: :as_lists, limit: :infinity, pretty: true)
    scope |> deps_file() |> File.write!(text)
    text
  end

  # -----------------
  # private functions
  # -----------------

  # parse command line arguments for the task
  @spec arg_task([String.t()]) :: build()

  defp arg_task([scope | libs]) when scope in @scopes do
    {String.to_atom(scope), arg_libs(libs), arg_sups(libs)}
  end

  defp arg_task([arg | _]) do
    raise ArgumentError, message: "Invalid argument '#{arg}', expecting #{@scopes}"
  end

  defp arg_task([]) do
    scopes = Enum.join(@scopes, "|")
    raise ArgumentError, message: "Error: no arguments, expecting: #{scopes} all|libs..."
  end

  # parse lib arguments to atoms
  @spec arg_libs([String.t()]) :: [atom()]

  defp arg_libs(["all"]), do: Map.keys(@exa_tags)

  defp arg_libs(args) do
    args |> Enum.map(&String.to_atom/1) |> Enum.filter(&is_map_key(@exa_tags, &1))
  end

  # parse support library arguments to atoms
  @spec arg_sups([String.t()]) :: [atom()]

  defp arg_sups(["all"]), do: @sup_libs

  defp arg_sups(args) do
    args |> Enum.map(&String.to_atom/1) |> Enum.filter(&(&1 in @sup_libs))
  end

  # convert a library atom key to a mix dependency
  @spec lib2dep(scope(), lib()) :: dep()
  defp lib2dep(:local, lib), do: {lib, [path: path(lib), app: false]}
  defp lib2dep(:main, lib), do: {lib, ">= 0.0.0", [git: repo(lib), branch: "main", app: false]}
  defp lib2dep(:tag, lib), do: {lib, [git: repo(lib), tag: tag(lib), app: false]}

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
end
