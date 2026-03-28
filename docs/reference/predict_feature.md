# Predicts features' scores from a model

Under development. This function is meant to predict the scores of
features obtained from a trained model such as one returned by the
'reduce\_\*' family of functions. In particular, the function would
ideally work with any technique implemented so far (PCA, rPCA, ICA) and
whether or not scaling and centering have been required. This function
could be used then within a more stringent crossclassification approach
(in which scores are computed) anew, or even with different tasks to
check whether different signatures can be observed in an independent
pool of data. It takes as input a "time" argument to ensure the
timepoints used by the model to compute the loadings match, if they
don't the function returns an error.

## Usage

``` r
predict_feature(vector, time, model, use_trimmed = FALSE)
```

## Arguments

- vector:

  A vector variable to be transformed according to the given model.
  Usually the pupil dimension for a trial/condition.

- time:

  A vector variable indicating the elapsed time. Should be the same as
  the loadings' names in the model

- model:

  Object returned by 'reduce\_\*', e.g. 'reduce_PCA()'.

- use_trimmed:

  Defaults to FALSE. However, if rPCA loadings are previously trimmed
  with 'trim_loadings' (and the corresponding values are appended in the
  model provided), then predictions are made with the trimmed loadings.
  Only works for rPCA.

## Value

A dataframe of scores - as many as the loadings in the model.
