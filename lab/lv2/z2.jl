# OOI Lab 2, Zadatak 2 za bodove
# Radili:
# Edis Jasarevic 19247
# Mersid Pilipovic 19070

using Pkg
Pkg.add("JuMP")
Pkg.add("GLPK")
using JuMP,GLPK

#=
    Tri proizvoda pakuju se u jednu kutiju zapremine 8 m3. Gustine proizvoda su 
    1 kg/m3
    2 kg/m3
    3 kg/m3
    , a prodajne cijene 8 KM/kg, 5 KM/kg i 4 KM/kg respektivno. Potrebno je odrediti koliko metara kubnih
    svakog od proizvoda treba smjestiti u kutiju da bi se ostvarila maksimalna vrijednost kutije. Težina kutije
    pri tome ne smije preći 12 kg.

=#

zad1 = Model(GLPK.Optimizer)

#ZAPREMINE
@variable(zad1,x1>=0)
@variable(zad1,x2>=0)
@variable(zad1,x3>=0)

#   MNOZILI SMO 8,5 I 4, RESPEKTIVNO S 1,2 I 3, JER NAM SE TRAZI KM/m3
@objective(zad1,Max,8x1 + 10x2 + 12x3)

@constraint(zad1,constraint1,x1 + 2x2 + 3x3 <= 12)
@constraint(zad1,constraint2,x1 + x2 + x3 <= 8)


print(zad1)

optimize!(zad1)

println("Rješenja: ")
println("x1= ",value(x1))
println("x2= ",value(x2))
println("x3= ",value(x3))

println("Vrijednost cilja: ")
println(objective_value(zad1))

#= 
    Rješenja:
    x1= 5.999999999999999
    x2= 0.0
    x3= 2.0000000000000004

    Vrijednost cilja:
    72.0

    JEDNAKO KAO U RJESENJU
=#


#=
    Fabrika proizvodi dva proizvoda. Za proizvodnju oba proizvoda koristi se jedna sirovina čija količina je
    ograničena na 20 kg u planskom periodu. Za pravljenje svakog kilograma prvog proizvoda potroši se 250
    grama sirovine,a za pravljenje svakog kilograma drugog proizvoda potroši se 750 grama sirovine. Dobit od
    prvog proizvoda je 3 KM po kilogramu, a od drugog 7 KM po kilogramu. Potrebno je napraviti plan
    proizvodnje koji maksimizira dobit, pri čemu je potrebno povesti računa da je količina proizvoda koji se
    mogu plasirati na tržište ograničena. Prvog proizvoda može se prodati maksimalno 10 kg, a drugog 9 kg

=#

zad2 = Model(GLPK.Optimizer)


@variable(zad2,x1>=0)#kg
@variable(zad2,x2>=0)#kg



@objective(zad2,Max,3x1 + 7x2)

@constraint(zad2,constraint1,0.25x1 + 0.75x2 <= 20)
@constraint(zad2,constraint2,x1 <= 10)
@constraint(zad2,constraint3,x2 <= 9)

print(zad2)

optimize!(zad2)

println("Rješenja: ")
println("x1= ",value(x1))
println("x2= ",value(x2))
println("Vrijednost cilja: ")
println(objective_value(zad2))

#=
    Rješenja:
    x1= 10.0
    x2= 9.0
    Vrijednost cilja:
    93.0

    KAO U RJESENJU
=#


#=
    Kompanija za proizvodnju slatkiša proizvodi visokokvalitetne čokoladne proizvode i namjerava pokrenuti
    proizvodnju dva nova slatkiša. Proizvodi se prave u tri različita odjeljka u kojem provode određeno
    vrijeme. Prvi proizvod zahtijeva 1 h proizvodnje u odjeljku 1 i 3 h proizvodnje u odjeljku 3 po jednom
    komadu. Drugi proizvod zahtijeva 1 h proizvodnje u odjeljku 2 i 2 h proizvodnje u odjeljku 3 po jedom
    komadu. Odjeljak 1 ima na raspolaganju 3 slobodna sata, odjeljak 2 ima 6 slobodnih sati i odjeljak 3 ima
    18 slobodnih sati. Svi proizvedeni novi proizvodi mogu se prodati a cijena prvog iznosi 2 KM, a drugog
    4 KM po komadu. 
=#

zad3 = Model(GLPK.Optimizer)


@variable(zad3,x1>=0)
@variable(zad3,x2>=0)

@objective(zad3,Max,2x1 + 4x2)

@constraint(zad3,constraint1,x1 <= 3)
@constraint(zad3,constraint2,x2 <= 6)
@constraint(zad3,constraint3,3x1 + 2x2 <= 18)

print(zad3)

optimize!(zad3)

println("Rješenja: ")
println("x1= ",value(x1))
println("x2= ",value(x2))
println("Vrijednost cilja: ")
println(objective_value(zad3))

#=
    Rješenja:
    x1= 2.0
    x2= 6.0
    Vrijednost cilja:
    28.0

    ISTO KAO U RJESENJU
=#