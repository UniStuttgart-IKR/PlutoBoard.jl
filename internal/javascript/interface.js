delete functionRunning;
delete waitForReturn;


functionRunning = true;
waitForReturn = setInterval(function () {
    if (document.getElementById('callJuliaFunctionReturn')) {
        clearInterval(waitForReturn);
        functionRunning = false;
    }
}, 100)



function callJuliaFunction(func, args = [], returnValue = false) {
    const textField = document.getElementById('callJuliaFunctionTextField');

    //map args to dict wih key: type and value: value
    let argsArray = args;

    passedArgs = {
        "func": func,
        "args": argsArray,
        "returnValue": returnValue
    }

    textField.value = JSON.stringify(passedArgs);
    textField.dispatchEvent(new CustomEvent("input"));

    console.log("Calling Julia function: " + func + " with args: " + argsArray);
}

async function callJuliaFunctionWithReturn(func, args = []) {
    while (functionRunning === true) {
        await sleep(100);
        console.log("Blocking", functionRunning);
    }
    functionRunning = true;

    changeCallJuliaFunctionReturnValue("Waiting for Julia function to return...")

    const h1Before = document.getElementById('callJuliaFunctionReturn').innerHTML;
    callJuliaFunction(func, args, true);

    let h1After = document.getElementById('callJuliaFunctionReturn').innerHTML;
    while (h1Before == h1After) {
        h1After = document.getElementById('callJuliaFunctionReturn').innerHTML;
        await sleep(100);
    }
    if (h1After == "") {
        functionRunning = false;
        return null;
    }
    const answer = JSON.parse(h1After);
    functionRunning = false;
    return answer;

}