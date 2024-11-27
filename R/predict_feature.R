#' Predicts features' scores from a model
#'
#' Under development. This function is meant to predict
#' the scores of features obtained from a trained model
#' such as one returned by the 'reduce_*' family of functions.
#' In particular, the function would ideally work with any
#' technique implemented so far (PCA, rPCA, ICA) and whether or
#' not scaling and centering have been required.
#' This function could be used then within a more stringent
#' crossclassification approach (in which scores are computed)
#' anew, or even with different tasks to check whether different
#' signatures can be observed in an independent pool of data.
#' It takes as input a "time" argument to ensure the timepoints
#' used by the model to compute the loadings match, if
#' they don't the function returns an error.
#'
#' @param vector A vector variable to be transformed according
#' to the given model. Usually the pupil dimension for a trial/condition.
#' @param time A vector variable indicating the elapsed time. Should be the
#' same as the loadings' names in the model
#' @param model Object returned by 'reduce_*', e.g. 'reduce_PCA()'.
#' @param use_trimmed Defaults to FALSE. However, if rPCA
#' loadings are previously trimmed with 'trim_loadings' (and the
#' corresponding values are appended in the model provided), then
#' predictions are made with the trimmed loadings. Only works for rPCA.
#'
#' @return A dataframe of scores - as many as the loadings in the model.
#'
#' @export

predict_feature= function(vector,
                          time,
                          model,
                          use_trimmed= FALSE){


  #checks here if time== rownames(Loadings)
  trained_time= as.numeric(rownames(model$Loadings))

  #initial time, last, length, average diff
  test1= time[1]== trained_time[1]
  test2= tail(time, 1)== tail(trained_time, 1)
  test3= length(time)== length(trained_time)
  test4= mean(diff(time))== mean(diff(trained_time))

  if (test1*test2*test3*test4== 0) {
    stop("Supplied and trained timepoints do not match")
  }

  #now scale if necessary

  #scale appropriately

  vector_s= vector

  if(model$scaling$is_centered){

    vector_s= vector_s - model$scaling$M

  }

  if(model$scaling$is_scaled){

    vector_s= vector_s / model$scaling$SD

  }

  #now predict
  if("ICA" %in% names(model)){

    new_data= as.matrix(t(vector_s))

    Q = model$ICA$Q
    Y = tcrossprod(new_data, Q)
    res= Y %*% model$ICA$R

  } else if("PCA" %in% names(model)) {

    res= stats::predict(model$PCA,
                 t(vector_s))[1:ncol(model$Loadings)]

  } else {

    if(use_trimmed== FALSE){

      res= psych::predict.psych(model$rPCA,
                 data = vector_s,
                 old.data = model$rs_mat)

    } else {

      res= psych::predict.psych(model$Trimmed_rPCA,
                                data = vector_s,
                                old.data = model$rs_mat)

    }



  }

  names(res)= dimnames(res)[[2]]
  res= as.data.frame(res)
  return(res)




}



