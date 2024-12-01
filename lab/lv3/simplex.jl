using LinearAlgebra


function max_u_zadnjem_redu(simplex_tabela, m)

  zadnji_red = simplex_tabela[size(simplex_tabela, 1), :]
  max = zadnji_red[2] # preskacemo 1 jer je funkcija cilja
  vodeca_kolona = 2 # preskacemo 1 jer su u prvoj koloni ogranicenja
  for i = 2:size(zadnji_red, 1)
    if (zadnji_red[i] > max)
      max = zadnji_red[i]
      vodeca_kolona = i
    end
  end
  return max, vodeca_kolona
end

function is_equal(A::Float64,B::Float64,epsilon::Float64=1.0e-10)
  if abs( A - B ) <= epsilon
      return true
  else
      return false
  end
end

function rijesi_simplex(A, b, c)
  # A - matrica, c funkcija cilja VEKTOR, b granice VEKTOR
  k = size(A, 2)
  l = size(c, 1)
  if (size(b, 2) != 1 || size(c, 2) != 1 || size(A, 2) > size(c, 1))      
    return "Neispravan unos ulaznih parametara"
  end
  # FORMIRANJE simpleks tabele
  simplex_tabela = Int[]
  simplex_tabela = reshape(b, :, 1)
  simplex_tabela = hcat(simplex_tabela, A)
  m = size(A, 1)
  n = size(A, 2)
  base = zeros(m)
  for i = 1:m
    base[i] = n + i
  end

  dopunske = Matrix(1.0I, size(b, 1), size(b, 1)) ## matrica identiteta I
  simplex_tabela = hcat(simplex_tabela, dopunske)

  zadnji_red = append!([0], c, zeros(size(b, 1)))
  simplex_tabela = vcat(simplex_tabela, transpose(zadnji_red))

  c_max = 1
  # Provjera da li je rjesenje neograniceno

  for i = 2:size(simplex_tabela, 2)
    x = findmax(simplex_tabela[1:(end-1), i])[1]
    if (x <= 0 && zadnji_red[i]>0)
      return "Rjesenje je neograniceno"
    end
  end

  while (c_max > 0)
    display(simplex_tabela)
    rezultat = max_u_zadnjem_redu(simplex_tabela, m)
    c_max = rezultat[1]
    vodeca_kolona = rezultat[2]
    if (c_max <= 0)
      break
    end
    #trazimo vodeci red p

    # Kreiranje vektora kolicnika
    vektor_kolicnika = zeros(0)
    for i = 1:m
      if (simplex_tabela[i, vodeca_kolona] > 0)
        push!(vektor_kolicnika, simplex_tabela[i, 1] / simplex_tabela[i, vodeca_kolona])
      elseif (simplex_tabela[i, vodeca_kolona] < 0)
        push!(vektor_kolicnika, -1)
      end
    end

    tmax = vektor_kolicnika[1]
    vodeci_red = 1 ## prvi xi kolona
    for i = 1:size(vektor_kolicnika, 1)
      if (vektor_kolicnika[i] >= 0) 
      random_broj=rand(1:10) ##Za degenerisano 
        if ((vektor_kolicnika[i] < tmax || tmax == -1) || (is_equal(vektor_kolicnika[i],tmax) && random_broj>5))
          tmax = vektor_kolicnika[i]
          vodeci_red = i
        end
      end
    end

    base[vodeci_red] = vodeca_kolona - 1
    pivot = simplex_tabela[vodeci_red, vodeca_kolona]
    for j = 1:size(simplex_tabela, 2)
      simplex_tabela[vodeci_red, j] = simplex_tabela[vodeci_red, j] / pivot
    end

    for i = 1:size(simplex_tabela, 1)
      if (i != vodeci_red)
        faktor = simplex_tabela[i, vodeca_kolona]
        for j = 1:size(simplex_tabela, 2)
          simplex_tabela[i, j] = simplex_tabela[i, j] - faktor * simplex_tabela[vodeci_red, j]
        end
      end
    end
  end

  optimalno_rjesenje = zeros(size(simplex_tabela, 2) - 1)

  for i = 1:size(base, 1)
    optimalno_rjesenje[Int(base[i])] = simplex_tabela[i, 1]
  end
  ##round.(optimalnoRjesenje, digits=3) ## Da ispis stane u jedan red ekrana - NE radi iz nekog razloga
  return "Optimalno rjesenje je X=", optimalno_rjesenje, "^T Vrijednost funkcije cilja Z=", -simplex_tabela[size(base, 1)+1, 1]

end

println("1. Test: ", rijesi_simplex([2 2 2; 2 3 1; 0 1 1;], [4,2,3], [2,3,1])) # 40 stranica predavanja
println("2. Test: ", rijesi_simplex([-2 1; 0 1], [1, 3], [1, 2])) # Neograniceno rjesenje
println("4. Test: ", rijesi_simplex([0.25 -8 -1 9; 0.5 -12 -0.5 3; 0 0 1 0], [0, 0, 1], [3, -80, 2, -24])) # Degenerirano rješenje

