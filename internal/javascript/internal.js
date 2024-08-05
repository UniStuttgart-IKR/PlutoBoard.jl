// DO LOAD IN IFRAME!

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
}

function openNav() {
    document.getElementById("mySidebar").style.width = "250px";
}

function closeNav() {
    document.getElementById("mySidebar").style.width = "0";
}


