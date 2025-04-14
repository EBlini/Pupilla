#' Highlights and test the time-course of effects through crossvalidation (uses glmer)
#'
#' Same as 'decode_signal()' except it is powered by
#' 'glmer()' and thus performs generalized LMEMs.
#'
#' @param data A data.frame containing all the necessary variables.
#' @param formula A 'lme4'-style formula, passed as a string.
#' @param dv A string indicating the name of the dependent variable.
#' @param time A string indicating the name of the time variable.
#' @param id A string indicating the name of the id (participant) variable.
#' @param trial A string indicating the name of the trial variable.
#' @param nfolds Number of folds to split trials in. Defaults to 3.
#' @param t_thresh Used to seek consensus: the minimum t-value required to push the
#' time-point forward.
#' @param consensus_thresh The minimum proportion of time-points that must be above
#' 't_thresh' across folds in order to keep the time-point in the consensus.
#' @param ... Further params for 'glmer()', e.g. "family".

#' @return A list including: peaks retained for each (left-out) fold; test of the
#'  retained, cross-validated peaks; test of the consensus time-points, if any; list
#'  of time-points retained in the consensus for each effect.
#'
#' @export

decode_signal_g= function(data, formula,
                        dv, time, id, trial,
                        nfolds= 3,
                        t_thresh= 2,
                        consensus_thresh= 0.75, ...){

  #first change names for your convenience
  DF= data.frame(data)
  DF$dv= DF[,colnames(DF)== dv]
  DF$time= DF[,colnames(DF)== time]
  DF$subject= DF[,colnames(DF)== id]
  DF$trial= DF[,colnames(DF)== trial]

  #then you create folds by simply taking trial by subject order
  DF$interaction= interaction(DF$trial, DF$subject)
  lev= levels(DF$interaction)
  folds= rep(1:nfolds, times= ceiling(length(lev)/nfolds))
  folds= folds[1:length(lev)]
  names(folds)= lev
  ind= folds[DF$interaction]
  names(ind)= NULL
  DF$Fold= ind

  #as formula
  formula= as.formula(formula)

  #split data for every level of time
  if(is.factor(DF$time))(time_lev= levels(factor(DF$time))) else (time_lev= unique(DF$time))
  time_list= lapply(time_lev, function(x){

    ind= DF$time %in% x

    DF[ind,]

  })

  #now create a function that, given data, fits the models for each fold
  fit_folds= function(data2, nfolds){

    data2$pred= NA

    res= vector("list", nfolds)

    for(i in 1:nfolds){

      train= data2[!data2$Fold %in% i,]
      #needless here
      #test= data2[data2$Fold %in% i,]

      #train
      mod= NULL

      mod= tryCatch(lme4::glmer(formula,
                                   train, ...),
                    error= function(dummy)(mod= NULL))


      if(is.null(mod))(res[[i]]= NULL) else (res[[i]]= summary(mod)$coefficients)

    }

    return(res)

  }

  #now fit for every time point and fold
  all_fit= lapply(time_list, function(x)fit_folds(x, nfolds))

  #now assess the time course of all effects for each fold
  effects= rownames(all_fit[[1]][[1]])

  course_eff= vector("list", length(effects))

  for (e in effects){

    course_eff[[e]]=
      lapply(1:nfolds, function(f){

        sapply(all_fit, function(x){x[[f]][e, 4]})

      })

  }

  #for each fold and condition check where t is larger

  full_table= expand.grid("Fold"= 1:nfolds,
                          "Effect"= effects,
                          "Peak_t"= NA,
                          "Peak_obs"= NA,
                          "Peak_time"= NA)

  for (i in 1:nrow(full_table)){

    e= as.character(full_table$Effect[i])
    f= full_table$Fold[i]
    vec= course_eff[[e]][[f]]

    full_table$Peak_t[i]= vec[which.max(abs(vec))]
    full_table$Peak_obs[i]= which.max(abs(vec))
    full_table$Peak_time[i]= time_lev[which.max(abs(vec))]

  }

  #test common peak
  summary_table= expand.grid("Effect"= effects,
                             "Test_t"= NA,
                             "Test_df"= NA,
                             "Test_p"= NA)

  for (e in effects){

    eDF= DF
    st= full_table[full_table$Effect== e,]

    nDF= {}

    for (f in 1:nfolds){

      tp= st$Peak_time[f]

      nDF= rbind(nDF, eDF[eDF$Fold== f & eDF$time== tp,])

    }

    #table(nDF$time, nDF$Fold)

    ind= which(summary_table$Effect== e)

    mod= NULL

    mod= tryCatch(summary(lme4::glmer(formula,
                                         nDF, ...)),
                  error= function(dummy)(mod= NULL))


    if(is.null(mod)){

      summary_table[ind,2:4]= NA

    } else {

      summary_table[ind,2]= mod$coefficients[ind, 4]
      summary_table[ind,3]= mod$coefficients[ind, 3]
      summary_table[ind,4]= mod$coefficients[ind, 5]
    }

  }

  #or maybe you want where there is consensus between folds?

  consensus= vector("list", length(effects))

  for(e in effects){

    l= course_eff[[e]]

    l= lapply(l, function(x)which(abs(x)>t_thresh))

    con= table(unlist(l))/length(l)
    consensus[[e]]= as.numeric(names(con)[con>=consensus_thresh])

  }

  consensus= consensus[names(consensus) != ""]



  #test consensus here
  consensus_table= expand.grid("Effect"= effects,
                               "Test_t"= NA,
                               "Test_df"= NA,
                               "Test_p"= NA)

  for (e in effects){

    eDF= DF
    st= time_lev[consensus[[e]]]

    eDF= eDF[eDF$time %in% st,]

    eDF$interaction= factor(eDF$interaction)
    lvl= levels(eDF$interaction)

    nDF= {}

    #freaking slow...
    for (l in lvl){

      tp= eDF[eDF$interaction== l,]

      tp2= tp[1,]

      tp2$dv= mean(tp$dv)
      nDF= rbind(nDF, tp2)

    }

    #table(nDF$time, nDF$Fold)

    ind= which(summary_table$Effect== e)

    mod= NULL

    mod= tryCatch(summary(lme4::glmer(formula,
                                         nDF, ...)),
                  error= function(dummy)(mod= NULL))


    if(is.null(mod)){

      consensus_table[ind,2:4]= NA

    } else {

      consensus_table[ind,2]= mod$coefficients[ind, 4]
      consensus_table[ind,3]= mod$coefficients[ind, 3]
      consensus_table[ind,4]= mod$coefficients[ind, 5]
    }

  }


  #wrap it up

  res= list("All_Folds"= full_table,
            "Peaks_test"= summary_table,
            "Consensus_test" = consensus_table,
            "Consensus"= consensus)

  return(res)
}
