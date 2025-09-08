/**
 * @fileoverview Internal Pluto functions for PlutoBoard.jl
 * @module Internal
 */

/**
 * Updates all cells in the Pluto notebook.
 * @memberof module:Internal
 * @returns {Promise<void>}
 */
export async function updateAllCells() {
    const cells = document.querySelectorAll("pluto-cell");
    await cells[0]._internal_pluto_actions.set_and_run_multiple(Array.from(cells).map(cell => cell.id));
    window.location.reload();
}


async function updateCell(cellID) {
    const cell = document.getElementById(cellID);
    await cell._internal_pluto_actions.set_and_run_multiple([cellID]);
}

/**
 * Hides the Pluto navigation bar by setting its parent element's minimum height to zero.
 * @memberof module:Internal
 * @returns {void}
 */
export function resizePlutoNav() {
    let element = document.getElementById("pluto-nav").parentElement.parentElement;
    element.style.minHeight = "0";
}