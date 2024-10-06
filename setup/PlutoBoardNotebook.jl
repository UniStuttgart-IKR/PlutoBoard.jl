### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 306bfe84-b28b-4f52-a427-ba6950ddead4
using Pkg

# ╔═╡ 0e8625f9-e2cb-4660-b355-cc62d35b252d
Pkg.activate(".")

# ╔═╡ caff9170-f1e7-11ee-3e0a-7bed8d1d0dd4
using Revise

# ╔═╡ e558f3b5-a1aa-4ed8-bb9c-817a8f4e9820
using PlutoBoard

# ╔═╡ 96ff4362-fda0-4cae-9786-2dc29626479c
using HTTP.WebSockets

# ╔═╡ ffa65a89-13b7-41b1-b1d5-95605c5ae39d
using WGLMakie

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
PlutoBoard.load_bootstrap_css()

# ╔═╡ 3117a56f-2a81-4da7-b832-cc8ade73b136
PlutoBoard.load_bootstrap_js()

# ╔═╡ 191eb887-6681-4f75-8192-240ca3fc5da2
PlutoBoard.load_html_string_to_body()

# ╔═╡ 7d9362b1-c508-4cad-add2-4f62a6ad8409
PlutoBoard.load_js()

# ╔═╡ a12112c1-58e7-473b-a8c2-d825d0f416d9
function handle_julia_function_call(ws, parsed)
	function_name = parsed[:function]
	args = parsed[:args]

	if haskey(parsed, :kwargs)
		kwargs = parsed[:kwargs]
	else
		kwargs = Dict()
	end
	kwargs = NamedTuple(PlutoBoard.parse_to_symbol(kwargs))

	expr = Meta.parse("$user_package.$function_name")
	func = eval(expr)

	if !isa(func, Function) #TODO move above for it to work..
		PlutoBoard.log("Function $function_name not found")
		send(ws, "Function $function_name not found")
	end

	val = func(args...; kwargs..., ws = ws)

	message = Dict(
		"type" => "return",
		"return" => val,
	)
	send(ws, PlutoBoard.JSON.json(message))

end

# ╔═╡ 147ed5fe-0133-4eef-96f2-afafe9385f27
begin
	if user_package.global_websocket !== nothing
		schedule(user_package.global_websocket, InterruptException(), error = true)
	end

	user_package.global_websocket = @async WebSockets.listen("0.0.0.0", 8080) do ws
		for msg in ws
			parsed = PlutoBoard.parse_to_symbol(PlutoBoard.JSON.parse(msg))
			type = parsed[:type]

			if type == "julia_function_call"
				handle_julia_function_call(ws, parsed)
			end
		end
	end
end

# ╔═╡ 13eafc45-2e29-4b2b-999b-4d89721124ef
12

# ╔═╡ Cell order:
# ╠═caff9170-f1e7-11ee-3e0a-7bed8d1d0dd4
# ╠═306bfe84-b28b-4f52-a427-ba6950ddead4
# ╠═0e8625f9-e2cb-4660-b355-cc62d35b252d
# ╠═e558f3b5-a1aa-4ed8-bb9c-817a8f4e9820
# ╠═96ff4362-fda0-4cae-9786-2dc29626479c
# ╠═64f17c2b-5f54-4df5-8d7d-d57f3b314b5b
# ╠═c8f44fcc-b2b4-49e6-8c5c-93ee51e42d1a
# ╠═3117a56f-2a81-4da7-b832-cc8ade73b136
# ╠═191eb887-6681-4f75-8192-240ca3fc5da2
# ╠═7d9362b1-c508-4cad-add2-4f62a6ad8409
# ╠═a12112c1-58e7-473b-a8c2-d825d0f416d9
# ╠═147ed5fe-0133-4eef-96f2-afafe9385f27
# ╠═ffa65a89-13b7-41b1-b1d5-95605c5ae39d
# ╠═13eafc45-2e29-4b2b-999b-4d89721124ef
