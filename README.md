# 𝔼𝕏tr𝔸 𝔼li𝕏ir 𝔸dditions (𝔼𝕏𝔸)

𝔼𝕏𝔸ctly 10¹⁸ 𝔼𝕏𝔸lted 𝔼𝕏𝔸mples of 𝔼li𝕏ir.

EXA is a collection of utility libraries for Elixir.

## Domains

The main targets of development are:
- utils for Elixir datatypes (Core)
- standard library for new data structures (Std)
- parsing/serialization I/O for various formats
- simple domain models for existing standards
- spatial types (2D, 3D), some 2D computational geometry
- colors (byte, hex, float, names) and color model conversion
- bitmaps and images (I, IA, RGB, RGBA) and image I/O
- image processing (r/w, subimage, reflect, rotate, resize, filter, etc.)
- fonts (read, process, index, unicode, symbols)
- graphics (2D, image, text, 3D)
- GIS geometry and file formats (CSV, GeoJSON).
- some web stuff (XML, HTML, CSS, SVG)
- graph formats (GraphViz DOT, Erlang digraph, AGR)
- other data formats (CSV, JSON, XML)

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
  - use standard tools, e.g. Logger, ExUnit, ExDoc
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

There are some command line interfaces to installed programs:
- GraphViz DOT for drawing directed graphs
- FFMPEG (ffmpeg, ffprobe, ffplay) for video processing

## Libraries

Contents:

- [Exa Core](#exa-core)
- [Exa Standard Library](#exa-standard)
- [Exa Space](#exa-space)
- [Exa Color](#exa-color)
- [Exa Image](#exa-image)
- [Exa Json](#exa-json)
- [Exa Csv](#exa-csv)
- [Exa Gis](#exa-gis)
- [Exa Dot](#exa-dot)
- [Exa Dig](#exa-dig)

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

Features:

- Histograms for positive integer labels (IDs)
  - 1D using the Erlang `:array` module
  - 2D, 3D sparse histograms using Elixir `Map` module
- Run Length Encoding (RLE):
  - general for lists of any type
  - integers, using lossless binary delta-compression
- Character Stream: incremental char from a binary String with line/column address
- Tidal: managing out-of-order streaming sequence (integer IDs)
- Map of Lists (MoL)
- Yet Another Zip List (yazl): list with local cursor

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

Bitmap:

- bitmap: create, access, update, output to ascii art and image
- bitmap/image: bitmap to alpha, bitmap matte composition

Image:

- all 1,3,4 byte pixel types
- image: create, access, update, sub-image
- basic ops: crop, reflect, rotate, histogram
- colormap to image; expand index image using colormap
- map/reduce over pixels
- sample nearest/bilinear
- convolve kernels over subimages
- downsize, upsize and resize (integer multiple only)
- split and merge for chunked parallel processing

Image I/O
- fork of E3D to read/write PNG/TIF/BMP formats
- read/write _portable_ PBM/PGM/PBM text/binary formats

Video (only if [ffmpeg](https://ffmpeg.org/download.html) is installed):
- create video from image files
- probe video for information

### Exa Json

Module path: `Exa.Json`

Repo link: [exa_json](https://github.com/red-jade/exa_json)

Features:

- Read JSON files (optionally gzip compressed) and decode JSON data
- Write JSON files and encode JSON data
- Configure object conversion 
- (future GIS extensions)

### Exa Csv

Module path: `Exa.Csv`

Repo link: [exa_csv](https://github.com/red-jade/exa_csv)

Features:

- Read CSV files (optionally gzip compressed)
- Parse CSV fields into various data types 
- Write CSV files 

### Exa Gis

Module path: `Exa.Gis`

Repo link: [exa_gis](https://github.com/red-jade/exa_gis)

Features:

- Simple formats for locations and bearings.
- Parsers and formatters for location fields.
  Parsers can be included in CSV Reader.
- GeoJSON reader, using the basic JSON reader,
  with a custom GeoJSON object factory.
- Fast Equirectangular (tangent plane Pythagoras) implementation of local distances.
- Basic Haversine (spherical geometry) for distances and geodesics.
- At least one projection: _Equirectangular Projection_

### Exa Dot

Module path: `Exa.Dot`

Repo link: [exa_dot](https://github.com/red-jade/exa_dot)

Features:

- Read DOT files and return a graph data structure.
- Write DOT files 
- Render DOT files, if GraphViz DOT is installed

### Exa Dig


Module path: `Exa.Dig`

Repo link: [exa_gis](https://github.com/red-jade/exa_dig)

Features:
- Wrapper around Erlang `digraph` module.
- Graphs allow cyclic graphs and self-loops, but not multi-edges 
  (multiple edges between the same pair of vertices).
- Functions to fetch vertex degrees and neighborhoods.
- Build 1D and 2D histograms from vertex degrees,
  and hence generate a hash for a graph.
- Use the hash for simple isomorphism test.

- Conversion to and from GraphViz DOT file format.

### E3D License

The `Exa.Image` repo contains the image subset of E3D
copied (forked) from Wings3D on 23 November 2023 (v2.3):

https://github.com/dgud/wings

See the file `exa_image/src/e3d/license.terms` for licensing.

See source file headers for author credit and copyright:

All files are: <br>
Copyright (c) Dan Gudmundsson

## EXA License

EXA source code is released under the MIT license.

EXA code and documentation are:<br>
Copyright (c) 2024 Mike French


