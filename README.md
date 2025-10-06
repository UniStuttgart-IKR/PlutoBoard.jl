# PlutoBoard.jl
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://UniStuttgart-IKR.github.io/PlutoBoard.jl/dev)

# Setup
Add PlutoBoard and set it up
```bash
$> julia --project=@temp -e 'using Pkg; Pkg.add(url="https://github.com/UniStuttgart-IKR/PlutoBoardExamples"); Pkg.add(url="https://github.com/UniStuttgart-IKR/PlutoBoard.jl"); using PlutoBoard; PlutoBoard.setup()'
```

The setup will ask for the desired package name and an example to load. After that, you can cd into the newly created package and run PlutoBoard:

```bash
YOUR_PACKAGE_NAME$> julia --project -e 'using PlutoBoard; PlutoBoard.run()'
```

## Writing your own code
For a go through of PlutoBoard functionalities, refer to the [documentation](https://unistuttgart-ikr.github.io/PlutoBoard.jl/dev/).


## Simple example
![image](https://github.com/user-attachments/assets/af99abeb-f613-4b8f-9ae2-c25fb15107bd)

