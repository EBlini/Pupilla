
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
#' @param thresh Threshold (z point or absolute value) above which values are marked as NA.
#' @param speed_method Whether the 'thresh' is a z-score ('z'), with deviant values
#' omitted once, or until there are no more values above the threshold ('z-dynamic').
#' 'abs' is used instead when a precise absolute value for speed is supplied.
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
                      speed_method= pp_options("speed_method"),
                      extend_by= pp_options("extend_by"),
                      island_size= pp_options("island_size")){


  #compute speed
  #the absolute value is not taken here anymore
  space= diff(vector)

  speed= space / diff(time)

  #here if speed_method is "z" or "z-dynamic, turn speed to z-scores
  if (speed_method %in% c("z", "z-dynamic")){
    speed= (speed - mean(speed, na.rm= T))/sd(speed, na.rm= T)
  }

  # if abs take the absolute value and then check against thresh
  #this has not been turned to z scores before
  if (speed_method == "abs"){

    indices= abs(speed) > thresh

  }

  # if is "z" take the absolute value and then check against thresh
  if (speed_method == "z"){

    indices= abs(speed) > thresh

  }
  #if "z-dynamic repeat until there are no more deviant values
  if (speed_method == "z-dynamic"){

    indices= abs(speed) > thresh

    speed2= speed

    while (sum(abs(speed2) > thresh, na.rm= T) > 0){

      speed2[indices]= NA
      speed2= (speed2 - mean(speed2, na.rm= T))/sd(speed2, na.rm= T)
      indices[abs(speed2) > thresh]= TRUE
      #print(sum(indices, na.rm= T))

      }
  }


  #extend if requested
  if(!is.null(extend_by)){

    ind2= which(indices== TRUE) #| is.na(speed)

    for(i in ind2){

      from= i - extend_by
      to= i + extend_by

      if(from < 1)(from= 1)
      if(to>length(speed))(to= length(speed))

      indices[from:to]= TRUE

    }
  }


  #finally set vector to NA where indices is TRUE
  vector[c(FALSE, indices)]= NA

  #remove islands if requested (and present)
  is= 1:island_size

  for(i in is) {

    vector= clean_island(vector, i)

  }



  return(vector)


}



