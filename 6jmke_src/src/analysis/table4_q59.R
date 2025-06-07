# table 4: question 59, what topics for pastoral care do respondents indicate?

# Theo Pleizier, PThU, 19 March 2021

# script structure:
# dataset: defines dataset
# translations: provides translations for the tables' columns and footnotes
# tables: produces (flex)table

# required R-packages: here, flextable, labelled

if (!exists("dataset")){library(here); source(here("src/data-preparation/initialise_dataset.R"))}

language(current_language) #use this command to select language (see: available_languages)
keep <- ls() #housekeeping

# dataset
# -------

df4 <- subset(dataset, select = NL_59a:NL_59i)

number <- integer(9); type <- character(9)
for (i in 1:9){ 
  type[i] <- labelled::var_label(df4[[i]])
  number[i] <- as.integer(table(df4[[i]])[2])
}
df4 <- data.frame(type = type, number = number)

df4 <- df4[order(-df4$number),]

# translations
# ------------

translations <- data.frame(language = c("EN", "NL"),
                           topic = c("Topic","Onderwerp"),
                           number_marked= c("Number of times marked", "Aantal keer geselecteerd"),
                           fn_question = c("The exact question was: 'This church should give more pastoral attention in person to ... (mark up to two options)' ",
                                           "The precieze vraag was: 'Deze gemeente moet meer persoonlijke pastorale aandacht geven aan... (kruis max. twee hokjes aan)' "),
                           type9 = c("Those who need to be called to account for their behaviour",
                                     "Hen die op hun gedrag gewezen moeten worden"))

lang_nr <- match(current_language, translations$language)

df4$type[9] <- translations$type9[lang_nr]


# table
# -----
library(flextable)
table4 <- df4 %>% 
  flextable() %>% 
  set_header_labels(type = translations$topic[lang_nr],
                    number = translations$number_marked[lang_nr]) %>% 
  autofit() %>% 
  footnote(i=1,j=1,
           value = as_paragraph(c(translations$fn_question[lang_nr])),
           ref_symbols = c("a"),
           part = "header") %>% 
  font(fontname = "Times", part = "all")

table4
#save_as_image(table4, path = "gen/analysis/output/table4_q59.png")

# housekeeping
keep <- c(keep,"lang_nr","translations","table4","df4")
clear_environment(keep)