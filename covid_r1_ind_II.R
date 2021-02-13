model <- "

model {
      
# week1

for (i in 1:m) {
  
                # likelihood
  
                y[i,1:4] ~ dmulti(prob[i,1:4],n[i])

                prob[i,1] <- pi[i]*(Se[1]*Se[2]) + (1-pi[i])*((1-Sp[1])*(1-Sp[2]))
                prob[i,2] <- pi[i]*(Se[1]*(1-Se[2])) + (1-pi[i])*((1-Sp[1])*Sp[2])
                prob[i,3] <- pi[i]*((1-Se[1])*Se[2]) + (1-pi[i])*(Sp[1]*(1-Sp[2]))
                prob[i,4] <- pi[i]*((1-Se[1])*(1-Se[2])) + (1-pi[i])*(Sp[1]*Sp[2])

                # priors for prevalence parameters

                pi[i] ~ dbeta(1,1)
                }
          
# week2
        
for (i in (m+1):(2*m)) {

                # likelihood

                y[i,1:4] ~ dmulti(prob[i,1:4],n[i])

                prob[i,1] <- pi[i]*(Se[1]*Se[3]) + (1-pi[i])*((1-Sp[1])*(1-Sp[3]))
                prob[i,2] <- pi[i]*(Se[1]*(1-Se[3])) + (1-pi[i])*((1-Sp[1])*Sp[3])
                prob[i,3] <- pi[i]*((1-Se[1])*Se[3]) + (1-pi[i])*(Sp[1]*(1-Sp[3]))
                prob[i,4] <- pi[i]*((1-Se[1])*(1-Se[3])) + (1-pi[i])*(Sp[1]*Sp[3])

                # priors for prevalence parameters

                pi[i] ~ dbeta(1,1)
                }          
 
#week3

for (i in (2*m+1):(3*m)) {
                
                # likelihood

                y[i,1:4] ~ dmulti(prob[i,1:4],n[i])


                prob[i,1] <- pi[i]*(Se[1]*Se[4]) + (1-pi[i])*((1-Sp[1])*(1-Sp[4]))
                prob[i,2] <- pi[i]*(Se[1]*(1-Se[4])) + (1-pi[i])*((1-Sp[1])*Sp[4])
                prob[i,3] <- pi[i]*((1-Se[1])*Se[4]) + (1-pi[i])*(Sp[1]*(1-Sp[4]))
                prob[i,4] <- pi[i]*((1-Se[1])*(1-Se[4])) + (1-pi[i])*(Sp[1]*Sp[4])

                # priors for prevalence parameters

                pi[i] ~ dbeta(1,1)
                }          

Se[1] ~ dbeta(1,1) I(0.2,)
#Sp[1] ~ dbeta(426.36,4.64)  I(0.2,)
#Sp[1] ~ dbeta(76.63, 4.35)  I(0.2,)
Sp[1]<-1
Se[2] ~ dbeta(1,1) I(0.2,)
Sp[2] ~ dbeta(108.19,2.53) I(0.2,)
#Sp[2] ~ dbeta(76.63, 4.35)  I(0.2,)
Se[3] ~ dbeta(1,1) I(0.2,)
Sp[3] ~ dbeta(108.19,2.53) I(0.2,)
#Sp[3] ~ dbeta(76.63, 4.35)  I(0.2,)
Se[4] ~ dbeta(1,1) I(0.2,)
Sp[4] ~ dbeta(108.19,2.53) I(0.2,)
#Sp[4] ~ dbeta(76.63, 4.35)  I(0.2,)
      
#data# m, n, y
#inits# 
#monitor# Se, Sp, pi, cdp1, cdp2, cdp3, cdn1, cdn2, cdn3

}
        
"