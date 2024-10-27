# OOI Lab 1, Zadatak 3 za bodove
# Radili:
# Edis Jasarevic 19247
# Mersid Pilipovic 19070

# Unesite funkciju npr. x.^2 sin.(x) i kliknite Racunaj, da se prikaze grafik
using Pkg
Pkg.add("Gtk")
Pkg.add("Cairo")
using Gtk
using Plots
using Cairo
using Gtk

function crtaj(s::String)
    global x = LinRange(-5,5,100)
    x = [x;];
    y = eval(Meta.parse(s))
    return plot(x,y)
end

const io = PipeBuffer()

function plotStuff(button, can, entry)
    @guarded draw(can) do widget
        ctx = getgc(can)
        show(io, MIME("image/png"),  crtaj(Gtk.get_gtk_property(entry,:text,String)))
        img = read_from_png(io)
        set_source_surface(ctx, img, 0, 0)
        paint(ctx)
    end
end

function plotincanvas()
    win = Gtk.Window("Plotanje funkcije iz stringa", 600, 480) |> (vbox = GtkBox(:v))
    can = GtkCanvas()
    entry = Gtk.Entry()
    button = Gtk.Button("Racunaj")
    push!(vbox, entry)
    push!(vbox, button)
    push!(vbox, can)
    Gtk.signal_connect(button, "clicked") do widget
        plotStuff(widget, can, entry)
    end
    set_gtk_property!(vbox, :expand, can, true)
    showall(win)
    show(can)
end

plotincanvas()

