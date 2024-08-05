# PlutoBoard.jl

This is still in its very early states, so don't expect too much.

# Setup
Generate your package
```bash
$> Julia -e 'using Pkg; Pkg.generate("YOUR_PACKAGE_NAME")' && cd YOUR_PACKAGE_NAME
```
Add PlutoBoard and set it up
```bash
YOUR_PACKAGE_NAME$> Julia --project -e 'using Pkg; Pkg.add("HTTP"); Pkg.add("JSON"); Pkg.add(url="https://github.com/UniStuttgart-IKR/PlutoBoard.jl"); using PlutoBoard; PlutoBoard.setup()' 
```
Run the notebook
```bash
YOUR_PACKAGE_NAME$> Julia --project -e 'using Pluto; Pluto.run(notebook="PlutoBoardNotebook.jl")'
```

# Write your own code
There is some hierarchy:
- `main` in `src/Main.jl` gets called in the beginning, so use this as julia entry point
- functions that should be callable from js should go into `src/Functions.jl`
- all javascript files in `static/javascript` are getting executed, though `static/javascript/javascript.js` is the last one, so use this as js entry point

There is a simple example in `src/Functions.jl`, `src/static/index.html` and `src/static/javascript/javascript.js` about calling a julia function from javascript with callbacks.

# Docs are about to come
