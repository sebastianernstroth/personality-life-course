library(tidyverse)
library(rprojroot)
library(haven)
library(qs)

# Call HILDA 2021 dta files
dta_files <- fs::dir_ls(path = "/Users/sebastianroth/Desktop/Data/HILDA 2021",
                        type = "file",
                        glob = "*Combined_*.dta",
                        recurse = TRUE)

# Read files
data <- lapply(dta_files, read_dta)

# Name file list
names(data) <- dta_files %>%
  basename()

# Relabel headers
for (i in 1:length(data)) {
  names(data[[i]]) <- sub(paste0("^", letters[i]), "", names(data[[i]]))
}

# Create dataset
data <- data.table::rbindlist(data, fill = TRUE, idcol = "source")

# Create and re-label variables
df <- data %>%
  rename(individual = xwaveid,
         age = hgage,
         gender = hgsex,
         birth_date = hgdob,
         marital_status = mrcurr,
         children_number = tcr,
         income = tifditp,
         education = edhigh1,
         agreeableness = pnagree,
         sympathetic = pnsymp,
         cooperative = pncoop,
         warm = pnwarm,
         kind = pnkind,
         conscientiousness = pnconsc,
         orderly = pnorder,
         systematic = pnsyst,
         inefficient = pnineff,
         sloppy = pnsoppy,
         disorganised = pndorg,
         efficient = pneffic,
         emotional_stability = pnemote,
         envious = pnenvy,
         moody = pnmoody,
         touchy = pntouch,
         jealous = pnjeal,
         temperamental = pntemp,
         fretful = pnfret,
         extroversion = pnextrv,
         talkative = pntalk,
         bashful = pnbful,
         quiet = pnquiet,
         shy = pnshy,
         lively = pnlivly,
         extroverted = pnextro,
         openness_to_experience = pnopene,
         deep = pndeep,
         philosophical = pnphil,
         creative = pncreat,
         intellectual = pnintel,
         complex = pncompx,
         imaginative = pnimag) %>%
  select(source,
         individual,
         age,
         gender,
         birth_date,
         marital_status,
         children_number,
         income,
         education,
         agreeableness,
         sympathetic,
         cooperative,
         warm,
         kind,
         conscientiousness,
         orderly,
         systematic,
         inefficient,
         sloppy,
         disorganised,
         efficient,
         emotional_stability,
         envious,
         moody,
         touchy,
         jealous,
         temperamental,
         fretful,
         extroversion,
         talkative,
         bashful,
         quiet,
         shy,
         lively,
         extroverted,
         openness_to_experience,
         deep,
         philosophical,
         creative,
         intellectual,
         complex,
         imaginative) %>%
    mutate(survey_wave = str_extract(source, regex("\\w{1}(?=\\d{3})")),
           survey_wave = match(survey_wave, letters[1:26]),
           survey_year = survey_wave+2000,
           birth_year = str_extract(birth_date, regex("\\d{4}")))
  
root <- rprojroot::is_rstudio_project

dataDir <- root$find_file("data")

# Dataset creation
qsave(df, paste(dataDir, "hilda-dataset.qs", sep = "/"))
