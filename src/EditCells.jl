export add_cell, remove_cell, get_cells

const CELL_HEAD = "# ╔═╡ ";
const ORDER_TITLE = "# ╔═╡ Cell order:";
const ORDER_HEAD = "# " * "..";
const SHOWN_HEAD = "# ╠═";
const HIDDEN_HEAD = "# ╟─";
const LAST_CELL = SHOWN_HEAD * "147ed5fe-0133-4eef-96f2-afafe9385f27";


"""
	add_cell(
		;
		ws::WebSocket
	) -> nothing

Adds a cell at the bottom of the notebook
"""
function add_cell(; ws)
	uuid = UUIDs.uuid4()

	open("PlutoBoardNotebook.jl", "r") do file
		file_content = read(file, String)
	end

	# find line with ORDER_TITLE
	order = findfirst(ORDER_TITLE, file_content)

	# add cell to the end
	file_content = file_content[1:order[1]-1] * CELL_HEAD * string(uuid) * "\n\n" * file_content[order[1]:end]

	# add cell to end of order
	if file_content[end] != '\n'
		file_content *= '\n'
	end
	file_content = file_content * SHOWN_HEAD * string(uuid) * '\n'
	open("PlutoBoardNotebook.jl", "w") do file
		write(file, file_content)
	end
	chmod("PlutoBoardNotebook.jl", 0o766)
end

"""
	remove_cell(
		uuid::String
		;
		ws::WebSocket
	) -> nothing

Removes cell with uuid
"""
function remove_cell(uuid::String; ws)
	file_content = ""
	open("PlutoBoardNotebook.jl", "r") do file
		file_content = read(file, String)
	end

	# remove cell from order
	cell_order = findfirst(HIDDEN_HEAD * uuid, file_content)
	if cell_order === nothing
		cell_order = findfirst(SHOWN_HEAD * uuid, file_content)
	end
	file_content = file_content[1:cell_order[1]-1] * file_content[cell_order[end]+1:end]

	# remove cell
	cell_head = findfirst(CELL_HEAD * uuid, file_content)
	cell_end = findfirst(CELL_HEAD, file_content[cell_head[end]:end])
	file_content = file_content[1:cell_head[1]] * file_content[cell_head[end]+cell_end[1]:end]

	open("PlutoBoardNotebook.jl", "w") do file
		write(file, file_content)
	end
	chmod("PlutoBoardNotebook.jl", 0o766)
end

"""
	get_cells(
		;
		ws::WebSocket
	) -> Array{String}

Returns an array of all cells uuids
"""
function get_cells(; ws)
	file_content = ""
	open("PlutoBoardNotebook.jl", "r") do file
		file_content = read(file, String)
	end

	last_cell_index = findfirst(LAST_CELL, file_content)[end] + 1
	cells = []
	for cell in split(file_content[last_cell_index:end], "#")
		cell_uuid = replace(cell, "\n" => "", SHOWN_HEAD[2:end] => "", HIDDEN_HEAD[2:end] => "")
		if length(cell_uuid) > 0
			push!(cells, cell_uuid)
		end
	end

	return cells
end