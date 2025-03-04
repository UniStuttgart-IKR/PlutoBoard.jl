export run, initialize, javascript

"""
    run(debug::Bool=false)

Runs the Pluto notebook with the PlutoBoard notebook.
If `debug` is true, the notebook will reload when the file changes.
"""
function run(debug::Bool=false)
  if debug == false
    Pluto.run(notebook="PlutoBoardNotebook.jl")
  else
    Pluto.run(notebook="PlutoBoardNotebook.jl", auto_reload_from_file=true)#, capture_stdout=false)
  end
end

"""
	initiliaize(
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
