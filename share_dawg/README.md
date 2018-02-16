# RWO data conversion

## Dependencies
* BaseX 9.0 (currently in beta; see [latest development snapshot](http://files.basex.org/releases/latest/))
* RDFLib (`pip install rdflib`)

## Installation
See the [BaseX wiki](http://docs.basex.org/wiki/Main_Page) for detailed documentation about installing and using BaseX.

## Usage
* Increasing the amount of memory available to BaseX is recommended. Open the `basexserver` script in `basex/bin` and update the `-Xmx` value (for example, to `4096m`).
* Start the BaseX database server by running `./basexserver`.
* In `rwo.py`, edit the value of the file paths to match your local system, as appropriate.
* Execute the Python script to run the conversion.
