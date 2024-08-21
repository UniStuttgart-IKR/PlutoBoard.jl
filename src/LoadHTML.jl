function set_fullscreen()
	if PlutoBoard.fullscreen
		return @htl("<script>resizePlutoCell()</script>")
	end
end

function load_bootstrap_css()
	if PlutoBoard.bootstrap
		return @htl("""<link href="$(config["cdn"]["bootstrap_css"])" rel="stylesheet" 
		integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">""")
	end
end

function load_bootstrap_js()
	if PlutoBoard.bootstrap
		return @htl("""<script src="$(config["cdn"]["bootstrap_js"])" 
		integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>""")
	end
end

function load_html()
	html_string = css_string = ""
	open(html_path) do file
		html_string = read(file, String)
	end
	open(css_path) do file
		css_string = """<style>$(read(file, String))</style>"""
	end

	html = HTML(html_string * css_string)
	return html
end

function load_html_string_to_body()
	#get filepath where this module is loaded
	plutoboard_filepath = dirname(@__FILE__)
	internal_css_path = joinpath(plutoboard_filepath, "static/css/internal.css")
	always_load_css_path = joinpath(plutoboard_filepath, "static/css/alwaysLoad.css")


	html_string = css_string = ""
	open(html_path) do file
		html_string = read(file, String)
	end
	open(css_path) do file
		open(internal_css_path) do css_file
			open(always_load_css_path) do always_css_file
				internal_css = read(css_file, String)
				always_css = read(always_css_file, String)

				if hide_notebook == true
					css_string = """<style>$(read(file, String)) $(internal_css) /n$(always_css)</style>"""
				else
					css_string = """<style>$(read(file, String)) $(always_css)</style>"""
				end
			end
		end
	end



	return @htl("""
	<script>
	insertHTMLToBody($(html_string), $(css_string));
	</script>
	""")
end


function load_js()::HypertextLiteral.Result

	paths = []
	for path in ["""$(plutoboard_filepath)/$(config["paths"]["javascript_dir"])/""", "static/javascript/"]
		for file in readdir(path)
			if file == "Init.js"
				continue
			end
			push!(paths, path * file)

		end
	end

	println(paths)

	#add init.js to paths
	#push!(paths, "MINDFulPluto/src/static/scripts/Init.js")


	scripts = []
	for path in paths
		push!(scripts, open_file(path))
	end


	return @htl("""
	<!-- html -->
	<script>

	
	let scripts = $(scripts)
	const paths = $(paths)

	console.log(paths)

	const body = document.getElementsByTagName('body')[0]
	
	//add scripts to body
	addScriptLoop:
	for (let i = 0; i < scripts.length; i++) {
		if (window.self !== window.top && (scripts[i].includes('DO NOT LOAD IN IFRAME') || paths[i].startsWith('static/javascript/'))) {
			continue addScriptLoop
		}


		//check if script is already loaded
		let queryScripts = document.querySelectorAll('script');
		for (let j = 0; j < queryScripts.length; j++) {
			if (queryScripts[j].className === paths[i]) {
				//remove script
				queryScripts[j].remove()
			}
		}

		console.log('added script ' + paths[i])
		

		let script = document.createElement('script')
		script.innerHTML = scripts[i]
		script.className = paths[i]
		body.appendChild(script)
	}

	</script>
	<!-- !html -->
	""")

end
