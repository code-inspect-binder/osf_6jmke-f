# Script NCLS-pilot, produces table 2 and table 3, question 58: approached for pastoral care  (baseR)

# Theo Pleizier, 18-3-2021

# research question: who is approached for pastoral care?

# table 2: age / marital status / work situation and approached for pastoral visit (frequencies)
# table 3: 

# script structure:
# dataset: defines two datasets (df2 and df3), one for each table
# translations: provides translations for the tables' columns and footnotes
# tables: produces (flex)tables, table2 and table3


if (!exists("dataset")){library(here); source(here("src/openaccess/initialise_dataset.R"))}

language(current_language) #use this command to select language (see: available_languages)
keep <- ls()

# dataset
# -------

dataset <- dataset[!is.na(dataset$NL_58),]
index <- dataset$NL_58 == 1 # approached for visit 'yes'

# define table2: age, marital, work and approached for pastoral visit (df2)

age_total <- as.integer(table(dataset$AGE10))
age_sum <- tapply(index,dataset$AGE10,sum, na.rm=TRUE)
age.df <- data.frame(age = names(attr(dataset$AGE10, "labels"))[-1],
                     n.age = age_sum,
                     perc.age = round(age_sum/age_total*100,1))

marital_total <- as.integer(table(dataset$NL_12))
marital_sum <- tapply(index,dataset$NL_12,sum, na.rm=TRUE)
marital.df <- data.frame(marital = names(attr(dataset$NL_12, "labels"))[-1],
                         n.marital = marital_sum,
                         perc.marital = round(marital_sum/marital_total*100,1))

work <- subset(dataset, select = c(NL_14a:NL_14h))
wtype = character(8); wnumber = integer(8); wpercentage = numeric(8)
for (i in 1:8){ 
  wtype[i] <- labelled::var_label(work[[i]])
  wnumber[i] <- tapply(index,work[[i]],sum, na.rm=TRUE)[2]
  wpercentage[i] <- round(wnumber[i]/table(work[[i]])[2]*100,1)
}
work.df <- data.frame(work = wtype,
                      n.work = wnumber,
                      perc.work = wpercentage)

# add empty rows (work and marital) and combine dfs into df2 for table2
marital.df[nrow(marital.df)+1,] <- NA
work.df[nrow(work.df)+1,] <- NA
df2 <- cbind(age.df,marital.df,work.df); rm(age.df,marital.df,work.df)

# define table 3: attendance length / sense of belonging (df3)

attendance_total <- as.integer(table(dataset$NL_02))
attendance_sum <- tapply(index,dataset$NL_02,sum, na.rm=TRUE)
attendance.df <- data.frame(attendance = names(attr(dataset$NL_02, "labels"))[-1],
                            n.attendance = attendance_sum,
                            perc.attendance = round(attendance_sum/attendance_total*100,1))

belonging_total <- as.integer(table(dataset$NL_05))
belonging_sum <- tapply(index,dataset$NL_05,sum, na.rm=TRUE)
belonging.df <- data.frame(belonging = names(attr(dataset$NL_05, "labels"))[-1],
                           n.belonging = belonging_sum,
                           perc.belonging = round(belonging_sum/belonging_total*100,1))

belonging.df[nrow(belonging.df)+1,] <- NA
df3 <- cbind(attendance.df,belonging.df)

# translations
# ------------

translations <- data.frame(language = c("EN", "NL"),
                           age = c("Age", "Leeftijd"),
                           marital = c("Marital situation", "Burgerlijke staat"),
                           work = c("Work situation", "Werk situatie"),
                           attendance = c("Attendance","Kerkgang"),
                           belonging = c("Sense of belonging", "Gevoel erbij te horen"))

lang_nr <- match(current_language, translations$language)


# tables 
# ------

library(flextable)

table2 <- df2 %>% 
  flextable() %>%
  font(fontname = "Times", part = "all") %>%
  colformat_int(j = c("n.marital", "n.work"),
                na_str = "") %>%
  colformat_double(j = c("perc.age","perc.marital", "perc.work"),
                   digits = 1,
                   na_str = "") %>%
  vline(j = c(3,6), part = "body", border = officer::fp_border() ) %>%
  align(j = c(2:3,5:6,8:9), align = "right", part = "all") %>% # alignment of numeric columns 2:7
  set_header_labels(age = translations$age[lang_nr],
                    n.age = "n",
                    perc.age = "%",
                    marital = translations$marital[lang_nr],
                    n.marital = "n",
                    perc.marital = "%",
                    work = translations$work[lang_nr],
                    n.work = "n",
                    perc.work = "%") %>% 
  italic(j=c(2,5,8), part = "header") %>% 
  autofit()

table2

table3 <- df3 %>% 
  flextable() %>%
  colformat_int(j = c("n.belonging"),
                na_str = "") %>%
  colformat_double(j = c("perc.attendance","perc.belonging"),
                   digits = 1,
                   na_str = "") %>%
  vline(j = c(3), part = "body", border = officer::fp_border() ) %>%
  align(j = c(2:3,5:6), align = "right", part = "all") %>% # alignment of numeric columns 2:7
  set_header_labels(attendance = translations$attendance[lang_nr],
                    n.attendance = "n",
                    perc.attendance = "%",
                    belonging = translations$belonging[lang_nr],
                    n.belonging = "n",
                    perc.belonging = "%") %>% 
  font(fontname = "Times", part = "all") %>%
  italic(j=c(2, 5), part = "header") %>% 
  autofit() 

table3 
#save_as_image(table3, path = "gen/analysis/output/table3_q58.png")

keep <- c(keep,"df2","table2","df3","table3","lang_nr","translations")
clear_environment(keep)



