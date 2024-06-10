module PlutoBoard

using HypertextLiteral
using JSON
using TOML

include("InterfaceFunctions.jl")
include("LoadHTML.jl")
include("Utilities.jl")
include("JSCommands/HandleCommands.jl")

const plutoboard_filepath = dirname(dirname(pathof(PlutoBoard)))
const config = TOML.parsefile(plutoboard_filepath * "/config/config.toml")


html_path::Union{String, Nothing} = nothing
css_path::Union{String, Nothing} = nothing
fullscreen::Bool = false
bootstrap::Bool = false

hide_notebook::Bool = true

functions = Dict{String, Function}()



function log(msg)
	open("log.txt", "a") do f
		redirect_stdout(f) do
			println(msg)
		end
	end
end

end

export PlutoBoard
