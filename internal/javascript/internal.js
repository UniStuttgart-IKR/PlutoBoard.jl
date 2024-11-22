// DO LOAD IN IFRAME!

async function updateAllCells() {
    const cells = document.querySelectorAll("pluto-cell");
    await cells[0]._internal_pluto_actions.set_and_run_multiple(Array.from(cells).map(cell => cell.id));
    window.location.reload();
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
}

function openNav() {
    document.getElementById("mySidebar").style.width = "250px";
}

function closeNav() {
    document.getElementById("mySidebar").style.width = "0";
}

function resizeInitial() {
    let element = document.getElementById("pluto-nav").parentElement.parentElement;
    element.style.minHeight = "0";
}



// --------------------------------------------------- SETTINGS MODAL ---------------------------------------------------

const modal = document.getElementById('default-modal');
const openBtn = document.getElementById('open-settings-modal');
const closeBtn = document.getElementById('close-settings-modal');
const pageContent = document.getElementById('main-export');

function openSettings() {
    modal.classList.remove('hidden');
    modal.classList.add('flex');
    pageContent.classList.add('blur-sm');
}

function closeSettings() {
    modal.classList.remove('flex');
    modal.classList.add('hidden');
    pageContent.classList.remove('blur-sm');
}

openBtn.addEventListener('click', () => {
    openSettings();
});

closeBtn.addEventListener('click', () => {
    closeSettings();
});

function findCell(cell_id) {
    //find cell with property cellid=cell_id
    const cell = document.querySelector(`div[cellid="${cell_id}"]`);
    if (cell) {
        sendToast(`Cell ${cell_id} found.`, 'success');
        closeSettings();
        cell.classList.add('border-4', 'border-red-500');
        setTimeout(() => {
            cell.classList.remove('border-4', 'border-red-500');
        }, 3000);
    } else {
        sendToast(`Cell ${cell_id} not found.`, 'error');
    }
}


function sendToast(message, type) {
    const toastContainer = document.getElementById('toast-container');
    let img = '';
    if (type === 'success') {
        img = `<div class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-green-500 bg-green-100 rounded-lg dark:bg-green-800 dark:text-green-200">
                    <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 8.207-4 4a1 1 0 0 1-1.414 0l-2-2a1 1 0 0 1 1.414-1.414L9 10.586l3.293-3.293a1 1 0 0 1 1.414 1.414Z"/>
                    </svg>
                    <span class="sr-only">Check icon</span>
                </div>`;
    } else if (type === 'error') {
        img = `<div class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-red-500 bg-red-100 rounded-lg dark:bg-red-800 dark:text-red-200">
                    <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 11.793a1 1 0 1 1-1.414 1.414L10 11.414l-2.293 2.293a1 1 0 0 1-1.414-1.414L8.586 10 6.293 7.707a1 1 0 0 1 1.414-1.414L10 8.586l2.293-2.293a1 1 0 0 1 1.414 1.414L11.414 10l2.293 2.293Z"/>
                    </svg>
                    <span class="sr-only">Error icon</span>
                </div>`;
    }
    else if (type === 'warning') {
        img = `<div class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-orange-500 bg-orange-100 rounded-lg dark:bg-orange-700 dark:text-orange-200">
                    <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM10 15a1 1 0 1 1 0-2 1 1 0 0 1 0 2Zm1-4a1 1 0 0 1-2 0V6a1 1 0 0 1 2 0v5Z"/>
                    </svg>
                    <span class="sr-only">Warning icon</span>
                </div>`;
    }

    //generate random id for toast
    const id = Math.random().toString(36).substring(7);
    const toast = `<div id="toast-${id}" class="flex items-center w-full max-w-xs p-4 mb-4 text-gray-500 bg-white rounded-lg shadow dark:text-gray-400 dark:bg-gray-800" role="alert">
                        ${img}
                        <div class="ms-3 text-sm font-normal">${message}</div>
                        <button type="button" class="ms-auto -mx-1.5 -my-1.5 bg-white text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-gray-100 inline-flex items-center justify-center h-8 w-8 dark:text-gray-500 dark:hover:text-white dark:bg-gray-800 dark:hover:bg-gray-700" data-dismiss-target="#toast-success" aria-label="Close">
                            <span class="sr-only">Close</span>
                            <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                            </svg>
                        </button>
                    </div>`;

    //append toast to toast container
    toastContainer.insertAdjacentHTML('beforeend', toast);

    //remove toast after 5 seconds
    setTimeout(() => {
        document.getElementById(`toast-${id}`).remove();
    }, 5000);
}


// --------------------------------------------------- CELL TABLE ---------------------------------------------------

function updateCellIDsTable() {
    callJuliaFunction("get_cells", { internal: true }).then(
        r => {
            const table = document.getElementById("cellids-tbody");
            const rows = [];
            r.forEach(cell_id => {
                index = r.indexOf(cell_id) + 1;
                console.log(cell_id);
                rows.push(`
                        <tr
                        class="odd:bg-white odd:dark:bg-gray-900 even:bg-gray-50 even:dark:bg-gray-800 border-b dark:border-gray-700">
                        <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                            ${index}
                        </th>
                        <td class="px-6 py-4">
                            ${cell_id}
                        </td>
                        <td class="px-6 py-4">
                            <button
                                class="w-30 bg-transparent  text-slate-200 text-sm border border-slate-200 rounded-md px-3 py-2 hover:bg-gray-600 hover:text-white"
                                onclick="findCell('${cell_id}')">Find</button>
                        </td>
                        <td class="px-6 py-4">
                            <button
                                class="w-30 bg-transparent  text-slate-200 text-sm border border-slate-200 rounded-md px-3 py-2 hover:bg-gray-600 hover:text-white"
                                onclick="">Move up</button>
                        </td>
                        <td class="px-6 py-4">
                            <button
                                class="w-30 bg-transparent  text-slate-200 text-sm border border-slate-200 rounded-md px-3 py-2 hover:bg-gray-600 hover:text-white"
                                onclick="">Move down</button>
                        </td>
                        <td class="px-6 py-4">
                            <button
                                class="w-30 bg-transparent  text-slate-200 text-sm border border-slate-200 rounded-md px-3 py-2 hover:bg-gray-600 hover:text-white"
                                onclick="removeCell('${cell_id}')">Remove</button>
                        </td>
                        
                        <td class="px-6 py-4">
                            
                        </td>
                    </tr>
                    `);
            });
            table.innerHTML = "";
            table.innerHTML = rows.join("");
        }
    )
}

function removeCell(cell_id) {
    callJuliaFunction("remove_cell", {
        args: [cell_id],
        internal: true
    }).then(
        _ => {
            sendToast(`Cell removed.`, 'success');
            updateCellIDsTable();
        }
    );
}

function addCell() {
    callJuliaFunction("add_cell", { internal: true }).then(
        r => {
            sendToast(`Cell added.`, 'success');
            updateCellIDsTable();
        }
    );
}
updateCellIDsTable();

// --------------------------------------------------- Run functions ---------------------------------------------------

resizeInitial();



