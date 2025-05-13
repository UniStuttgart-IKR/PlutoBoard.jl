export async function updateCell(cellID) {
    //updates a cell by its ID
    const cell = document.getElementById(cellID);
    await cell._internal_pluto_actions.set_and_run_multiple([cellID]);
}

export async function updateCellsByID(cellIDs) {
    //updates multiple cells by their IDs
    const cells = cellIDs.map(cellID => document.getElementById(cellID));
    await cells[0]._internal_pluto_actions.set_and_run_multiple(cellIDs);
}

export async function updateCellByReactiveVariableAttribute(rv) {
    //updates all cells containing `rv` in their `rv` attribute
    const cells = [...document.querySelectorAll(`div[rv]`)].filter(el => new RegExp(`\\b${rv}\\b`).test(el.getAttribute('rv')));
    for (let i = 0; i < cells.length; i++) {
        await updateCell(cells[i].getAttribute('cellid'));
    }
}

export async function updateCellsByReactiveVariable(rv) {
    //updates all cells containing `rv` in their innerHTML
    const cellIDS = [...document.querySelectorAll(`div[class="awesome-wrapping-plugin-the-line cm-line"]`)].filter(el => new RegExp(`${rv}`).test(el.innerHTML)).map(el => el.closest(`pluto-cell`)?.id);

    await updateCellsByID(cellIDS);
    console.log(`Updated cells with reactive variable ${rv}:`, cellIDS);
}

export async function updateCellByVariable(varName) {
    //fetch cellids needed to get updated
    const cellIDS = await callJuliaFunction("find_cells_with_variable", {args: [varName], internal: true});
    console.log(`Updating cells with variable ${varName}:`, cellIDS);
    //update cells
    await updateCellsByID(cellIDS);
}


function setupWebsocket() {
    let socket;
    while (socket === undefined) {
        info('Waiting for WebSocket to be defined');
        new Promise(resolve => setTimeout(resolve, 100));
        socket = new WebSocket('ws://localhost:8080');
    }

    socket.addEventListener('open', function (event) {
        info('WebSocket is open now.');
    });

    socket.addEventListener('close', function (event) {
        info('WebSocket is closed now.');
    });

    socket.addEventListener('error', function (event) {
        error('WebSocket error observed:', event);
    });
    return socket;
}

function waitForOpenConnection(socket) {
    return new Promise((resolve, reject) => {
        if (socket.readyState === WebSocket.OPEN) {
            resolve();
        } else {
            socket.addEventListener('open', () => {
                resolve();
            });

            socket.addEventListener('error', (err) => {
                reject(new Error('WebSocket connection failed: ' + err.message));
            });
        }
    });
}

export async function callJuliaFunction(func_name, {
    args = [], kwargs = {}, response_callback = () => {
    }, internal = false
} = {}) {
    const socket = setupWebsocket();
    await waitForOpenConnection(socket);

    info(`Calling Julia function ${func_name} with args: ${args}, kwargs: ${JSON.stringify(kwargs)}, internal: ${internal}`);

    const cmd = {
        "type": "julia_function_call",
        "function": func_name,
        "args": args,
        "kwargs": kwargs,
        "internal": internal
    }
    socket.send(JSON.stringify(cmd));

    return new Promise((resolve, reject) => {
        socket.addEventListener('message', (event) => {
            if (JSON.parse(event.data).type === 'return') {
                socket.close();
                resolve(JSON.parse(event.data).return);
            } else if (JSON.parse(event.data).type === 'response') {
                response_callback(JSON.parse(event.data).response);
            }
        });
    });
}

export function info(message) {
    console.log(`[PlutoBoard.jl] ${message}`);
}

export function warn(message) {
    console.warn(`[PlutoBoard.jl] ${message}`);
}

export function error(message) {
    console.error(`[PlutoBoard.jl] ${message}`);
}

export function placeIframe(targetCellID, destinationDiv) {
    const iFrameID = `cell-iframe-${targetCellID}`;

    let listener = setInterval(function () {
        if (destinationDiv !== null) {
            clearInterval(listener);


            let notebook = document.querySelector('pluto-notebook');
            let notebookID = notebook.id;

            let div = destinationDiv;
            //remove all iFrame children of div
            div.querySelectorAll('iframe').forEach(iframe => {
                iframe.remove();
            });

            let iframe = document.createElement('iframe');
            iframe.id = iFrameID;
            iframe.src = `http://localhost:1234/edit?id=${notebookID}`;

            if (window.location === window.parent.location) {
                div.appendChild(iframe);

                //wait until iframe is loaded
                let interval = setInterval(function () {
                    if (document.querySelector(`#${iFrameID}`).contentDocument) {
                        clearInterval(interval);

                        let interval2 = setInterval(function () {
                            if (document.querySelector(`#${iFrameID}`).contentDocument.getElementById(targetCellID)) {
                                clearInterval(interval2);
                                info(`IFrame with cellid ${targetCellID} loaded`);

                                let iframeDoc = document.querySelector(`#${iFrameID}`).contentDocument;

                                const cell = iframeDoc.getElementById(targetCellID);
                                cell.style.margin = '0.8vw';
                                cell.style.padding = '2vw';
                                cell.style.display = 'block';


                                //get iFrame.css and add it to head in iFrame
                                let css = document.createElement('link');
                                css.rel = 'stylesheet';
                                css.type = 'text/css';
                                css.href = 'http://localhost:8085/internal/static/css/iFrame.css';
                                iframeDoc.head.appendChild(css);
                            }
                        }, 100);
                    }
                }, 100);
            }
        }
    }, 100);
}


export function placeAlliFrames() {
    //get all divs with class cell-div
    let cellDivs = document.querySelectorAll('.cell-div');
    cellDivs.forEach(cellDiv => {
        let cellID = cellDiv.getAttribute('cellid');
        if (cellID === null) {
            return;
        }
        placeIframe(cellID, cellDiv);
    });
}
