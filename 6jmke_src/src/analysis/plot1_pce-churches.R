# plot 1: model pastoral evaluations and churches

# Theo Pleizier, PThU, 23 March 2021

# script structure:
# dataset: defines dataset
# translations: provides translations for the tables' columns and footnotes
# tables: produces (flex)table

# required R-packages: here, flextable, labelled, likert

if (!exists("dataset")){library(here); source(here("src/data-preparation/initialise_dataset.R"))}


language(current_language) #use this command to select language (see: available_languages)
keep <- ls() #housekeeping

# dataset
# -------
df.plot1 <- subset(dataset, select = c(UNIQUECHURCHID, NL_61:NL_63))

for (i in 2:4) df.plot1[[i]] <- likert::recode(df.plot1[[i]], from = c(1:5), to = c(5:1))

df.plot1$pceval <- rowMeans(df.plot1[,2:4], na.rm =TRUE)

# translations
# ------------

translations <- data.frame(language = c("EN", "NL"),
                           xas = c("Churches that the respondents belonged to", 
                                   "Kerken waartoe de respondenten behoorden"),
                           yas = c("Mean of Pastoral Evaluation Construct", 
                                   "Gemiddelde van het construct 'Evaluatie pastoraat'"))

lang_nr <- match(current_language, translations$language)

# table / plot 
# ------------

plot1 <- ggplot(df.plot1, 
                mapping = aes (x = reorder(UNIQUECHURCHID, pceval, na.rm = TRUE, .desc = TRUE),
                               y = pceval)) +
  labs(x = translations$xas[lang_nr],
       y = translations$yas[lang_nr]) + 
  geom_boxplot(outlier.size = 0.5, ) +
  stat_summary(fun="mean", geom="point", shape=1) +
  coord_flip() +
  theme_TP_box()

plot1
#ggsave(plot = plot1, path = "gen/analysis/output/", filename = "plot1_pce.png")




# housekeeping
# ------------
keep <- c(keep,"lang_nr","translations", "plot1", "df.plot1")
clear_environment(keep)
