# Trim rPCA loadings according to heuristics and append them to the original object

Under development. This function takes a 'reduce_rPCA' object, and only
a 'reduce_rPCA' object, and trims the original loadings. The trimmed
loadings can then be used for (new) predictions with
'predict_feature()', for example. One reason why this could be useful is
to reduce collinearity between rotated components - albeit one can also
consider orthogonal solutions.

## Usage

``` r
trim_loadings(rpca_mod, keep_max = T, abs_value = 0.4)
```

## Arguments

- rpca_mod:

  An object returned by 'reduce_rPCA'.

- keep_max:

  If TRUE, for each timepoint only the largest loading (in absolute
  value) is preserved, the remaining ones are set to 0.

- abs_value:

  An absolute value below which loadings are set to 0

## Value

The original object in which information about the trimming has been
added
