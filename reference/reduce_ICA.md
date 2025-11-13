# Reduce time-series to few Independent Components

This function is under active development. It is meant to reduce the
entire time-series of normalized and baseline-corrected pupillary data
in just a few scores obtained by Independent Component Analysis. ICA is
an effective way to reduce data dimensionality as to have more
manageable dependent variables, which may additionally help having more
precise estimates (or fingerprints) of pupil signal and the underlying
cognitive processes. The functions use 'ica::icafast'.

## Usage

``` r
reduce_ICA(
  data,
  dv,
  time,
  id,
  trial,
  Ncomp = NULL,
  center = FALSE,
  scale = FALSE,
  add
)
```

## Arguments

- data:

  A data.frame containing all the necessary variables.

- dv:

  A string indicating the name of the dependent variable.

- time:

  A string indicating the name of the time variable.

- id:

  A string indicating the name of the id (participant) variable.

- trial:

  A string indicating the name of the trial variable.

- Ncomp:

  Number of components to retain. The default (NULL) automatically
  retains 95% of the explained variance. If Ncomp== "all" returns all
  the components. If Ncomp \<1 this is interpreted as if the user wishes
  to retain a given proportion of variance (e.g. 0.6).

- center:

  Whether variables, i.e. pupil size for each timepoint, should be
  centered beforehand. Defaults to FALSE assuming that measures are
  already baseline-corrected.

- scale:

  Whether variables, i.e. pupil size for each timepoint, should be
  centered beforehand. Defaults to FALSE assuming that measures are
  already baseline-corrected.

- add:

  String(s) indicating which variables names, if any, should be
  appendend to the scores dataframe.

## Value

A list including the processed data, the scores and loadings dataframes,
and the ICA object useful for prediction of new data.
