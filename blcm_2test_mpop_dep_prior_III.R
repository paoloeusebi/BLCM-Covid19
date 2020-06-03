model <- "

model {

for (i in 1:m) {

# likelihood

y[i,1:4] ~ dmulti(prob[i,1:4],n[i])

prob[i,1] <- pi[i]*(se1*se2+cdp)+(1-pi[i])*((1-sp1)*(1-sp2)+cdn)
prob[i,2] <- pi[i]*(se1*(1-se2)-cdp)+(1-pi[i])*((1-sp1)*sp2-cdn)
prob[i,3] <- pi[i]*((1-se1)*se2-cdp)+(1-pi[i])*(sp1*(1-sp2)-cdn)
prob[i,4] <- pi[i]*((1-se1)*(1-se2)+cdp)+(1-pi[i])*(sp1*sp2+cdn)



# priors for prevalence parameters

pi[i] ~ dbeta(1,1)
}

cdp~dunif(lse,use)
cdn~dunif(lsp,usp)

lse <- (se1-1)*(1-se2)
use <- min(se1,se2) - se1*se2
lsp <- (sp1-1)*(1-sp2)
usp <- min(sp1,sp2) - sp1*sp2


# priors for se/sp

se1 ~ dbeta(1,1) 
sp1 ~ dbeta(76.63, 4.35) #median=0.95, 5th percentile=0.90
se2 ~ dbeta(1,1) 
sp2 ~ dbeta(76.63, 4.35) #median=0.95, 5th percentile=0.90



#data# m, n, y

#inits# 

#monitor# se1, se2, sp1, sp2, cdp, cdn

}

"
