# Smooth a time series through cubic splines

This can be used as a simple smoothing function, in the case of
eyetracking data it can be used as a low-pass filter, useful to correct
artifacts, blinks, etc.

## Usage

``` r
smooth_vector(
  vector,
  time,
  spar = pp_options("spar"),
  disable_smoothing = pp_options("disable_smoothing")
)
```

## Arguments

- vector:

  A vector variable to be smoothed.

- time:

  A vector variable indicating the elapsed time.

- spar:

  Smoothing factor as in 'smooth.spline()'.

- disable_smoothing:

  Whether you want to disable smoothing. This parameter is FALSE by
  default; if you want to disable the smoothing, set it to TRUE.

## Value

A numeric vector smoothed as requested.
