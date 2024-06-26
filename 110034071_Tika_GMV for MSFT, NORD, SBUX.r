asset.names <- c(" MSFT ", " NORD ", " SBUX ")
mu.vec = c(0.0427, 0.0015, 0.0285)
names(mu.vec) = asset.names
sigma.mat = matrix(c(0.0100, 0.0018, 0.0011, 0.0018, 0.0109, 
                     0.0026, 0.0011, 0.0026, 0.0199) ,nrow=3, ncol=3)
dimnames(sigma.mat) = list(asset.names, asset.names)
mu.vec
sigma.mat

sd.vec = c()

#Return and variance of a given portfolio are given by
x.vec = rep(1,3)/3
names(x.vec) = asset.names
mu.p.x = crossprod(x.vec, mu.vec)
sig2.p.x = t(x.vec)%*%sigma.mat%*%x.vec
sig.p.x = sqrt(sig2.p.x)
mu.p.x
sig.p.x

#Computational Aspects
top.mat = cbind(2*sigma.mat, rep(1,3))
bot.vec = c(rep(1, 3), 0)
Am.mat = rbind(top.mat, bot.vec)
b.vec = c(rep(0, 3), 1)
z.m.mat = solve(Am.mat)%*%b.vec
m.vec = z.m.mat[1:3,1]
m.vec

#the portfolio return and standard deviation are
mu.gmin = as.numeric(crossprod(m.vec, mu.vec))
mu.gmin
sig2.gmin = as.numeric(t(m.vec)%*%sigma.mat%*%m.vec)
sig.gmin = sqrt(sig2.gmin)
sig.gmin

#Another way to compute it is to go further on the analytical expression, and to derive
one.vec = rep(1 , 3)
sigma.inv.mat = solve(sigma.mat)
top.mat = sigma.inv.mat%*%one.vec
bot.val = as.numeric((t(one.vec)%*%sigma.inv.mat%*%one.vec))
m.mat = top.mat/bot.val
m.mat[ ,1]

#If our target is to get the same return as Microsoft, say (MSFT)
top.mat = cbind(2*sigma.mat, mu.vec, rep(1 , 3) )
mid.vec = c(mu.vec, 0, 0)
bot.vec = c(rep(1, 3), 0, 0)
A.mat = rbind(top.mat, mid.vec, bot.vec)
bmsft.vec = c(rep(0, 3), mu.vec[" MSFT "], 1)
z.mat = solve(A.mat)%*%bmsft.vec
x.vec = z.mat[1:3,]
x.vec

#the portfolio return and standard deviation are
mu.px = as.numeric(crossprod(x.vec, mu.vec))
mu.px
sig2.px = as.numeric(t(x.vec)%*%sigma.mat%*%x.vec)
sig.px = sqrt(sig2.px)
sig.px

sd.vec = c(sd.vec, sig.px)

#If our target is to get the same return as Starbucks (SBUX)
bsbux.vec = c(rep(0, 3), mu.vec[" SBUX "], 1)
z.mat = solve(A.mat)%*%bsbux.vec
y.vec = z.mat[1:3,]
y.vec

#with expected return and standard deviation
mu.py = as.numeric(crossprod(y.vec, mu.vec))
sig2.py = as.numeric(t(y.vec)%*%sigma.mat%*%y.vec)
sig.py = sqrt(sig2.py)
mu.py
sig.py

sd.vec = c(sd.vec, sig.py)

#Observe that actually, those two portfolios are extremely correled
sigma.xy = as.numeric(t(x.vec)%*%sigma.mat%*%y.vec)
rho.xy = sigma.xy/(sig.px*sig.py)
rho.xy

#solution lambda
M.mat = cbind(mu.vec, one.vec)
B.mat = t(M.mat)%*% solve(sigma.mat)%*%M.mat
mu.tilde.msft = c(mu.vec[" MSFT "], 1)
x.vec.2 = solve(sigma.mat)%*%M.mat%*%solve(B.mat)%*%mu.tilde.msft
x.vec.2

#compute the efficient frontier
a = 0.5
z.vec = a*x.vec + (1-a)*y.vec
z.vec

#with expected return and standard deviation
mu.pz = as.numeric(crossprod(z.vec, mu.vec))
sig2.pz = as.numeric(t(z.vec)%*%sigma.mat%*%z.vec)
sig.pz = sqrt(sig2.pz)
mu.pz
sig.pz

#or equivalently
mu.pz = a*mu.px + (1-a)*mu.py
sig.xy = as.numeric(t(x.vec)%*%sigma.mat%*%y.vec)
sig2.pz = a^2 * sig2.px + (1-a)^2 * sig2.py + 2*a*(1-a)*sig.xy
sig.pz = sqrt(sig2.pz)
mu.pz
sig.pz

#if we want the same return as Nordstrom (NORD)
a.nord = (mu.vec[" NORD "] - mu.py)/(mu.px - mu.py)
z.nord = a.nord*x.vec + (1-a.nord)*y.vec
z.nord

#Expected return and standard deviation are then
mu.pz.nord = a.nord*mu.px + (1-a.nord)*mu.py
sig2.pz.nord = a.nord^2 * sig2.px + (1-a.nord)^2 * sig2.py + 2*a.nord*(1-a.nord)*sigma.xy
sig.pz.nord = sqrt(sig2.pz.nord)
mu.pz.nord
sig.pz.nord

sd.vec = c(sd.vec, sig.pz.nord)

#compute the efficient frontier, consider a sequence of α�s
a = seq(from=1, to=-1, by=-0.1)
n.a = length(a)
z.mat = matrix(0, n.a, 3)
mu.z = rep(0, n.a)
sig2.z = rep(0, n.a)
sig.mx = t(m.vec)%*%sigma.mat%*%x.vec
for (i in 1:n.a){
  z.mat[i, ] = a[i]*m.vec + (1-a[i])*x.vec
  mu.z[i] = a[i]*mu.gmin + (1-a[i])*mu.px
  sig2.z[i] = a[i]^2 * sig2.gmin + (1-a[i])^2 * sig2.px + 2*a[i]*(1-a[i])*sig.mx
  }
plot(sqrt(sig2.z), mu.z, type="b", ylim=c(0, 0.06), xlim=c(0, 0.17), pch =16, col=" blue ", ylab=expression(mu[p]), xlab=expression(sigma[p]))
points(sd.vec, mu.vec, col = "green", pch = 16)
text(sig.gmin, mu.gmin, labels="Global min", pos =4)
text(sd.vec, mu.vec, labels=asset.names, pos=4)
