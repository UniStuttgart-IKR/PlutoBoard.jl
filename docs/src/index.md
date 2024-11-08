```@contents
```

# Starting a new project

## Setup
Generate your package
```bash
$> julia -e 'using Pkg; Pkg.generate("YOUR_PACKAGE_NAME")' && cd YOUR_PACKAGE_NAME
```
Add PlutoBoard and set it up
```bash
YOUR_PACKAGE_NAME$> julia --project -e 'using Pkg; Pkg.add(url="https://github.com/UniStuttgart-IKR/PlutoBoard.jl"); using PlutoBoard; PlutoBoard.setup()' 
```
Run the notebook
```bash
YOUR_PACKAGE_NAME$> julia --project -e 'using Pluto; Pluto.run(notebook="PlutoBoardNotebook.jl")'
```

## Write your own code
There is some hierarchy:
- `main` in `src/Main.jl` gets called in the beginning, so use this as julia entry point
- functions that should be callable from js need to go into `src/Functions.jl`
- all javascript files in `static/javascript/` are getting executed, though `static/javascript/javascript.js` is the last one, so use this as js entry point

There is a simple example in `src/Functions.jl`, `src/static/index.html` and `src/static/javascript/javascript.js` about calling a julia function from javascript with callbacks.

### Simple calling of a Julia function within HTML using a button and an input

First, lets write a simple Julia function in `src/Functions.jl`
```Julia
function get_cube(num; ws)
    # iterate 50 times
	for i in 1:50
        # send each i to the frontend
		PlutoBoard.send_to_ws(ws, i/50)
        # sleep a little bit so we have time to see it
		sleep(0.05)
	end
    # finally return the cube of `num`
	return num^3
end
```

Now we create an input with `id=buttonInput` for our number in `static/index.html`
```HTML
<input type="text" id="buttonInput" placeholder="Input number">
```
as well as a button
```HTML
<button class="btn btn-light" id="calculateButton" onclick="calculateVeryHardStuff()">Calculate</button>
```
and a div to show our output
```HTML
<div class="text-white" id="buttonOutput">Output: </div>
```
Since we used `calculateVeryHardStuff` in our button, we need to define it aswell. We do this in `static/javascript/javascript.js`
```JavaScript
function calculateVeryHardStuff() {
    // get our input
    const input = document.getElementById("buttonInput");
    // get the value of input 
    const number = parseInt(input.value);

    // call our previously defined Julia function with arguments and callback
    callJuliaFunction(
        // "get_cube" is the function we want to call
        "get_cube", {
        // `get_cube` takes one argument, in this case we pass `number`
        args: [number],
        // also pass a callback when we get a response (remember, we are sending the progress of the for loop, i/50)
        response_callback: (
            // define the function
            r => {
                // get output div
                const outputP = document.getElementById("buttonOutput");
                // set innerHTML of output div to show the progress
                outputP.innerHTML = `${Math.round(r * 100)}%...`;
            }
        )
    })
    // after getting the return value we want to show it in the output div
    .then(
        r => {
            const outputP = document.getElementById("buttonOutput");
            outputP.innerHTML = `Cube of ${number} is ${r}`;
        }
    )
}
```
And that's it, we have created a simple application using HTML and JavaScript as input and Julia for calculating!

# PlutoBoard.jl Documentation

## PlutoBoard interface

### Julia interface
```@docs
initialize(_html_path::String, _css_path::String; fullscreen::Bool = false, bootstrap::Bool = false, hide_notebook::Bool = true)
```

### JavaScript interface
These functions can be called in the browser and are written in **JavaScript**.
```@docs
callJuliaFunction()
```

## Internal functions

### Julia internal functions
```@docs
load_scripts_and_links()
load_html()
load_html_string_to_body()
load_js()
open_file(path::String)
copy_with_delete(from::String, to::String)
setup()
get_package_name()
```

### JavaScript internal functions
```@docs
placeIframe()
updateAllCells()
updateCell()
insertHTMLToBody()
```