export callJuliaFunction, placeIframe, updateAllCells, updateCell, insertHTMLToBody

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


"""
```javascript
placeIframe(targetCellID, destinationDiv)
```
Places an iframe of the site itself in `destinationDiv` only showing `targetCellID`.
"""
function placeIframe()
end

"""
```javascript
placeAlliFrames()
```
Calls `placeIframe` for every div with `cellid` attribute.
"""
function placeAlliFrames()
end

"""
```javascript
async updateAllCells()
```
Forcefully reevaluates all Pluto cells.
"""
function updateAllCells()
end

"""
```javascript
async updateCell(cellid)
```
Reevaluates Pluto cell with `cellid`.
"""
function updateCell()
end

"""
```javascript
insertHTMLToBody(html, css)
```
Appends html and css string below body.
"""
function insertHTMLToBody()
end
