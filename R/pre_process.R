#' A convenience function to preprocess pupillometry data
#'
#' The function calls, in order, 'speed_clean', 'interpolate', and 'smooth_vector' from this packages.
#' Parameters can only be changed in the package options, i.e. 'Pupilla::pp_options()'.
#' Warning, the best preprocessing parameters may deviate from the defaults used here,
#' be mindful!
#'
#' @param vector A vector variable to be cleaned
#' @param time A vector variable indicating the elapsed time, needed to compute
#' velocity.

#' @return A numeric vector processed as requested or as per the default. .
#'
#' @export

pre_process= function(vector,
                      time){


  vector= speed_clean(vector = vector,
                      time = time)

  vector= interpolate(vector = vector)

  if(sum(is.na(vector))==0){

    vector= smooth_vector(vector = vector,
                   time = time)

  }


  return(vector)


}



