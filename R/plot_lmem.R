#' takes an LMEM object and plots the results
#'
#' This function is meant to depict the time course of
#' t statistics for each effect in a lmem_test object. At state it is
#' very essential, and there is little room to set graphical pars from
#' within this function.
#'
#' @param LMEM A lmem_test object.
#' @param exclude_intercept Whether the intercept should be excluded.
#' @param subset_significant Whether only significant clusters should be plotted.
#' @return A plot powered by 'ggplot2'.
#'
#' @export


plot_lmem= function(LMEM,
                    exclude_intercept=T,
                    subset_significant=T){

  #first reshape the results
  #get all effects tested
  effects= names(LMEM$LMEMs)

  if(exclude_intercept)(effects= effects[!effects %in% "(Intercept)"])

  DF= {}
  for(e in effects){
    temp= data.frame(Time= LMEM$timepoints,
                     Effect= rep(e, length(LMEM$timepoints)),
                     t= LMEM$LMEMs[[e]]$statistic,
                     p= LMEM$LMEMs[[e]]$p.corrected)

    DF= rbind(DF, temp)

  }

  #subset of significant values
  DF= DF %>%
    dplyr::group_by(Effect) %>%
    dplyr::mutate(
      Sig = p < 0.05,
      Sig_run = cumsum(Sig != lag(Sig, default = first(Sig)))
    ) %>%
    dplyr::ungroup()

  if(subset_significant){
    DF= DF[DF$Sig,]

  }

  #have fixed y lims
  ylims= range(DF$t)
  if(ylims[2]<0)(ylims[2]=0)
  if(ylims[1]>0)(ylims[1]=0)


  #graphical pars

  commonTheme = {list(
    ggplot2::theme_minimal(),
    ggplot2::theme(
      legend.box.margin = margin(-10, -5, -10, -10),

      text = element_text(
        size = 11,
        face = "bold",
        color = "black"
      ),
      axis.text.x = element_text(
        size = 11,
        face = "bold",
        color = "black"
      ),
      axis.text.y = element_text(
        size = 11,
        face = "bold",
        color = "black"
      )
    )
  )}

  p= ggplot2::ggplot(DF, ggplot2::aes(x= Time, y= t,
                                   color= Effect)) +
    ggplot2::geom_line(data = subset(DF, !Sig),
                       ggplot2::aes(group = interaction(Effect, Sig_run)),
                       linewidth = 0.8, linetype= "dashed") +
    ggplot2::geom_line(data = subset(DF, Sig),
                       ggplot2::aes(group = interaction(Effect, Sig_run)),
                       linewidth = 1.2) +
    commonTheme +
    #ggplot2::scale_x_continuous(n.breaks = 4) +
    ggplot2::ylab("t value") +
    ggplot2::ylim(ylims)

  return(p)

}
