export parse_to_symbol, send_to_ws

"""
	parse_to_symbol(
		d::Dict{String, Any}
	)::Dict{Symbol, Any}

Parse a dictionary with string keys to a dictionary with symbol keys.
"""
function parse_to_symbol(d)
	return Dict(Symbol(k) => v for (k, v) in d)
end

"""
	send_to_ws(
		ws::WebSocket,
		message::String
	)

Send a message to a WebSocket as response. This triggers `callback` in `callJuliaFunction`.
"""
function send_to_ws(ws, message)
	send(ws, JSON.json(Dict("type" => "response", "response" => message)))
end





