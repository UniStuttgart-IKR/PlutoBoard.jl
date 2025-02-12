import { callJuliaFunction } from './interface.js';

export async function insertHTMLToBody() {
    const body = document.querySelector('body');

    const mainSite = await ((await fetch("http://localhost:8085/index.html")).text());
    const settingsSite = await ((await fetch("http://localhost:8085/internal/static/html/settings.html")).text());

    const htmlString = settingsSite + mainSite;

    if (!document.getElementById('main-export')) {
        body.insertAdjacentHTML('afterbegin', htmlString);
    } else {
        document.getElementById('main-export').remove();
        body.insertAdjacentHTML('afterbegin', htmlString);
    }
}

export async function addCSSToBody() {
    const cssFiles = await callJuliaFunction('get_css_files', { internal: true });
    console.log(cssFiles);
    const head = document.querySelector('head');
    cssFiles.forEach(async (cssFile) => {
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = `http://localhost:8085/css/${cssFile}`;
        head.appendChild(link);
    });
}