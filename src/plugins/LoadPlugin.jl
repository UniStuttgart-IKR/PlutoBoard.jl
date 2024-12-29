function load_plugin(package)
    path_js = abspath(joinpath(pathof(package), "..", "static", "main.js"))
    if isfile(path_js) && !in(js_files_to_load, path_js)
        push!(js_files_to_load, path_js)
    end
end