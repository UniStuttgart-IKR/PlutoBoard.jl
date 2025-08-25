module JuliaCon

using PlutoBoard
using Distributions

include("Main.jl")

samples_len::Int64 = 0
first_sample = [0, 0]
last_sample = [0,0]
samples = [[0,0]]

function get_cube(num; ws)
    for i in 1:50
        PlutoBoard.send_to_ws(ws, i / 50)
        sleep(0.05)
    end

    return num^3
end

function get_2d_samples(n_samples::Int, mean_x::Real=0.0, mean_y::Real=0.0, var_x::Real=1.0, var_y::Real=1.0)
    d = MvNormal([mean_x, mean_y], [var_x 0; 0 var_y])
    samples = rand(d, n_samples)
    JuliaCon.samples = [[samples[1, i], samples[2, i]] for i in 1:n_samples]

    JuliaCon.first_sample = samples[1]
    JuliaCon.last_sample = samples[end]
    JuliaCon.samples_len = length(JuliaCon.samples)
    return JuliaCon.samples
end


end

