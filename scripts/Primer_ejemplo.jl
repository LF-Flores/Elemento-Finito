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
end

# ╔═╡ 328a50c6-f9f5-11ea-3419-854805c77da8
ϕ(x,j) = x^(j+1);

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

# ╔═╡ 9fcfbb82-f9e9-11ea-1301-03bb1c7de274
const a = 0.0; const b = 10.0; @bind k html"<input type=range min=1 max=10 step=1>"

# ╔═╡ 1afebcbe-f9eb-11ea-27b5-d5a8be772c32
approx(f,x) = sum(α(f, k, a, b).*ϕ.(x, 1:k+1));

# ╔═╡ 49ee9618-f9ea-11ea-37b3-afcacf5a15a6
begin
	plot(x -> approx(sin, x), a:0.1:b, label = "Approximation")
	plot!(sin, a:0.1:b, label = "sin(x)")
end

# ╔═╡ Cell order:
# ╠═fab5c9e4-f9e4-11ea-0ab8-17db5563ed64
# ╠═328a50c6-f9f5-11ea-3419-854805c77da8
# ╠═dbc3b9b2-f9d6-11ea-044a-a30a981307a2
# ╠═9fcfbb82-f9e9-11ea-1301-03bb1c7de274
# ╠═1afebcbe-f9eb-11ea-27b5-d5a8be772c32
# ╠═49ee9618-f9ea-11ea-37b3-afcacf5a15a6
