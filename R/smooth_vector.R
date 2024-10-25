#' Smooth a time series through cubic splines
#'
#' This can be used as a simple smoothing function, in the case of eyetracking
#' data it can be used as a low-pass filter, useful to correct artifacts,
#' blinks, etc.
#'
#' @param vector A vector variable to be smoothed.
#' @param time A vector variable indicating the elapsed time.
#' @param spar Smoothing factor as in 'smooth.spline()'.
#' @param disable_smoothing Whether you want to disable smoothing. This parameter
#' is FALSE by default; if you want to disable the smoothing, set it to TRUE.

#' @return A numeric vector smoothed as requested.
#'
#' @export

smooth_vector= function(vector,
                 time,
                 spar= pp_options("spar"),
                 disable_smoothing= pp_options("disable_smoothing")){

  if(disable_smoothing){

    lp= vector

  } else {

    ss= smooth.spline(time, vector, spar= spar)
    lp= predict(ss, time)$y

  }

  return(lp)


}



