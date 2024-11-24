import { callJuliaFunction } from "/internal/static/javascript/interface.js";

function calculateVeryHardStuff() {
    const input = document.getElementById("buttonInput");
    const number = parseInt(input.value);

    callJuliaFunction("get_cube", {
        args: [number],
        response_callback: (
            r => {
                const outputP = document.getElementById("buttonOutput");
                outputP.innerHTML = `${Math.round(r * 100)}%...`;
            }
        )
    })
        .then(
            r => {
                const outputP = document.getElementById("buttonOutput");
                outputP.innerHTML = `Cube of ${number} is ${r}`;
            }
        )
}

document.getElementById("calculateButton").addEventListener("click", calculateVeryHardStuff);