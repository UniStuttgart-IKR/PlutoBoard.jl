module PlutoBoard

using Pluto
using HypertextLiteral
using JSON
using TOML
using HTTP
using HTTP.WebSockets
using UUIDs
using FileWatching
using Base.Filesystem
using MacroTools

include("InterfaceFunctions.jl")
include("LoadHTML.jl")
include("Utilities.jl")
include("jscommands/HandleCommands.jl")
include("static/javascript/JSDocs.jl")
include("EditCells.jl")
include("fileserver/FileServer.jl")
include("websocket/WebSocket.jl")
include("plugins/LoadPlugin.jl")
include("HotReload.jl")
include("Expressions.jl")

function __init__()
    global SERVE_DIR = joinpath(pwd(), "static")
end

plutoboard_filepath = dirname(dirname(pathof(PlutoBoard)))
config = TOML.parsefile(plutoboard_filepath * "/config/config.toml")


html_path::Union{String,Nothing} = nothing
css_path::Union{String,Nothing} = nothing
hide_notebook::Bool = true

scripts_urls::Array{String} = []
stylesheet_urls::Array{String} = []

fileserver = nothing
websocket = nothing

# Plugins
js_files_to_load::Array{String} = []

end

export PlutoBoard
