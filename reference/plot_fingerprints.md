# Plot all (three) fingerprints of reduced time-series

This function is under active development. It is meant to depict the
three eigenvectors/loadings/weights of components obtained by reducing
pupillary time-series, as to ease interpretation. Note that the
components and their names are re-ordered according to their explained
variance by default, and so are their names, so that results may differ
from the original scores. Be mindful!

## Usage

``` r
plot_fingerprints(data, order = "var", flip = c(1, 1, 1))
```

## Arguments

- data:

  An object as returned by, e.g., 'reduce_PCA'.

- order:

  A character, defaults to "var" for reordering the fingerprints by
  their share of explained variance. Else "none" or "peak", to order by
  latency of the peak value.

- flip:

  A vector of numbers indicating the component(s) to flip in sign (e.g.,
  c(1,1,-1))

## Value

A plot powered by 'ggplot2'.
