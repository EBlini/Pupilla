# Recode a Time variable to a different granularity

A time variable is passed to this function and the corresponding
downsampled time bin is returned. One between 'to_ms' and 'to_hz' must
be null

## Usage

``` r
downsample_time(Time, to_ms = 25, to_hz = NULL)
```

## Arguments

- Time:

  A vector variable indicating the elapsed time, in ms, aligned to some
  origin - i.e., not a timestamp.

- to_ms:

  How many ms the bins must be.

- to_hz:

  How many hertz the new sampling rate is.

## Value

A numeric time vector recoded in time bins.
