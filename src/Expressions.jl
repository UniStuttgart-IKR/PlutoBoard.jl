"""
    find_cells_with_variable(
        var::String
    ) -> Set{String}

    Finds all cells in the notebook that contain the given variable and returns their IDs.
"""
function find_cells_with_variable(var::String)
    notebook = read("PlutoBoardNotebook.jl", String)

    cells = split(notebook, "\n# ╔═╡ ")[2:end-1]
    ids = map(c -> c[1:findfirst(==('\n'), c)-1], cells)

    cell_contents = map(c -> c[findfirst(==('\n'), c)+1:end], cells)
    cell_contents = map(c -> strip(c), cell_contents)

    cells = Dict(zip(ids, cell_contents))

    #check for var
    cells_containing_var =
        filter(((k, v),) -> MacroTools.inexpr(Meta.parse(v), Meta.parse(var)), cells)

    return keys(cells_containing_var)
end
