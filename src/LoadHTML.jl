export set_fullscreen, load_bootstrap_css, load_bootstrap_js, load_html, load_html_string_to_body, load_js

function set_fullscreen()
	if PlutoBoard.fullscreen
		return @htl("<script>resizePlutoCell()</script>")
	end
end

"""
	load_scripts_and_links() -> HypertextLiteral.Result

Returns a HypertextLiteral.Result object with scritps and links to load.
"""
function load_scripts_and_links()
	scripts_and_links_html = ""

	for url in PlutoBoard.scripts_urls
		scripts_and_links_html *= """<script src="$url"/>"""
	end

	for url in PlutoBoard.stylesheet_urls
		scripts_and_links_html *= """<link href="$url" rel="stylesheet"/>"""
	end

	return HTML(scripts_and_links_html)
end


"""
	load_html() -> HTML

Returns a HTML object with the html and css loaded.
"""
function load_html()::HTML
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


"""
	load_html_string_to_body() -> HypertextLiteral.Result

Returns a HypertextLiteral.Result object to call a javascript function to insert the html and css to the body.
"""
function load_html_string_to_body()
	#get filepath where this module is loaded
	plutoboard_filepath = dirname(@__FILE__)
	internal_css_path = joinpath(plutoboard_filepath, "static/css/internal.css")
	always_load_css_path = joinpath(plutoboard_filepath, "static/css/alwaysLoad.css")


	html_string = css_string = internal_css = always_css = vue_css = ""
	open(html_path) do file
		html_string = read(file, String)
	end
	open(css_path) do file
		css_string = read(file, String)
	end
	open(internal_css_path) do file
		internal_css = read(file, String)
	end
	open(always_load_css_path) do file
		always_css = read(file, String)
	end
	try
		open("static/vue.css") do file
			vue_css = read(file, String)
		end
	catch
	end


	if hide_notebook == true
		css_string = """<style>$(css_string) $(internal_css) $(vue_css) $(always_css)</style>"""
	else
		css_string = """<style>$(css_string) $(vue_css) $(always_css)</style>"""
	end



	return @htl("""
	<!-- html -->
	<script>
	function insertHTMLToBody(html, css) {
		let body = document.querySelector('body');
		if (!body.querySelector('style')) {
			body.insertAdjacentHTML('beforeend', css);
		} else {
			body.querySelector('style').remove();
			body.insertAdjacentHTML('afterbegin', css);
		}

		if (!document.getElementById('main-export')) {
			body.insertAdjacentHTML('afterbegin', html);
		} else {
			document.getElementById('main-export').remove();
			body.insertAdjacentHTML('afterbegin', html);
		}
	}
	insertHTMLToBody($(html_string), $(css_string));
	console.log("Added html string to body");
	</script>
	<!-- !html -->
	""")
end

"""
	load_js() -> HypertextLiteral.Result

Returns a HypertextLiteral.Result object to load all javascript files.
"""
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
		if (paths[i].includes("static/javascript/index-") ){
			script.type = "module"
		}

		body.appendChild(script)
	}

	</script>
	<!-- !html -->
	""")

end
