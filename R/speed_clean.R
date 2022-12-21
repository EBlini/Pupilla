
clean_island= function(vector, island_size){

  #reshape
  grid= embed(vector, island_size+2)

  #first and last column must be NA
  ss1= is.na(grid[,1]) & is.na(grid[,island_size+2])

  #sum of middle columns must NOT be NA

  if(island_size==1){

    ss2= !is.na(grid[,2])

  } else {

    mc= 2:(island_size+1)
    ss2= !is.na(apply(grid[,mc], 1, sum))

  }

  #you get the borders
  borders= which(ss1 & ss2)

  for(i in borders){

    vector[(i+1):(i+1+island_size)]= NA

  }

  return(vector)

}

# x= c(rep(NA, 5), 4, 5, NA, NA)
# clean_island(vector= x,island_size = 2)

#' Help identifying artifacts with a speed-based criterion
#'
#' A signal vector is stripped of values exceeding a given
#' threshold, computed on the basis of the absolute speed of signal
#' increase or decrease.
#'
#'
#' @param vector A vector variable to be cleaned
#' @param time A vector variable indicating the elapsed time, needed to compute
#' velocity.
#' @param thresh Threshold (z point) above which values are marked as NA.
#' @param extend_by Number of samples starting from the deviant speed values that
#' are stripped (e.g., the signal in proximity of blinks may be biased as well).
#' @param island_size Islands of signal in the midst of NAs are removed if smaller
#' or equal to this threshold (amount of samples).

#' @return A numeric vector cleaned as requested.
#'
#' @export

speed_clean= function(vector,
                      time,
                      thresh= pp_options("thresh"),
                      extend_by= pp_options("extend_by"),
                      island_size= pp_options("island_size")){


  space= abs(diff(vector))

  speed= space / diff(time)

  speed= (speed - mean(speed, na.rm= T))/sd(speed, na.rm= T)


  if(!is.null(extend_by)){

    indices= which(speed> thresh) #| is.na(speed)

    for(i in indices){

      from= i - extend_by
      to= i + extend_by

      if(from < 1)(from= 1)
      if(to>length(speed))(to= length(speed))

      speed[from:to]= Inf

    }
  }


  vector[c(FALSE, speed> thresh)]= NA

  #remove islands
  is= 1:island_size

  for(i in is) {

    vector= clean_island(vector, i)

  }



  return(vector)


}



