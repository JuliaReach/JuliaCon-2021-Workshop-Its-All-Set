## It's all Set: A hands-on introduction to JuliaReach

Workshop proposal for JuliaCon 2021.

## Abstract

JuliaReach is among the best-of-breed software addressing the fundamental problem of reachability analysis: computing the set of states that are reachable by a dynamical system from all initial states and for all admissible inputs and parameters. We explain the role of Julia's multiple dispatch to gain an unprecedented level of flexibility and expressiveness in this area. We explore diverse applications including differential equations, hybrid systems and neural network controlled systems.

## Description

We present [JuliaReach](https://github.com/JuliaReach), a Julia ecosystem to perform reachability analysis of dynamical systems. JuliaReach builds on sound scientific approaches and was, in two occasions (2018 and 2020) the winner of the annual friendly competition on Applied Verification for Continuous and Hybrid Systems ([ARCH-COMP](https://cps-vo.org/group/ARCH)).

The workshop consists of three parts (respectively packages) in [JuliaReach](https://github.com/JuliaReach): our core package for set representations, our main package for reachability analysis, and a new package applying reachability analysis with potential use in domain of control, robotics and autonomous systems.

In the first part we present [LazySets.jl](https://github.com/JuliaReach/LazySets.jl), which provides ways to symbolically represent sets of points as geometric shapes, with a special focus on convex sets and polyhedral approximations. [LazySets.jl](https://github.com/JuliaReach/LazySets.jl) provides methods to apply common set operations, convert between different set representations, and efficiently compute with sets in high dimensions.

In the second part we present [ReachabilityAnalysis.jl](https://github.com/JuliaReach/ReachabilityAnalysis.jl), which provides tools to approximate the set of reachable states of systems with both continuous and mixed discrete-continuous dynamics, also known as hybrid systems. It implements conservative discretization and set-propagation techniques at the state-of-the-art.

In the third part we present [NeuralNetworkAnalysis.jl](https://github.com/JuliaReach/NeuralNetworkAnalysis.jl), which is an application of [ReachabilityAnalysis.jl](https://github.com/JuliaReach/ReachabilityAnalysis.jl) to analyze dynamical systems that are controlled by neural networks. This package can be used to validate or invalidate specifications, for instance about the safety of such systems.

### Meet the team of researchers and students that form the [JuliaReach](http://juliareach.com) network:

- [Luis Benet](https://github.com/lbenet). Universidad Nacional Autónoma de México. *Validated integration, Nonlinear Physics.* He is also one of the lead developers of [JuliaIntervals](https://github.com/JuliaIntervals).

- [Marcelo Forets](https://github.com/mforets). Universidad de la República, Uruguay. *Reachability Analysis, Hybrid Systems, Neural Network Robustness.*

- [Daniel Freire Caporale](https://github.com/dfcaporale). Universidad de la República, Uruguay. *Reachability, PDEs, Fluid Mechanics.*

- [Sebastian Guadalupe](https://github.com/sebastianguadalupe). Universidad de la República, Uruguay. *Julia Seasons of Contributions 2020 Alumni. Mathematical Modeling, Hybrid systems.*

- [Uziel Linares](https://github.com/uziellinares). Universidad Nacional Autónoma de México. *Google Summer of Code 2020 Alumni. Nonlinear reachability, Taylor models.*

- [Jorge Pérez Zerpa](https://github.com/jorgepz). Universidad de la República, Uruguay. *Finite Element Method, Structural Engineering, Material Identification.*

- [David P. Sanders](https://github.com/dpsanders). Universidad Nacional Autónoma de México and visiting professor at MIT. *Computational Science, Interval Arithmetic, and Numeric-symbolic Computing.* He is also one of the lead developers of [JuliaIntervals](https://github.com/JuliaIntervals).

- [Christian Schilling](https://github.com/schillic). University of Konstanz, Germany. *Formal Verification, Artificial Intelligence, Cyber-Physical Systems.*
