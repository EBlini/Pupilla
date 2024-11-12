#' Plot a 3D scatterplot (based on plot3D) based on a reduce_rPCA object
#'
#' This function is under active development. It is
#' meant to depict the three scores of components obtained by reducing
#' pupillary time-series through rPCA.
#' There are some strong assumptions, first and foremost that the object is
#' from rotated PCA, and that it includes variables named
#' "RC1" - x axis, "RC2" - y axis, and "RC3" - z axis.
#' The function is a wrapper around 'plot3D::scatter3D'
#' and thus the package is required.
#'
#' @param Scores An object as returned by 'reduce_rPCA'.
#' @param colvar;col  The name of a variable to use for colors;
#' a char vectors of colors.
#' @param theta;phi The angles of the "eyes" on the plot
#' @param pch;cex Some graphical pars defining shape and size
#' of the points plotted
#' @param adapt3D Whether axis should be "as is", FALSE, or strectched to fit
#' the 3D box, TRUE
#' @param xlim;ylim;zlim To manually supply limits
#'
#' @return A 3D plot powered by 'plot3D'.
#'
#' @export

plot_manifold= function(Scores,
                        colvar= NULL,
                        col= NULL,
                        theta= 0,
                        phi= 0,
                        pch= 16,
                        cex= 2,
                        adapt3D= F,
                        xlim= NULL,
                        ylim= NULL,
                        zlim= NULL
                        ){

  #require("plot3D")

  #save old pars to restore them
  old_par= par("mar")
  par(mar=c(0,0,0,0))

  #if full obj is provided
  if(class(Scores)== "list"){Scores= Scores$Scores}
  Scores= as.data.frame(Scores)

  #for loop: different color for each level
  if(is.null(colvar)){

    lvl= 1

  } else {

    #ind= which(colnames(Scores)== colvar)

    Scores$key= Scores[,colvar]

    #cv= unlist(Scores[,colvar])
    if(is.factor(Scores$key)){
      lvl= levels(Scores$key)
    } else {

      warning("Does not currently support continuous values for coloring")

    }

  }

  #if null give a palette
  if (is.null(col)){

    colfunc <- colorRampPalette(c("black", "light gray"))
    col= colfunc(length(lvl))

  }

  if (is.null(xlim) & is.null(ylim) & is.null(zlim)){
    if(adapt3D){

      xlim= range(Scores$RC1)
      ylim= range(Scores$RC2)
      zlim= range(Scores$RC3)

    } else {

      full_range= range(c(Scores$RC1,
                          Scores$RC2,
                          Scores$RC3))

      xlim= full_range; ylim= full_range; zlim= full_range

    }
  } #only if not provided manually

  for (l in 1:length(lvl)){

    newS= Scores[Scores$key== lvl[l],]

    x= newS$RC1
    y= newS$RC2
    z= newS$RC3

    res=
      plot3D::scatter3D(
        x = x,
        y = y,
        z = z,
        xlim= xlim, ylim= ylim, zlim= zlim,
        pch = pch,
        cex = cex,
        theta = theta,
        phi = phi,
        add = ifelse(l == 1, F, T),
        col = col[l],
        xlab = "RC1",
        ylab = "RC2",
        zlab = "RC3",
        font.lab = 2,
        colkey = F
      )
  }

  #res
  par(mar= old_par)
  #return(res)

}
