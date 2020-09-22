### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ ea6441c0-fa0c-11ea-2a5f-49f22959f44f
begin
	using QuadGK
    using Plots
end;

# ╔═╡ 5e91c35e-fc2d-11ea-1997-9d5185bc6e96
md"# Ejemplo 2: Base de polinomios de primer grado, $S_h^k[a,b]$"

# ╔═╡ 40fdf2bc-fc2e-11ea-27d3-a518cc33d66e
md"Se cargarán los siguientes paquetes:
* **QuadGK:** Paquete de integración numérica en una dimensión. ver documentación en [aquí](https://juliamath.github.io/QuadGK.jl/stable/)
* **Plots:** Paquete para gráficos con diversos backends, en particular Plotly. Ver documentación de `Plots` [aquí](http://docs.juliaplots.org/latest/)"

# ╔═╡ cdc4f11e-fc2e-11ea-1adc-1f1e28574a62
md"Por claridad de escritura en el algoritmo principal, se guardan los siguientes procedimientos comunes en simbología matemática: La integral sobre $[0,1]$ (el intervalo elegido para nuestras funciones de referencia $\phi_r$) y la sumatoria."

# ╔═╡ 5947192a-fa12-11ea-3653-05996c1743bc
begin
	∫(f) = quadgk(f,0,1)[1]
	∑(lista) = sum(lista)
end;

# ╔═╡ d6a76d54-fc3d-11ea-27ea-3b5a47f9bbcf
md"Utilizamos a $\phi_1(x) = 1-x$ y $\phi_2(x) = x$ como funciones de referencia, ambas tomando valores del intervalo $[0,1]$ hacia $\mathbb{R}$, para obtener todas las funciones de la base de $S^k_h[a,b]$ mediante la transformación $T_i(x) = x_{i+1}x + x_i(1-x)$ la cual también se define a continuación."

# ╔═╡ 3057bfa8-fa01-11ea-0224-9fc40052f7b9
begin
	ϕ₁(x) = 1-x
	ϕ₂(x) = x
	Tᵢ(xᵢ,xᵢ₊₁,x) = xᵢ₊₁*x + xᵢ*(1-x)
end;

# ╔═╡ 8c534936-fc67-11ea-26aa-f9c888b8f0c2
md"El algoritmo principal consiste en tres partes:
* **Paso 1:** Utilizamos las entradas del algoritmo (la función $f$ y la partición $P$ de algún intervalo) para definir:
  * El número $N$ de puntos en la partición $P$ que a su vez define el número de elementos en nuestra base y por ende el tamaño del vector $d \in \mathbb{R}^N$ y $A \in \mathbb{R}^{N \times N}$
  * La matriz del sistema y vector resultante de la combinación lineal, $A$ y $d$ respectivamente, que se llenarán en la siguiente etapa
  * Funciones auxiliares ($\phi_i*\phi_j, f*\phi_r$ con $i,j,r \in \{1,2\}$) para calcular los productos internos (integrales en este caso) que nos permitirán rellenar a $A$ y $d$.
* **Paso 2:** Se rellenan iterativamente $A$ y $d$. En el caso de $A$, nosotros tenemos su aporte calculado fuera del ciclo de repetición, teniendo que calcular solamente el Jacobiano, $x_{i+1}-x_i$, en cada iteración. Éste se utiliza para el cálculo de $d$, el cual sí requiere calcular do integrales en cada iteración ya que $f*\phi_r$ sí depende de $T_i$.
* **Paso 3:** Se resuelve el sistema lineal $A\alpha = d$, obteniendo así el retorno $\alpha$ de la función."

# ╔═╡ cc44fb2c-fa0d-11ea-0d15-5b5318b63087
function α(f, P)
	N = length(P)
	A = zeros(N,N); d = zeros(N)
	ϕ₁²(x) = ϕ₁(x)^2; ϕ₂²(x) = ϕ₂(x)^2; ϕ₁ϕ₂(x) = ϕ₁(x)ϕ₂(x)
	fϕ₁(xᵢ,xᵢ₊₁,x) = (f∘Tᵢ)(xᵢ,xᵢ₊₁,x)*ϕ₁(x)
	fϕ₂(xᵢ,xᵢ₊₁,x) = (f∘Tᵢ)(xᵢ,xᵢ₊₁,x)*ϕ₂(x)
	aporte_A = [∫(ϕ₁²)  ∫(ϕ₁ϕ₂);
				∫(ϕ₁ϕ₂) ∫(ϕ₂²)]
	for i ∈ 1:N-1
		xᵢ₊₁⁻xᵢ = abs(P[i+1]-P[i])
		A[i:i+1,i:i+1] += (xᵢ₊₁⁻xᵢ)*aporte_A
		d[i:i+1] += (xᵢ₊₁⁻xᵢ)*[∫(x->fϕ₁(P[i],P[i+1],x))
							   ∫(x->fϕ₂(P[i],P[i+1],x))]
	end
	return(A\d)
end;

# ╔═╡ 6bc079d6-fcec-11ea-12c2-b92391328e9c
md"Para ejecutar un ejemplo del algoritmo elegimos los siguientes valores para:
* El intervalo $[a,b]$
* Número de puntos, $N$, que queremos que tenga la partición.
* Los objetos derivados de éstos dos: El tamaño de paso $h$ y la partición $P$ del intervalo $[a,b]$."

# ╔═╡ f92cae14-fc26-11ea-08e7-776b470503ab
const a=0; const b=10; const N = 25; const h = (b-a)/N; P = a:h:b;

# ╔═╡ a9ad3cf0-fcec-11ea-2eba-bb798a7b4b6d
md"Podemos ahora visualizar los valores resultantes de la aproximación (en este caso para $\sin(x)$)..."

# ╔═╡ b0ea580c-faaa-11ea-0c7c-c5bf8dd2595b
α(sin, P)

# ╔═╡ b383030e-fcec-11ea-16e8-bb0bf274259a
md"...O graficarlos en comparación con la función exacta."

# ╔═╡ 0847f150-fa41-11ea-022b-ff06c203b4e7
begin
    plot(P, α(sin, P), label = "Approximation")
    plot!(sin, a:0.05:b, label = "sin(x)")
end

# ╔═╡ Cell order:
# ╟─5e91c35e-fc2d-11ea-1997-9d5185bc6e96
# ╟─40fdf2bc-fc2e-11ea-27d3-a518cc33d66e
# ╠═ea6441c0-fa0c-11ea-2a5f-49f22959f44f
# ╟─cdc4f11e-fc2e-11ea-1adc-1f1e28574a62
# ╠═5947192a-fa12-11ea-3653-05996c1743bc
# ╟─d6a76d54-fc3d-11ea-27ea-3b5a47f9bbcf
# ╠═3057bfa8-fa01-11ea-0224-9fc40052f7b9
# ╟─8c534936-fc67-11ea-26aa-f9c888b8f0c2
# ╠═cc44fb2c-fa0d-11ea-0d15-5b5318b63087
# ╟─6bc079d6-fcec-11ea-12c2-b92391328e9c
# ╠═f92cae14-fc26-11ea-08e7-776b470503ab
# ╟─a9ad3cf0-fcec-11ea-2eba-bb798a7b4b6d
# ╠═b0ea580c-faaa-11ea-0c7c-c5bf8dd2595b
# ╟─b383030e-fcec-11ea-16e8-bb0bf274259a
# ╠═0847f150-fa41-11ea-022b-ff06c203b4e7
