#' Plot loadings of a reduced time-series
#'
#' This function is under active development. It is
#' meant to depict the loadings of components obtained by reducing
#' pupillary time-series, as to ease interpretation.
#'
#' @param name A string indicating the component to depict (e.g., "PC1").
#' @param data An object as returned by, e.g., 'reduce_PCA'.
#' @return A plot powered by 'ggplot2'.
#'
#' @export

plot_loadings= function(name,
                        data){

  #set data
  dv= data$Loadings[, name]
  time= as.numeric(rownames(data$Loadings))

  DF= data.frame(Time= time, dv= dv)

  #pretty color scheme
  percentile= ecdf(abs(DF$dv))
  DF$Color= percentile(abs(DF$dv) + min(abs(DF$dv)))


  limit= c(min(dv), max(dv))
  if(limit[2]<0)(limit[2]= 0)
  if(limit[1]>0)(limit[1]= 0)

  if("ICA" %in% names(data)){
    cp= gsub("[[:digit:]]","",name)
    cp= as.numeric(gsub(cp,"",name))
    ev= round(data$summaryPCA["Proportion of Variance", cp], 2)
  } else {
    ev= round(data$summaryPCA["Proportion of Variance", name], 2)

    }



  #theme
  commonTheme= list(#theme_bw(),
    ggplot2::theme(text= ggplot2::element_text(size= 16,
                                               face="bold")),
    ggplot2::xlab("Time (ms)"),
    ggplot2::ylab("Loading"),
    ggplot2::ylim(limit),
    ggplot2::ggtitle(name,
            subtitle= paste0("Explained variance: ",
                             ev))
  )


  p=
    ggplot2::ggplot(DF, ggplot2::aes(x= Time, y= dv)) +
    ggplot2::geom_point(ggplot2::aes(color= Color),
                        size= 1.3, show.legend = F) +
    ggplot2::scale_color_gradient(low = "yellow", high = "red") +
    ggplot2::geom_hline(yintercept = 0,
               color= "black", linetype= "dashed",
               linewidth= 1.2) +
    commonTheme

  return(p)

}
