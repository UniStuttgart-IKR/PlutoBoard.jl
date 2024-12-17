import { placeAlliFrames } from "./iFrame.js";
import { callJuliaFunction } from "./interface.js";
import { sendToast } from "./toasts.js";

// --------------------------------------------------- SETTINGS MODAL ---------------------------------------------------

export function addModalButtonListener() {
    const openBtn = document.getElementById('open-settings-modal');
    const closeBtn = document.getElementById('close-settings-modal');

    openBtn.addEventListener('click', () => {
        openSettings();
    });

    closeBtn.addEventListener('click', () => {
        closeSettings();
    });
}

export function openSettings() {
    const modal = document.getElementById('default-modal');
    const pageContent = document.getElementById('main-export');

    modal.classList.remove('hidden');
    modal.classList.add('flex');
    pageContent.classList.add('blur-sm');
}

export function closeSettings() {
    const modal = document.getElementById('default-modal');
    const pageContent = document.getElementById('main-export');

    modal.classList.remove('flex');
    modal.classList.add('hidden');
    pageContent.classList.remove('blur-sm');
}

export function findCell(cell_id) {
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


// --------------------------------------------------- CELL TABLE ---------------------------------------------------

export function updateCellIDsTable() {
    callJuliaFunction("get_cells", { internal: true }).then(
        r => {
            const table = document.getElementById("cellids-tbody");
            const rows = [];
            r.forEach(cell_id => {
                const index = r.indexOf(cell_id) + 1;
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

export function removeCell(cell_id) {
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

export function addCell() {
    callJuliaFunction("add_cell", { internal: true }).then(
        r => {
            updateCellIDsTable();
            sendToast(`Cell added.`, 'success');
        }
    );
}