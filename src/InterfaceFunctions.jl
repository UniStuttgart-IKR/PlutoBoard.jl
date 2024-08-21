export initialize, javascript

"""
	initiliaize(
		html_path::String,
		css_path::String
		;
		fullscreen::Bool = false,
		bootstrap::Bool = false,
		hide_notebook::Bool = true
	) -> nothing

Initializes the PlutoBoard module with parameters.
"""
function initialize(html_path::String, css_path::String; fullscreen::Bool = false, bootstrap::Bool = false, hide_notebook::Bool = true)
	PlutoBoard.html_path = html_path
	PlutoBoard.css_path = css_path
	PlutoBoard.fullscreen = fullscreen
	PlutoBoard.bootstrap = bootstrap
	PlutoBoard.hide_notebook = hide_notebook
end



"""
	javascript(code::String) -> HypertextLiteral.HTML

Returns a HypertextLiteral.HTML object with the given javascript code.
"""
function javascript(code::String)
	time_ns = string(Base.time_ns()) #is needed to force a refresh of the html export if the code stays the same
	return @htl("""<html><script>eval($(code)); $(time_ns)</script></html>""")
end
