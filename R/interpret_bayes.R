#' Interprets easily the results of 'bayesian_test'
#'
#' This is a helper function. It takes an object
#' created by 'bayesian_test' and spits intervals
#' with evidence for either the null or alternative models.
#'
#' @param bfs An object returned by 'bayesian_test'.
#' @param evidence_thresh Threshold to judge evidence. Defaults
#' to 10. It is meant to be symmetrical: values above 10
#' indicate support for the alternative Hp, less than 1/10 for the null.
#' @return A list including intervals that support H0 or H1.
#'
#' @export

interpret_bayes= function(bfs,
                          evidence_thresh= 10){

  #effects
  effects= names(bfs$BFs)

  help_ext= function(x, #logical vector
                     interpret){

    tmp= data.frame(unclass(rle(x)))

    end = cumsum(tmp$lengths)
    start = c(1, lag(end)[-1] + 1)

    df= cbind(tmp,
              start= bfs$timepoints[start],
              end= bfs$timepoints[end])
    df$interpretation= interpret
    df= df[df$values== T,]

    return(df)

  }

  tb_int= lapply(effects, function(e){

    H1= bfs$BFs[[e]]> evidence_thresh
    H0= bfs$BFs[[e]]< 1/evidence_thresh
    uncertain= bfs$BFs[[e]]> 1/evidence_thresh & bfs$BFs[[e]]< evidence_thresh

    res = rbind(
      help_ext(H1, "Supports H1"),
      help_ext(uncertain, "Not conclusive"),
      help_ext(H0, "Supports H0")
    )

    rownames(res)= NULL

    res= res[,colnames(res)!= "values"]

    return(res)
  })

  names(tb_int)= effects


  return(tb_int)
}
