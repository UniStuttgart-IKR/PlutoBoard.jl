function main()
	## write your code here
	PlutoBoard.initialize("static/index.html", "static/index.css", fullscreen=true, bootstrap=true)


	PlutoBoard.add_functions([get_square, get_package_name, get_julia_version])
end
