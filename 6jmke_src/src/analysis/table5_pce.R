# table 5: model question 61-64 on pastoral evaluations 

# Theo Pleizier, PThU, 20 March 2021

# script structure:
# dataset: defines dataset
# translations: provides translations for the tables' columns and footnotes
# tables: produces (flex)table

# required R-packages: here, flextable, labelled, likert

if (!exists("dataset")){library(here); source(here("src/openaccess/initialise_dataset.R"))}

language(current_language) #use this command to select language (see: available_languages)
keep <- ls() #housekeeping

# dataset
# -------

df5 <- subset(dataset, select = c(NL_61:NL_64))

# recoding scale 1-5
df51 <- df5
for (i in 1:4) df51[[i]] <- likert::recode(df5[[i]], from = c(1:5), to = c(5:1))
head(df5); head(df51)

# create table: items, means, sd's and correlation matrix
df510 <- data.frame()
for (i in 1:4){
  df510[nrow(df510)+1,] <- NA
  df510$rowname[i] <- labelled::var_label(df5[[i]], unlist = TRUE)
  df510$M[i] <- round(mean(df51[[i]], na.rm = TRUE),2)
  df510$SD[i] <- round(sd(df51[[i]], na.rm = TRUE), 2)
}

df511 <- correlation_matrix(df = df51,
                            digits = 2, 
                            use = 'lower', 
                            replace_diagonal = TRUE,
                            replacement = "",
                            replacement_diag = "-")

colnames(df511) <- c("1","2","3","4")

df512 <- cbind(df510,df511) 

df5 <- df512[,-7] # remove last (empty) column

# translations
# ------------

translations <- data.frame(language = c("EN", "NL"),
                           rowname1 = c("1. workers have interest in my/our spiritual life(s)", 
                                        "1. vindt plaats vanuit een interesse in mijn/ons geestelijk leven"),
                           rowname2 = c("2. is done in competent and safe atmosphere", 
                                        "2. wordt gedaan in een competente en veilige sfeer"),
                           rowname3 = c("3. is directed towards discipleship", 
                                        "3. is gericht op discipelschap"),
                           rowname4 = c("4. meant for those in crisis / with problems", 
                                        "4. is bedoeld voor hen in crisis / met problemen"),
                           title = c("Pastoral Care:","Pastorale zorg:"),
                           footnote1 = c("Items were recoded into a scale of 1 'strongly disagree' to 5 'strongly agree'",
                                         "Items zijn opnieuw gecodeerd op een schaal van 1 'zeer mee eens' naar 5 'zeer mee oneens'"),
                           footnote2 = c("*** Pearson correlation p < .001","*** Pearson correlatie p < .001"))

lang_nr <- match(current_language, translations$language)

for (i in 1:4) df5$rowname[i] <- translations[[i+1]][lang_nr]

# table 5: correlation table 
# --------------------------
library(flextable)
table5 <- df5 %>%
  flextable() %>%
  fontsize(size=12, part = "all") %>%
  width(j = 1, width = 2) %>%
  align(j = 2:6, align = "center", part = "all") %>% 
  colformat_double(j = 2:3, digits = 2) %>%
  set_header_labels(rowname = translations$title[lang_nr]) %>% 
  footnote(i = 1, j = 1,
           value = as_paragraph(translations$footnote1[lang_nr]),
           ref_symbols = "a",
           part = "header",
           inline = TRUE) %>%
  footnote(i = 2, j = 4,
           value = as_paragraph(translations$footnote2[lang_nr]),
           ref_symbols = "",
           part = "body",
           inline = TRUE) %>%
  font(fontname = "Times", part = "all") %>%
  fontsize(part = "footer", size = 10) #%>% autofit()  #autofit niet nodig vanwege breedte 1e kolom, zie boven width()

table5
#save_as_image(table5, path = "gen/analysis/output/table5_pce.png")

# housekeeping
# ------------
keep <- c(keep,"lang_nr","translations","table5","df5")
clear_environment(keep)
