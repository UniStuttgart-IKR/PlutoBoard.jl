function callJuliaFunction(func, args, returnValue=false) {
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

async function callJuliaFunctionWithReturn(func, args) {
    changeCallJuliaFunctionReturnValue("Waiting for Julia function to return...")
    const h1Before = document.getElementById('callJuliaFunctionReturn').innerHTML;
    callJuliaFunction(func, args, true);
    //wait until it changes
    let h1After = document.getElementById('callJuliaFunctionReturn').innerHTML;
    while (h1Before == h1After) {
        h1After = document.getElementById('callJuliaFunctionReturn').innerHTML;
        await sleep(100);
    }
    return JSON.parse(h1After);

}