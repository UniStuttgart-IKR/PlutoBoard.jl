function handle_command(command::String)
	if command == ""
		return
	end

	passed_args = JSON.parse(command)

	func_name = passed_args["func"]
	args = passed_args["args"]
	return_value_bool = passed_args["returnValue"]


	if return_value_bool == true
		return_value = functions[func_name](args...)
		return @htl("""
		<script>
			const return_value = JSON.stringify($(return_value))
			console.log("return_value: ", return_value)
			changeCallJuliaFunctionReturnValue(return_value)
		</script>
		""")
	end

	return functions[func_name](args...)

end


