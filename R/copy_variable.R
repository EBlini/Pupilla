#' copy a variable from one data.frame to another of different length given ID and Trial constraints
#'
#' Sometimes info that are relevant for the eye-tracking file are only to be
#' found in the associated behavioral file. These data.frames have different
#' dimensions, thus copying one variable to another can be cumbersome.
#' This function does the job by expanding the relevant information accordingly
#' and exploits constraints in the two files. The task is performed for each
#' ID separately and requires a "Trial" variable that is used to calculate the amount of
#' required expansion in the data. 
#' 
#' @param var_name A string suggesting which variable to look for in the
#' smaller data.frame (usually the behavioral one) and then copy to the larger
#' data.frame (usually the eye-tracker one).
#' @param id_var The name of the ID variable or the grouping variable for
#' which the assignment must be separated (e.g., performed for each participant).
#' Can be NULL for no grouping.
#' @param constrained_var The name of the variable that represents the available costraint.
#' For example, this can be Trial number and 'var_name' will be expanded as to have
#' the same value for each value of Trial number.
#' @param larger_df The larger data.frame. The output vector will match 
#' the number of rows of this dataframe. Typically, the eye-tracker dataframe.
#' @param smaller_df The smaller dataframe which includes 'var_name'. 

#' @return A vector of 'length= nrow(larger_df)'.
#'
#' @export

copy_variable= function(var_name,
                        id_var= "p_ID",
                        constrained_var= "Trial",
                        larger_df= ET,
                        smaller_df= BD){
  

  #split dataframes by grouping variable if needed
  if (is.null(id_var)) {
    
    all_ET= list(larger_df= larger_df, smaller_df= smaller_df)
    
  } else {
  
    s= unique(smaller_df[,id_var])
    
    all_ET= lapply(s, function(x){
      
      larger_df= larger_df[larger_df[,id_var]== x,]
      smaller_df= smaller_df[smaller_df[,id_var]== x,]
      
      return(list(larger_df= larger_df, 
                  smaller_df= smaller_df))
      
    })
  
  }
  
  #compute expanded vectors of the correct final size
  all_v= lapply(all_ET, function(x){
    
    l= x$larger_df
    s= x$smaller_df
    
    what= s[, var_name]
    times= c(table(l[,constrained_var])) 
    
    vector= rep(what, times= times)
    
    return(vector)
    
  })
  
  #concatenate all vectors
  vector= do.call(c, all_v)
  
  
  return(vector)
  
  
}



