#' Convenience function to check series across IDs and Trials, and save a plot in the current path
#'
#' Convenience function to check series across IDs and Trials, which saves multiple
#' plots in the current path by creating folders and subfolders in a hopefully
#' meaningful way.
#' Note that with massive data this could take some time, so you may want to
#' debug first with a subset of the data.
#' The defaults for 'ggsave', which is used internally, are for now a bit stiff but may become more
#' flexible in the future.
#' The 'check_series' function is invoked for plots, thus you may want to check
#' the relative help page.
#'
#' @param data Mandatory, differently from 'check_series'. The IDs and Trials
#' levels around which the loop is set are retrieved here.
#' @param ID A string indicating the name of the ID column.
#' @param Trial A string indicating the name of the Trial column.
#' @param series1 Unlike 'check_series', this must only be a string
#' indicating the name of the first time series to plot.
#' @param series2 Unlike 'check_series', this must only be a string
#' indicating the name of the second time series to plot.
#' @param time Unlike 'check_series', this must only be a string
#' indicating the elapsed time, which will be used for the x-axis.
#' @return A plot.
#'
#' @export

check_all_series= function(data,
                           ID,
                           Trial,
                           series1,
                           series2,
                           time){

  #get vectors for the grid - this is slower than ideal
  id_vector= unlist(data[,colnames(data)== ID])
  trial_vector= unlist(data[,colnames(data)== Trial])
  #check numeric
  if(!is.numeric(id_vector))(warning("ID variable must be numeric"))
  if(!is.numeric(trial_vector))(warning("Trial variable must be numeric"))

  # #get grid, can be quite massive
  # grid= expand.grid(id= unique(id_vector),
  #                   trial= unique(trial_vector))
  #
  #it is cleaner to create a folder for each ID
  id_uniques= unique(id_vector)
  trial_uniques= unique(trial_vector)

  #friendly messages

  print("The folder is in the current path")
  print("Beware: not all files may be rewritten")

  dir.create(file.path(getwd(), "check_all_series"),
             showWarnings = FALSE)

  #now for each subject

  for(id_loop in id_uniques){

    #create id subfolder
    dir.create(file.path(getwd(), "check_all_series", id_loop),
               showWarnings = FALSE)

    #trial loop
    for(trial_loop in trial_uniques){

      p= data[id_vector== id_loop & trial_vector== trial_loop,]

      p= check_series(data = p,
                      series1,
                      series2,
                      time)

      p= p +
        ggplot2::ggtitle(paste0("ID ", id_loop, ", Trial ", trial_loop))

      ggplot2::ggsave(filename = paste0("Trial ", trial_loop, ".png"),
                      path= file.path(getwd(), "check_all_series", id_loop),
                      plot = p,
                      #scale= 6,
                      width = 6,
                      height = 5)

    }

  } #end id_loop

} #end function
