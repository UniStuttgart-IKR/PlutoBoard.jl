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
    cp(from, to, force=true)
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
    menu = RadioMenu(options, pagesize=3)
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

        cp(joinpath(examples_path, file), joinpath(package_path, file); force=true)
    end

    # change options[choice] in `src/$options[choice].jl` to `package_name`
    content = read(joinpath(package_path, "src", options[choice] * ".jl"), String)
    fixed_content = replace(content, "$(options[choice])" => "$(package_name)")
    rm(joinpath(package_path, "src", options[choice] * ".jl"))
    write(joinpath(package_path, "src", package_name * ".jl"), fixed_content)

    # copy config/user_config.toml to package_path/user_config.toml
    cp(joinpath(PlutoBoard.plutoboard_filepath, "config", "user_config.toml"), joinpath(package_path, "user_config.toml"); force=true)

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


"""
	get_local_user_config()::Dict{String, Any}
Reads the user_config.toml file from the current directory and returns it as a dictionary. If the file does not exist, returns an empty dictionary.
"""
function get_local_user_config()::Dict{String,Any}
    user_config_path = joinpath(pwd(), "user_config.toml")
    if isfile(user_config_path)
        return TOML.parsefile(user_config_path)
    else
        return Dict{String,Any}()
    end
end

"""
	update_local_user_config(new_config::Dict{String,Any})::nothing
Updates the user_config.toml file in the current directory with the new configuration provided in `new_config`. If the file does not exist, it will be created.
"""
function update_local_user_config(new_config::Dict{String,Any})
    user_config_path = joinpath(pwd(), "user_config.toml")
    if isfile(user_config_path)
        current_config = TOML.parsefile(user_config_path)
        merged_config = merge(current_config, new_config)
        open(user_config_path, "w") do io
            TOML.print(io, merged_config)
        end
    else
        open(user_config_path, "w") do io
            TOML.print(io, new_config)
        end
    end

    PlutoBoard.config = TOML.parsefile(user_config_path)
end


"""
	is_port_free(port::Int)::Bool
Checks if a port is free to use. Returns true if the port is free, false otherwise.
"""
function is_port_free(port::Int)::Bool
    try
        server = listen(IPv4("127.0.0.1"), port)
        close(server)
        return true
    catch e
        return false
    end
end
