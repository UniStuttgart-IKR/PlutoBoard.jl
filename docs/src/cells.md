# Pluto Cells

You can place Pluto cells everywhere in the HTML document by adding `cell-div` to the class attribute of a div. PlutoBoard will place the cell with matching `cellid` inside that div:

```html
<div class="cell-div" cellid="cell_id" rv="some_variable" />
```

`rv` is optional and used for reactive variables. For further information about reactivity and reactive variables head to `reactivity`.
