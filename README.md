# 𝔼𝕏tr𝔸 𝔼li𝕏ir 𝔸dditions (𝔼𝕏𝔸)

𝔼𝕏𝔸ctly 10¹⁸ 𝔼𝕏𝔸lted 𝔼𝕏𝔸mples of 𝔼li𝕏ir.

EXA is a collection of utility libraries for Elixir.

## Domains

The main targets of development are:
- utils for Elixir datatypes (Core)
- standard library for new data structures (Std)
- parsing/serialization I/O for various formats
- simple domain models for existing standards
- spatial types (2D, 3D, GIS), some computational geometry
- colors (byte, hex, float, names) and color model conversion
- bitmaps and images (I, IA, RGB, RGBA) and image I/O
- image processing (r/w, subimage, reflect, rotate, resize, filter, etc.)
- fonts (read, process, index, unicode)
- graphics (2D, image, text, 3D)
- some web stuff (XML, HTML, CSS, SVG)
- data formats (CSV, JSON, XML)

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
  - not production quality 
  - test suite is sparse
  - starting point for custom solutions
- code style:
  - follow Elixir patterns and practices
  - no macro meta-programming (maybe some in the future)
  - old-style typespecs, for documentation, as much as for dialyzer
  - separate modules for types and constants
  - use standard tools, e.g. `Logger`, `ExUnit`, `ExDoc`
  - only use tools that work in git bash shell
- packaging:
  - all libraries all the way
  - no web service APIs
  - no containers, Docker, K8s, or cloud deployment
  
EXA is broad, shallow and open to change,
rather than narrow, deep and immutable.

EXA aims to be as self-contained as possible, 
but there are some exceptions:
- contains a fork of WX E3D Erlang for image handling
- use of WX native interfaces for OpenGL and WX UI
- (possible use of the _Nx_ Elixir tensor library in the future)

## Libraries

### Exa Core 

Module path: `Exa`

Repo link: [exa_core](https://github.com/red-jade/exa_core)

Features:

- Utilities relating to specific language modules or features:<br>
  `Binary`, `File`, `List`, `Map`, `Tuple`, `Set` (MapSet), `String`,<br>
  `Text` (chardata), `Message`, `Option`, `Process`, `Random`, `System`.
  
- `Indent`: an indentable text output formatter.
  
- `Math`: floating-point arithmetic and wrappers for Erlang `:math`.

- `Parse`: basic combinators for simple types.

- `Factory`: for structs built by data parsers.

- `Stopwatch`: for simple timing and benchmarking tasks.

- Trivial functions for `Http`, `Logger`.

- Type conversions.

Many EXA Core modules have the same name as the 
built-in Elixir standard library.
The idea is not to import or alias `Exa` Core, 
but always use the fully qualified module name.
It is not accidental that `Exa` is a short prefix.

### Exa Standard

Module path: `Exa.Std`

Repo link: [exa_std](https://github.com/red-jade/exa_std)

...

### Exa Space 

Module path: `Exa.Space`

Repo link: [exa_space](https://github.com/red-jade/exa_space)

Features:

- Positions: 2i,3i, 2f,3f
- Vectors: 2i, 2f,3f,4f
- Bounding box: 1i,2i,3i, 2f
- Transforms: 
  - 2x2, 3x3, 4x4 square matrices
  - affine and homogeneous (projective) transforms

### Exa Color 

Module path: `Exa.Color`

Repo link: [exa_color](https://github.com/red-jade/exa_color)

Features:

- Colors: 1,3,4 byte,float
- Color models: RGB, HSL
- Color maps: index => col3b
- Named CSS colors
- Pixels and components
- Conversion utilities: byte,float

### Exa Image

Module path: `Exa.Image`

Repo link: [exa_image](https://github.com/red-jade/exa_image)

...

## License

EXA source code is released under the MIT license.

EXA code and documentation are:<br>
Copyright (c) 2024 Mike French


