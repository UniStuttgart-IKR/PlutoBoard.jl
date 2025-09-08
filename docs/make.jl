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
    # "JavaScript API" => "javascript.md",
    "JavaScript API Reference" => "jsdoc.md",
]

makedocs(
    sitename="PlutoBoard.jl",
    pages=PAGES,
    remotes=nothing,  # Disable remote source links
)

github_repo = get(ENV, "GITHUB_REPOSITORY", "")
username = split(github_repo, "/")[1]

deploydocs(
    repo="github.com/$username/PlutoBoard.jl.git",
)
