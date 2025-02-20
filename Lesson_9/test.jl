using .RKDiff
using PyPlot
using LinearAlgebra
#dy/dt = a*y
a = 3.4
myfun(t, y) = a * y;
solution(t) = exp(a * t)
t0 = 0
tend = 10;
nn =  1:5 
err_e = [];
err_rk = Vector{Float64}(undef, length(nn));
err_rk45 = [];
for (i,n) in enumerate(nn)

    dt = 0.1^n
    T = t0:dt:tend
    y_e = euler(myfun, 1.0, [t0, tend], dt)
    y_rk = rk23(myfun, 1.0, [t0, tend], dt)
    push!(err_e, solution(tend) - y_e[end]);
    err_rk[i] = solution(tend) - y_rk[end];
    y_rk45 = rk45(myfun, 1.0, [t0, tend], dt);
    push!(err_rk45, solution(tend) - y_rk45[end]);
end

plot(0.1 .^ nn, err_e, label="euler")
plot(0.1 .^ nn, err_rk, label="rk23")
plot(0.1 .^ nn, err_rk45, label="rk45")
yscale("log")
xscale("log")
legend()