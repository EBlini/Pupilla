# Consolidate pupil data according to different heuristics

Mostly used, e.g., when pupil data is available for both eyes and one
needs a single variable. Results are weighted by vectors of signal
validity as provided by the eye-trackers. If absent, that all signals is
valid is assumed.

## Usage

``` r
consolidate_signal(
  s1,
  s2,
  v1,
  v2,
  strategy = c("conservative", "liberal", "pick_best"),
  plausible = NULL
)
```

## Arguments

- s1:

  A vector with the first signal.

- s2:

  A vector with the second signal.

- v1:

  A vector with the weights for the first signal.

- v2:

  A vector with the weights for the second signal.

- strategy:

  A strategy for mixing the two signals. Conservative takes the mean
  only when both signals are valid. Liberal additionally take one valid
  signal even when the other is not valid. Pick_best chooses the best
  overall signal (valid more often) and disregard the other when only
  one of the two is valid.

- plausible:

  A vector of length 2 defining the range of plausible values for pupil
  size. If provided, values outside this range are set to NA.

## Value

A numeric vector with the consolidated pupil size or NAs when not
available.
