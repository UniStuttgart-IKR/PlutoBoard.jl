export load_scripts_and_links, load_html, get_html, load_js

"""
	load_scripts_and_links() -> HypertextLiteral.Result

Returns a HypertextLiteral.Result object with scritps and links to load.
"""
function load_scripts_and_links()
    scripts_and_links_html = ""

    for url in PlutoBoard.scripts_urls
        scripts_and_links_html *= """<script src="$url"></script>"""
    end

    for url in PlutoBoard.stylesheet_urls
        scripts_and_links_html *= """<link href="$url" rel="stylesheet"></link>"""
    end

    return HTML(scripts_and_links_html)
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
    get_css_files() -> Array{String}

Returns all css files in developer package
"""

function get_css_files()
    css_files = []
    for file in readdir("static/css")
        push!(css_files, file)
    end

    return css_files
end

"""
	load_js() -> HypertextLiteral.Result

Returns a HypertextLiteral.Result object to load entry js files as modules and css scripts
"""
function load_js()::HypertextLiteral.Result
    plugin_js_files_contents = []
    for f in js_files_to_load
        open(f) do file
            push!(plugin_js_files_contents, read(file, String))
        end
    end

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

            //add plugin scripts
            for (let i = 0; i < $(js_files_to_load).length; i++) {
                const script = document.createElement('script')
                script.type = "module"
                script.src = url + "absolute/" + $(js_files_to_load)[i]
                head.appendChild(script)
            }
    	}
    }, 100)

    </script>
    <!-- !html -->
    """)
end