# Plot Actual Pastoral Care Experience

# Theo Pleizier, PThU, 23 March 2021

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

df.plot2 <- subset(dataset, select = c(NL_56a:NL_56h, NL_58, NL_61:NL_63))

# evaluations pastoral care 
for (i in 10:12) df.plot2[[i]] <- likert::recode(df.plot2[[i]], from = c(1:5), to = c(5:1))
df.plot2$pceval <- rowMeans(df.plot2[,10:12], na.rm =TRUE)

# actual contacts pastoral care
df.plot2$inside <-rowSums(df.plot2[,1:3]) # minister/pastoral; elder/staff; volunteer
contacts <- df.plot2$inside
visits <- df.plot2$NL_58
df.plot2$apc <- ifelse((contacts == 0 & visits == 2), 1, 
                      ifelse((contacts > 0 & visits == 1), 3, 2)) # contacts > 1?

# translations
# ------------
translations <- data.frame(language = c("EN", "NL"),
                           xas = c("Pastoral Care Experiences (past 2 years)",
                                   "Ervaringen met pastorale zorg (afgelopen 2 jaar)"),
                           yas = c("Mean of the Evaluation of Pastoral Care",
                                   "Gemiddelden van evaluaties pastorale zorg"))

translations$apcmodel <- list(c("None", "Some", "Various"), 
                              c("Geen", "Enige", "Meerdere"))

lang_nr <- match(current_language, translations$language)

df.plot2$apc <- factor(df.plot2$apc, labels = translations$apcmodel[[lang_nr]])



# plot: actual contacts versus evaluations
# ------------

plot2 <- df.plot2[!is.na(df.plot2$apc),] %>% 
  ggplot(df.plot2,
         mapping = aes (x = apc, y = pceval)) + 
  geom_boxplot(outlier.size = 0.5) +
  theme_TP_box() + 
  theme(legend.position="top",
        legend.box = NULL) + 
  labs(x = translations$xas[lang_nr],
       y = translations$yas[lang_nr])

plot2
#ggsave(plot = plot2, path = "gen/analysis/output/", filename = "plot2_apc.png")

# housekeeping
# ------------
keep <- c(keep,"lang_nr","translations","plot2", "df.plot2")
clear_environment(keep)