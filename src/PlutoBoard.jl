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
using REPL.TerminalMenus
using PlutoBoardExamples
using Sockets

import Base.print

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

"""
    __init__()

Initialize the PlutoBoard module by setting up global variables and configuration.

This function is automatically called when the module is loaded. It sets up:
- `SERVE_DIR`: The directory to serve static files from (defaults to "static" in current working directory)
- `config`: Configuration loaded from "user_config.toml" if it exists in the current directory

If no user_config.toml file is found, only the setup() function will be available.
"""
function __init__()
    # Needs to be in init, so it runs every time PlutoBoard is loaded rather than only when PlutoBoard is being precompiled.
    global SERVE_DIR = joinpath(pwd(), "static")

    if isfile(joinpath(pwd(), "user_config.toml")) == true
        global config = TOML.parsefile(joinpath(pwd(), "user_config.toml"))
    else
        @info "No user_config.toml file found in current directory. Only setup() will be available."
    end
end

plutoboard_filepath = dirname(dirname(pathof(PlutoBoard)))


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
