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

function load_html()::HTML
	html_string = css_string = ""
	open(html_path) do file
		html_string = read(file, String)
	end
	open(css_path) do file
		css_string = """<style>$(read(file, String))</style>"""
	end

	return HTML(html_string * css_string)
end


function load_js()::HypertextLiteral.Result

	paths = []
	for path in ["static/javascript/", """$(plutoboard_filepath)/$(config["paths"]["javascript_dir"])/"""]
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
