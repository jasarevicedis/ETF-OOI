# OOI Lab 2, Zadatak 1 za bodove
# Radili:
# Edis Jasarevic 19247
# Mersid Pilipovic 19070

#=
    Koristenjem JuMP paketa i GLPK solver-a za problema linearnog programiranja, 
    rijesiti tri razlicito postavljena problema s predavanja.
=#
using Pkg
Pkg.add("JuMP")
Pkg.add("GLPK")
using JuMP,GLPK



#=
    Zadaci s predavanja
=#

#=
    Zad 1 - primjer sa stranice 3 iz Linearnog programiranja(mljevena kafa)
    Model:
        arg max Z(x) = 3 x1 + 2 x2
    p.o.
        0.5 x1 + 0.3 x2 <= 150
        0.1 x1 + 0.2 x2 <=  60
        x1 >= 0, x2 >= 0
=#
zad1 = Model(GLPK.Optimizer)

@variable(zad1,x1>=0)
@variable(zad1,x2>=0)

@objective(zad1,Max,3x1 + 2x2)

@constraint(zad1,constraint1,0.5x1 + 0.3x2 <= 150)
@constraint(zad1,constraint2,0.1x1 + 0.2x2 <= 60)

print(zad1)

optimize!(zad1)

println("Rješenja: ")
println("x1= ",value(x1))
println("x2= ",value(x2))
println("Vrijednost cilja: ")
println(objective_value(zad1))

#=
    Rješenja:
    x1= 171.42857142857144
    x2= 214.28571428571428
    Vrijednost cilja:
    942.8571428571429
=#



#=
    ZAD2 - Stranica 24 u Linearnom programiranju

    Primjer: Grafičkim metodom riješiti problem linearnog programiranja
        arg max Z = 3 x1 + 5 x2
    p. o.
        x1 <= 4
        2 x2 <= 12
        3 x1 + 2 x2 <= 18
        x1 + 3 x2 <= 21
        2 x1 + 3 x2 >= 6
        x1 >= 0, x2 >= 0
=#

zad2 = Model(GLPK.Optimizer)

@variable(zad2,x1>=0)
@variable(zad2,x2>=0)

@objective(zad2,Max,3x1 + 5x2)

@constraint(zad2,constraint1,x1 <= 4)
@constraint(zad2,constraint2,2x2 <= 12)
@constraint(zad2,constraint3,3x1 + 2x2 <= 18)
@constraint(zad2,constraint4,x1 + 3x2 <= 21)
@constraint(zad2,constraint5,2x1 + 3x2 >= 6)



print(zad2)

optimize!(zad2)

println("Rješenja: ")
println("x1= ",value(x1))
println("x2= ",value(x2))
println("Vrijednost cilja: ")
println(objective_value(zad2))

#=
    Rješenja:
    x1= 2.0
    x2= 6.0
    Vrijednost cilja:
    36.0
=#

#=
    ZAD 3 - Primjer sa strane 28 u linearnom programiranju

    Primjer: Metodom pretrazivanja vrhova dopustivog prostora, rijesiti problem linearnog programiranja
    arg min Z = 100 x1 + 200 x2 + 300 x3
    p. o.
    25 x1 + 20 x2 + 40 x3 >= 1000
    2 x1 + 4 x2 + 5 x3 <= 500
    x1 >= 0, x2 >= 0, x3 >= 0

=#
zad3 = Model(GLPK.Optimizer)

@variable(zad3,x1>=0)
@variable(zad3,x2>=0)
@variable(zad3,x3>=0)


@objective(zad3,Min,100x1 + 200x2 + 300x3)

@constraint(zad3,constraint1,25x1 + 20x2 + 40x3 >= 1000)
@constraint(zad3,constraint2,2x1 + 4x2 + 5x3 <= 500)




print(zad3)

optimize!(zad3)

println("Rješenja: ")
println("x1= ",value(x1))
println("x2= ",value(x2))
println("x3= ",value(x3))
println("Vrijednost cilja: ")
println(objective_value(zad3))

#=
    Rješenja:
    x1= 40.0
    x2= 0.0
    x3= 0.0
    Vrijednost cilja:
    4000.0
=#