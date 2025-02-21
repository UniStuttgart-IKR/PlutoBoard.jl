export load_scripts_and_links, get_css_files, load_js

"""
	load_scripts_and_links() -> HypertextLiteral.Result

Returns a HypertextLiteral.Result object with scritps and links to load defined by the developer in [`initialize`](@ref)
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
    get_css_files() -> Array{String}

Returns all css files in `static/css` folder of developer package.
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

Returns a HypertextLiteral.Result object to load entry js files as modules and css stylesheets.
"""
function load_js()::HypertextLiteral.Result
  plugin_js_files_contents = []
  for f in js_files_to_load
    open(f) do file
      push!(plugin_js_files_contents, read(file, String))
    end
  end

  js_content = ""
  open(joinpath(PlutoBoard.plutoboard_filepath, "src","static", "javascript", "injections", "setup.js")) do file
    js_content = HypertextLiteral.JavaScript(read(file, String))
  end

  test = "console.log('A')"

  return @htl("""
  <script>
              const notebookHidden = $(PlutoBoard.hide_notebook);
              const js_files_to_load = $(js_files_to_load);
              $(js_content)
  </script>
  """)


end
