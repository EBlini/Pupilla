# Set or get options for Pupilla's preprocessing parameters

Set or get options for Pupilla's preprocessing parameters

## Usage

``` r
pp_options(...)
```

## Arguments

- thresh:

  **speed_clean** Threshold (z point or absolute value) above which
  values are marked as NA.

- speed_method:

  **speed_clean** Whether the 'thresh' is a z-score ('z'), with deviant
  values omitted once, or until there are no more values above the
  threshold ('z-dynamic'). 'abs' is used instead when a precise absolute
  value for speed is supplied.

- extend_by:

  **speed_clean** Number of samples starting from the deviant speed
  values that are stripped (e.g., the signal in proximity of blinks may
  be biased as well).

- island_size:

  **speed_clean** Islands of signal in the midst of NAs are removed if
  smaller or equal to this threshold (amount of samples).

- extend_blink:

  **interpolate** NAs are extended by these many samples prior to
  interpolation. This gets rid of signal that may be compromised in the
  close proximity of a blink.

- overall_thresh:

  **interpolate** Overall quality threshold: e.g., the total amount of
  data that is allowed to be missing from the original vector.

- consecutive_thresh:

  **interpolate** Consecutive gaps in the signal: e.g., the total amount
  of data that is allowed to be missing from the original vector
  **consecutively**.

- disable_smoothing:

  **smooth** Whether you want to disable smoothing. This parameter is
  FALSE by default; if you want to disable the smoothing, set it to
  TRUE.

- spar:

  **smooth** Smoothing factor as in 'smooth.spline()'.
