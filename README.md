# 𝔼𝕏tr𝔸 𝔼li𝕏ir 𝔸dditions (𝔼𝕏𝔸)

𝔼𝕏𝔸ctly 10¹⁸ 𝔼𝕏𝔸lted 𝔼𝕏𝔸mples of 𝔼li𝕏ir.

EXA is a collection of utility libraries for Elixir.

This EXA repo is just the index for all the individual libraries.

## Principles

The general approach for EXA is:
- self-contained:
  - all the code is here - minimize 3rd party library dependencies 
  - pure Elixir - minimize native code interfaces (NIF)
- performance:
  - not highly optimized, but not stupidly inefficient
  - Elixir is not C (or Rust), there is no inline mutability
  - some data-parallel implementations (e.g. image processing)
  - use _benchee_ for benchmarking
- quality:
  - not (yet) production quality 
  - starting point for custom solutions
- code style
  - follow Elixir patterns and practices
  - no macro meta-programming (maybe some in the future)
  - old-style typespecs, for documentation as much as for dialyzer
  - separate modules for types and constants
  - use logger, ExUnit, ExDoc

EXA aims to be as self-contained as possible, 
but there are some exceeptions:
- contains a fork of Wings3D E3D Erlang for image handling
- use of Wings3D native interfaces for OpenGL
- (possible use of the _Nx_ Elixir tensor library in the future)

## Libraries

#### Exa Core 

Module path: `Exa`

Repo link: [exa_core](https://github.com/red-jade/exa_core)

- Utilities relating to specific language modules or features:
  `Binary`, `File`, `List`, `Map`, `Tuple`, `Set` (MapSet), `String`,
  `Text` (chardata), `Message`, `Option`, `Process`, `Random`, `System`.
  
- `Indent`: an indentable text output formatter
  
- `Math`: floating-point arithmetic and wrappers for Erlang `:math`.
  
- Trivial wrappers for Http, Logger.

- `Parse`: basic combinators for simple types.

- `Factory`: for structs built by data parsers.

- `Stopwatch`: for simple timing and benchmarking tasks.

- Type conversions.

Many Exa Core modules have the same name as the 
built-in Elixir standard library.
The idea is not to import or alias Exa Core, 
but always use the fully qualified module name.
It is not accidental that `Exa` is a short prefix.

## License

Exa source code is released under the MIT license.

Exa code and documentation are:
Copyright (C) 2024 Mike French


