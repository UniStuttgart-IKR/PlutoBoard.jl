### A Pluto.jl notebook ###
# v0.19.42

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

# ╔═╡ 64f17c2b-5f54-4df5-8d7d-d57f3b314b5b
begin
	project_toml_path = joinpath(@__DIR__, "Project.toml")
	project_toml = PlutoBoard.TOML.parsefile(project_toml_path)
	project_name = project_toml["name"]
	eval(Meta.parse("using $project_name"))
	eval(Meta.parse("$project_name.main()"))
end

# ╔═╡ c8f44fcc-b2b4-49e6-8c5c-93ee51e42d1a
PlutoBoard.load_bootstrap_css()

# ╔═╡ 3117a56f-2a81-4da7-b832-cc8ade73b136
PlutoBoard.load_bootstrap_js()

# ╔═╡ 7d9362b1-c508-4cad-add2-4f62a6ad8409
PlutoBoard.load_js()

# ╔═╡ 191eb887-6681-4f75-8192-240ca3fc5da2
PlutoBoard.load_html_string_to_body()

# ╔═╡ ffa65a89-13b7-41b1-b1d5-95605c5ae39d
1

# ╔═╡ 13eafc45-2e29-4b2b-999b-4d89721124ef
2

# ╔═╡ 13eafc45-2e29-4b2b-999b-4d8972112123
3

# ╔═╡ Cell order:
# ╠═caff9170-f1e7-11ee-3e0a-7bed8d1d0dd4
# ╠═306bfe84-b28b-4f52-a427-ba6950ddead4
# ╠═0e8625f9-e2cb-4660-b355-cc62d35b252d
# ╠═e558f3b5-a1aa-4ed8-bb9c-817a8f4e9820
# ╠═64f17c2b-5f54-4df5-8d7d-d57f3b314b5b
# ╠═c8f44fcc-b2b4-49e6-8c5c-93ee51e42d1a
# ╠═3117a56f-2a81-4da7-b832-cc8ade73b136
# ╠═7d9362b1-c508-4cad-add2-4f62a6ad8409
# ╠═191eb887-6681-4f75-8192-240ca3fc5da2
# ╠═ffa65a89-13b7-41b1-b1d5-95605c5ae39d
# ╠═13eafc45-2e29-4b2b-999b-4d89721124ef
# ╠═13eafc45-2e29-4b2b-999b-4d8972112123
