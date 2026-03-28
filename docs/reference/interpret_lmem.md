# Interprets easily the results of 'lmem_test'

This is a helper function. It takes an object created by 'lmem_test' and
spits intervals with significant effects.

## Usage

``` r
interpret_lmem(lmems, p = "p.corrected", sig_thresh = 0.05, cluster_size = 10)
```

## Arguments

- lmems:

  An object returned by 'lmem_test'.

- p:

  defaults to "corrected" to use adjusted p values

- sig_thresh:

  Threshold to judge significance.

- cluster_size:

  How many timepoints constitute a cluster?

## Value

A list including intervals with significant fixed effects.
