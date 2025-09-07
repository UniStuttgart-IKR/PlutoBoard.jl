export run, initialize, javascript

"""
	run(debug::Bool=false)

Runs the Pluto notebook with the PlutoBoard notebook.
If `debug` is true, the notebook will reload when the file changes.
Additionally copies the interface.js file to the lib directory of the current directory.
"""
function run(debug::Bool=false, notebook_path::String="PlutoBoardNotebook.jl")

    #copy static/javascript/interface.js into pwd/lib
    target_dir = joinpath(pwd(), "lib")
    if !isdir(target_dir)
        mkpath(target_dir)
    end
    cp(joinpath(@__DIR__, "static/javascript/interface.js"), joinpath(target_dir, "interface.js"), force=true)
    cp(joinpath(@__DIR__, "static/javascript/interface.d.ts"), joinpath(target_dir, "interface.d.ts"), force=true)

    user_config = PlutoBoard.get_local_user_config()
    websocket_port = user_config["websocket"]["default_port"]
    fileserver_port = user_config["fileserver"]["default_port"]

    #check if websocket_port is free
    while !is_port_free(websocket_port)
        websocket_port += 1
        @warn "Websocket port $(websocket_port-1) is already in use. Trying $websocket_port"
    end

    while !is_port_free(fileserver_port)
        fileserver_port += 1
        @warn "Fileserver port $(fileserver_port-1) is already in use. Trying $fileserver_port"
    end

    @info "Websocket port: $websocket_port"
    @info "Fileserver port: $fileserver_port"

    #write ports to user_config.toml
    user_config["websocket"]["port"] = websocket_port
    user_config["fileserver"]["port"] = fileserver_port
    PlutoBoard.update_local_user_config(user_config)

    if debug == false
        Pluto.run(notebook=notebook_path)
    else
        Pluto.run(notebook=notebook_path, auto_reload_from_file=true)#, capture_stdout=false)
    end
end

"""
	initialize(
		html_path::String,
		;
		hide_notebook::Bool = true,
		scripts::Array{String} = [],
		links::Array{String} = [],
	) -> nothing

Initializes the PlutoBoard module with parameters.
`scripts` and `links` are urls to scripts and stylesheets.
"""
function initialize(html_path::String; hide_notebook::Bool=true, scripts=[], stylesheets=[])
    PlutoBoard.html_path = html_path
    PlutoBoard.css_path = css_path
    PlutoBoard.hide_notebook = hide_notebook

    PlutoBoard.scripts_urls = scripts
    PlutoBoard.stylesheet_urls = stylesheets
end



"""
	javascript(code::String) -> HypertextLiteral.HTML

Returns a HypertextLiteral.HTML object with the given javascript code.
"""
function javascript(code::String)
    time_ns = string(Base.time_ns()) #is needed to force a refresh of the html export if the code stays the same
    return @htl("""<html><script>eval($(code)); $(time_ns)</script></html>""")
end
