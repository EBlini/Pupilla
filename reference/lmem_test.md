# Highlights and test the time-course of effects through mixed-effects models

This function performs (g)lmer for each timepoint. Data are first
separated for each time-point, and a LMEM as specified by the 'formula'
parameter, which is passed to 'lmerTest::lmer', is performed. The
function returns t/z values, p values, and corrected p values.

## Usage

``` r
lmem_test(data, formula, time, family = "gaussian", correction = "fdr", ...)
```

## Arguments

- data:

  A data.frame containing all the necessary variables.

- formula:

  A 'lme4'-style formula, passed as a string.

- time:

  A string indicating the name of the time variable.

- family:

  A string indicating a GLM family to be passed to (g)lmer.

- correction:

  A string indicating the method for correcting p values (see p.adjust).
  defaults to "fdr".

- ...:

  Other pars passed to (g)lmer.

## Value

A list including: t/z values, p values, corrected p values.
