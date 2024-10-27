# OOI Lab 1, Zadatak 2 za bodove
# Radili:
# Edis Jasarevic 19247
# Mersid Pilipovic 19070

# U entry field unesite ili broj ili matricu!
# Matricu unosite u formatu npr. [[3,2,1],[6,5,4]]
using Pkg
Pkg.add("Gtk")
using Gtk

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

function parse_input(input_string::String)
    if startswith(input_string, "[") && endswith(input_string, "]")
        matrix_string = input_string[2:end-1]
        rows = split(matrix_string, "],[")
        matrix = []
        for row in rows
            clean_row = strip(row, ['[', ']', ' '])
            columns = split(clean_row, ",")
            push!(matrix, parse.(Float64, columns))
        end
        return hcat(matrix...)
    else
        return 0
    end
end

function on_button_click(button, entry, result_label)
    arg = parse_input(Gtk.get_gtk_property(entry,:text,String))
    suma_matrice,suma_redova,suma_kolona, suma_dijagonale1, suma_dijagonale2 = sume_matrice(arg)
    GAccessor.text(result_label,"Ukupna suma: $suma_matrice, \nRedovi: $suma_redova, \nKolone: $suma_kolona, \nGlavna dijagonala: $suma_dijagonale1, \nSporedna dijagonala: $suma_dijagonale2 ")
end


function create_gui()
    window = Gtk.Window("Sume matrice GUI",500,400)  
    vbox = Gtk.Box(:v)
    
    entry = Gtk.Entry()
    button = Gtk.Button("Racunaj")
    result_label = Gtk.Label("Rezultat: ")

    Gtk.signal_connect(button, "clicked") do widget
        on_button_click(widget, entry, result_label)
    end
    
    push!(vbox, entry)
    push!(vbox, button)
    push!(vbox, result_label)
    push!(window, vbox)
    
    showall(window)
end

create_gui()
