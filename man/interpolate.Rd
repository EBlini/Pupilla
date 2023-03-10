% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/interpolate.R
\name{interpolate}
\alias{interpolate}
\title{Linearly interpolate signal provided quality checks are met, else only returns NAs}
\usage{
interpolate(
  vector,
  extend_blink = pp_options("extend_blink"),
  overall_thresh = pp_options("overall_thresh"),
  consecutive_thresh = pp_options("consecutive_thresh")
)
}
\arguments{
\item{vector}{A vector to interpolate.}

\item{extend_blink}{NAs are extended by these many samples
prior to interpolation. This gets rid of signal that may be compromised
in the close proximity of a blink.}

\item{overall_thresh}{Overall quality threshold: e.g., the total amount of data
that is allowed to be missing from the original vector.}

\item{consecutive_thresh}{Consecutive gaps in the signal: e.g., the total amount of data
that is allowed to be missing from the original vector \strong{consecutively}.}
}
\value{
A numeric vector of interpolated data or NAs if quality checks are not met.
}
\description{
This is used to linearly interpolate any data provided successful quality controls.
If these controls are not met, the returned vector is a vector of equal length
composed of only NAs. Quality checks are general (i.e., overall percentage of
available non NA data) or relative to consecutive gaps in the signal, which
must not exceed a given threshold. Thresholds refer to the
maximum rate (percentage) of entries that are allowed to be NAs; results
are only interpolated below these thresholds.
}
