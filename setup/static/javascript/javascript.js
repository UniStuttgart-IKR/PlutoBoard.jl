console.log("Hello from PlutoBoard.jl")


function calculateVeryHardStuff() {
    const input = document.getElementById("buttonInput");
    const number = parseInt(input.value);

    callJuliaFunction("get_cube", {
        args: [number],
        response_callback: (
            r => {
                const outputP = document.getElementById("buttonOutput");
                outputP.innerHTML = `Calculating the cube of ${number}... ${Math.round(r * 100)}% done!`;
            }
        )
    }).then(
        r => {
            const outputP = document.getElementById("buttonOutput");
            outputP.innerHTML = `The cube of ${number} is ${r}`;
        }
    )
}