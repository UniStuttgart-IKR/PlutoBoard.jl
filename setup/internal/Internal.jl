"""
calls a julia function with the given arguments and keyword arguments

	sends stringified JSON response to the websocket
	response = {
		"type": "return",
		"return": return_value
	}
"""
function handle_julia_function_call(ws, parsed)
	function_name = parsed[:function]
	args = parsed[:args]

	if haskey(parsed, :kwargs)
		kwargs = parsed[:kwargs]
	else
		kwargs = Dict()
	end
	kwargs = NamedTuple(PlutoBoard.parse_to_symbol(kwargs))

	expr = Meta.parse(function_name)
	func = eval(expr)

	if !isa(func, Function) #TODO move above for it to work..
		PlutoBoard.log("Function $function_name not found")
		send(ws, "Function $function_name not found")
	end

	val = func(args...; kwargs..., ws = ws)

	message = Dict(
		"type" => "return",
		"return" => val,
	)
	send(ws, JSON.json(message))

end


"""
	receives a message from a websocket in this format:
	{
		"type": can be ["julia_function_call", "js_function_call"],
		"function": function_name::String,
		"args": args::Array{Any},
		"kwargs": {
			"key1": value1::Any,
			"key2": value2::Any,
			...
		}
	}
	"""
function start_websocket()
	@async WebSockets.listen("0.0.0.0", 8080) do ws

		for msg in ws
			parsed = PlutoBoard.parse_to_symbol(JSON.parse(msg))
			type = parsed[:type]

			if type == "julia_function_call"
				handle_julia_function_call(ws, parsed)
			end
		end
	end
end
