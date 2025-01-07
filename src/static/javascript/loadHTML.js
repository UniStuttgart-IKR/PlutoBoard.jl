import { callJuliaFunction } from './interface.js';

export async function insertHTMLToBody() {
    const body = document.querySelector('body');

    const mainSite = await ((await fetch("http://127.0.0.1:8085/index.html")).text());

    if (!document.getElementById('main-export')) {
        body.insertAdjacentHTML('afterbegin', mainSite);
    } else {
        document.getElementById('main-export').remove();
        body.insertAdjacentHTML('afterbegin', mainSite);
    }
}