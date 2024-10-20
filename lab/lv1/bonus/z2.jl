#=
    Napisati funkciju koja vrsi sabiranje svih elemenata proslijedene matrice, 
    sabiranje elemenata po redovima, kolonama i dijagonalama, te
    vraca odgovarajuce sume. Zadatak uradite bez koristenja predefinisanih funkcija. 
    Potrebno je provjeriti rad funkcije.
=#

function sume_matrice(mat)
    suma_matrice=0
    suma_redova=zeros(size(mat,1))
    suma_kolona=zeros(size(mat,2))
    suma_dijagonale1=0
    suma_dijagonale2=0
    for i = 1:size(mat,1)
        for j = 1:size(mat,2)
            suma_matrice+=mat[i,j]
            suma_redova[i]+=mat[i,j]
            suma_kolona[j]+=mat[i,j]
            if size(mat,1) == size(mat,2)
                if i==j
                    suma_dijagonale1 += mat[i,j]
                end
                if (i + j) == (size(mat,1)+1)
                    suma_dijagonale2 += mat[i,j]; 
                end
            end
        end
    end
    return suma_matrice,suma_redova,suma_kolona, suma_dijagonale1, suma_dijagonale2
end

sume_matrice([1 2 3; 4 5 6; 7 8 9])
a=[3 1 3; 4 7 2; 4 3 9];
sume_matrice(a)
sume_matrice(a[2,:])
sume_matrice(a[1:2,1:2])
