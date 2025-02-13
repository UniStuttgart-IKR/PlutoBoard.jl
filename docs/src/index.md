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
- `main` in `src/Main.jl` gets called in the beginning, use this as Julia entry point
- `static/javascript/main.js` is getting executed in the beginning too, use this as JS entrypoint
- functions that should be callable from js should to go into `src/Functions.jl`. They can be anywhere else too, but make sure they are included in `src/YOUR_PACKAGE_NAME.jl`

There is a simple example in `src/Functions.jl`, `static/index.html` and `static/javascript/main.js` about calling a Julia function from JS with callbacks.

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
<button class="btn btn-light" id="calculateButton">Calculate</button>
```
and a div to show our output
```HTML
<div class="text-white" id="buttonOutput">Output: </div>
```
Now we need to define a function that does something when we click the button. We do this in `static/javascript/main.js`
```JavaScript
//Import callJuliaFunction. Internal JS files are on /internal/static/javascript
import { callJuliaFunction } from "/internal/static/javascript/interface.js";

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

//add our function as click event to the button
document.getElementById("calculateButton").addEventListener("click", calculateVeryHardStuff);
```
!!! info
    Using `await` Syntax also works:
    ```JavaScript
    let value = await callJuliaFunction("get_cube", {args: [10]});
    console.log(value);
    ```

    ```
    > 1000
    ```

And that's it, we have created a simple application using HTML and JavaScript as input and Julia for calculating!

Importing other JS files is easily done using ES6 Modules:
```javascript
//imports function from static/javascript/folder/file.js
import { function } from "./folder/file.js";
```

!!! info
    Don't forget to export functions you want to import elsewhere.