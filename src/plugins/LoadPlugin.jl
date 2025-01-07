function load_plugin(package)
    path_js = abspath(joinpath(pathof(package), "..", package.config["js_path"]))
    if isfile(path_js) && !in(path_js, js_files_to_load)
        push!(js_files_to_load, path_js)
    end
end