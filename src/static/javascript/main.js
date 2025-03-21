import { insertHTMLToBody, addCSSToBody, insertSettingsHTMLToBody } from './loadStatic.js';
import { addModalButtonListener, updateCellIDsTable } from './settings.js';
import { resizePlutoNav } from './internal.js';
import { addCell, removeCell, findCell } from './settings.js';
import { updateAllCells } from './internal.js';
import { setIFrames } from './iFrame.js';
import { callJuliaFunction } from './interface.js';

// --------------------------------------------------- LOAD HTML ---------------------------------------------------
await insertHTMLToBody();
await addCSSToBody();

resizePlutoNav();
setIFrames();

// --------------------------------------------------- SETTINGS ---------------------------------------------------
await insertSettingsHTMLToBody();
addModalButtonListener();
updateCellIDsTable();

window.addCell = addCell;
window.removeCell = removeCell;
window.findCell = findCell;


// --------------------------------------------------- GENERAL ---------------------------------------------------

//add updateAllCells function to the window object
window.updateAllCells = updateAllCells;

callJuliaFunction("monitor_folder", {
    response_callback: (changed) => {
        console.log("changed", changed);
        if (changed) {
            updateAllCells();
        }
    },
    internal: true
});





