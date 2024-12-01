#=
Napišite Julia funkciju tabela koja prima parametre matricu A (koeficijenti ograničenja s lijeve strane), 
vektor kolona b (koeficijenti ograničenja s desne strane) i 
vektor red c (koeficijenti u funkciji cilja). 
Problem je max i sva ograničenja su tipa ≤. 
U slučaju proslijeđivanja matrica i vektora neodgovarajućih dimenzija te negativnih vrijednosti vektora b baciti error. 
Funkcija vrši formiranje simplex tabele gdje se u posljednjoj koloni nalazi vektor b. 
Funkcija vraća simplex tabelu ST i bazu base. (3 poena) 
=#

using LinearAlgebra

function tabela(A,b,c)
    m,n = size(A)

    if length(b) != m
        throw("Error")
    end
    if length(c) != n
        throw("Error")
    end

    if any(x -> x<0,b)
        throw("Error")
    end

    ST = hcat(A, I(m), b)
    ST = [ST; hcat(c',zeros(1,m+1))]

    base = n+1:n+m

    return ST, base
end

tabela([2 1 3; 4 5 6], [1,2], [3,4,5])