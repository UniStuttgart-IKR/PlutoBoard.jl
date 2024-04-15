function open_file(path)
	f = open(path, "r")
	content = read(f, String)
	close(f)
	return content
end



function setup()
	cwd = pwd()
	#copy contents of setup folder into cwd
	for file in readdir("$(plutoboard_filepath)/setup")
		if file == "src"
			#copy contents of src folder into cwd
			for src_file in readdir("$(plutoboard_filepath)/setup/src")
				cp("$(plutoboard_filepath)/setup/src/$src_file", "$cwd/src/$src_file")
			end
			continue
		end
		cp("$(plutoboard_filepath)/setup/$file", "$cwd/$file")
	end

	#open Project.toml and get project name
	project_toml_path = joinpath(cwd, "Project.toml")
	project_toml = TOML.parsefile(project_toml_path)
	project_name = project_toml["name"]

	project_file_path = joinpath(cwd, "src/$(project_name).jl")
	open(project_file_path, "w") do f
		write(f,
			"""
			module $(project_name)

			using PlutoBoard

			include("Main.jl")
			include("Functions.jl")


			end""",
		)
	end

end
