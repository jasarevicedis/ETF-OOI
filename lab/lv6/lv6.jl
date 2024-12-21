# Edis Jasarevic(19247) i Mersid Pilipovi(19070)

function najkraci_put(M)
    broj_cvorova = size(M, 1)
    udaljenosti = fill(Inf, broj_cvorova)
    prethodnici = fill(1, broj_cvorova)
    indexi = collect(1:broj_cvorova)
    udaljenosti[1] = 0  

    for red in 1:broj_cvorova
        for kolona in 1:broj_cvorova
            if M[red, kolona] != 0 && udaljenosti[red] != Inf && udaljenosti[red] + M[red, kolona] < udaljenosti[kolona]
                udaljenosti[kolona] = udaljenosti[red] + M[red, kolona]
                prethodnici[kolona] = red
            end
        end
    end

    putevi = hcat(indexi, udaljenosti, prethodnici)
    return putevi
end

M = [0 1 3 0 0 0; 0 0 2 3 0 0; 0 0 0 -4 9 0; 0 0 0 0 1 2; 0 0 0 0 0 2; 0 0 0 0 0 0]; 
putevi = najkraci_put(M);
println("Putevi:")
println(putevi)
#putevi = [1 0 1; 2 1 1; 3 3 2; 4 -1 3; 5 0 4; 6 1 4]

# primejr iz predavanja
testna_matrica1 = [
    0 2 10 7 0 0 0
    0 0 0 3 9 0 0
    0 0 0 6 0 6 0
    0 0 0 0 5 8 12
    0 0 0 0 0 1 7
    0 0 0 0 0 0 4
    0 0 0 0 0 0 0
]
putevi = najkraci_put(testna_matrica1);
println("Putevi:")
println(putevi)
