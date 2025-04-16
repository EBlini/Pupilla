#' Highlights and test the time-course of effects through mixed-effects models
#'
#' This function performs (g)lmer for each timepoint.
#' Data are first separated for each time-point, and a LMEM as specified by the 'formula'
#' parameter, which is passed to 'lmerTest::lmer', is performed.
#' The function returns t/z values, p values, and corrected p values.
#'
#' @param data A data.frame containing all the necessary variables.
#' @param formula A 'lme4'-style formula, passed as a string.
#' @param time A string indicating the name of the time variable.
#' @param family A string indicating a GLM family to be passed to (g)lmer.
#' @param correction A string indicating the method for correcting p values (see p.adjust). defaults to "fdr".
#' @param ... Other pars passed to (g)lmer.
#' @return A list including: t/z values, p values, corrected p values.
#'
#' @export

lmem_test = function(data,
                     formula,
                     time,
                     family = "gaussian",
                     correction = "fdr",
                     ...) {

  #first change names for your convenience
  DF= data.frame(data)
  DF$time= DF[,colnames(DF)== time]

  #as formula
  formula= as.formula(formula)

  #split data for every level of time
  if(is.factor(DF$time))(time_lev= levels(factor(DF$time))) else (time_lev= unique(DF$time))
  time_list= lapply(time_lev, function(x){

    ind= DF$time %in% x

    DF[ind,]

  })

  #fit function

  my_fit= function(time_list,
                   formula,
                   family,
                   ...) {
    lapply(time_list, function(x) {
      if (family == "gaussian") {
        mod <- tryCatch(
          lmerTest::lmer(formula = formula,
                         data = x,
                         ...),
          error = function(e) NULL
        )
      } else {
        mod <- tryCatch(
          lme4::glmer(formula = formula,
                      data = x,
                      family = family, ...),
          error = function(e) NULL
        )
      }
      #print(mod)
      if (!is.null(mod)) {
        summary(mod)$coefficients
      } else {
        NULL
      }
    })
  }

  all_fit= my_fit(time_list,
                  formula= formula,
                  family= family, ...)
  #now fit for every time point and fold
  # all_fit= lapply(time_list, function(x, ...){
  #
  #   if(family== "gaussian"){
  #   mod= tryCatch(
  #     lmerTest::lmer(
  #       formula = formula,
  #       data = x,
  #       ...
  #     ),
  #     error= function(dummy)(mod= NULL))
  #   } else {
  #
  #     mod= tryCatch(
  #       lme4::glmer(
  #         formula = formula,
  #         data = x,
  #         family= family,
  #         ...
  #       ),
  #       error= function(dummy)(mod= NULL))
  #   }
  #
  #   if(!is.null(mod))(mod= summary(mod)$coefficients)
  #
  # })

  #now assess the time course of all effects for each fold
  effects= rownames(all_fit[[1]])

  course_eff= vector("list", 0)

  #rename stats
  all_fit= lapply(all_fit, function(x){

    if(!is.null(x)){
    x= data.frame(x)
    w.i= which(colnames(x) %in% c("z value",
                                  "t.value",
                                  "t value"))
    colnames(x)[w.i]= "statistic"
    w.p= ncol(x)
    colnames(x)[w.p]= "p"
    }
    return(x)
  })

  for (e in effects){

    ts = sapply(all_fit, function(x) {
      if(is.null(x))(NA) else(x[e, ]$statistic)
    })
    ps = sapply(all_fit, function(x) {
      if(is.null(x))(NA) else(x[e, ]$p)
    })
    corr= p.adjust(c(unlist(ps)), method = correction)

    course_eff[[e]]= list(statistic= c(unlist(ts)),
                          p.value= c(unlist(ps)),
                          p.corrected= corr)
  }


  #wrap it up
  res = list("LMEMs" = course_eff,
             timepoints = time_lev,
             formula = formula)


  return(res)
}
