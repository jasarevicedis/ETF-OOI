#=
    Napišite Julia funkciju simplex_table koja prima tri parametra A, b i vsigns. Parametar A
odgovara koeficijentima sa lijeve strane ograničenja, b koeficijentima sa desne strane
ograničenja, vsigns predstavlja znak ograničenja, pri čemu 1, 0 i -1 predstavljaju >=, = i <=
respektivno. Smatra se da su sve promjenljive >= 0. Funkcija treba da vrati formiranu simplex
tabelu ST i indekse promjenljivih koje se nalaze u bazi base.
=#

function simplex_table(A,b,c,vsigns)
    #Moguće uraditi na više načina
    A_novo = A;
    b_novo = b;
    c_novo = c;
    redova,kolona = size(A);
    dodatna = zeros(kolona,1);
    base = [];
    c_novo_M = zeros(1,size(c,2));
    funkcija_M =0;
    #Kôd odgovara načinu formiranja tabele kao na predavanju/tutorijalima
    for i = 1:redova
        #Neobavezan dio
        if (b_novo[i] < 0)
            A_novo[i,:] = -A_novo[i,:];
            b_novo[i] = -b_novo[i];
            if vsigns[i]== -1
                vsigns[i] = 1;
            elseif vsigns[i] == 1
                vsigns[i] = -1;
            end
        end
        #Obavezni dio
        if vsigns[i] == -1
            tmp_kolona = zeros(redova,1);
            tmp_kolona[i] = 1;
            A_novo = [A_novo tmp_kolona];
            c_novo_M = [c_novo_M 0];
            c_novo = [c_novo 0];
            base=[base; size(c_novo,2)];
        
        elseif vsigns[i] ==1
            tmp_kolona = zeros(redova,1);
            tmp_kolona[i] = -1;
            A_novo = [A_novo tmp_kolona];
            c_novo_M = [c_novo_M 0];
            c_novo = [c_novo 0];
            tmp_kolona = zeros(redova,1);
            tmp_kolona[i] = 1;
            A_novo = [A_novo tmp_kolona];
            c_novo_M =[c_novo_M -1];
            c_novo = [c_novo 0];
            base=[base; size(c_novo,2)];
            c_novo_M[:] .= c_novo_M[:] .+ A_novo[i,:];
            funkcija_M = funkcija_M .+ b_novo[i];
        else
            tmp_kolona = zeros(redova,1);
            tmp_kolona[i] = 1;
            A_novo = [A_novo tmp_kolona];
            c_novo_M =[c_novo_M -1];
            c_novo = [c_novo 0];
            base=[base; size(c_novo,2)];
            c_novo_M[:] .= c_novo_M[:] .+ A_novo[i,:];
            funkcija_M = funkcija_M .+ b_novo[i];
        end
    end
    c_novo = [c_novo 0];
    c_novo_M = [c_novo_M funkcija_M];
    ST = [A_novo b_novo'; c_novo_M; c_novo]
    return ST,base
end  