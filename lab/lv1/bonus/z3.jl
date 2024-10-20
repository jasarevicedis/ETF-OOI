#=
    Napisati funkciju koja prima string koji je reprezentacija naredbe, te
    crta grafik proizvoljne funkcije jedne promjenljive. Potrebno je iskoristiti
    odgovarajuce meta naredbe za evaluaciju string-a kao izraza/naredbe. U
    funkciji predvidjeti da broj tacaka intervala bude 100, te da se funkcija
    crta na intervalu [-5,-5].

=#

#
#   https://docs.julialang.org/en/v1/manual/metaprogramming/#Expressions-and-evaluation
#

using  Plots

function nacrtaj_funkciju(funkcija::Expr)
    x_range = range(-5, 5, length=100)
    x_vals = collect(x_range)
    
    y_vals = [eval(Expr(:block, :(x = $x), funkcija)) for x in x_vals]
    
    plot(x_vals, y_vals, label=string(funkcija))
end

nacrtaj_funkciju(:(x^2 + 1))
nacrtaj_funkciju(:(x + 2)) 
nacrtaj_funkciju(:(x + x^(-3) + 3))