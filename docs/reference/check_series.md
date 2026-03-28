# Plots two time series against each other

The function plots two time series against each other. The intended use
is generally to check the original vs. preprocessed data. The first
series is plotted with a black line, the second one - typically the
reconstructed series - with a red line. Nas show up as interruptions of
the lines. The function can be used within dplyr's style pipes - in
which case 'data' can be omitted and the other variables must be
provided as quoted variables' names - or standard vectors may be
provided - in which case 'data' should be NULL and args should be passed
by name.

## Usage

``` r
check_series(data, series1, series2, time)
```

## Arguments

- data:

  Optional. Can be omitted if passed through dplyr's style pipelines
  (through '.'), in which case the other arguments should be passed as
  quoted variables' names.

- series1:

  A vector variable with values for the first time series. It is plotted
  by means of a black line. Typically, the original data.

- series2:

  A vector variable with values for the second time series. It is
  plotted by means of a red line. Typically, the processed data.

- time:

  A vector variable indicating the elapsed time, which is used for the x
  axis.

## Value

A plot.
