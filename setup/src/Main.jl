# SERVE_DIR = joinpath(dirname(@__DIR__), "public")
# mime_types = Dict("js" => "text/javascript", "html" => "text/html")

# function file_server(req::HTTP.Request)
# 	requested_path = String(req.target)[2:end]
# 	full_path = joinpath(SERVE_DIR, requested_path)
# 	@info full_path, SERVE_DIR, requested_path

# 	extension = split(full_path, ".")[end]

# 	if isfile(full_path) && haskey(mime_types, extension)
# 		file_content = open(full_path) do file
# 			read(file)
# 		end

# 		return HTTP.Response(200, ["Content-Type" => mime_types[extension]], file_content)
# 	else
# 		return HTTP.Response(404, "File not found")
# 	end
# end


function main()
	# @async HTTP.serve(file_server, Sockets.localhost, 8000)

	PlutoBoard.initialize("static/index.html", "static/index.css"; fullscreen = true, bootstrap = false, hide_notebook = true)



	# @info "Server is running on http://127.0.0.1:8000/"
	# @info SERVE_DIR

	#write your code here

end
