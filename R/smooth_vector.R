#' Smooth a time series through cubic splines
#'
#' This can be used as a simple smoothing function, in the case of eyetracking
#' data it can be used as a low-pass filter, useful to correct artifacts,
#' blinks, etc.
#'
#' @param vector A vector variable to be smoothed.
#' @param time A vector variable indicating the elapsed time.
#' @param spar Smoothing factor as in 'smooth.spline()'.

#' @return A numeric vector smoothed as requested.
#'
#' @export

smooth_vector= function(vector,
                 time,
                 spar= pp_options("spar")){

  ss= smooth.spline(time, vector, spar= spar)

  lp= predict(ss, time)$y

  return(lp)


}



