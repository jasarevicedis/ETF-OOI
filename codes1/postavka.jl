#=
Farmer je kupio 100 hektara zemlje. Odlučio je da posadi pšenicu i ječam. 
S obzirom na kvalitet klime u regionu, sve žitarice će biti prodane. 
Pomozite farmeru da napravi optimalan plan sadnje u sklopu 100 hektara na osnovu troškova, 
profita i ljudskog rada. Budžet farmera je 5165 KM i ljudski resursi su 1490 ljudi-dana (man-days). 
Ostali potrebni parametri su dati u tabeli ispod.

proizvod/resurs  Troškovi (KM/ha) Rad (ljudi-dani/ha) Prodajna cijena (KM/ha)
pšenica              3                     3                     45
ječam                2                     2                     80

Cilj farmera je da maksimizira svoje prihode. 
Postavite problem matematskog programiranja za rješavanje u Juliji, pomoću GLPK-a i JuMP-a. (3 poena)

=#

using Pkg
Pkg.add("JuMP")
Pkg.add("GLPK")
using JuMP,GLPK

model = Model(GLPK.Optimizer)

@variable(model,x1>=0)#psenica -broj hektara
@variable(model,x2>=0)#jecam - broj hektara

#maksimizacija prihoda, a ne profita(prihodi - troskovi) --> al nije ni bitno
@objective(model,Max,45x1 + 80x2)

@constraint(model,constraint1,3x1 + 2x2 <= 5165)
@constraint(model,constraint2,2x1 + 2x2 <= 1490)

optimize!(model)

println("Rješenja: ")
println("Psenica= ",value(x1))
println("Jecam= ",value(x2))
println("Vrijednost cilja: ")
println(objective_value(model))