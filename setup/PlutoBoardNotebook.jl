### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 306bfe84-b28b-4f52-a427-ba6950ddead4
using Pkg;

# ╔═╡ 0e8625f9-e2cb-4660-b355-cc62d35b252d
Pkg.activate(".");

# ╔═╡ caff9170-f1e7-11ee-3e0a-7bed8d1d0dd4
using Revise

# ╔═╡ e558f3b5-a1aa-4ed8-bb9c-817a8f4e9820
using PlutoBoard

# ╔═╡ 64f17c2b-5f54-4df5-8d7d-d57f3b314b5b
begin
	project_toml_path = joinpath(@__DIR__, "Project.toml")
	project_toml = PlutoBoard.TOML.parsefile(project_toml_path)
	project_name = project_toml["name"]
	eval(Meta.parse("using $project_name; PlutoBoardDeveloper = $project_name"))
end

# ╔═╡ ccaca478-9064-47a4-8967-ae0d41ccec7b
eval(Meta.parse("$project_name.main()"))

# ╔═╡ c8f44fcc-b2b4-49e6-8c5c-93ee51e42d1a
PlutoBoard.load_bootstrap_css()

# ╔═╡ 3117a56f-2a81-4da7-b832-cc8ade73b136
PlutoBoard.load_bootstrap_js()

# ╔═╡ 7d9362b1-c508-4cad-add2-4f62a6ad8409
PlutoBoard.load_js()

# ╔═╡ aa5b4411-c643-4f81-bb08-54b94d5c5fbb
PlutoBoard.load_html()

# ╔═╡ 4a5c458d-c7e5-40ca-97af-f2ffaebc214b
PlutoBoard.set_fullscreen()

# ╔═╡ bd4f5ceb-b5c1-426b-bc29-2a71dc06a5aa
begin
	intent_command_bind = @bind intent_command html"""<input type="text" id="callJuliaFunctionTextField" classname="inactive" value="">"""

	PlutoBoard.@htl("""

	$(embed_display(intent_command_bind))

	""")
end

# ╔═╡ 23857a51-0465-4b80-817a-19c994ae7b2d
PlutoBoard.handle_command(intent_command)

# ╔═╡ 4d55b3cc-ad5d-412a-a312-aed9374ee85c
PlutoBoard.@htl("""<h1 id="callJuliaFunctionReturn"></h1>""")

# ╔═╡ Cell order:
# ╠═caff9170-f1e7-11ee-3e0a-7bed8d1d0dd4
# ╠═306bfe84-b28b-4f52-a427-ba6950ddead4
# ╠═0e8625f9-e2cb-4660-b355-cc62d35b252d
# ╠═e558f3b5-a1aa-4ed8-bb9c-817a8f4e9820
# ╠═64f17c2b-5f54-4df5-8d7d-d57f3b314b5b
# ╠═ccaca478-9064-47a4-8967-ae0d41ccec7b
# ╠═c8f44fcc-b2b4-49e6-8c5c-93ee51e42d1a
# ╠═3117a56f-2a81-4da7-b832-cc8ade73b136
# ╠═7d9362b1-c508-4cad-add2-4f62a6ad8409
# ╠═aa5b4411-c643-4f81-bb08-54b94d5c5fbb
# ╠═4a5c458d-c7e5-40ca-97af-f2ffaebc214b
# ╠═bd4f5ceb-b5c1-426b-bc29-2a71dc06a5aa
# ╠═23857a51-0465-4b80-817a-19c994ae7b2d
# ╠═4d55b3cc-ad5d-412a-a312-aed9374ee85c
