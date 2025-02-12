function parse_to_symbol(d)
	return Dict(Symbol(k) => v for (k, v) in d)
end

function send_to_ws(ws, message)
	Sockets.send(ws, JSON.json(Dict("type" => "response", "response" => message)))
end





