using ReachabilityAnalysis
using Plots
using Colors

logocolors = Colors.JULIA_LOGO_COLORS

x = 0.4    # parameter to change the separation of the balls
c = 3.0    # parameter to change the position of the balls

# define the center of each ball
V = VPolytope([[c-x, 0, 0, 0, 0], [c+x, 0, 0, 0, 0], [c, x*sqrt(3), 0, 0, 0]])

# define a ball in the 2-norm
Bcolors = [Ball2(v, 0.1) for v in vertices_list(V)]

# polygonal approximation
ndirs = 100
X0red, X0purple, X0green = [overapproximate(Projection(Bi, 1:2), PolarDirections(ndirs)) for Bi in Bcolors]

plot(X0red, c=logocolors.red, alpha=1.)
plot!(X0green, c=logocolors.green, alpha=1.)
plot!(X0purple, c=logocolors.purple, alpha=1., ratio=1.)

# example from LGG09
D = [-1 -4 0 0 0; 4 -1 0 0 0; 0 0 -3 1 0; 0 0 -1 -3 0; 0 0 0 0 -2]
P = [0.6 -0.1 0.1 0.7 -0.2; -0.5 0.7 -0.1 -0.8 0; 0.9 -0.5 0.3 -0.6 0.1; 0.5 -0.7 0.5 0.6 0.3; 0.8 0.7 0.6 -0.3 0.2]
A = P * D * inv(P)

# Id = Matrix(1.0I, 5, 5)
# U = BallInf(zeros(5), 0.05)
# prob = @ivp(x' = A*x + Id*u, x(0) ∈ Bcolors, x ∈ Universe(5), u ∈ U);
prob = @ivp(x' = A*x, x(0) ∈ Bcolors)

dirs_12 = PolarDirections(ndirs)
template = Vector{Vector{Float64}}(undef, length(dirs_12))
for (i, d) in enumerate(dirs_12)
    template[i] = vcat(d, zeros(3))
end

alg = LGG09(δ=0.01, template=template)
@time sol_julia = solve(prob, alg=alg, T=5.0);


# we compute trajectories as well
using DifferentialEquations

# remake due to a current limitation of solving with distributed initial states
sol_ensemble = []
for x0 in [X0red, X0green, X0purple]
    _sol = solve(IVP(prob.s, x0 × ZeroSet(3)), alg=BOX(δ=1.0), T=5.0, ensemble=true, trajectories=50);
    push!(sol_ensemble, ensemble(_sol))
end

sol_julia_1 = [ReachSet(overapproximate(Projection(set(R), 1:2), 1e-3), tspan(R)) for R in sol_julia[1]];
sol_julia_2 = [ReachSet(overapproximate(Projection(set(R), 1:2), 1e-3), tspan(R)) for R in sol_julia[2]];
sol_julia_3 = [ReachSet(overapproximate(Projection(set(R), 1:2), 1e-3), tspan(R)) for R in sol_julia[3]];

fig1 = plot(xlab="time")

# flowpipes
plot!(fig1, sol_julia_1, vars=(0, 1), c=logocolors.red, alpha=1., lw=0.5, lc=logocolors.red)
plot!(fig1, sol_julia_2, vars=(0, 1), c=logocolors.green, alpha=1., lw=0.5, lc=logocolors.green)
plot!(fig1, sol_julia_3, vars=(0, 1), c=logocolors.purple, alpha=1., lw=0.5, lc=logocolors.purple)

plot!(fig1, sol_julia_1, vars=(0, 2), c=logocolors.red, alpha=1., lw=0.5, lc=logocolors.red)
plot!(fig1, sol_julia_2, vars=(0, 2), c=logocolors.green, alpha=1., lw=0.5, lc=logocolors.green)
plot!(fig1, sol_julia_3, vars=(0, 2), c=logocolors.purple, alpha=1., lw=0.5, lc=logocolors.purple)

# ensemble simulations
plot!(fig1, sol_ensemble[1], vars=(0, 1), c=:black, lw=0.2)
plot!(fig1, sol_ensemble[2], vars=(0, 1), c=:black, lw=0.2)
plot!(fig1, sol_ensemble[3], vars=(0, 1), c=:black, lw=0.2)

plot!(fig1, sol_ensemble[1], vars=(0, 2), c=:black, lw=0.2)
plot!(fig1, sol_ensemble[2], vars=(0, 2), c=:black, lw=0.2)
plot!(fig1, sol_ensemble[3], vars=(0, 2), c=:black, lw=0.2)

savefig(fig1, "julia_logo_0.png")
savefig(fig1, "julia_logo_0.pdf")

fig2 = plot(xlab="x₁(t)", ylab="x₂(t)", ratio=1.)

# flowpipes
plot!(fig2, sol_julia_2, vars=(1, 2), c=logocolors.green, alpha=1., lw=0.5, lc=logocolors.green)
plot!(fig2, sol_julia_3, vars=(1, 2), c=logocolors.purple, alpha=1., lw=0.5, lc=logocolors.purple)
plot!(fig2, sol_julia_1, vars=(1, 2), c=logocolors.red, alpha=1., lw=0.5, lc=logocolors.red)

# initial sets
plot!(fig2, X0green, alpha=0.1, lw=2.0, c=logocolors.green, lc=logocolors.green)
plot!(fig2, X0purple, alpha=0.1, lw=2.0, c=logocolors.purple, lc=logocolors.purple)
plot!(fig2, X0red, alpha=0.1, lw=2.0, c=logocolors.red, lc=logocolors.red)

# ensemble simulations
plot!(fig2, sol_ensemble[2], vars=(1, 2), c=:black, lw=0.2)
plot!(fig2, sol_ensemble[3], vars=(1, 2), c=:black, lw=0.2)
plot!(fig2, sol_ensemble[1], vars=(1, 2), c=:black, lw=0.2)

savefig(fig2, "julia_logo_12.png")
savefig(fig2, "julia_logo_12.pdf")
