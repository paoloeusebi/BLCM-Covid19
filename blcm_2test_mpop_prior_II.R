model <- "

model {

for (i in 1:m) {

# likelihood

y[i,1:4] ~ dmulti(prob[i,1:4],n[i])

prob[i,1] <- pi[i]*se1*se2+(1-pi[i])*(1-sp1)*(1-sp2)
prob[i,2] <- pi[i]*se1*(1-se2)+(1-pi[i])*(1-sp1)*sp2
prob[i,3] <- pi[i]*(1-se1)*se2+(1-pi[i])*sp1*(1-sp2)
prob[i,4] <- pi[i]*(1-se1)*(1-se2)+(1-pi[i])*sp1*sp2

# priors for prevalence parameters

pi[i] ~ dbeta(1,1)
}

# priors for se/sp

se1 ~ dbeta(1,1) 
sp1 <-1
se2 ~ dbeta(1,1) 
sp2 ~ dbeta(108.19,2.53) #median=0.98, 5th percentile=0.95


#data# m, n, y

#inits# 

#monitor# se1, se2, sp1, sp2

}

"
