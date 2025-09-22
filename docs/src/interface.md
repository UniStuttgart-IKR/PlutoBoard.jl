# Interface

```@docs
initialize(html_path::String; hide_notebook::Bool=true, scripts=[], stylesheets=[])
send_to_ws(
		ws::WebSocket,
		message::String
)
PlutoBoard.run(debug::Bool=false, notebook_path::String="PlutoBoardNotebook.jl")
javascript(code::String)
```