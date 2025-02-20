module RKDiff

export euler;
export rk23


function euler(f::Function, y0::Float64, tspan::AbstractVector{<:Number}, dt::Float64)::Vector{Float64}
    T = tspan[1]:dt:tspan[2]
    y = Vector{Float64}(undef, length(T))
    y[1] = y0
    for i in eachindex(T)[2:end]
        y[i] = y[i-1] + dt * f(T[i-1], y[i-1])
    end
    return y;
end


function rk23(f::Function, y0::Float64, tspan::AbstractVector{<:Number}, dt::Float64)::Vector{Float64}
    T = tspan[1]:dt:tspan[2]
    y = Vector{Float64}(undef, length(T))
    y[1] = y0
    for i in eachindex(T)[2:end] 
        ỹ = y[i-1] + dt * f(T[i-1], y[i-1])
        y[i] = y[i-1] + dt * ((f(T[i-1], y[i-1]) + f(T[i], ỹ))/2)
        #ỹ =  y[i]
        #y[i] = y[i-1] + dt * ((f(T[i-1], y[i-1]) + f(T[i], ỹ))/2)
    end
    return y;
end


end
