using Pkg

function open_file(path)
	f = open(path, "r")
	content = read(f, String)
	close(f)
	return content
end


function copy_with_delete(from, to)
	cp(from, to, force = true)
	chmod(to, 0o644)
	@info "Copied $from to $to"
end


function setup()
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
		elseif file == "internal"
			#check if internal folder exists
			if !isdir("$cwd/internal")
				mkdir("$cwd/internal")
			end

			#copy contents of internal folder into cwd
			for internal_file in readdir("$(plutoboard_filepath)/setup/internal")
				copy_with_delete("$(plutoboard_filepath)/setup/internal/$internal_file", "$cwd/internal/$internal_file")
			end
			continue
		end
		copy_with_delete("$(plutoboard_filepath)/setup/$file", "$cwd/$file")
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

function get_package_name()
	project_toml_path = joinpath(pwd(), "Project.toml")
	project_toml = TOML.parsefile(project_toml_path)
	return project_toml["name"]
end
