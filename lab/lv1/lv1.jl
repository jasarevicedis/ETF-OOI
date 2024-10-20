#Zadatak 1
3*456/23+31.54+2^6
sin(pi/7)*exp(0.3)*2(2+0.9*im)
sqrt(2)*log(10)
(5+3*im)/(1.2+4.5im)

#Zadatak 2

a=(atan(5)+exp(5.6))/3
b=sin(pi/3)^(1/15)
c=(log(15)+1)/23
d=sin(pi/2)+cos(pi)

(a+b)*c
acos(b)*asin(c/11)
(a-b)^4/d
c^(1/a)+b*im/(3+2*im)

#Zadatak 3
using LinearAlgebra

A=[1 -4*im sqrt(2); log(Complex(-1)) sin(pi/2) cos(pi/3); asin(0.5) acos(0.8) exp(0.8)]
A'
transpose(A)
A+transpose(A)
A*transpose(A)
transpose(A)*A
det(A)
inv(A)
pinv(A)

#Zadatak 4

zeros(8,9)
ones(7,5)
I(5)
I(5)+zeros(5,5)
randn(4,9)

#Zadatak 5
a=[2 7 6; 9 5 1; 4 3 8]
sum(a)
sum(a,dims=1)
sum(a,dims=2)
tr(a)
tr(rotl90(a))
minimum(a,dims=1)
minimum(a,dims=2)
minimum(diag(a))
minimum(diag(rotl90(a)))
maximum(a,dims=1)
maximum(a,dims=2)
maximum(diag(a))
maximum(diag(rotl90(a)))

#Zadatak 6
a=[1 2 3; 4 5 6; 7 8 9]
b=[1 1 1; 2 2 2; 3 3 3]
c=sin.(a)
c=sin.(a).*cos.(b)
c=(a^3)^(1/3)
c=(a.^3).^(1/3)


#Zadatak 7
0:99
[0:99;]'
[0:0.01:0.99;]'
[39:-2:1;]

#Zadatak 8
a=[7*ones(4,4) zeros(4,4); 3*ones(4,8)]
b=I(8)+a
c=b[1:2:8,:]
d=b[:,1:2:8]
e=b[1:2:8,1:2:8]
c[2,:] = c[2,:] *2

#Zadatak 9
import Pkg; 
Pkg.add("Plots")
using Plots
x=[-pi:pi/50:pi;];
y=sin.(x)
plot(x,y,title = "Sinus", label = "sin(x)")
xlabel!("x")
ylabel!("y")

x=range(-pi,stop=pi,length=101);
y=cos.(x);
plot(x,y,title = "Kosinus", label = "cos(x)")
xlabel!("x")
ylabel!("y")

x=range(-pi, π, length = 101)
y=[sin.(x) cos.(x)]
plot(x,y,shape = [:circle :star5], label = ["sin(x)" "cos(x)"])
title!("Sinus i kosinus")

x=range(-pi, π, length = 101)
y1=sin.(x);
y2=cos.(x);
p1=plot(x,y1,title="Sinus",shape=:circle,label="sin(x)");
p2=plot(x,y2,title="Kosinus",color=:red,shape=:star5,label="cos(x)");
plot(p1,p2,layout=(1,2))

#Zadatak 10
x, y = -8:0.5:8, -8:0.5:8
z(x,y) = sin.(sqrt.(x.^2+y.^2))
surface(x,y,z, st=:surface)


