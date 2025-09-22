```@contents
```

# Starting a new project

## Setup
Add PlutoBoard and set it up
```bash
YOUR_PACKAGE_NAME$> julia --project -e 'using Pkg; Pkg.add(url="https://github.com/UniStuttgart-IKR/PlutoBoard.jl"); using PlutoBoard; PlutoBoard.setup()' 
```

The setup will ask for the desired package name and an example to load. After that, you can cd into the newly created package and run PlutoBoard:

```bash
YOUR_PACKAGE_NAME$> julia --project -e 'using PlutoBoard; PlutoBoard.run()'
```

## Writing your own code
`main()` in `src/Main.jl` gets called in the beginning, use this as Julia entry point.

### Calling of a Julia function within HTML using a button and an input

First, lets write a simple Julia function in `src/Functions.jl`.
!!! info
    The file name can be arbitrarly chosen, just make sure to include it in `src/PlutoBoard.jl`

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
Now we need to define a function that does something when we click the button. We do this in `static/javascript/main.js`.

!!! info
    Internal JS files are located on `/internal/static/javascript/`.

```JavaScript
//Import callJuliaFunction.
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

Lastly we just need to load the file, so we add it to the head of `index.html`:
```html
<html>
  <head>
    <title>PlutoBoard.jl</title>
    <script
      src="http://localhost:8085/javascript/main.js"
      type="module"
    ></script>
  </head>
  ...
</html>
```

!!! info
    If you use another port for the fileserver, PlutoBoard automatically changes it in the `index.html` file, so don't worry about that!

!!! info
    If you run PlutoBoard while editing a static file, like `index.html`, the notebook auto reloads!

And that's it, we have created a simple application using HTML and JavaScript as input and Julia for calculating!

Importing other JS files is easily done using ES6 Modules:
```javascript
//imports function from static/javascript/folder/file.js
import { function } from "./folder/file.js";
```

!!! info
    Don't forget to export functions you want to import elsewhere.
