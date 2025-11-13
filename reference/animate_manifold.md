# Animate a 3D scatterplot (based on plot3D) through gifski

This function executes plot_manifold, from which it inherits parameters,
iteratively, saves each frame in a folder in the current path, and then
creates a gif with the package gifski, which must be installed.

## Usage

``` r
animate_manifold(
  Scores,
  colvar = NULL,
  col = NULL,
  gifname = "gif.gif",
  thetas = seq(0, 359, 1),
  phis = rep(10, 360),
  pch = 16,
  cex = 2,
  xlim = NULL,
  ylim = NULL,
  zlim = NULL,
  adapt3D = F,
  width = 700,
  height = 700,
  delay = 75/1000
)
```

## Arguments

- Scores:

  An object as returned by 'reduce_rPCA'.

- gifname:

  Name of the gif file saved in the current path

- adapt3D:

  Whether axis should be "as is", FALSE, or strectched to fit the 3D
  box, TRUE

- delay:

  Speed of the transitions in seconds

- colvar;col:

  The name of a variable to use for colors; a char vectors of colors.

- thetas;phis:

  The angles of the "eyes" on the plot given as vectors of angles that
  will form the gif. Vectors must have the same length

- pch;cex:

  Some graphical pars defining shape and size of the points plotted

- xlim;ylim;zlim:

  To manually supply limits

- width;height:

  Dimensions of the images and thus of the gif

## Value

A gif is saved in the current path; side effect: all frames are saved in
a folder in the path.
