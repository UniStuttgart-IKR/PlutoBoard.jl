# PlutoBoard.jl

This is still in its very early states, so don't expect too much.

# Setup
Generate your package
```bash
$> Julia -e 'using Pkg; Pkg.generate("YOUR_PACKAGE_NAME")'
```
cd into it
```bash
$> cd YOUR_PACKAGE_NAME
```
Add PlutoBoard and set it up
```bash
/YOUR_PACKAGE_NAME$> Julia --project -e 'using Pkg; Pkg.add("HTTP"); Pkg.add("JSON"); Pkg.add(url="https://github.com/UniStuttgart-IKR/PlutoBoard.jl"); using PlutoBoard; PlutoBoard.setup()' 
```
Run the notebook
```bash
/YOUR_PACKAGE_NAME$> Julia --project -e 'using Pluto; Pluto.run(notebook="PlutoBoardNotebook.jl")'
```
