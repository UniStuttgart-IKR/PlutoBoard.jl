import { info } from "./logger.js";

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

export function setIFrames() {
    const mainExportListener = setInterval(function () {
        if ((document.querySelector('#app') !== undefined) || (document.querySelector("#main-export") !== undefined)) {
            clearInterval(mainExportListener);
            placeAlliFrames();
        }
    }, 100);
}