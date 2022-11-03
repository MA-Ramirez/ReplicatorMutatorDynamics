using DynamicalSystems

"""
    ReplicatorMutatorEqs(du, u, p, t)
Defines the dynamic rule (`f`) for n replicator-mutator equations

The dynamic rule is defined in-place, because it might handle big systems (10 or more dimensions):
f` **must** be in the form `f!(xnew, x, p, t)`
     which means that given a state `x::Vector` and some parameter container `p`,
     the function writes in-place the new state/rate-of-change in `xnew`.
`t` stands for time.
"""

@inline @inbounds function ReplicatorMutatorEqs(du, u, p, t)

    #Input payoff matrix as parameter
    A = p[1]
    #Input mutation matrix as parameter
    Q = p[2]

    #Define vector of variables
    X = []
    for i in 1:n
        push!(X,u[i])
    end

    #Define fitness values
    f = []
    for i in 1:n
        push!(f,(A*X)[i])
    end

    #Average fitness
    Avg = transpose(X)*A*X

    #n replicator-mutator equations
    for i in 1:n
        sum = 0
        for j in 1:n
            sum += X[j]*f[j]*Q[j,i]
        end
        du[i] = sum - X[i]*Avg
    end

    #Output
    return
end
