# Plot a 3D scatterplot (based on plot3D) based on a reduce_rPCA object

This function is under active development. It is meant to depict the
three scores of components obtained by reducing pupillary time-series
through rPCA. There are some strong assumptions, first and foremost that
the object is from rotated PCA, and that it includes variables named
"RC1" - x axis, "RC2" - y axis, and "RC3" - z axis. The function is a
wrapper around 'plot3D::scatter3D' and thus the package is required.

## Usage

``` r
plot_manifold(
  Scores,
  colvar = NULL,
  col = NULL,
  theta = 0,
  phi = 0,
  pch = 16,
  cex = 2,
  adapt3D = F,
  xlim = NULL,
  ylim = NULL,
  zlim = NULL
)
```

## Arguments

- Scores:

  An object as returned by 'reduce_rPCA'.

- adapt3D:

  Whether axis should be "as is", FALSE, or strectched to fit the 3D
  box, TRUE

- colvar;col:

  The name of a variable to use for colors; a char vectors of colors.

- theta;phi:

  The angles of the "eyes" on the plot

- pch;cex:

  Some graphical pars defining shape and size of the points plotted

- xlim;ylim;zlim:

  To manually supply limits

## Value

A 3D plot powered by 'plot3D'.
