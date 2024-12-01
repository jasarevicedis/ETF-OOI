#=
Fabrika treba da proizvede mješavinu koja se sastoji od dvije legure A i B. U 10 grama legure
A nalaze se 2 grama bakra, jedan gram cinka i jedan gram olova. U 10 grama legure B nalaze
se jedan gram bakra, jedan gram cinka i jedan gram olova. Mješavina treba da sadrži barem 10
grama bakra, 8 grama cinka i 12 grama olova. Legura B košta 1,5 puta više po kilogramu od
legure A. Potrebno je odrediti količinu legura A i B koje treba pomiješati kako bi se
zadovoljili traženi uslovi uz što manje troškove.
a. Napisati matematički model opisanog problema. (2 poena)
b. Napisati početnu simpleks tabelu za dobiveni matematički model (3 poena)
c. Napisati matematički model dualnog problema, reći koji od problema, dualni ili
primalni, je lakše riješiti i zašto. (2 poena)
=#
using Pkg
Pkg.add("JuMP")
Pkg.add("GLPK")
using JuMP,GLPK

m=Model(GLPK.Optimizer)

@variable(m,x1>=0)
@variable(m,x2>=0)

@objective(m,Min,1x1+1.5x2)
@constraint(m,constraint1,2x1+x2>=10)
@constraint(m,constraint2,x1+x2>=8)
@constraint(m,constraint3,x1+x2>=12)

optimize!(m)

println("Status:", termination_status(m))
println("Rješenja:")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("x3 = ", -1*(10 - value(constraint1)))
println("x4 = ", -1*(8 - value(constraint2)))
println("x5 = ", -1*(12 - value(constraint3)))
println("Vrijednost cilja:")
println(objective_value(m))

println("Vrijednost dualnih promjenljivih:")
println("y1 = ", dual(constraint1))
println("y2 = ", dual(constraint2))
println("y3 = ", dual(constraint3))
println("y4 = ", dual(LowerBoundRef(x1)))
println("y5 = ", dual(LowerBoundRef(x2)))