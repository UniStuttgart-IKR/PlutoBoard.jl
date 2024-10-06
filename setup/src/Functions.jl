function get_cube(num; ws)
	for i in 1:50
		PlutoBoard.send_to_ws(ws, i/50)
		sleep(0.05)
	end

	return num^3
end
