//DO NOT LOAD IN IFRAME

function placeIframe(targetCellID, destinationDiv) {
    const iFrameID = `cell-iframe-${targetCellID}`;
    const plutoBoardExportDivID = 'main-export';

    let listener = setInterval(function () {
        if (destinationDiv !== null) {
            clearInterval(listener);


            let notebook = document.querySelector('pluto-notebook');
            let notebookID = notebook.id;

            let div = destinationDiv;
            let iframe = document.createElement('iframe');
            iframe.id = iFrameID;
            iframe.src = `http://localhost:1234/edit?id=${notebookID}`;

            if (window.location === window.parent.location) {
                div.appendChild(iframe);


                //wait until iframe is loaded
                let interval = setInterval(function () {
                    if (document.querySelector(`#${iFrameID}`).contentDocument) {
                        clearInterval(interval);
                        console.log('iframe loaded');

                        let interval2 = setInterval(function () {
                            if (document.querySelector(`#${iFrameID}`).contentDocument.querySelector(`#${plutoBoardExportDivID}`)) {
                                clearInterval(interval2);
                                console.log('main-export loaded');

                                //find all style tags in iframe and remove them
                                let iframeDoc = document.querySelector(`#${iFrameID}`).contentDocument;
                                let styles = iframeDoc.querySelectorAll('style');
                                //remove all styles without class attribute
                                styles.forEach(style => {
                                    // if (!style.hasAttribute('class')) {
                                    //     style.remove();
                                    // }
                                    //if stlye.innerHTML includes 'PlutoBoard.jl internal stylesheet' remove it
                                    if (style.innerHTML.includes('PlutoBoard.jl internal stylesheet')) {
                                        style.remove();
                                    }

                                });

                                //get all pluto-cell elements and hide them
                                let cells = iframeDoc.querySelectorAll('pluto-cell');
                                cells.forEach(cell => {
                                    //check if id is equal to targetCellID
                                    if (cell.id !== targetCellID) {
                                        cell.style.display = 'none';
                                    } else {
                                        cell.style.margin = '0.8vw';
                                        cell.style.padding = '2vw';
                                    }
                                });

                                //set body background to transparent
                                let body = iframeDoc.querySelector('body');
                                body.style.backgroundColor = 'transparent';

                                //hide header
                                let header = iframeDoc.querySelector('header');
                                header.style.display = 'none';

                                //hie footer
                                let footer = iframeDoc.querySelector('footer');
                                footer.style.display = 'none';

                                //hide #main-export
                                let mainExport = iframeDoc.querySelector(`#${plutoBoardExportDivID}`);
                                mainExport.style.display = 'none';

                                //hide .not-iframe
                                let notIframe = iframeDoc.querySelectorAll('.not-iframe');
                                notIframe.forEach(element => {
                                    element.style.display = 'none';
                                });

                                //hide #helpbox-wrapper
                                let helpbox = iframeDoc.querySelector('#helpbox-wrapper');
                                helpbox.style.display = 'none';

                                //hide every child of body except body>div>pluto-editor>main>pluto-notebook

                                //set main margin & padding to 0
                                let main = iframeDoc.querySelector('main');
                                main.style.margin = '0';
                                main.style.padding = '0';
                                main.style.display = 'contents';

                                //hide preamble
                                let preamble = iframeDoc.querySelector('preamble');
                                preamble.style.display = 'none';

                                //hide all add_cell buttons
                                let addCellButtons = iframeDoc.querySelectorAll('.add_cell');
                                addCellButtons.forEach(button => {
                                    button.style.display = 'none';
                                });

                                //hide .cm-gutters
                                let cmGutters = iframeDoc.querySelectorAll('.cm-gutters');
                                cmGutters.forEach(gutter => {
                                    gutter.style.display = 'none';
                                });

                                //hide all pluto-shoulders
                                let shoulders = iframeDoc.querySelectorAll('pluto-shoulder');
                                shoulders.forEach(shoulder => {
                                    shoulder.style.display = 'none';
                                });

                                //get pluto-editor parent
                                let editor = iframeDoc.querySelector('pluto-editor');
                                let editorParent = editor.parentElement;
                                editorParent.style.minHeight = '0';

                                //set body min height to 0
                                body.style.minHeight = '0';

                                //hide loading-bar
                                let loadingBar = iframeDoc.querySelector('loading-bar');
                                loadingBar.style.display = 'none';


                                //pluto-notebook border radius
                                let notebook = iframeDoc.querySelector('pluto-notebook');
                                notebook.style.borderRadius = '4vw';
                                notebook.style.width = '100vw';
                                notebook.style.height = '100vh';

                                //hide pluto-trafficlight
                                let trafficLight = iframeDoc.querySelector('pluto-trafficlight');
                                trafficLight.style.display = 'none';

                            }
                        }, 100);
                    }
                }, 100);
            }
        }
    }, 100);
}


function placeAlliFrames() {
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

mainExportListener = setInterval(function () {
    if ((document.querySelector('#app') !== undefined) || (document.querySelector("#main-export") !== undefined)) {
        clearInterval(mainExportListener);
        placeAlliFrames();
    }
}, 100);