# table 1: number of contacts

# Theo Pleizier, 16-12-2020

# topic / research question: who speaks with who?

# init, required scripts, settings for clear environment
if (!exists("dataset")){library(here); source(here("src/data-preparation/initialise_dataset.R"))}

language(current_language) #change language (see: available_languages)
keep <- ls() #housekeeping

# subset and dataframe for table

q56 <- subset(dataset, select = c(AGE, NL_56a:NL_56h))

number <- numeric(8)
type <- character(8)
percentage <-  numeric(8)

for (i in 1:8){ # names(q56)[2:9]
  type[i] <- labelled::var_label(q56[[i+1]])
  number[i] <- table(q56[[i+1]])[2] 
  percentage[i] <- round(prop.table(table(q56[[i+1]]))[2]*100,1)
}

df1 <- data.frame(type = type,
                     number = number, 
                     percentage = percentage) #nog sorteren: oplopende op percentage; met 2x Nee onderaan

# match translation

translations <- data.frame(language = c("EN", "NL"),
                           type = c("Yes, I met with","Ja, ik heb gesproken met"),
                           number = c("times selected","aantal keer geselecteerd"),
                           percentage = c("by ...% respondents","door ...% respondenten"),
                           footnote = c("Have you received pastoral care and support in your church in the last 2 years?",
                                        "Heeft u in de afgelopen 2 jaar pastorale zorg en ondersteuning ontvangen in uw kerk?"))

lang_nr <- match(current_language, translations$language)

# table

library(flextable)
table1 <- df1 %>% 
  flextable() %>% 
  set_header_labels(type = translations$type[lang_nr],
                    number = translations$number[lang_nr],
                    percentage = translations$percentage[lang_nr]) %>% 
  footnote(i=1, j=1,
           value = as_paragraph(c(translations$footnote[lang_nr])),
           ref_symbols = c("a"),
           part = "header") %>% 
  font(fontname = "Times", part = "all") %>%
  autofit() 

table1
#save_as_image(table1, path = "gen/analysis/output/table1_q56.png")


# housekeeping
keep <- c(keep,"lang_nr","translations","table1","df1")
clear_environment(keep)
