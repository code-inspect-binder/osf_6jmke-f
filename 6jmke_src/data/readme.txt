==========================================================
          D A T A S E T   D E S C R I P T I O N
==========================================================

Name of the dataset: ncls_pilot_2019_EN

The dataset is available in three formats:

CSV: comma separated values (plain text)
SAV: SPSS 
RDS: R data-structure

The dataset is accompanied by a codebook in CSV-format.

NOTE: the dataset is located on the ownCloud server. 

----------------------------------------------------------

1. Motivation of data collection 

The data was collected to pursue a pilot to test a Dutch version of CLS (Church Life Survey), including a module of newly constructed questions on Pastoral Care practices in local churches. These questions were developed by Theo Pleizier (PThU). Coordinator of the Dutch implementation of CLS is Marten van der Meulen (PThU). 

The aim of the pilot was to test whether CLS would be useful for Dutch churches. The pilot resulted in "Nieuw Kerkelijk Peil" (https://www.pthu.nl/ccc/NL-CLS/). 


2. Composition of dataset 

The dataset is a subset of the complete dataset that was generated for the Dutch version of CLS. It contains the variables that were used to perform analyses on the topic of Pastoral Care. See below: Uses. 

The file with the codebook (codebook_ncls_pilot_2019.csv) contains the list of variables, their position (column number) in the dataset, and two language versions of the variable labels (and if availabe: value-labels), both in English and in Dutch. 

There are two identifiers in the data: 
- an unique UserID for each respondent and 
- a ChurchID for the church that the respondent attends. 

Both identifiers are anonimized; the research team has a non-public list with keys to identify the churches. 

3. Collection process 

The collection of the data is described in the methodology section of the paper. 

4. Preprocessing/cleaning/labeling 

The dataset was created as SPSS dataset and includes variable labels and value-labels. For portability reasons the labels are stored in the codebook and an R-script is available to connect the dataset (.csv) with the codebook. The .sav and .Rds versions of the dataset include the labels. 

No recoding was applied to the dataset. Some recoding of variables is done during the analysis, see the R-scripts that produce the tables and plots. 

5. Uses 

The dataset is used to publish a paper on quantitative and qualitative aspects of pastoral care in parishes. 

6. Distribution 

The dataset can be accessed freely at Open Science Framework (OSF), hosted at Frankfurt to comply with European GPRS regulations. The dataset is published at: https://osf.io/6jmke/

7. Maintenance 

There is no further maintainance of the dataset. The published version on OSF (see Distribution) is made available by the research team (Theo Pleizier, Karen Zwijze and Marten van der Meulen, PThU). The research team has the administrative rights. 
