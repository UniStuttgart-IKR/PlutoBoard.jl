### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 306bfe84-b28b-4f52-a427-ba6950ddead4
using Pkg

# ╔═╡ 0e8625f9-e2cb-4660-b355-cc62d35b252d
Pkg.activate(".")

# ╔═╡ e558f3b5-a1aa-4ed8-bb9c-817a8f4e9820
using PlutoBoard

# ╔═╡ 64f17c2b-5f54-4df5-8d7d-d57f3b314b5b
begin
	project_toml_path = joinpath(@__DIR__, "Project.toml")
	project_toml = PlutoBoard.TOML.parsefile(project_toml_path)
	project_name = project_toml["name"]
	eval(Meta.parse("using $project_name"))
	eval(Meta.parse("$project_name.main()"))
	const user_package = eval(Meta.parse("$project_name"))
end

# ╔═╡ c8f44fcc-b2b4-49e6-8c5c-93ee51e42d1a
PlutoBoard.load_scripts_and_links()

# ╔═╡ 7d9362b1-c508-4cad-add2-4f62a6ad8409
PlutoBoard.load_js()

# ╔═╡ a12112c1-58e7-473b-a8c2-d825d0f416d9
function handle_julia_function_call(ws, parsed, package)
	function_name = parsed[:function]
	args = parsed[:args]

	if haskey(parsed, :kwargs)
		kwargs = parsed[:kwargs]
	else
		kwargs = Dict()
	end
	kwargs = NamedTuple(PlutoBoard.parse_to_symbol(kwargs))

	if parsed[:internal] == true
        func = getfield(PlutoBoard, Symbol(function_name))
    else
        func = getfield(package, Symbol(function_name))
    end

	local val
	try
		val = func(args...; kwargs..., ws = ws)
	catch MethodError
		val = func(args...; kwargs...)
	end

	message = Dict(
		"type" => "return",
		"return" => val,
	)
	PlutoBoard.send(ws, PlutoBoard.JSON.json(message))
end

# ╔═╡ 231a2a26-b3ec-4ad0-8335-db43a53f1a86
PlutoBoard.run_fileserver()

# ╔═╡ 147ed5fe-0133-4eef-96f2-afafe9385f27
begin
	try
		schedule(PlutoBoard.websocket, InterruptException(), error = true)
	catch e
		@info e
	end
	
	PlutoBoard.websocket = @async PlutoBoard.WebSockets.listen(PlutoBoard.config["websocket"]["url"], PlutoBoard.config["websocket"]["port"]) do ws
		for msg in ws
			parsed = PlutoBoard.parse_to_symbol(PlutoBoard.JSON.parse(msg))
			type = parsed[:type]

			if type == "julia_function_call"
				@info parsed
				handle_julia_function_call(ws, parsed, user_package)
			end
		end
	end
end

# ╔═╡ 2eac3d05-ae01-40c8-abfa-d55349f043f3
x=1

# ╔═╡ 2e287869-a591-45ba-ac12-28c24fd9059a
x

# ╔═╡ Cell order:
# ╠═306bfe84-b28b-4f52-a427-ba6950ddead4
# ╠═0e8625f9-e2cb-4660-b355-cc62d35b252d
# ╠═e558f3b5-a1aa-4ed8-bb9c-817a8f4e9820
# ╠═64f17c2b-5f54-4df5-8d7d-d57f3b314b5b
# ╠═c8f44fcc-b2b4-49e6-8c5c-93ee51e42d1a
# ╠═7d9362b1-c508-4cad-add2-4f62a6ad8409
# ╠═a12112c1-58e7-473b-a8c2-d825d0f416d9
# ╠═231a2a26-b3ec-4ad0-8335-db43a53f1a86
# ╠═147ed5fe-0133-4eef-96f2-afafe9385f27
# ╠═2eac3d05-ae01-40c8-abfa-d55349f043f3
# ╠═2e287869-a591-45ba-ac12-28c24fd9059a

