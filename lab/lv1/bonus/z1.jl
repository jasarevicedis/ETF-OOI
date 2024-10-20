#=
    Napisati funkciju koja vrsi sabiranje i oduzimanje dva proslijedjena argumenta, 
    i vraca oba rezultata. Dodati provjeru broja argumenata. Ako
    argument nije proslijeden, dodijeliti mu 0. Obzirom da argumenti mogu
    biti matrice, izvrsite provjeru dimenzija. U slucaju da se dimenzije ne
    podudaraju vratiti rezultat 0. Potrebno je provjeriti rad funkcije.
=#

function zbir_razlika(x=0,y=0)
    if (size(x)===size(y))
     x + y, x-y
    else return (0,0)
    end
end

zbir_razlika([3;3])
zbir_razlika([1 2 3; 4 5 6],[1 2 3])
a,b=zbir_razlika(2,4)
zbir_razlika([1 2 3; 1 2 3], [4 5 6; 4 5 6])
zbir_razlika()