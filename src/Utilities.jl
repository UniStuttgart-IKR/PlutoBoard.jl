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

Copies a file from one location to another and deletes the original file. Sets the permissions of the copied file to 666.
"""
function copy_with_delete(from::String, to::String)
	cp(from, to, force = true)
	chmod(to, 0o766)
	@info "Copied $from to $to"
end

"""
	setup()::nothing

Sets up PlutoBoard project by creating a new Julia package and copying necessary files.
"""
function setup()
	@info "Setting up PlutoBoard"

	print("What should be the package name? ")
	package_name = readline()
	Pkg.generate(package_name)

	package_path = joinpath(pwd(), package_name)
	package_file_path = joinpath(package_path, "src/$(package_name).jl")

	options = ["Bare", "Simple", "JuliaCon"]
	menu = RadioMenu(options, pagesize = 3)
	choice = request("Choose your setup template. \"Simple\" is recommended, \"JuliaCon\" let's you see what's possible. ", menu)

	examples_path = joinpath(dirname(dirname(Pkg.pathof(PlutoBoardExamples))), options[choice])

	# copy everything into `package_path`
	for file in readdir(examples_path)
		if file == "Project.toml"
			# only add [deps] and [compat] sections from the example Project.toml
			example_toml = TOML.parsefile(joinpath(examples_path, file))
			new_toml = TOML.parsefile(joinpath(package_path, file))
			for (k, v) in example_toml
				if k in ["deps", "compat"]
					new_toml[k] = v
				end
			end
			open(joinpath(package_path, file), "w") do io
				TOML.print(io, new_toml)
			end
			continue
		end

		cp(joinpath(examples_path, file), joinpath(package_path, file); force = true)
	end

	# change options[choice] in `src/$options[choice].jl` to `package_name`
	content = read(joinpath(package_path, "src", options[choice] * ".jl"), String)
	fixed_content = replace(content, "$(options[choice])" => "$(package_name)")
	rm(joinpath(package_path, "src", options[choice] * ".jl"))
	write(joinpath(package_path, "src", package_name * ".jl"), fixed_content)

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
