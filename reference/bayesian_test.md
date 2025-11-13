# Highlights and test the time-course of effects through bayes factors

This function performs general bayesian tests through
'BayesFactor::generalTestBF()'.

## Usage

``` r
bayesian_test(data, formula, time, whichRandom, whichModels = "bottom", ...)
```

## Arguments

- data:

  A data.frame containing all the necessary variables.

- formula:

  A 'lme4'-style formula, passed as a string.

- time:

  A string indicating the name of the time variable.

- whichRandom:

  A string (vector) indicating which variables in the formula are random
  effects. Random effects must be factors. see '?anovaBF'

- whichModels:

  defaults to "bottom", meaning a type 2 test of inclusion. see
  '?anovaBF'

- ...:

  Further arguments that are passed to 'BayesFactor::generalTestBF()'.
  For example in cases in which you intend to deviate from default
  priors.

## Value

A list including, for each term in the model, the bayes factors for each
timepoint.
