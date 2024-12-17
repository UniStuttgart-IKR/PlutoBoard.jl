import { callJuliaFunction } from './interface.js';

export async function insertHTMLToBody() {
    const body = document.querySelector('body');

    // const htmlString = await callJuliaFunction("get_html", {
    //     internal: true,
    // });

    const mainSite = await ((await fetch("http://127.0.0.1:8085/index.html")).text());

    const settingsSite = await ((await fetch("http://127.0.0.1:8085/internal/static/html/settings.html")).text());

    const htmlString = settingsSite + mainSite;

    if (!document.getElementById('main-export')) {
        body.insertAdjacentHTML('afterbegin', htmlString);
    } else {
        document.getElementById('main-export').remove();
        body.insertAdjacentHTML('afterbegin', htmlString);
    }
}