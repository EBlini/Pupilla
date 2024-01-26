#commonTheme
commonTheme= ggplot2::theme(
  text= ggplot2::element_text(size= 14, face= "bold"),
  axis.text= ggplot2::element_text(size= 14, face= "bold", color= "black"))


#' Plots two time series against each other
#'
#' The function plots two time series against each other.
#' The intended use is generally to check the original vs. preprocessed data.
#' The first series is plotted with a black line, the second one - typically
#' the reconstructed series - with a red line. Nas show up as interruptions
#' of the lines. The function can be used within dplyr's style pipes -
#' in which case 'data' can be omitted and the other variables must
#' be provided as quoted variables' names - or standard vectors may be
#' provided - in which case 'data' should be NULL and args should be passed
#' by name.
#'
#' @param data Optional. Can be omitted if passed through dplyr's style
#' pipelines (through '.'), in which case the other arguments should be
#' passed as quoted variables' names.
#' @param series1 A vector variable with values for the first time series.
#' It is plotted by means of a black line. Typically, the original data.
#' @param series2 A vector variable with values for the second time series.
#' It is plotted by means of a red line. Typically, the processed data.
#' @param time A vector variable indicating the elapsed time, which is
#' used for the x axis.

#' @return A plot.
#'
#' @export

check_series= function(data,
                       series1,
                       series2,
                       time){

  if(is.null(data)){

    #consolidate DF
    ggDF= data.frame(series1= series1,
                     series2= series2,
                     time= time)

  } else {

    ggDF= data.frame(series1= data[, series1],
                     series2= data[, series2],
                     time= data[, time])

  }

  colnames(ggDF)= c("series1", "series2", "time")

  #plot
  p= ggplot2::ggplot(ggDF,
                     ggplot2::aes(y= series1, x= time)) +
    ggplot2::geom_line(linewidth= 1.3) +
    ggplot2::geom_line(ggplot2::aes(y= series2),
              color= "red", alpha= 0.7,
              linewidth= 1) +
    commonTheme +
    ggplot2::ylab("Series") +
    ggplot2::xlab("Time")

  return(p)

}



