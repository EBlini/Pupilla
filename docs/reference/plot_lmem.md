# takes an LMEM object and plots the results

This function is meant to depict the time course of t statistics for
each effect in a lmem_test object. At state it is very essential, and
there is little room to set graphical pars from within this function.

## Usage

``` r
plot_lmem(LMEM, exclude_intercept = T, subset_significant = T)
```

## Arguments

- LMEM:

  A lmem_test object.

- exclude_intercept:

  Whether the intercept should be excluded.

- subset_significant:

  Whether only significant clusters should be plotted.

## Value

A plot powered by 'ggplot2'.
