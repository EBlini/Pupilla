

#from: https://coolbutuseless.github.io/2020/08/26/run-length-encoding-and-the-problem-of-nas/
rle2 <- function (x)  {
  stopifnot("'x' must be a vector of an atomic type" = is.atomic(x))

  n <- length(x)
  if (n == 0L) {
    return(structure(list(
      lengths = integer(), values = x)
    ), class = 'rle')
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Where does next value not equal current value?
  # i.e. y will be TRUE at the last index before a change
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  y <- (x[-1L] != x[-n])

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Since NAs are never equal to anything, NAs in 'x' will lead to NAs in 'y'.
  # These current NAs in 'y' tell use nothing - Set all NAs in y to FALSE
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  y[is.na(y)] <- FALSE

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # When a value in x is NA and its successor is not (or vice versa) then that
  # should also count as a value change and location in 'y' should be set to TRUE
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  y <- y | xor(is.na(x[-1L]), is.na(x[-n]))

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Any TRUE locations in 'y' are the end of a run, where the next value
  # changes to something different
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  i <- c(which(y), n)

  structure(list(
    lengths = diff(c(0L, i)),
    values  = x[i]
  ), class = 'rle')
}

# check continuous NA in a passed vector, according to a % threshold
check_cont_na <- function(vec, thresh){

  rl = rle2(vec)
  rd = as.data.frame(cbind(rl$lengths, rl$values))
  rdna = dplyr::slice(rd, which(is.na(rl$values)))

  if (max(rdna[, 1]) / length(vec) > thresh)(FALSE) else (TRUE)
}

# x= c(1:10, NA, NA)
# check_cont_na(x, 0.16)

ext_blink= function(vector, extend_blink){

  rl = rle2(vector)
  rd = as.data.frame(cbind(rl$lengths, rl$values))
  rd$to= cumsum(rd$V1)

  rdna = dplyr::slice(rd, which(is.na(rl$values)))

  #remove blinks
  eb= 1:nrow(rdna)

  for(i in eb) {

    from= rdna$to[i] - (rdna$V1[i]-1) - extend_blink
    to= rdna$to[i] + extend_blink

    if(from < 1)(from= 1)
    if(to>length(vector))(to= length(vector))

    vector[from:to]= NA

  }

  return(vector)

}

# x= c(1:10, NA, 2, 2,2, NA, 1:10)
# x= clean_island(x, 3)
# ext_blink(x, 3)
#
# x= c(1:10, NA, 2, 2,2, NA, 1:10)
# ext_blink(x, 1)



#' Linearly interpolate signal provided quality checks are met, else only returns NAs
#'
#' This is used to linearly interpolate any data provided successful quality controls.
#' If these controls are not met, the returned vector is a vector of equal length
#' composed of only NAs. Quality checks are general (i.e., overall percentage of
#' available non NA data) or relative to consecutive gaps in the signal, which
#' must not exceed a given threshold. Thresholds refer to the
#' maximum rate (percentage) of entries that are allowed to be NAs; results
#' are only interpolated below these thresholds.
#'
#' @param vector A vector to interpolate.
#' @param extend_blink NAs are extended by these many samples
#' prior to interpolation. This gets rid of signal that may be compromised
#' in the close proximity of a blink.
#' @param overall_thresh Overall quality threshold: e.g., the total amount of data
#' that is allowed to be missing from the original vector.
#' @param consecutive_thresh Consecutive gaps in the signal: e.g., the total amount of data
#' that is allowed to be missing from the original vector **consecutively**.

#' @return A numeric vector of interpolated data or NAs if quality checks are not met.
#'
#' @export


interpolate= function(vector,
                      extend_blink= pp_options("extend_blink"),
                      overall_thresh= pp_options("overall_thresh"),
                      consecutive_thresh= pp_options("consecutive_thresh")){


  #first extend blinks if required (then check criteria)

  if(!is.null(vector)){

    vector= ext_blink(vector, extend_blink)

  }



  #now check criteria

  #TRUE if quality is met
  criterion= sum(is.na(vector))/length(vector)< overall_thresh

  if(!is.null(consecutive_thresh)) {

    #also TRUE if quality is met
    criterion= criterion * check_cont_na(vector, consecutive_thresh)

  }

  #if failed, return NAs, else...
  if(criterion== 0)(return(rep(NA, length(vector)))) else {

    #if the first sample is NA, interpolation is not possible
    #set this value to first non-NA value
    if (is.na(vector[1])){
      vector[1]= na.omit(vector)[1]

    }

    #same for last observation
    if (is.na(vector[length(vector)])){
      vector[length(vector)]= tail(na.omit(vector), 1)

    }

    #interpolate linearly
    vector= zoo::na.approx(vector)

    return(vector)

  } #end criterion met


}

# x= c(1:10, NA, NA, 8)
# interpolate(x, 2, 0.1)
# interpolate(x, 2,  0.1, 0.1)
# interpolate(x, 2, 0.5, 0.1)
# interpolate(x, 2, 0.5, 0.4)

