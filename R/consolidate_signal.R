#' Consolidate pupil data according to different heuristics
#'
#' Mostly used, e.g., when pupil data is available for both eyes and one needs
#' a single variable. Results are weighted by vectors of signal validity
#' as provided by the eye-trackers. If absent, that all signals is valid is assumed.
#'
#'
#' @param s1 A vector with the first signal.
#' @param s2 A vector with the second signal.
#' @param v1 A vector with the weights for the first signal.
#' @param v2 A vector with the weights for the second signal.
#' @param strategy A strategy for mixing the two signals. Conservative takes
#' the mean only when both signals are valid. Liberal additionally take
#' one valid signal even when the other is not valid. Pick_best chooses the
#' best overall signal (valid more often) and disregard the other when
#' only one of the two is valid.
#' @param plausible A vector of length 2 defining the range of plausible values
#' for pupil size. If provided, values outside this range are set to NA.

#' @return A numeric vector with the consolidated pupil size or NAs when not
#' available.
#'
#' @export

consolidate_signal= function(s1,
                             s2,
                             v1,
                             v2,
                             strategy= c("conservative",
                                         "liberal",
                                         "pick_best"),
                             plausible= NULL
                             ) {


  strategy= match.arg(strategy)

  #all valid if not provided - though in this case strategy is useless
  if(is.null(v1))(v1= rep(1, length(s1)))
  if(is.null(v2))(v2= rep(1, length(s2)))

  #unlist all
  s1= unlist(s1)
  s2= unlist(s2)
  v1= unlist(v1)
  v2= unlist(v2)


  if(strategy== "conservative"){

    pupil= ifelse((v1+v2)== 2,
                  (s1 + s2)/2,
                  NA)
  }

  if(strategy== "liberal"){

    sc= ifelse(v1>v2, s1, s2)

    pupil= ifelse((v1+v2)== 2,
                  (s1 + s2)/2,
                  ifelse((v1+v2)== 1,
                         sc,
                         NA)
                  )
  }

  if(strategy== "pick_best"){

    if(mean(v1, na.rm = T)>mean(v2, na.rm = T))(best= v1) else(best= v2)

    pupil= ifelse((v1+v2)== 2,
                  (s1 + s2)/2,
                  ifelse((v1+v2)== 1,
                         best,
                         NA)
                  )

  }

  if(!is.null(plausible)){

    pupil[pupil<plausible[1] | pupil>plausible[2]]= NA

  }

  return(as.numeric(pupil))


}



