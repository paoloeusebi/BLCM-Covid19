#Test1: PCR
#Test2: IgG or IgM, IgG only, IgM only

getwd()

# libraries
# install.packages("runjags", "rjags")
library(tidyverse)
library(readxl)
library(runjags)
library(rjags)
testjags()


# Model
source("covid_r1_ind_I.R")
# source("covid_r1_ind_II.R")
# source("covid_r1_ind_III.R")
# source("covid_r1_dep_I.R")
# source("covid_r1_dep_II.R")
# source("covid_r1_dep_III.R")

# Data

df <- read_excel('data.xls')

df2 <- df %>%
  filter(Ab %in% "IgGM") %>% # other choices: IgM, IgG
  select(Week, Author, `PCR+/Ab+`, `PCR+/Ab-`, `PCR-/Ab+`, `PCR-/Ab-`) %>%
  group_by(Week, Author) %>%
  summarise_all(funs(sum)) %>%
  ungroup()
df2

y <- df2 %>%
  select(`PCR+/Ab+`, `PCR+/Ab-`, `PCR-/Ab+`, `PCR-/Ab-`) %>%
  as.matrix()
y

m = length(unique(df$Author)) # number of studies
n = apply(y, 1, sum) #sample size for each study


# initial values
inits1 = list(".RNG.name" ="base::Mersenne-Twister", ".RNG.seed" = 100022)
inits2 = list(".RNG.name" ="base::Mersenne-Twister", ".RNG.seed" = 300022)
inits3 = list(".RNG.name" ="base::Mersenne-Twister", ".RNG.seed" = 500022)

# Running
results <- run.jags(model, 
                    n.chains = 3,
                    inits=list(inits1, inits2, inits3),
                    burnin = 10000,
                    sample = 60000)
print(results)
plot(results,
     vars = list("Se", "Sp"),
     layout = c(4, 6),
     plot.type = c("trace", "histogram", "autocorr"))
