#Test1: PCR
#Test2: IgGorM, IgG only, IgM only

getwd()

# Libraries
#install.packages("runjags", "rjags")
library(runjags)
library(rjags)
testjags()

# Directory

# Model
source("covid_r1_dep_III.R")
#other choice: blcm_2test_mpop_prior_I.R
#other choice: blcm_2test_mpop_prior_II.R
#other choice: blcm_2test_mpop_prior_III.R
#other choice: blcm_2test_mpop_dep_prior_I.R
#other choice: blcm_2test_mpop_dep_prior_II.R
#other choice: blcm_2test_mpop_dep_prior_III.R

# Data
library(tidyverse)
library(readxl)
df <- read_excel('data.xls')

df2 <- df %>%
  filter(Ab %in% "IgGM") %>% #other choices: IgM, IgG, IgG/M
  select(Week, Author, `PCR+/Ab+`, `PCR+/Ab-`, `PCR-/Ab+`, `PCR-/Ab-`) %>%
  group_by(Week, Author) %>%
  summarise_all(funs(sum)) 

df2

y <- df2 %>%
  ungroup() %>%
  select(`PCR+/Ab+`, `PCR+/Ab-`, `PCR-/Ab+`, `PCR-/Ab-`) %>%
  as.matrix()

y

m = length(unique(df$Author))
n = apply(y, 1, sum)


#initials

inits1 = list(".RNG.name" ="base::Mersenne-Twister",
              ".RNG.seed" = 100022)
inits2 = list(".RNG.name" ="base::Mersenne-Twister",
              ".RNG.seed" = 300022)
inits3 = list(".RNG.name" ="base::Mersenne-Twister",
              ".RNG.seed" = 500022)


# Running
results <- run.jags(model, 
                    n.chains = 3,
                    inits=list(inits1, inits2, inits3),
                    burnin = 10000,
                    sample = 60000)
print(results)
