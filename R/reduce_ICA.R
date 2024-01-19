#' Reduce time-series to few Independent Components
#'
#' This function is under active development. It is meant to
#' reduce the entire time-series of normalized and baseline-corrected
#' pupillary data in just a few scores obtained by Independent
#' Component Analysis. ICA is an effective way to reduce data dimensionality
#' as to have more manageable dependent variables, which may additionally
#' help having more precise estimates (or fingerprints) of pupil signal
#' and the underlying cognitive processes. The functions
#' use 'ica::icafast'.
#'
#' @param data A data.frame containing all the necessary variables.
#' @param dv A string indicating the name of the dependent variable.
#' @param time A string indicating the name of the time variable.
#' @param id A string indicating the name of the id (participant) variable.
#' @param trial A string indicating the name of the trial variable.
#' @param Ncomp Number of components to retain. The default (NULL) automatically
#' retains 95% of the explained variance. If Ncomp== "all" returns all
#' the components. If Ncomp <1 this is interpreted as if the user wishes to retain
#' a given proportion of variance (e.g. 0.6).
#' @param scaling Whether variables, i.e. pupil size for each timepoint,
#' should be scaled beforehand. Defaults to FALSE assuming that measures
#' are already normalized (with z-scores) and baseline-corrected.
#' @param add String(s) indicating which variables names, if any, should
#' be appendend to the scores dataframe.
#' @return A list including the processed data, the scores and loadings dataframes,
#' and the ICA object useful for prediction of new data.
#'
#' @export

reduce_ICA= function(data,
                     dv,
                     time,
                     id,
                     trial,
                     Ncomp= NULL,
                     scaling= FALSE,
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

    warning("NAs is the data will be discarded:
            check the data (unequal timepoints maybe?)!")

  }

  #discard
  ind= apply(rsmat2, 2, function(x)sum(is.na(x))==0)

  orig= levels(DF$interaction)[ind]

  rsmat3= rsmat2[,ind]

  rs_mat= t(rsmat3)

  #return scaling info just in case
  col_means= apply(rs_mat, 2, mean)
  col_sd= apply(rs_mat, 2, sd)

  #run PCA
  PCA= prcomp(rs_mat, scale= scaling, center= scaling)

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

  #now ICA
  ICA= ica::icafast(rs_mat, nc=Ncomp,
                    center= scaling)

  Loadings= ICA$M[,1:Ncomp]

  rownames(Loadings)= order

  Scores= ICA$S

  colnames(Loadings)= paste0("IC", 1:Ncomp)
  colnames(Scores)= paste0("IC", 1:Ncomp)

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
            Loadings= Loadings,
            Scores= Scores,
            ICA= ICA,
            scaling= list(M= col_means, SD= col_sd))


  return(res)


}
