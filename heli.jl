using ReachabilityModels
using Plots
using Colors

ivp = load_model("helicopter")

function figure_heli_extremes(var; xlab="Time", ylab="x₅ (yaw rate r)")
    fig = plot(xlab=xlab, ylab=ylab, title="Controlled Helicopter model (2²⁸ corner cases)")

    T = 10.0
    alg = LGG09(δ=1e-3, vars=var[2], dim=28, approx_model=Forward())
    sol = solve(ivp, T=T, alg=alg);
    plot!(fig, sol, vars=var, lw=0.0, c=:red, alpha=1., lab="Non-deterministic inputs")

    # keep homogeneous part, to compare with simulations
    ivph = @ivp(x' = ivp.s.A * x, x(0) ∈ ivp.x0);
    sysh = system(ivph)
    solh = solve(ivph, T=10.0, alg=alg);
    plot!(fig, solh, vars=var, lw=0.0, c=:blue, alpha=1., lab="Constant inputs")

    max_yaw_simu = []
    ei = zeros(28)
    ei[var[2]] = 1.0

    # high init cond
    δsimu = 1e-3
    x0h = high(ivp.x0)
    sol_simu = solve(IVP(sysh, Singleton(x0h)), T=T, alg=ORBIT(δ=δsimu));
    plot!(fig, sol_simu, vars=var, seriestype=:path, markershape=:none, lw=1.0, c=:black, ls=:dash, lab="Simulation (high X0)")
    push!(max_yaw_simu, ρ(ei, sol_simu))

    # low init cond
    x0l = low(ivp.x0)
    sol_simu = solve(IVP(sysh, Singleton(x0l)), T=T, alg=ORBIT(δ=δsimu));
    plot!(fig, sol_simu, vars=var, seriestype=:path, markershape=:none, lw=1.0, c=:black, ls=:dot, lab="Simulation (low X0)")
    push!(max_yaw_simu, ρ(ei, sol_simu))

    fig, max_yaw_simu
end

function figure_heli_simu(var; xlab="Time", ylab="x₅ (yaw rate r)", trajectories=100)
    fig = plot(xlab=xlab, ylab=ylab, title="Controlled Helicopter model (2²⁸ corner cases)")

    T = 10.0
    alg = LGG09(δ=1e-3, vars=var[2], dim=28, approx_model=Forward())
    sol = solve(ivp, T=T, alg=alg);
    plot!(fig, sol, vars=var, lw=0.0, c=:red, alpha=1., lab="Non-deterministic inputs (1 flowpipe)")

    # keep homogeneous part, to compare with simulations
    ivph = @ivp(x' = ivp.s.A * x, x(0) ∈ ivp.x0);
    sysh = system(ivph)
    solh = solve(ivph, T=10.0, alg=alg);
    plot!(fig, solh, vars=(0, var[2]), lw=0.0, c=:blue, alpha=1., lab="Constant inputs (1 flowpipe)")

    max_simu = []
    ei = zeros(28)
    ei[var[2]] = 1.0

    # high init cond
    δsimu = 1e-3
    x0h = high(ivp.x0)
    sol_simu = solve(IVP(sysh, Singleton(x0h)), T=T, alg=ORBIT(δ=δsimu));
    plot!(fig, sol_simu, vars=var, seriestype=:path, markershape=:none, lw=1.0, c=:black, ls=:dash, lab="Constant inputs ($trajectories simulations)")
    push!(max_simu, ρ(ei, sol_simu))

    # low init cond
    x0l = low(ivp.x0)
    sol_simu = solve(IVP(sysh, Singleton(x0l)), T=T, alg=ORBIT(δ=δsimu));
    plot!(fig, sol_simu, vars=var, seriestype=:path, markershape=:none, lw=1.0, c=:black, ls=:dot, lab="")
    push!(max_simu, ρ(ei, sol_simu))

    c = distinguishable_colors(trajectories);

    for i in 1:trajectories
        xx0 = LazySets.sample(ivp.x0)
        sol_simu = solve(IVP(sysh, xx0), T=T, alg=ORBIT(δ=δsimu))
        plot!(fig, sol_simu, vars=var, seriestype=:path, markershape=:none, lw=0.5, c=c[i], alpha=1., lab="")
        push!(max_simu, ρ(ei, sol_simu))
    end

    fig, max_simu
end

# =================
# Generate plots
# =================

trajectories = 500

var = (0, 5)
fig, _ = figure_heli_extremes(var)
savefig(fig, "heli_05_extremes.png")

# save information about max values
fig, _ = figure_heli_simu(var, trajectories=trajectories)
savefig(fig, "heli_05_simu.png")

# ------------

var = (0, 6)
fig, _ = figure_heli_extremes(var, ylab="Forward velocity (vx)")
savefig(fig, "heli_06_extremes.png")

# save information about max values
fig, _ = figure_heli_simu(var, ylab="Forward velocity (vx)", trajectories=trajectories)
savefig(fig, "heli_06_simu.png")

# ------------

var = (0, 8)
fig, _ = figure_heli_extremes(var, ylab="Vertical velocity (vz)")
savefig(fig, "heli_08_extremes.png")

# save information about max values
fig, _ = figure_heli_simu(var, ylab="Vertical velocity (vz)", trajectories=trajectories)
savefig(fig, "heli_08_simu.png")

# ------------

var = (0, 4)
fig, _ = figure_heli_extremes(var, ylab="Pitch rate (q)")
savefig(fig, "heli_04_extremes.png")

# save information about max values
fig, _ = figure_heli_simu(var, ylab="Pitch rate (q)", trajectories=trajectories)
savefig(fig, "heli_04_simu.png")
