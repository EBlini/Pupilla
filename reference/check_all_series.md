# Convenience function to check series across IDs and Trials, and save a plot in the current path

Convenience function to check series across IDs and Trials, which saves
multiple plots in the current path by creating folders and subfolders in
a hopefully meaningful way. Note that with massive data this could take
some time, so you may want to debug first with a subset of the data. The
defaults for 'ggsave', which is used internally, are for now a bit stiff
but may become more flexible in the future. The 'check_series' function
is invoked for plots, thus you may want to check the relative help page.

## Usage

``` r
check_all_series(data, ID, Trial, series1, series2, time)
```

## Arguments

- data:

  Mandatory, differently from 'check_series'. The IDs and Trials levels
  around which the loop is set are retrieved here.

- ID:

  A string indicating the name of the ID column.

- Trial:

  A string indicating the name of the Trial column.

- series1:

  Unlike 'check_series', this must only be a string indicating the name
  of the first time series to plot.

- series2:

  Unlike 'check_series', this must only be a string indicating the name
  of the second time series to plot.

- time:

  Unlike 'check_series', this must only be a string indicating the
  elapsed time, which will be used for the x-axis.

## Value

A plot.
