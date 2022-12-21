#' Detect a change in a column, and returns an incremental counter 
#'
#' Mostly used, e.g., in case the ET file does not provide a Trial number column.
#' The function monitors the occurrences of a 'key' value and, when this value appears
#' for the first time, increases a counter by 1. For example, this will return 
#' a counter that for the first occurrences of "target" in the "Event" column,
#' thus returning the putative trial number assuming that target is repeated
#' for each iteration. By default, the column to track is filled downward. Also,
#' empty lines are changed to NA. As a final remark, you may need to clean up
#' lines that are not assigned to a trial (sometimes, e.g., the eyetracker
#' needs time to warm up). 
#' 
#' 
#' @param vector A vector variable to be tracked.
#' @param key Value to track, its first repetition will update the counter. 

#' @return A numeric vector returning the counter - the function can thus be used in
#' tidyverse-style pipelines with grouping (e.g., by ID).
#'
#' @export

detect_change= function(vector,
                        key){
  
  #select
  x= unlist(vector)
  
  #fill
  x= ifelse(x== "", NA, x)
  x= tidyr::fill(data.frame(x), .direction = "down")
  x= unlist(x)
  
  #nas made innocuous
  x[is.na(x)]= "none$%&"
  
  #shape as matrix
  emb= embed(x, 2)== key
  
  #check first change only
  #so that 2 trues do not count
  res= ifelse(emb[,1]== TRUE & emb[,2]== FALSE, 1, 0)
  
  #cumulative sum (- 1 for python)
  cs= cumsum(res) 
  
  #adding back first value for the derivative
  #subtracting 1 for enhance python compatibility
  res= c(cs[1], cs) - 1
  
  return(res)
  
  
}



