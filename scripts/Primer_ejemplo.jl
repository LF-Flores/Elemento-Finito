### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ fab5c9e4-f9e4-11ea-0ab8-17db5563ed64
begin
	using QuadGK
	using Plots
end;

# ╔═╡ f4e899c6-fd02-11ea-349c-152ac2e1e854
md"# Ejemplo 1: Espacio de polinomios de grado a lo más $k$ para aproximar funciones continuas"

# ╔═╡ eb3fb754-fd02-11ea-3044-d957c8454a5e
md"Se cargarán los siguientes paquetes:
* **QuadGK:** Paquete de integración numérica en una dimensión. ver documentación en [aquí](https://juliamath.github.io/QuadGK.jl/stable/)
* **Plots:** Paquete para gráficos con diversos backends, en particular Plotly. Ver documentación de `Plots` [aquí](http://docs.juliaplots.org/latest/)"

# ╔═╡ 4838e58e-fd03-11ea-2944-c73d314c8702
md"Se definen los elementos de la base de nuestro espacio de Polinomios, $P^k[a,b]$, sobre el intervalo $[a,b]$. Éstos serán monomios de cada grado hasta el $k$-ésimo:"

# ╔═╡ 328a50c6-f9f5-11ea-3419-854805c77da8
ϕ(x,j) = x^(j+1);

# ╔═╡ 826aaddc-fd03-11ea-19b0-55b6f5e9d3dd
md"Describimos las entradas y salidas del algoritmo:
* **Entradas:** Tenemos la función $f$ a aproximar, el grado $k$ máximo de polinomio aproximante a utilizar, y el inicio y final del intervalo $[a,b]$ dónde aproximar
* **Salidas:** Retornaremos un vector de coeficientes, $\alpha$, determinado como solución al sistema lineal $A\alpha = b^f$, donde $b^f \in R^{k+1}$ es un vector de proyecciones de la función hacia nuestra base y la matriz $A \in R^{(k+1) \times (k+1)}$ contiene los productos internos por pares que de nuestros elementos de base $\phi_i$.
El algoritmo consiste en rellenar iterativamente el vector y matriz antes mencionados y resolver el sistema lineal."

# ╔═╡ dbc3b9b2-f9d6-11ea-044a-a30a981307a2
function α(f, k, a, b)
	A = zeros(k+1, k+1); bᶠ = zeros(k+1);
	ϕϕ(x,i,j) = ϕ(x,i)*ϕ(x,j);
	ϕf(x,j) = f(x)*ϕ(x,j);
	for i ∈ 1:k+1, j ∈ 1:k+1
		A[i,j] = quadgk(x -> ϕϕ.(x,i,j), a, b)[1];
		bᶠ[j] = quadgk(x -> ϕf.(x,j), a, b)[1];
	end
	return(A\bᶠ)
end;

# ╔═╡ e7d62f6a-fd04-11ea-03d5-4f551a2132c9
md"La siguiente celda define un ejemplo particular de ejecución del algoritmo para aproximar la función $\sin(x)$ sobre el intervalo $[0,10]$ con distintos grados $k$ de polinomios."

# ╔═╡ 9fcfbb82-f9e9-11ea-1301-03bb1c7de274
const a = 0.0; const b = 10.0;

# ╔═╡ 2791c470-fd05-11ea-11cc-75941ddfb41b
md"Para ello, $k$ se ha fijado a un deslizante entre 0 y 10. Esto puede que solo funcione cargando el Pluto notebook de manera local y no en el HTML estático:"

# ╔═╡ 1f1ddde2-fd05-11ea-2486-cffb9553aa20
@bind k html"k = 0 <input type=range min=1 max=10 step=1> 10"

# ╔═╡ 5ae8f820-fd05-11ea-1a21-893c07375fc8
md"Guardamos una función que calcule el polinomio aproximante, $p_f(x)$, de $f$ mediante la combinación lineal de los elemento de la base $\{\phi_j\}_{j=0}^k$ de $P^k[a,b]$. Es decir, calculamos: $p_f(x) = \sum_{j=0}^k \alpha_j \phi_j(x)$"

# ╔═╡ 1afebcbe-f9eb-11ea-27b5-d5a8be772c32
approx(f,x) = sum(α(f, k, a, b).*ϕ.(x, 1:k+1));

# ╔═╡ 8dcc0542-fd06-11ea-3b19-a1922e7dde34
md"Graficamos el resultado de la aproximación al par de la funciín $\sin(x)$ exacta."

# ╔═╡ 49ee9618-f9ea-11ea-37b3-afcacf5a15a6
begin
	plot(x -> approx(sin, x), a:0.1:b, label = "Approximation")
	plot!(sin, a:0.1:b, label = "sin(x)")
end

# ╔═╡ Cell order:
# ╟─f4e899c6-fd02-11ea-349c-152ac2e1e854
# ╟─eb3fb754-fd02-11ea-3044-d957c8454a5e
# ╠═fab5c9e4-f9e4-11ea-0ab8-17db5563ed64
# ╟─4838e58e-fd03-11ea-2944-c73d314c8702
# ╠═328a50c6-f9f5-11ea-3419-854805c77da8
# ╟─826aaddc-fd03-11ea-19b0-55b6f5e9d3dd
# ╠═dbc3b9b2-f9d6-11ea-044a-a30a981307a2
# ╟─e7d62f6a-fd04-11ea-03d5-4f551a2132c9
# ╠═9fcfbb82-f9e9-11ea-1301-03bb1c7de274
# ╟─2791c470-fd05-11ea-11cc-75941ddfb41b
# ╟─1f1ddde2-fd05-11ea-2486-cffb9553aa20
# ╟─5ae8f820-fd05-11ea-1a21-893c07375fc8
# ╠═1afebcbe-f9eb-11ea-27b5-d5a8be772c32
# ╟─8dcc0542-fd06-11ea-3b19-a1922e7dde34
# ╠═49ee9618-f9ea-11ea-37b3-afcacf5a15a6
