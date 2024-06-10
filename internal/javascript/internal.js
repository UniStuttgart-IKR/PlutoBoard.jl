function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function changeCallJuliaFunctionReturnValue(returnValue) {
    const h1 = document.getElementById('callJuliaFunctionReturn');
    h1.innerHTML = returnValue;
}

async function updateAllCells() {
    const cells = document.querySelectorAll("pluto-cell");
    await cells[0]._internal_pluto_actions.set_and_run_multiple(Array.from(cells).map(cell => cell.id));
}

async function updateCell(cellID) {
    const cell = document.getElementById(cellID);
    await cell._internal_pluto_actions.set_and_run_multiple([cellID]);
}

function insertHTMLToBody(html, css) {
    let body = document.querySelector('body');
    if (!body.querySelector('style')) {
        body.insertAdjacentHTML('beforeend', css);
    } else {
        body.querySelector('style').remove();
        body.insertAdjacentHTML('afterbegin', css);
    }

    if (!document.getElementById('main-export')) {
        body.insertAdjacentHTML('afterbegin', html);
    } else {
        document.getElementById('main-export').remove();
        body.insertAdjacentHTML('afterbegin', html);
    }

    (() => {
        let cellDivs = Array.from(document.querySelectorAll('div')).filter((element) => element.id.startsWith('cell-div-'));

        for (cellDiv of cellDivs) {
            let destinationDivId = cellDiv.id + "-destination"
            let cellID = cellDiv.getAttribute('cellid');

            cellDiv.innerHTML = `
                <div class="container">
                    <div class="container">
                        <div class="row">
                            <div class="col-8 d-flex justify-content-center">
                                <textarea cols="40" rows="4" class="text-left" id="cellinput-${cellID}" value="">
                                </textarea>
                            </div>
                            <div class="col-4 d-flex justify-content-center">
                                <button class="btn btn-light btn-run"
                                    onclick="runCellWrapper('${cellID}', '${destinationDivId}', 'cellinput-${cellID}');">Run
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="container">
                        <div class="row">
                            <div id="${destinationDivId}"></div>
                        </div>
                    </div>
                </div>`



            const textArea = cellDiv.querySelector('textarea');
            textArea.value = "";

            moveWhenDestinationDivIsEmptyListener(cellID, destinationDivId);
            moveCell(cellID, destinationDivId);

        }

    })();
}


function moveCell(id, destinationID) {
    let linkedDiv = document.getElementById(id);
    let destinationDiv = document.getElementById(destinationID);

    destinationDiv.appendChild(linkedDiv);
}

async function moveWhenDestinationDivIsEmptyListener(cellID, destinationID) {
    let observer = new MutationObserver(function (mutations) {
        //console.log(mutations);
        mutations.forEach(async function (mutation) {
            if (mutation.removedNodes.length > 0) {
                while ((document.getElementById(cellID).classList.contains('running') ||
                    document.getElementById(cellID).classList.contains('queued')) === true) {
                    console.log("Cell is running");
                    await sleep(100);
                }

                //console.log(document.getElementById('destination-div').innerHTML, mutation.removedNodes.length);
                await sleep(100);
                moveCell(cellID, destinationID);

            }

        });
    });
    console.log(document.getElementById(destinationID))
    observer.observe(document.getElementById(destinationID), { childList: true });
}

async function changeCellCodeContent(content, id) {
    let cell = document.getElementById(id);
    cell.querySelectorAll('.ͼo').forEach((element) => {
        element.innerHTML = "";
    });

    let code = cell.querySelector('.ͼo');
    code.innerHTML = content;
    await updateCell(id);
}

function runCellWrapper(cellID, destinationID, cellInputID) {
    const inputString = document.getElementById(cellInputID, cellID).value;
    changeCellCodeContent(inputString, cellID).then(() => {
        updateCell(cellID).then(() => {
            moveCell(cellID, destinationID)
        });
    });
}

