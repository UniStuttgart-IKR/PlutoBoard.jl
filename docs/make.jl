push!(LOAD_PATH, "../src/")

using Documenter, PlutoBoard

makedocs(sitename = "PlutoBoard.jl")

deploydocs(
    repo = "github.com/Niels1006/PlutoBoard.jl.git",
)