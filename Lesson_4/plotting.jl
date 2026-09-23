using GLMakie
using LaTeXStrings
x = -10:0.1:10



##
fig = Figure()
ax = Axis(fig[1,1], title="Plot example", xlabel = "Time, [s]", ylabel = L"\text{Amplitude, }[m^2]")
# sl_amp = Slider(fig[1, 2], range=-10:0.1:10, startvalue = 0, horizontal = false)
# sl_pha = Slider(fig[2, 1], range=-π:0.1:π, startvalue = 0, horizontal = true)

# x1 = x[1:5:end]
# y = lift(sl_amp.value, sl_pha.value) do amplitude, phase
#     amplitude*sin.(x .+ phase)
# end

# y1 = lift(sl_amp.value, sl_pha.value) do amplitude, phase
#     amplitude*sin.(x1 .+ phase)
# end
phase = Observable(0.0)

y = lift(phase) do phase_
    sin.(x .+ phase_)
end

y1 = lift(phase) do phase_
    sin.(x1 .+ phase_)
end


lines!(ax, x, y, label="sin")
scatter!(ax, x1, y1, color=x, markersize=20)
axislegend(ax)
ylims!(ax, [-10, 10])

framerate = 30
phase_iterator = -π:0.02:π
nframes = length(phase_iterator)

record(fig, "animation.mp4", phase_iterator;
        framerate = framerate) do phase_
    phase[] = phase_;
end
# xlims!(ax, [-1, 1])
fig



