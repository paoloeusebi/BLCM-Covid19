# Test1: PCR
# Test2: IgGorM, IgG only, IgM only
# Set the working directory where this main.R file, the data and models are stored

setwd("/Users/paoloeusebi/Desktop/Lavoro/Harmony/BLCM-COVID19_rev") 
getwd()

# libraries
library(tidyverse)
library(readxl)
# install.packages("runjags", "rjags")
library(runjags)
library(rjags)
testjags()

# Data
df1 <- read_excel('data.xls')
df1

# Model
source("covid_r1_dep.R")
#other choice: ...

#initials
inits1 = list(".RNG.name" = "base::Mersenne-Twister",
              ".RNG.seed" = 100022)
inits2 = list(".RNG.name" = "base::Mersenne-Twister",
              ".RNG.seed" = 300022)
inits3 = list(".RNG.name" = "base::Mersenne-Twister",
              ".RNG.seed" = 500022)


models <- c("covid_r1_ind_I.R",
            "covid_r1_dep_I.R",
            "covid_r1_ind_II.R",
            "covid_r1_ind_III.R",
            "covid_r1_dep_II.R",
            "covid_r1_dep_III.R")
# other options to be included:
  

tests <- c("IgGM")

# initialization results data set
results.dataset <- NULL

for (i in tests) {
  for (j in models) {
    source(j)
    print(j)
    df2 <- df1 %>%
      filter(Ab %in% i, # other options: IgM, IgG, IgG/M
             Author %in% c("Garcia", "Liu", "Pan", "Whitman")) %>% # select one or more studies
      dplyr::select(Author, Week, `PCR+/Ab+`, `PCR+/Ab-`, `PCR-/Ab+`, `PCR-/Ab-`) %>%
      group_by(Week, Author) %>%
      summarise_all(funs(sum)) %>%
      ungroup()
    
    y <- df2 %>%
      dplyr::select(`PCR+/Ab+`, `PCR+/Ab-`, `PCR-/Ab+`, `PCR-/Ab-`) %>%
      as.matrix()
    
    m = length(unique(df2$Author))
    n = apply(y, 1, sum)
    
    tryCatch({
      results <- run.jags(model, 
                         n.chains = 3,
                         inits = list(inits1, inits2, inits3),
                         sample = 20000, adapt = 1000, burnin = 9000)
    print(results)
    
    a <- results$summaries %>%
      as_tibble(rownames = "Monitor") %>%
      mutate(Analysis = j) %>%
      as.data.frame()
    results.dataset <- rbind(results.dataset, a)
    
    png(filename = paste0("plot_", j, "_", i,".png"),
        width = 16, height = 9, units = "in", res = 300)
    plot(results, vars = list("Se", "Sp"),
         layout = c(4, 6),
         plot.type = c("trace", "histogram", "autocorr"),
         histogram.options = list(xlim = c(0, 1), xlab = ""),
         acplot.options = list(ylab = "ACF"))
    dev.off()
    }, error=function(e){})
  }
}

results.dataset2 <- results.dataset %>%
  mutate(par_95CI = paste0(round(Median, 2), " (", round(Lower95, 2), "-", round(Upper95, 2),")")) 
writexl::write_xlsx(results.dataset2, "results.dataset.xlsx")

