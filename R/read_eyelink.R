read_el= function(ID,
                  keep_events= NULL,
                   path= getwd(),
                  sep= "\\",
                   start_behavior= "subject-",
                   start_eyelink= "sub_",
                   separate_behavioral= TRUE,
                  import_all= T){

  if(is.null(keep_events))(warning("You need to specify the event messages to keep"))

  #get likely adresses
  el= paste0(path, sep, start_eyelink, ID, ".edf")


  #read
  eDF= eyelinkReader::read_edf(el, import_samples = T)

  eDFs= eDF$samples

  eDFs$p_ID= ID

  #fill messages
  eDF$events$message= ifelse(eDF$events$message== "", NA,
                             eDF$events$message)

  eDF$events= tidyr::fill(eDF$events,
                          message, .direction = "down")

  eDF$events= eDF$events[eDF$events$type== "MESSAGEEVENT",]


  #connect events in the samples df
  eDFs$Event= NA
  for (i in 1:nrow(eDF$events)){

    trial= eDF$events[i, "trial"]
    from= eDF$events[i, "sttime"]
    msg= eDF$events[i, "message"]

    eDFs$Event[eDFs$trial== trial & eDFs$time>= from]= msg

  }

  #import all
  if(import_all){

    #import blinks (not necessary but...)
    eDFs$is_Blink= 0
    for (i in 1:nrow(eDF$blinks)){

      trial= eDF$blinks[i, "trial"]
      from= eDF$blinks[i, "sttime_rel"]
      to= eDF$blinks[i, "entime_rel"]

      eDFs$is_Blink[eDFs$trial== trial & eDFs$time_rel>= from & eDFs$time_rel<= to] = 1

    }

    #import fixations
    eDFs$is_Fixation= 0
    for (i in 1:nrow(eDF$fixations)){

      trial= eDF$fixations[i, "trial"]
      from= eDF$fixations[i, "sttime_rel"]
      to= eDF$fixations[i, "entime_rel"]

      eDFs$is_Fixation[eDFs$trial== trial & eDFs$time_rel> from & eDFs$time_rel< to] = 1

    }

  } #end import_all


  #omit calibration etc
  eDFs= eDFs[!is.na(eDFs$Event),]

  #only keep relevant events
  eDFs= eDFs[eDFs$Event %in% keep_events,]


  res= list(ET= data.frame(eDFs))


  #behavioral data, if required
  if(separate_behavioral) {

    behav= paste0(path, "\\",  start_behavior, ID, ".csv")

    BD= data.table::fread(behav)

    BD$p_ID= ID

    res[["BD"]]= data.frame(BD)

  }



  return(res)

}


#' Reads and imports eyelink eye-tracking and behavioral data
#'
#' These two type of data are usually separate and sometimes must be merged
#' to create one single file with both eyetracking and experimental details
#' (e.g., conditions), unless you have specified this via code in the experiment builder.
#' This function is written with OpenSesame-like csv files in mind, though compatibility
#' with other programs (e.g., e-prime) may be achieved provided that files are converted to
#' the csv format. This is optimized for Windows machines - you may encounter
#' address errors in Macs.
#'
#' This function is a wrapper around 'eyelinkReader::read_edf()'
#' which must be installed. In order to use this package,
#' eyelink proprietary code must be installed as well
#' (the relevant scripts are available in the eyelink forum)
#'
#' @param ID An integer corresponding to one participant's ID. This is attached
#' to the current path in order to locate the two files to read.
#' Also, One variable named p_ID is attached to both ET and BD files.
#' If a vector is supplied, files are read with `lapply` and then merged.
#' @param keep_events A character vector specifying the events
#' that should be kept. This is an hard assumption that
#' experimental phases are recorded as messages in the events$messages
#' slot returned by 'eyelinkReader::read_edf()'.
#' @param path Defaults to `getwd()` but can be specified to be otherwise.
#' Files will be searched for starting from this location.
#' @param sep Defaults to "\\" windows but can be changeg for
#' other systems.
#' @param start_behavior A string, it defaults to `"subject-"`. Usually
#' all files start with this string, regardless of their nature. Usually
#' names are built by concatenating `path`, `start_filename`,
#' `ID`, `.csv`.
#' @param start_eyelink A string, it defaults to `"subject-"`. Usually
#' all files start with this string, regardless of their nature. Usually
#' names are built by concatenating `path`, `start_eyelink`,
#' `ID`, `.edf`.
#' @param separate_behavioral defaults to `TRUE`. If `FALSE`, it only reads
#' eye-tracking data
#' @param import_all If TRUE (the default) import the
#' blink and fixation data as computed by the eyelink.
#'
#' @return A list of one or two DFs, one for eye-tracking data, one for behavioral data (if requested).
#'
#' @export

read_eyelink= function(ID,
                       keep_events= NULL,
                       path= getwd(),
                       sep= "\\",
                       start_behavior= "subject-",
                       start_eyelink= "sub_",
                       separate_behavioral= TRUE,
                       import_all= T){


  #call main function
  data= lapply(ID, function(x)read_el(x,
                                      keep_events = keep_events,
                                      path = path,
                                      sep= sep,
                                      start_behavior = start_behavior,
                                      start_eyelink = start_eyelink,
                                      separate_behavioral = separate_behavioral,
                                      import_all= import_all))

  #pick
  ET= lapply(data, function(x)x$ET)

  #merge
  ET= do.call(rbind, ET)

  #attach to result
  res= list(ET= ET)

  if(separate_behavioral) {

    #pick
    BD= lapply(data, function(x)x$BD)

    #same column names
    BD= lapply(BD, function(x){

      colnames(x)<-colnames(BD[[1]])
      return(x)

    })

    #merge
    BD= do.call(rbind, BD)

    #attach
    res[["BD"]]= BD

  }

  #return
  return(res)

}

