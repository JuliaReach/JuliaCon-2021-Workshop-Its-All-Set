using ReachabilityAnalysis, Plots
using TaylorModels

function lotkavolterra!(dx, x, params, t)
     α, β, γ, δ = params

    dx[1] = α * x[1] - β * x[1] * x[2]
    dx[2] = δ * x[1] * x[2] - γ * x[2]
    return dx
end

X0 = (4.8 .. 5.2) × (1.8 .. 2.2)
prob = @ivp(x' = lotkavolterra!(x), dim=2, x(0) ∈ X0)

params = [1.5, 1.0, 3.0, 1.0]
sol = solve(prob, T=8.0, alg=TMJets(), params=params);

orderQ = 2
orderT = 8
x = set_variables("x y", order=orderQ)

p1 = 5.2 + 0.2(x[1] - 1)
p2 = 0.4*x[1]^2 + 1.8

remm = t0 = tdom = interval(0)

S = [TaylorModel1(Taylor1(pol, orderT), remm, t0, tdom) for pol in [p1, p2]]
T0 = TaylorModelReachSet(S, interval(0));
H = overapproximate(T0, Hyperrectangle, ntdiv=1, nsdiv=100)

fig = plot()
plot!(fig, X0, leg=:top, lab="X0")
plot!(fig, H, vars=(1, 2), c=:orange, lab="Parabola (normalized TM)")
plot!(fig, range(4, 6, length=500), x -> 10x^2 - 100x + 251.8, c=:black, lw=2.0, lab="")

xlims!(4.75, 5.25)
ylims!(1.75, 2.2)

savefig(fig, "lv_parabola_init.png")

prob = @ivp(x' = lotkavolterra!(x), dim=2, x(0) ∈ T0)

params = [1.5, 1.0, 3.0, 1.0]
sol_para = solve(prob, T=8.0, alg=TMJets(orderQ=orderQ, orderT=orderT), params=params);

Hpara = [overapproximate(R, Hyperrectangle, ntdiv=10, nsdiv=80) for R in sol_para];

fig = plot(title="Propagation of parabola through the L-V equations")
[plot!(fig, Hpara[i], vars=(1, 2), lw=0.0) for i in 1:length(Hpara)];
savefig(fig, "lv_parabola_all.png")
