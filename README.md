# PlutoBoard.jl

This is still in its very early states, so don't expect too much.

# Setup
```bash
$ pkg> generate ExampleProject
```
```bash
$ cd ExampleProject
```
```bash
/ExampleProject$ Julia --project
```
```bash
(ExampleProject) pkg> add https://github.com/UniStuttgart-IKR/PlutoBoard.jl
```
```bash
(ExampleProject) pkg> add Pluto
```
```bash
julia> using PlutoBoard, Pluto
```
```bash
julia> PlutoBoard.setup()
```
```bash
julia> Pluto.run(notebook="PlutoBoardNotebook.jl")
```
