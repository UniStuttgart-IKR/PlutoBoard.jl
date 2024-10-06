export callJuliaFunction

"""
```javascript
async callJuliaFunction(
	func_name,
	{ args = [], kwargs = {}, response_callback = () => { } } = {}
) -> Promise
```
`kwargs` are kwargs for the Julia function to be called.

Calls specified Julia function with args and callback within browser context from JavaScript.

Example usage:
```javascript
callJuliaFunction("get_cube", {
	args: [number],
	response_callback: (
		r => {
			const outP = document.getElementById("buttonOutput");
			outP.innerHTML = `Cube of \${number}... \${Math.round(r * 100)}%`;
		}
	)
	}).then(
		r => {
			const outP = document.getElementById("buttonOutput");
			outP.innerHTML = `The cube of \${number} is \${r}`;
		}
	)
```
"""
function callJuliaFunction()

end

