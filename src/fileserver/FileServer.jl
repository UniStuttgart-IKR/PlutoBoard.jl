function run_fileserver()
	global fileserver
	try
		schedule(fileserver, InterruptException(), error = true)
	catch e
		@info e
	end

	fileserver = @async PlutoBoard.start_server()
end

function serve_file(req::HTTP.Request)
	base_path = String(HTTP.unescapeuri(req.target))[2:end]
	if split(base_path, "/")[1] == "internal"
		base_path = joinpath(@__DIR__, "..", split(base_path, "/")[2:end]...)
	end

	requested_path = joinpath(SERVE_DIR, base_path)

	if split(base_path, "/")[1] == "absolute"
		requested_path = split(base_path, "/"; limit = 2)[2]
	end

	@info "Requested file: $requested_path"

	headers = Dict(
		"Access-Control-Allow-Origin" => "http://localhost:1234",
		"Access-Control-Allow-Methods" => "GET, POST, PUT, DELETE",
		"Access-Control-Allow-Headers" => "Content-Type",
		"Content-Type" => get_mime_type(requested_path),
	)

	if isfile(requested_path)
		content = read(requested_path)  # Read file content
		return HTTP.Response(200, headers, content)
	elseif isdir(requested_path)
		dir_contents = join("\n", readdir(requested_path))
		return HTTP.Response(200, headers, dir_contents)
	else
		return HTTP.Response(404, headers, "File not found")
	end
end

function start_server()
	@info "Starting server on port to server $SERVE_DIR"
	HTTP.serve(config["fileserver"]["url"], config["fileserver"]["port"]) do req
		# try
			serve_file(req)
		# catch e
		# 	@error "Error serving request: $e"
		# 	return HTTP.Response(500, "Internal Server Error")
		# end
	end
end

function get_mime_type(file)
	if endswith(file, ".js")
		return "application/javascript"
	elseif endswith(file, ".css")
		return "text/css"
	elseif endswith(file, ".html")
		return "text/html"
	elseif endswith(file, ".json")
		return "application/json"
	elseif endswith(file, ".png")
		return "image/png"
	elseif endswith(file, ".jpg") || endswith(file, ".jpeg")
		return "image/jpeg"
	elseif endswith(file, ".gif")
		return "image/gif"
	elseif endswith(file, ".svg")
		return "image/svg+xml"
	elseif endswith(file, ".txt")
		return "text/plain"
	elseif endswith(file, ".xml")
		return "application/xml"
	elseif endswith(file, ".pdf")
		return "application/pdf"
	elseif endswith(file, ".woff")
		return "font/woff"
	elseif endswith(file, ".woff2")
		return "font/woff2"
	elseif endswith(file, ".otf")
		return "font/otf"
	elseif endswith(file, ".eot")
		return "application/vnd.ms-fontobject"
	elseif endswith(file, ".mp4")
		return "video/mp4"
	elseif endswith(file, ".webm")
		return "video/webm"
	elseif endswith(file, ".mp3")
		return "audio/mp3"
	elseif endswith(file, ".wav")
		return "audio/wav"
	else
		return "application/octet-stream"
	end
end
