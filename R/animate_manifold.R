#' Animate a 3D scatterplot (based on plot3D) through gifski
#'
#' This function executes plot_manifold, from which it
#' inherits parameters, iteratively, saves each frame in a folder in the
#' current path, and then creates a gif with the package gifski,
#' which must be installed.
#'
#'
#' @param Scores An object as returned by 'reduce_rPCA'.
#' @param colvar;col  The name of a variable to use for colors;
#' a char vectors of colors.
#' @param thetas;phis The angles of the "eyes" on the plot given
#' as vectors of angles that will form the gif. Vectors must have
#' the same length
#' @param pch;cex Some graphical pars defining shape and size
#' of the points plotted
#' @param adapt3D Whether axis should be "as is", FALSE, or strectched to fit
#' the 3D box, TRUE
#' @param xlim;ylim;zlim To manually supply limits
#' @param gifname Name of the gif file saved in the current path
#' @param width;height Dimensions of the images and thus of the gif
#' @param delay Speed of the transitions in seconds
#'
#' @return A gif is saved in the current path; side effect: all frames are saved in a folder in the path.
#'
#' @export

animate_manifold= function(Scores,
                           colvar= NULL,
                           col= NULL,
                           gifname= "gif.gif",
                           thetas= seq(0, 359, 1),
                           phis= rep(10, 360),
                           pch= 16,
                           cex= 2,
                           xlim= NULL,
                           ylim= NULL,
                           zlim= NULL,
                           adapt3D= F,
                           width= 700,
                           height= 700,
                           delay= 75/1000
                           ){

  #require("gifski")

  print("The folder is in the current path")
  print("Beware: not all files may be rewritten")

  dir.create(file.path(getwd(), "GIFs"),
             showWarnings = FALSE)


  for (i in 1:length(thetas)){



    nameimg= gsub(" ", 0, format(i, width= 4))

    png(file=paste("GIFs\\example", nameimg,".png"),
        width=width, height=height)

    plot_manifold(Scores= Scores,
                  colvar = colvar,
                  col= col,
                  theta = thetas[i],
                  phi= phis[i],
                  pch = pch, cex = cex,
                  xlim= xlim,
                  ylim= ylim,
                  zlim= zlim,
                  adapt3D=adapt3D)
    #print(res)

    dev.off()

    #Sys.sleep(1)
  }

  #gif here

  png_files <- list.files("GIFs",
                          pattern = ".*png$",
                          full.names = TRUE)

  #w and h to parametrize
  gifski::gifski(
    png_files,
    gif_file = gifname,
    width = width,
    height = height,
    delay = delay
  )


}
