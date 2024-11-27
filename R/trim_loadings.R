#' Trim rPCA loadings according to heuristics and append them to the original object
#'
#' Under development. This function takes a 'reduce_rPCA' object,
#' and only a 'reduce_rPCA' object, and trims the original loadings.
#' The trimmed loadings can then be used for (new) predictions
#' with 'predict_feature()', for example. One reason why
#' this could be useful is to reduce collinearity between
#' rotated components - albeit one can also consider orthogonal solutions.
#'
#' @param rpca_mod An object returned by 'reduce_rPCA'.
#' @param keep_max If TRUE, for each timepoint only the
#' largest loading (in absolute value) is preserved, the
#' remaining ones are set to 0.
#' @param abs_value An absolute value below which loadings
#' are set to 0
#'
#' @return The original object in which information about the trimming has been added
#'
#' @export

trim_loadings= function(rpca_mod,
                        keep_max= T,
                        abs_value= 0.4){


  #starting point
  new_loadings= rpca_mod$Loadings
  new_weights= rpca_mod$rPCA$weights

  #more drastic if "max" is provided
  if(keep_max){

    max_load= apply(abs(rpca_mod$Loadings),
                    1, max)

    for (i in 1:ncol(new_loadings)){

      new_weights[,i]= ifelse(abs(new_loadings[,i])==max_load,
                              new_weights[,i], 0)

      new_loadings[,i]= ifelse(abs(new_loadings[,i])==max_load,
                               new_loadings[,i], 0)

    }

  }

  #if value not null...

  if(!is.null(abs_value)){

    for (i in 1:ncol(new_loadings)){

      new_weights[,i]= ifelse(abs(new_loadings[,i])> abs_value,
                              new_weights[,i], 0)

      new_loadings[,i]= ifelse(abs(new_loadings[,i])> abs_value,
                               new_loadings[,i], 0)

    }

  }

  #finally...
  new_loadings= data.frame(new_loadings)
  rpca_mod$Trimmed_Loadings= new_loadings

  #new model also...
  #take
  new_model= rpca_mod$rPCA
  #change
  new_model$loadings= as.matrix(new_loadings)
  #new weights for prediction too
  new_model$weights= as.matrix(new_weights)

  #overwrite
  rpca_mod$Trimmed_rPCA= new_model


  return(rpca_mod)

}
