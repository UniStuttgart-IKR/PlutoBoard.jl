# Reactivity

Since Pluto's reactivity system does not work for variables inside a package (e.g. `user_package`), but we may need to rerun cells based on their variables (e.g. a cell containing a plot that should update when we collect data from the user with HTML elements), PlutoBoard.jl offers functions to achieve this.

## Updating all cells containing matching variables

```javascript
await updateCellsByReactiveVariable(reactiveVariable);
```

finds all cells containing `reactiveVariable` and reruns them.

!!! info
Note that `variable` would also rerun a cell containing `variable_1`. If exact matching is needed, use `updateCellByReactiveVariableAttribute`.

## Updating all cells with certain attribute

```javascript
await updateCellByReactiveVariableAttribute(reactiveVariable);
```

finds all `<div>` elements with the class `cell-div` attribute `rv=reactiveVariable` and reruns them.

`updateCellByReactiveVariableAttribute("some_number")` would rerun following `<div>`:

```html
<div class="cell-div" cellid="..." rv="some_number" />
```

But won't rerun not exact matches:

```html
<div class="cell-div" cellid="..." rv="some_number_2" />
```

The `rv` attribute is **not limited** to one Reactive variable, it can also have multiple, like `rv="some_number some_number_1 some_number_2"` seperated with a space.
