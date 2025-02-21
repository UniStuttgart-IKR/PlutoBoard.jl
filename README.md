# PlutoBoard.jl
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://UniStuttgart-IKR.github.io/PlutoBoard.jl/dev)

PlutoBoard.jl is still in an early state.

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
YOUR_PACKAGE_NAME$> julia --project -e 'using PlutoBoard; PlutoBoard.run(debug=True)'
```

# Write your own code
There is some hierarchy:
- `main` in `src/Main.jl` gets called in the beginning, so use this as julia entry point
- functions that should be callable from js need to be in the package, i.e., need to be included in `src/PlutoBoard.jl` (`include('path/to/some/file.jl')`)
- all javascript files in `static/javascript/` are getting executed, though `static/javascript/javascript.js` is the last one, so use this as js entry point

There is a simple example in `src/PlutoBoard.jl`, `src/static/index.html` and `src/static/javascript/javascript.js` about calling a julia function from javascript with callbacks.

Screenshot of a simple example:
![image](https://github.com/user-attachments/assets/af99abeb-f613-4b8f-9ae2-c25fb15107bd)

