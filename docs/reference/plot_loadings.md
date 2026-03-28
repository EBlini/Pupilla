# Plot loadings of a reduced time-series

This function is under active development. It is meant to depict the
loadings of components obtained by reducing pupillary time-series, as to
ease interpretation.

## Usage

``` r
plot_loadings(name, data)
```

## Arguments

- name:

  A string indicating the component to depict (e.g., "PC1").

- data:

  An object as returned by, e.g., 'reduce_PCA'.

## Value

A plot powered by 'ggplot2'.
