# Reads and imports eyelink eye-tracking and behavioral data

These two type of data are usually separate and sometimes must be merged
to create one single file with both eyetracking and experimental details
(e.g., conditions), unless you have specified this via code in the
experiment builder. This function is written with OpenSesame-like csv
files in mind, though compatibility with other programs (e.g., e-prime)
may be achieved provided that files are converted to the csv format.
This is optimized for Windows machines - you may encounter address
errors in Macs.

## Usage

``` r
read_eyelink(
  ID,
  keep_events = NULL,
  path = getwd(),
  sep = "\\",
  start_behavior = "subject-",
  start_eyelink = "sub_",
  separate_behavioral = TRUE,
  import_all = T
)
```

## Arguments

- ID:

  An integer corresponding to one participant's ID. This is attached to
  the current path in order to locate the two files to read. Also, One
  variable named p_ID is attached to both ET and BD files. If a vector
  is supplied, files are read with `lapply` and then merged.

- keep_events:

  A character vector specifying the events that should be kept. This is
  an hard assumption that experimental phases are recorded as messages
  in the events\$messages slot returned by 'eyelinkReader::read_edf()'.

- path:

  Defaults to [`getwd()`](https://rdrr.io/r/base/getwd.html) but can be
  specified to be otherwise. Files will be searched for starting from
  this location.

- sep:

  Defaults to "\\ windows but can be changed for other systems.

- start_behavior:

  A string, it defaults to `"subject-"`. Usually all files start with
  this string, regardless of their nature. Usually names are built by
  concatenating `path`, `start_filename`, `ID`, `.csv`.

- start_eyelink:

  A string, it defaults to `"subject-"`. Usually all files start with
  this string, regardless of their nature. Usually names are built by
  concatenating `path`, `start_eyelink`, `ID`, `.edf`.

- separate_behavioral:

  defaults to `TRUE`. If `FALSE`, it only reads eye-tracking data

- import_all:

  If TRUE (the default) import the blink and fixation data as computed
  by the eyelink.

## Value

A list of one or two DFs, one for eye-tracking data, one for behavioral
data (if requested).

## Details

This function is a wrapper around 'eyelinkReader::read_edf()' which must
be installed. In order to use this package, eyelink proprietary code
must be installed as well (the relevant scripts are available in the
eyelink forum)
