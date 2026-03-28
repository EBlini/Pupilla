# Highlights and test the time-course of effects through mixed-effects models

This function performs (g)lmer for each timepoint. Data are first
separated for each time-point, and a LMEM as specified by the 'formula'
parameter, which is passed to 'lmerTest::lmer', is performed. The
function returns t/z values, p values, and corrected p values.

## Usage

``` r
lmem_test(
  data,
  formula,
  time,
  test = c("contrasts", "omnibus"),
  family = "gaussian",
  correction = "fdr",
  Anova.type = "III",
  Anova.test = "Chisq",
  ...
)
```

## Arguments

- data:

  A data.frame containing all the necessary variables.

- formula:

  A 'lme4'-style formula, passed as a string.

- time:

  A string indicating the name of the time variable.

- test:

  Either "contrasts", in which case contrasts from lmerTest::lmer() are
  reported, or "omnibus", in which the model is given to car::Anova().

- family:

  A string indicating a GLM family to be passed to (g)lmer.

- correction:

  A string indicating the method for correcting p values (see p.adjust).
  defaults to "fdr".

- Anova.type:

  Passed to car::Anova() as "type".

- Anova.test:

  Passed to car::Anova() as "test.statistic".

- ...:

  Other pars passed to (g)lmer.

## Value

A list including: t/z values, p values, corrected p values.
