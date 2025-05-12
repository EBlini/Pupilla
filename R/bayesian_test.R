#' Highlights and test the time-course of effects through bayes factors
#'
#' This function performs general  bayesian tests through
#'  'BayesFactor::generalTestBF()'.
#'
#'
#' @param data A data.frame containing all the necessary variables.
#' @param formula A 'lme4'-style formula, passed as a string.
#' @param time A string indicating the name of the time variable.
#' @param whichRandom A string (vector) indicating which variables in the formula are
#' random effects. Random effects must be factors. see '?anovaBF'
#' @param whichModels defaults to "bottom", meaning a type 2 test
#' of inclusion. see '?anovaBF'
#' @param ... Further arguments that are passed to 'BayesFactor::generalTestBF()'.
#' For example in cases in which you intend to deviate from default priors.
#' @return A list including, for each term in the model, the bayes factors for
#' each timepoint.
#'
#' @export

bayesian_test= function(data,
                        formula,
                        time,
                        whichRandom,
                        whichModels= "bottom",
                        ...){

  #first change names for your convenience
  DF= data.frame(data)
  DF$time= DF[,colnames(DF)== time]

  #as formula
  formula= as.formula(formula)

  #split data for every level of time
  if(is.factor(DF$time)){
    time_lev= levels(factor(DF$time))
    } else {time_lev= unique(DF$time)}

  time_list= lapply(time_lev, function(x){

    ind= DF$time %in% x

    DF[ind,]

  })

  #fit function

  my_fit= function(time_list,
                   formula,
                   whichRandom,
                   whichModels,
                   ...) {
    lapply(time_list, function(x) {

      mod= tryCatch(
        BayesFactor::generalTestBF(
          formula = formula,
          data = x,
          whichRandom = whichRandom,
          whichModels = whichModels,
          progress = F,
          ...
        ),
        error= function(dummy)(mod= NULL))

    })

  }

  all_fit= my_fit(time_list,
                  formula= formula,
                  whichRandom= whichRandom,
                  whichModels= whichModels,
                  ...)

  # #now fit for every time point and fold
  # all_fit= lapply(time_list, function(x, ...){
  #
  #   mod= tryCatch(
  #     BayesFactor::generalTestBF(
  #       formula = formula,
  #       data = x,
  #       whichRandom = whichRandom,
  #       whichModels = whichModels,
  #       progress = F,
  #       ...
  #     ),
  #     error= function(dummy)(mod= NULL))
  #
  # })

  #now assess the time course of all effects for each fold
  effects= rownames(
    BayesFactor::extractBF(all_fit[[1]])
    )

  course_eff= vector("list", 0)

  for (e in effects){

    course_eff[[e]]=
      sapply(all_fit, function(f){

        BayesFactor::extractBF(f)[e, 1]

      })
  }



  #wrap it up

  res= list("BFs"= course_eff,
            timepoints= time_lev,
            formula= formula)

  return(res)
}
