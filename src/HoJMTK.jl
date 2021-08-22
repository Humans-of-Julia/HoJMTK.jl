module HoJMTK

using Reexport
@reexport using ModelingToolkit
@reexport using DifferentialEquations

@parameters t

const D = Differential(t)

include("Electrical/Electrical.jl")

export t, D
end