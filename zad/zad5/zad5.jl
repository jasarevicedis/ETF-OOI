using Pkg
Pkg.add("JuMP")
Pkg.add("GLPK")
using JuMP, GLPK
using LinearAlgebra

function general_simplex(goal, c, A, b, csigns, vsigns)
        b=b'
        csigns=csigns'
        vsigns=vsigns'

        if ismissing(csigns)
            if goal == "min"
            csigns = ones(size(b,1))
            else
                csigns = -1*ones(size(b,1))
            end
        end
    
        if ismissing(vsigns)
            vsigns = ones(size(c,2))
        end

        broj_pogresnih = count(i-> (i!=1 && i!=-1 && i!=0), csigns) + count(i-> (i!=1 && i!=-1 && i!=0), vsigns)

        if size(b, 1) != size(A, 1) || size(c, 2) != size(A, 2) || (goal != "min" && goal != "max") || (size(csigns, 1) != size(b, 1)) || (size(vsigns, 1) != size(c, 2) || broj_pogresnih != 0)
             return (NaN, NaN, NaN, NaN, NaN, 5)
        end
        
        vmap = []
        for i in 1:lastindex(vsigns)
            if vsigns[i] == -1
                A[:, i] *= -1
                c[i] *= -1
            elseif vsigns[i] == 0
                c = [c -c[i]]
                A = [A -A[:, i]]
                push!(vmap, (i, size(A, 2)))
            end
        end

        A1 = A
        b1 = b
        c1 = c
        rows = size(A,1)
        base = zeros(rows,1)
        M = zeros(1, size(c,2))
        M1 = 0
        vjestacke_varijable = []
        vjestacke_eq = []
        
   
        for i in 1:rows 
            if b1[i] < 0
                A1[i, :] = -A1[i, :]
                b1[i] = -b1[i]
                csigns[i] = -csigns[i]
            end

            if csigns[i] == -1
                new_col = zeros(rows, 1)
                new_col[i] = 1
                A1 = [A1 new_col]
                M = [M 0]
                c1 = [c1 0]
                base[i] = size(c1, 2)

            elseif csigns[i] == 1
                new_col = zeros(rows, 1)
                new_col[i] = -1
                A1 = [A1 new_col]
                M = [M 0]
                c1 = [c1 0]
            end
        end

        #vjestacke varijable
        for i in 1:rows
            if csigns[i] == 1
                new_col = zeros(rows, 1)
                new_col[i] = 1
                A1 = [A1 new_col]
                M = [M -1]
                c1 = [c1 0]
                base[i] = size(c1, 2)
                M[:] .= M[:] .+ A1[i, :]
                M1 = M1 .+ b1[i]
                vjestacke_varijable = [vjestacke_varijable; size(c1, 2)]
            elseif csigns[i] == 0
                new_col = zeros(rows, 1)
                new_col[i] = 1
                A1 = [A1 new_col]
                M = [M -1]
                c1 = [c1 0]
                base[i] = size(c1, 2)
                M[:] .= M[:] .+ A1[i, :]
                M1 = M1 .+ b1[i]
                vjestacke_varijable = [vjestacke_varijable; size(c1, 2)]
                vjestacke_eq = [vjestacke_eq; size(c1,2)]
            end
        end

        c1 = [0 c1]
        M = [M1 M]

        #konacna tabela spremna za iteriranje

        simplex_tabela = [b1 A1]
        simplex_tabela = [simplex_tabela; M; c1]

        if goal == "min"
            simplex_tabela[end, :] *= -1
        else
            simplex_tabela[end-1, 1] = abs(simplex_tabela[end-1, 1])
        end

        # trazenje maximuma

            row_M = deepcopy(simplex_tabela[end-1, :])
            popfirst!(row_M)
            (cMax_M, col_index_M) = findmax(row_M) # max u C i M redu
            col_index_M += 1

            col_index = 0
            predzadnji_red = simplex_tabela[end-1, :]
            zadnji_red = simplex_tabela[end, :]
            cMax = -Inf

            for i in 2:lastindex(zadnji_red)
                if zadnji_red[i] > cMax && (predzadnji_red[i] >= 0 || predzadnji_red[i] == -0)
                cMax = zadnji_red[i]
                col_index = i
                end
            end

        while cMax > 0 || cMax_M > 0 

                if cMax_M > 0
                    pivot_kolona = col_index_M
                else
                    pivot_kolona = col_index
                end
        
                    tMax = Inf
                    pivot_red = -1 

                for i in 1:size(simplex_tabela, 1)-2
                    if simplex_tabela[i, pivot_kolona] > 0
                        t_temp = simplex_tabela[i, 1] / simplex_tabela[i, pivot_kolona]
                        if (t_temp < tMax || (t_temp == tMax && rand() > 0.5)) #random izbor zbog degeneracije
                            tMax = t_temp
                            pivot_red = i 
                        end
                    end
                end
                
                if tMax == Inf
                    return (Inf, NaN, NaN, NaN, NaN, 3)
                end
                
                #sređivanje tabele
                    base[pivot_red] = pivot_kolona - 1
                    pivot = simplex_tabela[pivot_red, pivot_kolona]
                    simplex_tabela[pivot_red, :] ./= pivot
        
                for i in 1:size(simplex_tabela, 1)
                    if i != pivot_red
                        factor = simplex_tabela[i, pivot_kolona]
                        for j in 1:size(simplex_tabela, 2)
                            simplex_tabela[i, j] -= simplex_tabela[pivot_red, j] * factor
                        end
                    end
                end
                
                    row_M = deepcopy(simplex_tabela[end-1, :])
                    popfirst!(row_M)
                    (cMax_M, col_index_M) = findmax(row_M)
                    col_index_M += 1
        
                if cMax_M <= 1e-9 
                    cMax_M = 0
                end
        
                if cMax_M <= 0
                    nd_last_row = simplex_tabela[end-1, :]
                    zadnji_red = simplex_tabela[end, :]
                    cMax = -Inf
                    for i in 2:lastindex(zadnji_red)
                        if zadnji_red[i] > cMax && (nd_last_row[i] >= 0 || nd_last_row[i] == -0)
                            cMax = zadnji_red[i]
                            col_index = i
                        end
                    end
                end
        end

        for i in 1:lastindex(vjestacke_varijable)
            if (Float64(vjestacke_varijable[i]) in base)
                return (NaN, NaN, NaN, NaN, NaN, 4)
            end
        end

        x = vec(zeros(1, size(simplex_tabela, 2) - 1 - lastindex(vjestacke_varijable)))

        # basic variable values
        for i in 1:lastindex(base)
            x[Int(round(base[i]))] = simplex_tabela[i, 1]
        end

        duals = simplex_tabela[end, :]
        popfirst!(duals)
        
        indexi = []

        if !isempty(vmap)
        for i in 1:lastindex(vmap)
            prvi_el = vmap[i][1] in base
            drugi_el = vmap[i][2] in base
            if prvi_el && drugi_el
                #situacija u kojoj se desava da varijablu koju smo razbili na dvije varijable, te se te obje varijable nalaze 
                #u krajnjem baznom rjesenju bi trebala biti nemoguca, s obzirom da bi tada efektivni broj elemenata baze bio n-1
                #umjesto potrebnog n
            elseif !prvi_el && drugi_el
                replace!(base, vmap[i][2] => vmap[i][1])
                x[vmap[i][1]] = -x[vmap[i][2]]
            end
            push!(indexi, vmap[i][2])
        end
    end
    if !isempty(indexi)
        deleteat!(x, indexi)
        deleteat!(duals, indexi)
    end

        # Checking uniqueness
        is_unique = true
        for i in 1:(lastindex(duals)-lastindex(vjestacke_varijable))
            if x[i] == 0 && duals[i] == 0
                is_unique= false
            end
        end

        is_unique_str = is_unique ? "Rjesenje je jedinstveno" : "Rjesenje nije jedinstveno"

        # Adjusting final solution
        if !isempty(vmap)
            for i in 1:lastindex(vmap)
                prvi_el = findall(y -> y == vmap[i][1], x)
                drugi_el = findall(y -> y == vmap[i][2], x)
                    if !isempty(prvi_el) && !isempty(drugi_el)

                    elseif isempty(prvi_el) && !isempty(drugi_el)

                    x[vmap[i][1]] = -x[drugi_el]
                    deleteat!(x, drugi_el[1])

                    end
            end
        end

        # degeneracija
            jel_degenerisan = false
            for i in 1:(lastindex(simplex_tabela[:, 1])-2)
                if simplex_tabela[i, 1] == 0
                    jel_degenerisan = true
                end
            end

        
        is_degenerate_str = jel_degenerisan ? "Rjesenje je degenerirano" : "Rjesenje nije degenerisano"

        YUkupno = zeros(size(x, 1))

        # adjusting based on min/max

        Z = goal == "min" ? simplex_tabela[end, 1] : -simplex_tabela[end, 1]

        # duali

        csigns1 = Int[] 
        for i in 1:lastindex(csigns)
            if csigns[i] != 0
                push!(csigns1, csigns[i])
            end
        end

        broj_ogranicenja = count(i -> (i == 0), vsigns)

        for i in 1:(lastindex(duals)-lastindex(vjestacke_varijable))
            if x[i] == 0 && i >= (size(c, 2) - broj_ogranicenja + 1)
                if goal == "max"
                    if csigns1[i-(size(c, 2)-broj_ogranicenja)] == -1
                        YUkupno[i] = -duals[i]
                    elseif csigns1[i-(size(c, 2)-broj_ogranicenja)] == 1
                        YUkupno[i-(size(c, 2)-broj_ogranicenja)] = duals[i]
                    elseif csigns1[i-(size(c, 2)-broj_ogranicenja)] == 0
                        YUkupno[i] = -duals[i]
                    end
                elseif goal == "min"
                    if csigns1[i-(size(c, 2)-broj_ogranicenja)] == -1
                        YUkupno[i] = duals[i]
                    elseif csigns1[i-(size(c, 2)-broj_ogranicenja)] == 1
                        YUkupno[i] = -duals[i]
                    elseif csigns1[i-(size(c, 2)-broj_ogranicenja)] == 0
                        YUkupno[i] = duals[i]
                    end
                end
            elseif x[i] == 0
                if goal == "max"
                    YUkupno[i] = -duals[i]
                elseif goal == "min"
                    YUkupno[i] = -duals[i]
                end
            end
        end

        Y = YUkupno[(size(c, 2)+1-broj_ogranicenja):size(x, 1)]
        Yd = YUkupno[1:(size(c, 2)-broj_ogranicenja)]
        X = x[1:(size(c, 2)-broj_ogranicenja)]
        Xd = x[(size(c, 2)+1-broj_ogranicenja):size(x, 1)]

        if !isempty(vjestacke_eq)
        for i in vjestacke_eq
            if goal == "max"
                Y = [Y; -duals[i]]
                Xd = [Xd; 0]
            else
                Y = [Y; duals[i]]
                Xd = [Xd; 0]
            end
        end
    end



    status = 0
    if jel_degenerisan == true
        return (Z, X, Xd, Y, Yd, 1)
    elseif is_unique == false
        return (Z, X, Xd, Y, Yd, 2)
    end
    return (Z, X, Xd, Y, Yd, 0)
end


####             TESTIRANJE              ############

#test1
#Z=3000;  X=(60 20) Xd(90 0 60 100 0 40); Y(0 30 0 0 10 0) Yd(0 0) status(0)
goal="max";
c=[40 30];
A=[3 1.5;1 1;2 1;3 4;1 0;0 1];
b=[300 80 200 360 60 60] 
csigns=[-1 -1 -1 -1 -1 -1] 
vsigns=[1  1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test2
#Z=12;  X=(12 0) Xd(14 4 0); Y(0 0 1) Yd(0 0.5); status(0)
goal="min";
c=[1 1.5];
A=[2 1; 1 1; 1 1];
b=[10 8 12] 
csigns=[1 1 1] 
vsigns=[1  1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test3
#Z=38;  X=(0.66 0 0.33 0) Xd(0 0 0.3 0.16); Y(2 0.12 0 0) Yd(0 36 0 34); status(0)
goal="min";
c=[32 56 50 60];
A=[1 1 1 1;250 150 400 200;0 0 0 1;0 1 1 0];
b=[1 300 0.3 0.5] 
csigns=[0 1 -1 -1] 
vsigns=[1  1 1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#dual prethodnog problema
#test4
#Z=38; X(2 0.12 0 0) Xd(0 36 0 34); Y=(0.66 0 0.33 0) Yd(0 0 0.3 0.16);  status(0)
goal="max";
c=[1 300 -0.3 -0.5];
A=[1 250 0 0;1 150 0 -1;1 400 0 -1;1 200 -1 0];
b=[32  56  50  60] 
csigns=[-1 -1 -1 -1] 
vsigns=[0  1 1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test5
#Z=Inf; Problem ima neograniceno rjesenje (u beskonacnosti); status(3)
goal="max";
c=[1 1];
A=[-2 1;-1 2];
b=[-1 4] 
csigns=[-1 1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test6
#Z=Nan; Dopustiva oblast ne postoji; status(4)
goal="max";
c=[1 2];
A=[1 1; 3 3];
b=[2 4] 
csigns=[1 -1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test7
#Z=12*10^6; X(2500 1000) Xd(1500 0 0 2000); Y(0 2000 0 0) Yd(0 0); status(2)
#Z=12*10^6; X(2000 2000) ; status(2)
goal="max";
c=[4000 2000];
A=[3 3;2 1;1 0;0 1];
b=[12000 6000 2500 3000] 
csigns=[-1 -1 -1 -1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test8
#Z=18; X(0 2) Xd(0 0); Y(0 4.5) Yd(1.5 0); status(1)
#Z=18; X(0 2) Xd(0 0); Y(1.5 1.5) Yd(0 0); status(1)
goal="max";
c=[3 9];
A=[1 4;1 2];
b=[8 4] 
csigns=[-1 -1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)





#Zadatak 2
#Drugi Testni primjeri

#test 1
#Klasicna maksimizacija

#Primjer 3.8 iz Linearnog programiranja knjiga str 105
#Z = 900, X=( 300, 0), Xd=(0, 30), Y=(6, 0), Yd=(0, 0.8), status = 0
goal="max";
c=[3 1];
A=[0.5 0.3; 0.1 0.2];
b=[150 60] 
csigns=[-1 -1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test 2
#Klasicna maksimizacija

#Primjer 3.10 iz Linearnog programiranja knjiga str 111
#Z = 780000, X=(600, 300), Xd=(0, 0, 1550, 250), Y=(600/173, 8600/173, 0, 0), Yd=(0, 0), status = 0
goal = "max";
c = [800 1000];
A = [30 16; 14 19; 11 26; 0 1];
b = [22800 14100 15950 550]
csigns = [-1 -1 -1 -1]
vsigns = [1 1]
Z,X,Xd,Y,Yd,status = general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test 3
#maskimizacija ali namještena za pojavu degeneracije 

#Linearno programiranje knjiga strana 121
#Z = 5, X=(1, 0, 1, 0), Xd=(3/4, 0, 0), Y=(0, 6, 5), Yd=(0, 8, 0, 42), status = 0
goal = "max"
c = [3 -80 2 -24]
b = [0 0 1]
A = [0.25 -8 -1 9; 0.5 -12 -0.5 3; 0 0 1 0]
csigns = [-1 -1 -1]
vsigns = [1 1 1 1]
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test 4
#Klasicna minimizacija

#Primjer 3.13 iz Linearnog programiranja knjiga str 133
#Z = 1860/7, X=(24/7, 30/7), Xd=(1/7, 9/70,0,0), Y=(0, 0, 500/7, 300/7), Yd=(0, 0), status = 0
goal = "min"
c = [40 30]
b = [0.2 0.3 3 1.2]
A = [0.1 0; 0 0.1; 0.5 0.3; 0.1 0.2]
csigns = [1 1 1 1]
vsigns = [1 1]
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test 5
#maksimizacija sa drugacijim znakovima ogranicenja

#Primjer 4.7 iz Dualnosti u linearnom programiranju knjiga str 168
#Z = 36, X=(2, 6), Xd=(2, 0, 0, 1, 16), Y=(0, 3/2, 1, 0, 0), Yd=(0, 0), status = 0
goal = "max"
c = [3 5]
b = [4 12 18 21 6]
A = [1 0; 0 2; 3 2; 1 3; 2 3]
csigns = [-1 -1 -1 -1 1]
vsigns = [1 1]
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)


#test 6
#dual prethodnog testa

#Primjer 4.7 iz Dualnosti u linearnom programiranju knjiga str 169
#Z = 36, X=(0, 3/2, 1, 0, 0), Xd=(0, 0), Y=(2, 6), Yd=(2, 0, 0, 1, 16), status = 0
goal = "min"
c = [4 12 18 21 6]
b = [3 5]
A = [1 0 3 1 2; 0 2 2 3 3]
csigns = [1 1]
vsigns = [1 1 1 1 -1]
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)


#test 7
#sva ogranicenja =

#Primjer 4.9 iz Dualnosti u linearnom programiranju knjiga str 174
#Z = 700, X=(1, 0, 3), Xd=(0, 0), Y=(400, -100), Yd=(0, 400, 0), status = 0
goal = "max"
c = [100 300 200]
b = [4 9]
A = [1 2 1; 3 1 2]
csigns = [0 0]
vsigns = [1 1 1]
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)


#test 8
#dual prethodnog testa međutim sad su domene promjenjivih neograničene

#Zadatak Poglavlje 4_Dualnost_u_linearnom programiranju strana 25
#Z = 700, X=(400, -100), Xd=(0, 400, 0), Y=(1, 0, 3), Yd=(0, 0), status = 0
goal = "min"
c = [4 9]
b = [100 300 200]
A = [1 3; 2 1; 1 2]
csigns = [1 1 1]
vsigns = [0 0]
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test 9
#maksimizacija sa status 2

#Z = 2.0, X=(1.5, 0.5), Xd=(1, 0, 0), Y=(0, 1, 0), Yd=(0, 0), status = 2
goal = "max"
c = [1 1]
b = [3 2 1]
A = [1 1; 1 1; 1 -1]
csigns = [-1 -1 1]
vsigns = [1 1]
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test 10
#maksimizacija sa degeneracijom

#Z = 1, X=(1, 0, 0), Xd=(0, 0, 0), Y=(0, 1, 1), Yd=(0, 0, 0), status = 1
goal = "max";
c = [1 1 1];
b = [1 0 1];
A = [1 1 0; 0 -1 1; 1 2 0];
csigns = [-1 -1 -1];
vsigns = [1 1 1];
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test 11
#neogranicena oblast

#Z = Inf status = 3
goal = "max";
c = [1 2];
b = [1 3];
A = [-2 1; 0 1];
csigns = [-1 -1];
vsigns = [1 1];
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test 12
#oblast nemoguca

#Z = NaN status = 4
goal = "max";
c = [1 1];
b = [2 3 1];
A = [1 1; 1 2; -0.5 2];
csigns = [-1 1 -1];
vsigns = [1 1];
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test 13
#namjerno pogrešni parametri

goal = "max";
c = [1 1];
A = [1 1; 1 2; -0.5 2];
b = [2 3 1];
csigns = [-1 1 -1];
vsigns = [1 2];
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test 14
#namjerno pogrešni parametri

goal = "max";
c = [1 1 3];
A = [1 1; 1 2; -0.5 2];
b = [2 3 1];
csigns = [-1 1 -1];
vsigns = [1 1];
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

#test 15
#namjerno pogrešni parametri

goal = "maks";
c = [1 1];
A = [1 1; 1 2; -0.5 2];
b = [2 3 1];
csigns = [-1 1 -1];
vsigns = [1 1];
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)