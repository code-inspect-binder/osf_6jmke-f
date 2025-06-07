# all tables and plots
library(report)
library(here)
source(here("src/data-preparation/initialise_dataset.R"))

language("EN")

image_files <- T
bg_trans <- F

source(here("src/analysis/table1_q56.R")) # table 1 question 56
table1
if(!bg_trans){table1 <- bg(table1, bg = "white", part = "all")  }
if(image_files) save_as_image(table1, path = here("gen/openaccess/table1_q56.png")) 

source(here("src/analysis/table2-3_q58.R")) # table 2 en 3 question 58
table2
table3
if(!bg_trans){
  table2 <- bg(table2, bg = "white", part = "all")  
  table3 <- bg(table3, bg = "white", part = "all")
}

if(image_files) save_as_image(table2, path = here("gen/openaccess/table2_q58.png"))
if(image_files) save_as_image(table3, path = here("gen/openaccess/table3_q58.png"))

source(here("src/analysis/table4_q59.R")) # table 4 question 59
table4
if(!bg_trans){table4 <- bg(table4, bg = "white", part = "all")  }
if(image_files) save_as_image(table4, path = here("gen/openaccess/table4_q59.png"))

source(here("src/analysis/table5_pce.R")) # table 5 questions 61-64
table5
if(!bg_trans){table5 <- bg(table5, bg = "white", part = "all")  }
if(image_files) save_as_image(table5, path = here("gen/openaccess/table5_pce.png"))

source(here("src/analysis/plot1_pce-churches.R")) # Figure 1 model Evaluation
plot1 

if(image_files){
  if(bg_trans){
    plot1 <- plot1 +
      theme(
        panel.background = element_rect(fill='transparent'),
        plot.background = element_rect(fill='transparent', color=NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.background = element_rect(fill='transparent'),
        legend.box.background = element_rect(fill='transparent')
      )    
  }
  ggsave(filename = "plot1.png", 
         plot = plot1, 
         dpi = "print", scale = 1, width = 15, height = 15, units = "cm",
         path = here("gen/openaccess/"),
         bg = "transparent")
}

source(here("src/analysis/plot2_apc.R")) # Figure 2 model Experience
plot2

if(image_files){
  if(bg_trans){
    plot2 <- plot2 +
      theme(
        panel.background = element_rect(fill='transparent'),
        plot.background = element_rect(fill='transparent', color=NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.background = element_rect(fill='transparent'),
        legend.box.background = element_rect(fill='transparent')
      )    
  }
  ggsave(filename = "plot2.png", 
         plot = plot2, 
         dpi = "print", scale = 1, width = 15, height = 15, units = "cm",
         path = here("gen/openaccess/"),
         bg = "transparent")
  
}


cite_packages()

