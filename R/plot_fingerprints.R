#' Plot all (three) fingerprints of reduced time-series
#'
#' This function is under active development. It is
#' meant to depict the three eigenvectors/loadings/weights of components obtained by reducing
#' pupillary time-series, as to ease interpretation. Note that the
#' components and their names are re-ordered according to their explained variance
#' by default, and so are their names, so that results may differ from the original scores.
#' Be mindful!
#'
#' @param data An object as returned by, e.g., 'reduce_PCA'.
#' @param order A character, defaults to "var" for reordering the fingerprints
#' by their share of explained variance. Else "none" or "peak", to order by latency of the peak value.
#' @param flip A vector of numbers indicating the component(s) to flip in sign (e.g., c(1,1,-1))
#'
#' @return A plot powered by 'ggplot2'.
#'
#' @export

plot_fingerprints= function(data,
                            order= "var",
                            flip= c(1, 1, 1)){


  #get explained variance
  if("ICA" %in% names(data)){

    sub= "IC"
    ev= round(data$ICA$vafs, 2)
    names(ev)= colnames(data$Loadings)

  } else if("rPCA" %in% names(data)){

    if(ncol(data$summaryRPCA)==1){sub= "PC1"} else {sub= "RC"}

     ev= round(data$summaryRPCA["Proportion Var", ], 2)

  } else {

    sub= "PC"
    ev= round(data$summaryPCA["Proportion of Variance", 1:ncol(data$Loadings)], 2)

  }

  #only limit to 3 fingerprints
  if(length(ev)!= 3){stop("Only meant to work with 3 fingerprints!")}

  #loadings
  loadings= data$Loadings


  #automatically reorder!
  if (order== "none"){

    is.ordered= T

  } else if (order== "var") {

    is.ordered= sum(names(ev)== paste0(sub, 1:3))==3
    ord= order(ev, decreasing = T)

  } else if (order== "peak") {

    pks= apply(abs(loadings), 2, which.max)
    ord= order(pks, decreasing = T)
    is.ordered= sum(names(ev)== paste0(sub, 3:1))==3

    }

  new_names= paste0(sub, 1:3)

  if(is.ordered== FALSE){

    warning("Warning: fingerprint names have been reordered following the explained variance!")

    #expl var may change
    ev= ev[ord]
    names(ev)= new_names

    #same for loadings
    loadings= loadings[,ord]
    colnames(loadings)= new_names

  }

  #flip...
  for (i in 1:3){

    loadings[,i]= loadings[,i] * flip[i]
  }

  all_load= data.frame(loadings)
  colnames(all_load)= c("FC1", "FC2", "FC3")

  all_load$Time= as.numeric(rownames(all_load))

  ev= paste0(names(ev), ": ", ev * 100, "%")


  p= ggplot2::ggplot(all_load,
                     ggplot2::aes(x= Time)) +
    ggplot2::geom_hline(yintercept = 0, color= "black", linewidth= 1.2) +
    ggplot2::geom_line(ggplot2::aes(y= FC1, color= "red"),
              linewidth= 1.2) +
    ggplot2::geom_line(ggplot2::aes(y= FC2, color= "orange"),
              linewidth= 1.2) +
    ggplot2::geom_line(ggplot2::aes(y= FC3, color= "gold"),
              linewidth= 1.2) +
    ggplot2::scale_color_identity(name = "Fingerprints",
                         breaks = c("red", "orange", "gold"),
                         labels = ev,
                         guide = "legend") +
    ggplot2::theme_bw() +
    ggplot2::ylab("Weight") +
    ggplot2::theme(text= ggplot2::element_text(size= 16,
                             face="bold"))



  return(p)

}
