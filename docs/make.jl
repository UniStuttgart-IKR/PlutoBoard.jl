push!(LOAD_PATH, "../src/")

using Documenter, PlutoBoard

makedocs(sitename = "PlutoBoard.jl")

github_repo = get(ENV, "GITHUB_REPOSITORY", "")
username = split(github_repo, "/")[1]

deploydocs(
    repo = "github.com/$username/PlutoBoard.jl.git",
)