% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/detect_change.R
\name{detect_change}
\alias{detect_change}
\title{Detect a change in a column, and returns an incremental counter}
\usage{
detect_change(vector, key)
}
\arguments{
\item{vector}{A vector variable to be tracked.}

\item{key}{Value to track, its first repetition will update the counter.}
}
\value{
A numeric vector returning the counter - the function can thus be used in
tidyverse-style pipelines with grouping (e.g., by ID).
}
\description{
Mostly used, e.g., in case the ET file does not provide a Trial number column.
The function monitors the occurrences of a 'key' value and, when this value appears
for the first time, increases a counter by 1. For example, this will return
a counter that for the first occurrences of "target" in the "Event" column,
thus returning the putative trial number assuming that target is repeated
for each iteration. By default, the column to track is filled downward. Also,
empty lines are changed to NA. As a final remark, you may need to clean up
lines that are not assigned to a trial (sometimes, e.g., the eyetracker
needs time to warm up).
}
