#' Interprets easily the results of 'lmem_test'
#'
#' This is a helper function. It takes an object
#' created by 'lmem_test' and spits intervals
#' with significant effects.
#'
#' @param lmems An object returned by 'lmem_test'.
#' @param p defaults to "corrected" to use adjusted p values
#' @param sig_thresh Threshold to judge significance.
#' @param cluster_size How many timepoints constitute a cluster?
#' @return A list including intervals with significant fixed effects.
#'
#' @export

interpret_lmem= function(lmems,
                         p= "p.corrected",
                         sig_thresh= 0.05,
                         cluster_size= 10){

  #effects
  effects= names(lmems$LMEMs)

  help_ext= function(x, #logical vector
                     interpret){

    tmp= data.frame(unclass(rle(x)))

    end = cumsum(tmp$lengths)
    start = c(1, lag(end)[-1] + 1)

    df= cbind(tmp,
              start= lmems$timepoints[start],
              end= lmems$timepoints[end])
    df$interpretation= interpret
    df= df[df$values== T,]

    return(df)

  }

  tb_int= lapply(effects, function(e){

    sig= lmems$LMEMs[[e]][[p]]<sig_thresh
    ns= lmems$LMEMs[[e]][[p]]>=sig_thresh

    res = rbind(
      help_ext(sig, "Significant"),
      help_ext(ns, "N.S."))

    rownames(res)= NULL

    res= res[,colnames(res)!= "values"]

    res$cluster= ifelse(res$lengths>= cluster_size,
                        "Yes", "No")

    return(res)
  })

  names(tb_int)= effects



  return(tb_int)
}
