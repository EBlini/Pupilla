# Reduce time-series to few (rotated) Principal Components

This function is under active development. It is meant to reduce the
entire time-series of normalized and baseline-corrected pupillary data
in just a few scores obtained by rotated Principal Component Analysis.
PCA is an effective way to reduce data dimensionality as to have more
manageable dependent variables, which may additionally help having more
precise estimates (or fingerprints) of pupil signal and the underlying
cognitive processes. Rotation in the oblique sense does not force PCs to
be orthogonal and may help the interpretation of the resulting loadings.
This function uses 'psych::principal()' and as such may differ in how
standardization is performed.

## Usage

``` r
reduce_rPCA(
  data,
  dv,
  time,
  id,
  trial,
  Ncomp = NULL,
  center = FALSE,
  scale = FALSE,
  rotate = "promax",
  add = NULL
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
  retains 95% of the explained variance. Note that is, however, based on
  unrotated PCA, and rotated variables generally explain less variance.
  If Ncomp== "all" returns all the components. If Ncomp \<1 this is
  interpreted as if the user wishes to retain a given proportion of
  variance (e.g. 0.6), but again the unrotated PCA is used to find the
  number of components.

- center:

  Whether variables, i.e. pupil size for each timepoint, should be
  scaled beforehand. Defaults to FALSE assuming that measures are
  already normalized (with z-scores) and baseline-corrected. Note that
  this only impacts summaryPCA and the number of components retained
  because psych uses the covariance matrix.

- scale:

  Whether variables, i.e. pupil size for each timepoint, should be
  scaled beforehand. Defaults to FALSE assuming that measures are
  already normalized (with z-scores) and baseline-corrected. Note that
  this only impacts summaryPCA and the number of components retained
  because psych uses the covariance matrix.

- rotate:

  Defaults to "promax" for oblique rotation. Could be set to "none" to
  have PCA in the style of the 'psych' package. Accepts what is accepted
  by 'psych::principal()'.

- add:

  String(s) indicating which variables names, if any, should be
  appendend to the scores dataframe.

## Value

A list including the processed data, the scores and loadings dataframes,
and the PCA object useful for prediction of new data.
