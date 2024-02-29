#' Reduce time-series to few (rotated) Principal Components
#'
#' This function is under active development. It is meant to
#' reduce the entire time-series of normalized and baseline-corrected
#' pupillary data in just a few scores obtained by rotated Principal
#' Component Analysis. PCA is an effective way to reduce data dimensionality
#' as to have more manageable dependent variables, which may additionally
#' help having more precise estimates (or fingerprints) of pupil signal
#' and the underlying cognitive processes. Rotation in the oblique
#' sense does not force PCs to be orthogonal and may help the interpretation
#' of the resulting loadings. This function uses 'psych::principal()'
#' and as such may differ in how standardization is performed.
#'
#' @param data A data.frame containing all the necessary variables.
#' @param dv A string indicating the name of the dependent variable.
#' @param time A string indicating the name of the time variable.
#' @param id A string indicating the name of the id (participant) variable.
#' @param trial A string indicating the name of the trial variable.
#' @param Ncomp Number of components to retain. The default (NULL) automatically
#' retains 95% of the explained variance. Note that is, however,
#' based on unrotated PCA, and rotated variables generally explain
#' less variance. If Ncomp== "all" returns all
#' the components. If Ncomp <1 this is interpreted as if the user wishes to retain
#' a given proportion of variance (e.g. 0.6), but again the unrotated
#' PCA is used to find the number of components.
#' @param center Whether variables, i.e. pupil size for each timepoint,
#' should be scaled beforehand. Defaults to FALSE assuming that measures
#' are already normalized (with z-scores) and baseline-corrected.
#' Note that this only impacts summaryPCA and the number of components
#' retained because psych uses the covariance matrix.
#' @param scale Whether variables, i.e. pupil size for each timepoint,
#' should be scaled beforehand. Defaults to FALSE assuming that measures
#' are already normalized (with z-scores) and baseline-corrected.
#' Note that this only impacts summaryPCA and the number of components
#' retained because psych uses the covariance matrix.
#' @param rotate Defaults to "promax" for oblique rotation. Could
#' be set to "none" to have PCA in the style of the 'psych' package.
#' Accepts what is accepted by 'psych::principal()'.
#' @param add String(s) indicating which variables names, if any, should
#' be appendend to the scores dataframe.
#' @return A list including the processed data, the scores and loadings dataframes,
#' and the PCA object useful for prediction of new data.
#'
#' @export

reduce_rPCA= function(data,
                     dv,
                     time,
                     id,
                     trial,
                     Ncomp= NULL,
                     center= FALSE,
                     scale= FALSE,
                     rotate= "promax",
                     add){

  #first change names for your convenience; it's easier this way
  DF= data.frame(data)
  DF$dv= DF[,colnames(DF)== dv]
  DF$time= DF[,colnames(DF)== time]
  DF$subject= DF[,colnames(DF)== id]
  DF$trial= DF[,colnames(DF)== trial]

  #these will be the rows
  DF$interaction= interaction(DF$trial, DF$subject)

  #set unique levels
  order= unique(DF$time)
  # empty= rep(NA, length(order))
  # names(empty)= order
  #
  #get pupil as a vector

  rsmat= lapply(levels(DF$interaction), function(x){

    #extract time series
    vec_pupil= DF$dv[DF$interaction== x]

    if(length(vec_pupil)!= length(order))(vec_pupil= rep(NA, length(order)))

    return(vec_pupil)

  })


  #merge in columns
  rsmat2= do.call(cbind, rsmat)

  #check NAs here and warn
  if(sum(is.na(rsmat2))>0){

    warning("NAs in the data will be discarded:
            check the data!")

  }

  #discard
  ind= apply(rsmat2, 2, function(x)sum(is.na(x))==0)

  orig= levels(DF$interaction)[ind]

  rsmat3= rsmat2[,ind]

  rs_mat= t(rsmat3)

  #return scaling info just in case
  col_means= apply(rs_mat, 2, mean)
  col_sd= apply(rs_mat, 2, sd)

  #now scale
  rs_mat= scale(rs_mat, center = center, scale= scale)


  #run PCA - preliminary
  PCA= prcomp(rs_mat, scale= F, center= F)

  #summary
  summaryPCA= summary(PCA)$importance

  #how many comps for 95% variance
  Ncomp95= as.numeric(which(summaryPCA[3,]>0.95)[1])

  #Ncomp changes accordingly
  if(is.null(Ncomp)){

    Ncomp= Ncomp95

  }

  if(Ncomp== "all"){

    Ncomp= length(summaryPCA[3,])

  }

  if (Ncomp<1){

    Ncomp= as.numeric(which(summaryPCA[3,]>Ncomp)[1])

  }

  if (Ncomp>length(summaryPCA[3,])){

    warning("You asked for too many components!")

  }

  #summaryPCA[,1:3]

  rPCA= psych::principal(rs_mat,
                         nfactors = Ncomp,
                         rotate = rotate)

  summaryRPCA= rPCA$Vaccounted

  Loadings= rPCA$loadings[,1:Ncomp]

  rownames(Loadings)= order

  Scores= rPCA$scores

  #now append relevant information
  Scores= data.frame(Scores)
  Scores$id= NA
  Scores$trial= NA

  for(i in 1:nrow(Scores)){

    sel= orig[i]

    Scores$id[i]= DF$subject[DF$interaction== sel][1]
    Scores$trial[i]= DF$trial[DF$interaction== sel][1]

  }


  if(!is.null(add)){

    for (a in add){

      Scores$add= NA

      for(i in 1:nrow(Scores)){

        sel= orig[i]

        Scores$add[i]= DF[DF$interaction== sel, a][1]

      }

      colnames(Scores)[colnames(Scores)=="add"]= a

    }
  }


  res= list(rs_mat= rs_mat,
            summaryPCA= summaryPCA,
            summaryRPCA= summaryRPCA,
            Loadings= Loadings,
            Scores= Scores,
            rPCA= rPCA,
            scaling= list(is_centered= center,
                          is_scaled= scale,
                          M= col_means,
                          SD= col_sd))


  return(res)


}
