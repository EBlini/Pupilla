read_one= function(ID,
                   path= getwd(),
                   start_filename= "subject-",
                   append_TOBII= "_TOBII_output.tsv",
                   skip= 7,
                   separate_behavioral= TRUE){

  #get likely adresses
  tobii= paste0(path, "\\", start_filename, ID, append_TOBII)

  #read
  ET= data.table::fread(here::here(tobii),
                        header = T,
                        sep = "\t",
                        skip = skip,
                        fill= T)

  ET$p_ID= ID

  res= list(ET= data.frame(ET))

  #behavioral data, if required
  if(separate_behavioral) {

    behav= paste0(path, "\\",  start_filename, ID, ".csv")

    BD= data.table::fread(behav)

    BD$p_ID= ID

    res[["BD"]]= data.frame(BD)

  }

  return(res)

}


#' Reads and imports TOBII eye-tracking and behavioral data
#'
#' These two type of data are usually separate and sometimes must be merged
#' to create one single file with both eyetracking and experimental details
#' (e.g., conditions), unless you have specified this via code in the experiment builder.
#' This function is written with OpenSesame-like csv files in mind, though compatibility
#' with other programs (e.g., e-prime) may be achieved provided that files are converted to
#' the csv format. This is optimized for Windows machines - you may encounter
#' address errors in Macs.
#'
#' @param ID An integer corresponding to one participant's ID. This is attached
#' to the current path in order to locate the two files to read.
#' Also, One variable named p_ID is attached to both ET and BD files.
#' If a vector is supplied, files are read with `lapply` and then merged.
#' @param path Defaults to `getwd()` but can be specified to be otherwise.
#' Files will be searched for starting from this location.
#' @param start_filename A string, it defaults to `"subject-"`. Usually
#' all files start with this string, regardless of their nature. Usually
#' names are built by concatenating `path`, `start_filename`,
#' `ID`, and `append_TOBII` (for eye-tracking data, else ".csv").
#' @param append_TOBII A string, it defaults to `"_TOBII_output.tsv"` and
#' indicates the text that tells eye-tracking from behavioral files apart. Usually
#' names are built by concatenating `path`, `start_filename`,
#' `ID`, and `append_TOBII` (for eye-tracking data, else ".csv").
#' @param skip Integer. The amount of lines to skip from the eye-tracking file,
#' i.e. after how many lines the header is encountered.
#' This is passed to `data.table::fread()`.
#' @param separate_behavioral defaults to `TRUE`. If `FALSE`, it only reads
#' eye-tracking data
#'
#' @return A list of one or two DFs, one for eye-tracking data, one for behavioral data (if requested).
#'
#' @export

read_TOBII= function(ID,
                     path= getwd(),
                     start_filename= "subject-",
                     append_TOBII= "_TOBII_output.tsv",
                     skip= 7,
                     separate_behavioral= TRUE){


  #call main function
  data= lapply(ID, function(x)read_one(x,
                                       path= path,
                                       start_filename= start_filename,
                                       append_TOBII= append_TOBII,
                                       skip= skip,
                                       separate_behavioral= separate_behavioral))

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

