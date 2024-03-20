
# NEUTR - NEUmann Technical Reports

This repository hosts the source code for the [CTAN](https://ctan.org/)package [NEUTR](https://ctan.org/pkg/neutr).

The NEUTR package enhances a LaTeX installation with a LaTeX class for writing technical reports.
The style is a two-column format similar to IEEE. It is intendet for student team projects at universities as project result report. It provides a beginner friendly template example.
The neutr class requires latex/pdflatex in combination with biblatex using a biber backend.

DISCLAIMER: This neutr class does not support XeLaTeX or LuaTeX nor legacy bibtex or natbib.

If you just want to extend you LaTeX installation please download the [NEUTR package from CTAN](https://ctan.org/pkg/neutr) and follow the installation instructions.

If you want to extend the package please follow this guideline.

## Building the package

To build the package from source clone this repository:

```bash
$ git clone https://github.com/cyberlytics/neutr.git
```

and run `make`:

```bash
$ make dist
```

This will create the zip file `dist/neutr.zip` with the complete installation package as it can be downloaded from CTAN.

All build artifacts without the archive itself can be build with:

```bash
$ make compile
```

The repository can be cleaned up with:

```bash
$ make clean
```

## The source files

* `dependencies/` contains third party tools that are needed for compilation
* `doc/neutr.tex` The user documentation of the NEUTR class
* `patch/` Files needed for patching generated artifacts
* `src/neutr.cls` The LaTeX class of the package
* `static` All files that will be added unchanged to the CTAN package like `README` and template sources

## Build artifacts

All build artifacts can be found in `build`. The `Makefile` builds the following artifacts:

* `neutr.ins` and `neutr.dtx` which contains the LaTeX installation package and the documentation source.
* `neutr.pdf` the documentation of the class
* `*-example-*.zip` include TEX+PDF example based on this class

## Build dependencies

The build environment needs the following Unix tools to be installed:

* GNU make
* LaTeX (inclduding `latexmk`)
* perl
* Unix commandline: bash, echo, cp, mv, rm, ed, cut, mkdir, head

## Contact

* [Christoph P. Neumann <cyberpetaneuron@gmail.com>](mailto:cyberpetaneuron+neutr@gmail.com)