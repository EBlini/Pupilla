#' Recode a Time variable to a different granularity
#'
#' A time variable is passed to this function and the corresponding
#' downsampled time bin is returned. One between 'to_ms' and 'to_hz' must be null
#'
#'
#' @param Time A vector variable indicating the elapsed time, in ms, aligned
#' to some origin - i.e., not a timestamp.
#' @param to_ms How many ms the bins must be.
#' @param to_hz How many hertz the new sampling rate is.

#' @return A numeric time vector recoded in time bins.
#'
#' @export

downsample_time= function(Time,
                          to_ms= 20,
                          to_hz= NULL){


  if(!is.null(to_hz) & !is.null(to_ms)){warning("No sampling rate provided")}

  if(!is.null(to_hz))(to_ms= 1000/to_hz)

  time= ceiling((Time-(to_ms/2))/to_ms)*to_ms

  return(time)


}



