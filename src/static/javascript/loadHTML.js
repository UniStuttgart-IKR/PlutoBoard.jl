import { callJuliaFunction } from './interface.js';

export async function insertHTMLToBody() {
    const body = document.querySelector('body');

    const htmlString = await callJuliaFunction("get_html", {
        internal: true,
    });

    if (!document.getElementById('main-export')) {
        body.insertAdjacentHTML('afterbegin', htmlString);
    } else {
        document.getElementById('main-export').remove();
        body.insertAdjacentHTML('afterbegin', htmlString);
    }
}