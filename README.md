# PlutoBoard.jl
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://UniStuttgart-IKR.github.io/PlutoBoard.jl/dev)

PlutBoard.jl is still in an early state.

# Setup
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

# Write your own code
There is some hierarchy:
- `main` in `src/Main.jl` gets called in the beginning, so use this as julia entry point
- functions that should be callable from js need to go into `src/Functions.jl`
- all javascript files in `static/javascript/` are getting executed, though `static/javascript/javascript.js` is the last one, so use this as js entry point

There is a simple example in `src/Functions.jl`, `src/static/index.html` and `src/static/javascript/javascript.js` about calling a julia function from javascript with callbacks.

Screenshot of a simple example:
![image](https://github.com/user-attachments/assets/af99abeb-f613-4b8f-9ae2-c25fb15107bd)

