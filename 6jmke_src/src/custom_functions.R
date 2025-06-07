# custom-functions: to be used in all scripts for analysis 
# might become personal package (later!)

# Theo Pleizier, 16-12-2020

#libraries used in the functions below

library(Hmisc) # used in function correlation_matrix
library(flextable) #used in function theme_TP_box



#####################################
#  CORRELATION MATRIX
#####################################


################## https://www.r-bloggers.com/2020/07/create-a-publication-ready-correlation-matrix-with-significance-levels-in-r/
#' correlation_matrix
#' Creates a publication-ready / formatted correlation matrix, using `Hmisc::rcorr` in the backend.
#'
#' @param df dataframe; containing numeric and/or logical columns to calculate correlations for
#' @param type character; specifies the type of correlations to compute; gets passed to `Hmisc::rcorr`; options are `"pearson"` or `"spearman"`; defaults to `"pearson"`
#' @param digits integer/double; number of decimals to show in the correlation matrix; gets passed to `formatC`; defaults to `3`
#' @param decimal.mark character; which decimal.mark to use; gets passed to `formatC`; defaults to `.`
#' @param use character; which part of the correlation matrix to display; options are `"all"`, `"upper"`, `"lower"`; defaults to `"all"`
#' @param show_significance boolean; whether to add `*` to represent the significance levels for the correlations; defaults to `TRUE`
#' @param replace_diagonal boolean; whether to replace the correlations on the diagonal; defaults to `FALSE`
#' @param replacement character; what to replace the diagonal and/or upper/lower triangles with; defaults to `""` (empty string)
#'
#' @return a correlation matrix
#' @export
#'
#' @examples
#' `correlation_matrix(iris)`
#' `correlation_matrix(mtcars)`
correlation_matrix <- function(df, 
                               type = "pearson",
                               digits = 3, 
                               decimal.mark = ".",
                               use = "all", 
                               show_significance = TRUE, 
                               replace_diagonal = FALSE, 
                               replacement = "",
                               replacement_diag = "-"){ #added by TP 11-12-2020
  
  # check arguments
  stopifnot({
    is.numeric(digits)
    digits >= 0
    use %in% c("all", "upper", "lower")
    is.logical(replace_diagonal)
    is.logical(show_significance)
    is.character(replacement)
    is.character(replacement_diag)
  })
  # we need the Hmisc package for this
  require(Hmisc)
  
  # retain only numeric and boolean columns
  isNumericOrBoolean = vapply(df, function(x) is.numeric(x) | is.logical(x), logical(1))
  if (sum(!isNumericOrBoolean) > 0) {
    cat('Dropping non-numeric/-boolean column(s):', paste(names(isNumericOrBoolean)[!isNumericOrBoolean], collapse = ', '), '\n\n')
  }
  df = df[isNumericOrBoolean]
  
  # transform input data frame to matrix
  x <- as.matrix(df)
  
  # run correlation analysis using Hmisc package
  correlation_matrix <- Hmisc::rcorr(x, type = )
  R <- correlation_matrix$r # Matrix of correlation coeficients
  p <- correlation_matrix$P # Matrix of p-value 
  
  # transform correlations to specific character format
  Rformatted = formatC(R, format = 'f', digits = digits, decimal.mark = decimal.mark)
  
  # if there are any negative numbers, we want to put a space before the positives to align all
  if (sum(R < 0) > 0) {
    Rformatted = ifelse(R > 0, paste0(' ', Rformatted), Rformatted)
  }
  
  # add significance levels if desired
  if (show_significance) {
    # define notions for significance levels; spacing is important.
    stars <- ifelse(is.na(p), "   ", ifelse(p < .001, "***", ifelse(p < .01, "** ", ifelse(p < .05, "*  ", "   "))))
    Rformatted = paste0(Rformatted, stars)
  }
  # build a new matrix that includes the formatted correlations and their significance stars
  Rnew <- matrix(Rformatted, ncol = ncol(x))
  rownames(Rnew) <- colnames(x)
  colnames(Rnew) <- paste(colnames(x), "", sep =" ")
  
  # replace undesired values
  if (use == 'upper') {
    Rnew[lower.tri(Rnew, diag = replace_diagonal)] <- replacement
  } else if (use == 'lower') {
    Rnew[upper.tri(Rnew, diag = replace_diagonal)] <- replacement
  } else if (replace_diagonal) {
    diag(Rnew) <- replacement
  } 
  if (replacement != replacement_diag & replace_diagonal) {
    diag(Rnew) <- replacement_diag
  }
  
  return(Rnew)
}


#####################################
#  THEME FLEXTABLE
#####################################

theme_TP_box <- function(base_family = "serif", ...){ #https://www.r-bloggers.com/2018/08/exploring-ggplot2-boxplots-defining-limits-and-adjusting-style/
  theme_bw(base_family = base_family, ...) +
    theme(
      panel.grid = element_blank(),
      plot.title = element_text(size = 8),
      axis.ticks.length = unit(-0.05, "in"),
      axis.text.y = element_text(margin=unit(c(0.3,0.3,0.3,0.3), "cm")), 
      axis.text.x = element_text(margin=unit(c(0.3,0.3,0.3,0.3), "cm")),
      axis.ticks.x = element_blank(),
      aspect.ratio = 1
    )
}


#####################################
#  CLEAR ENVIRONMENT
#####################################
# function to clear the environment after running a script while keeping important objects 
# use clear_environment: add store_to_keep variable with list variables;
# tip: include a variable with curr_env

clear_environment <- function(keep, # vector with variable-names to be excluded from cleaning
                              all=ls(envir=pos.to.env(1))){
  rm(list = all[! all %in% keep], 
     envir = pos.to.env(1))
}


#####################################
#  LANGUAGE
#####################################

# use: language("EN")
# tip: available languages are stored in character vector available_languages; current_language contains the abbreviation of the language currently used
# asssumed objects: dataset (dataframe) and cb (codebook dataframe) 


language <- function(lang = "EN") {
  stopifnot({
  exists("dataset")  
  exists("cb")
  })
  # find languages in codebook
  available_languages <<- unique(gsub("_.*","",names(cb)[grepl("^[[:upper:]]{2,}", names(cb))]))
  current_language <<- lang
  # select language in codebook
  if (lang %in% available_languages){
    cb$label <<- cb[[paste0(lang,"_label")]]
    cb$val_label <<- cb[[paste0(lang,"_val_label")]]
    
    # join codebook with dataset 
    for (i in 1:length(names(dataset))){
      v_r <- cb[cb$variable==names(dataset)[i],]   #variables in codebook
      v_l <- v_r$label[1]                          #variable-label
      v_v <- v_r$value                             #variable-values
      names(v_v) <- v_r$val_label                  #named vector values/value-labels
      if(!is.na(v_v[[1]])){
        dataset[[i]] <<- labelled::labelled(dataset[[i]], 
                                            labels = v_v,
                                            label = v_l)
      } else {
        labelled::var_label(dataset[i]) <<- v_l
      }
    }
  }
}


