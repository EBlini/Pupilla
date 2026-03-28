# copy a variable from one data.frame to another of different length given ID and Trial constraints

Sometimes info that are relevant for the eye-tracking file are only to
be found in the associated behavioral file. These data.frames have
different dimensions, thus copying one variable to another can be
cumbersome. This function does the job by expanding the relevant
information accordingly and exploits constraints in the two files. The
task is performed for each ID separately and requires a "Trial" variable
that is used to calculate the amount of required expansion in the data.

## Usage

``` r
copy_variable(
  var_name,
  id_var = "p_ID",
  constrained_var = "Trial",
  larger_df = ET,
  smaller_df = BD
)
```

## Arguments

- var_name:

  A string suggesting which variable to look for in the smaller
  data.frame (usually the behavioral one) and then copy to the larger
  data.frame (usually the eye-tracker one).

- id_var:

  The name of the ID variable or the grouping variable for which the
  assignment must be separated (e.g., performed for each participant).
  Can be NULL for no grouping.

- constrained_var:

  The name of the variable that represents the available costraint. For
  example, this can be Trial number and 'var_name' will be expanded as
  to have the same value for each value of Trial number.

- larger_df:

  The larger data.frame. The output vector will match the number of rows
  of this dataframe. Typically, the eye-tracker dataframe.

- smaller_df:

  The smaller dataframe which includes 'var_name'.

## Value

A vector of 'length= nrow(larger_df)'.
