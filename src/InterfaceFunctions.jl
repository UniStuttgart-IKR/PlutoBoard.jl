export initialize, javascript

"""
	initiliaize(
		html_path::String,
		css_path::String
		;
		fullscreen::Bool = true,
		hide_notebook::Bool = true,
		scripts::Array{String} = [],
		links::Array{String} = [],
	) -> nothing

Initializes the PlutoBoard module with parameters.
"""
function initialize(html_path::String, css_path::String; fullscreen::Bool = true, hide_notebook::Bool = true, scripts = [], stylesheets = [])
	PlutoBoard.html_path = html_path
	PlutoBoard.css_path = css_path
	PlutoBoard.fullscreen = fullscreen
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
