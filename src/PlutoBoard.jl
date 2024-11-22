module PlutoBoard

using HypertextLiteral
using JSON
using TOML
using HTTP
using HTTP.WebSockets
using UUIDs

include("InterfaceFunctions.jl")
include("LoadHTML.jl")
include("Utilities.jl")
include("JSCommands/HandleCommands.jl")
include("../internal/javascript/Dummy.jl")
include("EditCells.jl")

const plutoboard_filepath = dirname(dirname(pathof(PlutoBoard)))
const config = TOML.parsefile(plutoboard_filepath * "/config/config.toml")


html_path::Union{String, Nothing} = nothing
css_path::Union{String, Nothing} = nothing
fullscreen::Bool = true
hide_notebook::Bool = true

scripts_urls::Array{String} = []
stylesheet_urls::Array{String} = []

end

export PlutoBoard
