module PlutoBoard

using Pluto
using HypertextLiteral
using JSON
using TOML
using HTTP
using HTTP.WebSockets
using UUIDs

include("InterfaceFunctions.jl")
include("LoadHTML.jl")
include("Utilities.jl")
include("jscommands/HandleCommands.jl")
include("static/javascript/JSDocs.jl")
include("EditCells.jl")
include("fileserver/FileServer.jl")
include("websocket/WebSocket.jl")
include("plugins/LoadPlugin.jl")


const plutoboard_filepath = dirname(dirname(pathof(PlutoBoard)))
const config = TOML.parsefile(plutoboard_filepath * "/config/config.toml")


html_path::Union{String,Nothing} = nothing
css_path::Union{String,Nothing} = nothing
hide_notebook::Bool = true

scripts_urls::Array{String} = []
stylesheet_urls::Array{String} = []

fileserver = nothing
websocket = nothing

const SERVE_DIR = joinpath(pwd(), "static")

# Plugins
js_files_to_load::Array{String} = []

end

export PlutoBoard
