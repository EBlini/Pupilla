# Help identifying artifacts with a speed-based criterion

A signal vector is stripped of values exceeding a given threshold,
computed on the basis of the absolute speed of signal increase or
decrease.

## Usage

``` r
speed_clean(
  vector,
  time,
  thresh = pp_options("thresh"),
  speed_method = pp_options("speed_method"),
  extend_by = pp_options("extend_by"),
  island_size = pp_options("island_size")
)
```

## Arguments

- vector:

  A vector variable to be cleaned

- time:

  A vector variable indicating the elapsed time, needed to compute
  velocity.

- thresh:

  Threshold (z point or absolute value) above which values are marked as
  NA.

- speed_method:

  Whether the 'thresh' is a z-score ('z'), with deviant values omitted
  once, or until there are no more values above the threshold
  ('z-dynamic'). 'abs' is used instead when a precise absolute value for
  speed is supplied.

- extend_by:

  Number of samples starting from the deviant speed values that are
  stripped (e.g., the signal in proximity of blinks may be biased as
  well).

- island_size:

  Islands of signal in the midst of NAs are removed if smaller or equal
  to this threshold (amount of samples).

## Value

A numeric vector cleaned as requested.
