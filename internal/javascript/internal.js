function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function changeCallJuliaFunctionReturnValue(returnValue) {
    const h1 = document.getElementById('callJuliaFunctionReturn');
    h1.innerHTML = returnValue;
}
function resizePlutoCell() {
    cellID = "aa5b4411-c643-4f81-bb08-54b94d5c5fbb";



    document.querySelector('main').style.maxWidth = "100vw";
    document.querySelector('main').style.width = "100vw";
    document.querySelector('main').style.padding = "0";

    document.getElementById('pluto-nav').style.display = "none";
    document.querySelector('pluto-helpbox').style.display = "none";
    document.querySelector('preamble').style.display = "none";
    document.querySelector('footer').style.display = "none";

    //append pluto-cell-spacing to style of document.querySelector('pluto-notebook')
    document.querySelector('pluto-notebook').style.setProperty('--pluto-cell-spacing', '0');




    for (cell of document.querySelectorAll('pluto-cell')) {
        if (cell.id != cellID) {
            cell.style.display = "none";
        }
        else {
            //hide all children except pluto-output
            for (child of cell.children) {
                if (child.className != "rich_output ") {
                    child.style.display = "none";
                }
                else {
                    child.style.padding = "0";
                }
            }
        }

    }

    const cellOutput = document.getElementById(cellID).querySelector('.raw-html-wrapper').firstChild;
    cellOutput.style.width = "100vw";
    cellOutput.style.height = "100vh";
    cellOutput.style.margin = "0";
    cellOutput.style.padding = "0";
    //change --pluto-cell-spacing to 0


    console.log(cellOutput);
}

async function updateAllCells() {
    const cells = document.querySelectorAll("pluto-cell");
    await cells[0]._internal_pluto_actions.set_and_run_multiple(Array.from(cells).map(cell => cell.id));

    //wait until .settings is display: none
    // while (document.querySelector(".settings-container").style.display !== "none") {
    //     await new Promise(resolve => setTimeout(resolve, 100));
    // }
}