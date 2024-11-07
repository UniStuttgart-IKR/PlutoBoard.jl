module PlutoBoard

using HypertextLiteral
using JSON
using TOML
using HTTP
using HTTP.WebSockets

include("InterfaceFunctions.jl")
include("LoadHTML.jl")
include("Utilities.jl")
include("JSCommands/HandleCommands.jl")
include("../internal/javascript/Dummy.jl")

const plutoboard_filepath = dirname(dirname(pathof(PlutoBoard)))
const config = TOML.parsefile(plutoboard_filepath * "/config/config.toml")


html_path::Union{String, Nothing} = nothing
css_path::Union{String, Nothing} = nothing
fullscreen::Bool = false
bootstrap::Bool = false

hide_notebook::Bool = true



function log(msg)
	open("log.txt", "a") do f
		redirect_stdout(f) do
			println(msg)
		end
	end
end

end

export PlutoBoard
