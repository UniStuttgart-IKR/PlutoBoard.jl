export set_fullscreen, load_scripts_and_links, load_html, get_html, load_js

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
	get_html() -> String

Returns contents of `index.html` as `String`
"""
function get_html()
	open(html_path) do file
		return read(file, String)
	end
end

"""
	load_js() -> HypertextLiteral.Result

Returns a HypertextLiteral.Result object to load entry js files as modules and css scripts
"""
function load_js()::HypertextLiteral.Result
	return @htl("""
	<!-- html -->
	<script>

	//check if in iframe 
	if (window.location !== window.parent.location) {
		//exit this script 
		return
	}

	const head = document.getElementsByTagName('head')[0]

	const script_locations = [
		"internal/static/javascript/main.js",
	];

	const css_locations = [
		"internal/static/css/alwaysLoad.css",
	];

	if ($(PlutoBoard.hide_notebook == true)) {
		css_locations.push("internal/static/css/internal.css")
	}

	const url = "http://localhost:8085/"

	script_locations.forEach(location => {
		const script = document.createElement('script')
		script.src = url + location
		script.type = "module"
		head.appendChild(script)
	});

	css_locations.forEach(location => {
		const link = document.createElement('link')
		link.href = url + location
		link.rel = "stylesheet"
		head.appendChild(link)
	});

	//wait for #main-export to be loaded
	const interval = setInterval(() => {
		if (document.getElementById("main-export")) {
			clearInterval(interval)
			const script = document.createElement('script')
			script.src = url + "javascript/main.js"
			script.type = "module"
			head.appendChild(script)
		}
	}, 100)

	</script>
	<!-- !html -->
	""")

end
