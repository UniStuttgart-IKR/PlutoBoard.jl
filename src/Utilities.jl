using Pkg

export open_file, copy_with_delete, setup, get_package_name

"""
	open_file(
		path::String
	)::String

Opens a file and returns its content as a string.
"""
function open_file(path::String)::String
	f = open(path, "r")
	content = read(f, String)
	close(f)
	return content
end


"""
	copy_with_delete(
		from::String,
		to::String
	)::nothing

Copies a file from one location to another and deletes the original file. Sets the permissions of the copied file to 644.
"""
function copy_with_delete(from::String, to::String)
	cp(from, to, force = true)
	chmod(to, 0o644)
	@info "Copied $from to $to"
end

"""
	setup(
		example::String="default"
	)::nothing

Sets up the PlutoBoard module by copying the necessary files to the current working directory.
Example can either be `default` or `vue` or `vue_moving_cells`.
"""
function setup(; example::String = "default")
	@info "Setting up PlutoBoard"

	Pkg.add("HTTP")
	Pkg.add("Sockets")
	Pkg.add("JSON")




	cwd = pwd()
	#copy contents of setup folder into cwd
	for file in readdir("$(plutoboard_filepath)/setup")
		if file == "src"
			#copy contents of src folder into cwd
			for src_file in readdir("$(plutoboard_filepath)/setup/src")
				copy_with_delete("$(plutoboard_filepath)/setup/src/$src_file", "$cwd/src/$src_file")
			end
			continue
		elseif file == "examples"
			continue
		end

		copy_with_delete("$(plutoboard_filepath)/setup/$file", "$cwd/$file")
	end


	if example == "vue"
		copy_with_delete("$(plutoboard_filepath)/setup/static/examples/vue/index.html", "$cwd/static/index.html")
		copy_with_delete("$(plutoboard_filepath)/setup/static/examples/vue/vue.css", "$cwd/static/vue.css")
		copy_with_delete("$(plutoboard_filepath)/setup/static/examples/vue/vue.js", "$cwd/static/javascript/vue.js")
	elseif example == "vue_moving_cells"
		copy_with_delete("$(plutoboard_filepath)/setup/static/examples/vue_moving_cells/index.html", "$cwd/static/index.html")
		copy_with_delete("$(plutoboard_filepath)/setup/static/examples/vue_moving_cells/vue.css", "$cwd/static/vue.css")
		copy_with_delete("$(plutoboard_filepath)/setup/static/examples/vue_moving_cells/vue.js", "$cwd/static/javascript/vue.js")

	end

	#open Project.toml and get project name
	project_name = get_package_name()

	project_file_path = joinpath(cwd, "src/$(project_name).jl")
	open(project_file_path, "w") do f
		write(f,
			"""
			module $(project_name)

			using PlutoBoard
			using HTTP
			using HTTP.WebSockets
			using JSON
			using Sockets

			include("Main.jl")
			include("Functions.jl")

			global global_websocket = nothing

			end""")
	end

	@info "Setup complete"
end


"""
	get_package_name()::String

Returns the name of the package from the Project.toml file.
"""
function get_package_name()::String
	project_toml_path = joinpath(pwd(), "Project.toml")
	project_toml = TOML.parsefile(project_toml_path)
	return project_toml["name"]
end
