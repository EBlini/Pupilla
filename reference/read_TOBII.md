# Reads and imports TOBII eye-tracking and behavioral data

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
read_TOBII(
  ID,
  path = getwd(),
  start_filename = "subject-",
  append_TOBII = "_TOBII_output.tsv",
  skip = 7,
  separate_behavioral = TRUE
)
```

## Arguments

- ID:

  An integer corresponding to one participant's ID. This is attached to
  the current path in order to locate the two files to read. Also, One
  variable named p_ID is attached to both ET and BD files. If a vector
  is supplied, files are read with `lapply` and then merged.

- path:

  Defaults to [`getwd()`](https://rdrr.io/r/base/getwd.html) but can be
  specified to be otherwise. Files will be searched for starting from
  this location.

- start_filename:

  A string, it defaults to `"subject-"`. Usually all files start with
  this string, regardless of their nature. Usually names are built by
  concatenating `path`, `start_filename`, `ID`, and `append_TOBII` (for
  eye-tracking data, else ".csv").

- append_TOBII:

  A string, it defaults to `"_TOBII_output.tsv"` and indicates the text
  that tells eye-tracking from behavioral files apart. Usually names are
  built by concatenating `path`, `start_filename`, `ID`, and
  `append_TOBII` (for eye-tracking data, else ".csv").

- skip:

  Integer. The amount of lines to skip from the eye-tracking file, i.e.
  after how many lines the header is encountered. This is passed to
  [`data.table::fread()`](https://rdatatable.gitlab.io/data.table/reference/fread.html).

- separate_behavioral:

  defaults to `TRUE`. If `FALSE`, it only reads eye-tracking data

## Value

A list of one or two DFs, one for eye-tracking data, one for behavioral
data (if requested).
