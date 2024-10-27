# OOI Lab 1, Zadatak 1 za bodove
# Radili:
# Edis Jasarevic 19247
# Mersid Pilipovic 19070

# U entry fieldove unesite ili broj ili matricu!
# Matricu unosite u formatu npr. [[3,2,1],[6,5,4]]
# ako argumenti nemaju iste dimenzije, rezultati ce biti 0

using Pkg
Pkg.add("Gtk")
using Gtk

function zbir_razlika(x=0,y=0)
    if (size(x)===size(y))
        x + y, x-y
    else 
        return (0,0)
    end
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
        return parse(Float64, input_string)
    end
end

function on_button_click(button, entry1, entry2, result_label)
    arg1 = parse_input(Gtk.get_gtk_property(entry1,:text,String))
    arg2 = parse_input(Gtk.get_gtk_property(entry2,:text,String))
    zbir,razlika = zbir_razlika(arg1,arg2)
    GAccessor.text(result_label,"Zbir: $zbir, \n Razlika: $razlika")
end

function create_gui()
    window = Gtk.Window("ZBIR RAZLIKA GUI",500,400)  
    vbox = Gtk.Box(:v)

    entry1 = Gtk.Entry()
    entry2 = Gtk.Entry()
    button = Gtk.Button("Racunaj")
    result_label = Gtk.Label("Result: ")

    Gtk.signal_connect(button, "clicked") do widget
        on_button_click(widget, entry1, entry2, result_label)
    end
    
    push!(vbox, entry1)
    push!(vbox, entry2)
    push!(vbox, button)
    push!(vbox, result_label)
    push!(window, vbox)
    
    showall(window)
end

create_gui()
