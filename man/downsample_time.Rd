% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/downsample_time.R
\name{downsample_time}
\alias{downsample_time}
\title{Recode a Time variable to a different granularity}
\usage{
downsample_time(Time, to_ms = 25, to_hz = NULL)
}
\arguments{
\item{Time}{A vector variable indicating the elapsed time, in ms, aligned
to some origin - i.e., not a timestamp.}

\item{to_ms}{How many ms the bins must be.}

\item{to_hz}{How many hertz the new sampling rate is.}
}
\value{
A numeric time vector recoded in time bins.
}
\description{
A time variable is passed to this function and the corresponding
downsampled time bin is returned. One between 'to_ms' and 'to_hz' must be null
}
