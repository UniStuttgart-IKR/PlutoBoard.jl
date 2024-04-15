function initialize(_html_path::String, _css_path::String; fullscreen::Bool = false, bootstrap::Bool = false)
	PlutoBoard.html_path = _html_path
	PlutoBoard.css_path = _css_path
	PlutoBoard.fullscreen = fullscreen
	PlutoBoard.bootstrap = bootstrap
end

function add_function(func::Function)
	println("Adding function: $func")
	#get function name 
	name = string(func)
	functions[name] = func
end

function add_functions(functions)
	for func in functions
		add_function(func)
	end
end

function javascript(code)
	time_ns = string(Base.time_ns()) #is needed to force a refresh of the html export if the code stays the same
	return @htl("""<html><script>eval($(code)); $(time_ns)</script></html>""")
end
