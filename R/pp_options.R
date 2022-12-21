# Variable, global to package's namespace.
# This function is not exported to user space and does not need to be documented.
opt= settings::options_manager(

  thresh= 3,
  extend_by= 3,
  island_size= 4,

  extend_blink= 3,
  overall_thresh= 0.4,
  consecutive_thresh= NULL,

  spar= 1

)

# User function that gets exported:

#' Set or get options for Pupilla's preprocessing parameters
#'
#' @param thresh **speed_clean** Threshold (z point) above which values are marked as NA.
#' @param extend_by **speed_clean** Number of samples starting from the deviant speed values that
#' are stripped (e.g., the signal in proximity of blinks may be biased as well).
#' @param island_size **speed_clean** Islands of signal in the midst of NAs are removed if smaller
#' or equal to this threshold (amount of samples).
#' @param extend_blink **interpolate** NAs are extended by these many samples
#' prior to interpolation. This gets rid of signal that may be compromised
#' in the close proximity of a blink.
#' @param overall_thresh **interpolate** Overall quality threshold: e.g., the total amount of data
#' that is allowed to be missing from the original vector.
#' @param consecutive_thresh **interpolate** Consecutive gaps in the signal: e.g., the total amount of data
#' that is allowed to be missing from the original vector **consecutively**.
#' @param spar **smooth** Smoothing factor as in 'smooth.spline()'.

#' @export

pp_options <- function(...){

  # protect against the use of reserved words.
  settings::stop_if_reserved(...)
  # return/change
  opt(...)

}
