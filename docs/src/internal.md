# Internals

## Cell management
```@docs
add_cell(;ws)
remove_cell(uuid::String; ws)
get_cells(;ws)
```

## JS, HTML and CSS injections
```@docs
load_scripts_and_links
load_js()
get_css_files()
```

## Fileserver
```@docs
serve_file(req::HTTP.Request)
start_server()
run_fileserver()
get_mime_type(file)

```

## Other stuff
```@docs
setup()
get_package_name()
open_file(path::String)
copy_with_delete(from::String, to::String)
parse_to_symbol(
		d::Dict{String, Any}
	)
```