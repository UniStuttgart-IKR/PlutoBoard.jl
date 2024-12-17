export callJuliaFunction

"""
```javascript
async callJuliaFunction(
	func_name,
	{ args = [], kwargs = {}, response_callback = () => { }, internal = false } = {}
) -> Promise
```
Calls specified Julia function with args and callback within browser context from JavaScript.

Args:
- `func_name: String`: Function name of the called Julia function

Kwargs:
- `args: Array`: Args for the Julia function
- `kwargs: Dict`: Kwargs for the Julia function
- `response_callback: Function`: Function that gets called when a new message is being sent from the Julia function
- `internal: Boolean = false`: Whether the targeted function is in PlutoBoard package. Only used for internal calls, defaults to false


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


# """
# ```javascript
# placeIframe(targetCellID, destinationDiv)
# ```
# Places an iframe of the site itself in `destinationDiv` only showing `targetCellID`.
# """
# function placeIframe()
# end

# """
# ```javascript
# placeAlliFrames()
# ```
# Calls `placeIframe` for every div with `cellid` attribute.
# """
# function placeAlliFrames()
# end

# """
# ```javascript
# async updateAllCells()
# ```
# Forcefully reevaluates all Pluto cells.
# """
# function updateAllCells()
# end

# """
# ```javascript
# async updateCell(cellid)
# ```
# Reevaluates Pluto cell with `cellid`.
# """
# function updateCell()
# end

# """
# ```javascript
# insertHTMLToBody(html, css)
# ```
# Appends html and css string below body.
# """
# function insertHTMLToBody()
# end
