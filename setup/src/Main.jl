function main()
	## write your code here
	PlutoBoard.initialize("static/index.html", "static/index.css"; fullscreen = false, bootstrap = true, hide_notebook = true)


	PlutoBoard.add_functions([hello_world_return, ping_pong, get_square])
end