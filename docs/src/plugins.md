# Plugins

## Create a Plugin
Plugins are Julia packages, so it's straight forward:
```
] generate MyPlugin
```

They need to have a dictionary containing its config:
```Julia
const config = Dict(
    "name" => "MyPlugin",
    "js_path" => joinpath("static", "main.js")
)
```
- `name` is your Plugins name.
- `js_path` points to the JS file that should get loaded from PlutoBoard. Adding more JS files can be done by just importing them in the main JS file.

!!! info
    Import JavaScript files with
    ```javascript
    import {func} from './file.js'
    ```

## Loading a plugin

Now, to load the Plugin, it needs to be imported in the developer package, preferably in `Main.jl`:
```Julia
using MyPlugin

PlutoBoard.load_plugin(MyPlugin)
```

Now, the Plugin gets loaded at the start of the notebook.

Using Plugins, it's possible to easily share functionalities bundled together instead of sending several code snippets.
Development only functionalities, like a small GUI for testing the notebook could also be bundled into a plugin to remove it easily in production.



## Internal functions

```@docs
load_plugin(package)
```
