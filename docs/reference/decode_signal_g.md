# Highlights and test the time-course of effects through crossvalidation (uses glmer)

Same as 'decode_signal()' except it is powered by 'glmer()' and thus
performs generalized LMEMs.

## Usage

``` r
decode_signal_g(
  data,
  formula,
  dv,
  time,
  id,
  trial,
  nfolds = 3,
  t_thresh = 2,
  consensus_thresh = 0.75,
  ...
)
```

## Arguments

- data:

  A data.frame containing all the necessary variables.

- formula:

  A 'lme4'-style formula, passed as a string.

- dv:

  A string indicating the name of the dependent variable.

- time:

  A string indicating the name of the time variable.

- id:

  A string indicating the name of the id (participant) variable.

- trial:

  A string indicating the name of the trial variable.

- nfolds:

  Number of folds to split trials in. Defaults to 3.

- t_thresh:

  Used to seek consensus: the minimum t-value required to push the
  time-point forward.

- consensus_thresh:

  The minimum proportion of time-points that must be above 't_thresh'
  across folds in order to keep the time-point in the consensus.

- ...:

  Further params for 'glmer()', e.g. "family".

## Value

A list including: peaks retained for each (left-out) fold; test of the
retained, cross-validated peaks; test of the consensus time-points, if
any; list of time-points retained in the consensus for each effect.
