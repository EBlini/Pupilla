# Interprets easily the results of 'bayesian_test'

This is a helper function. It takes an object created by 'bayesian_test'
and spits intervals with evidence for either the null or alternative
models.

## Usage

``` r
interpret_bayes(bfs, evidence_thresh = 10, cluster_size = 10)
```

## Arguments

- bfs:

  An object returned by 'bayesian_test'.

- evidence_thresh:

  Threshold to judge evidence. Defaults to 10. It is meant to be
  symmetrical: values above 10 indicate support for the alternative Hp,
  less than 1/10 for the null.

- cluster_size:

  How many timepoints constitute a cluster?

## Value

A list including intervals that support H0 or H1.
