console.log("Hello from PlutoBoard.jl")

function changeInnerHTML(id, text) {
    document.getElementById(id).innerHTML = text;
}

function currentTimeLoop() {
    setInterval(function () {
        var date = new Date();
        var time = date.toLocaleTimeString();
        changeInnerHTML("current-time", time);
    }, 1000);
}




delete waitForTextField;

waitForTextField = setInterval(function () {
    if (document.getElementById('callJuliaFunctionTextField')) {
        clearInterval(waitForTextField);
        callJuliaFunctionWithReturn("get_package_name").then((r) => {
            changeInnerHTML("package-name", r);
        })

        callJuliaFunctionWithReturn("get_julia_version").then((r) => {
            changeInnerHTML("julia-version", r);
        })
        currentTimeLoop();

    }
}, 100);
