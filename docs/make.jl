push!(LOAD_PATH, "../src/")

using Documenter, PlutoBoard
using HTTP.WebSockets
using HTTP

PAGES = [
    "Getting started" => "index.md",
    "Adding Pluto Cells" => "cells.md",
    "Reactivity" => "reactivity.md",
    "Using Vite" => "vite.md",
    "Plugins" => "plugins.md",
    "Interface" => "interface.md",
    "Internal" => "internal.md",
]

makedocs(
    sitename="PlutoBoard.jl",
    pages=PAGES,
)

github_repo = get(ENV, "GITHUB_REPOSITORY", "")
username = split(github_repo, "/")[1]

deploydocs(
    repo="github.com/$username/PlutoBoard.jl.git",
)
