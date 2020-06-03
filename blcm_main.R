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
source("blcm_2test_mpop_prior_III.R")
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
  filter(Week %in% 1, #other choices: 2, 3
         Ab %in% "IgG/M") %>% #other choices: IgM, IgG, IgG/M
  select(Author, `PCR+/Ab+`, `PCR+/Ab-`, `PCR-/Ab+`, `PCR-/Ab-`) %>%
  group_by(Author) %>%
  summarise_all(funs(sum)) 

df2

y <- df2 %>%
  select(`PCR+/Ab+`, `PCR+/Ab-`, `PCR-/Ab+`, `PCR-/Ab-`) %>%
  as.matrix()

y

m = dim(y)[1]
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
                    sample = 110000)
print(results)

write.csv(summary(results),file=paste("blcm_2test_mpop_prior_III.R","week 1", ".csv"))

