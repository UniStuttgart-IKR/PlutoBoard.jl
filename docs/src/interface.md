# Interface

## JavaScript interface
These functions can be called in the browser and are written in **JavaScript**.
```@docs
callJuliaFunction()
```

## Julia interface
```@docs
initialize(html_path::String; hide_notebook::Bool=true, scripts=[], stylesheets=[])
send_to_ws(
		ws::WebSocket,
		message::String
)
PlutoBoard.run(debug::Bool=false)
```