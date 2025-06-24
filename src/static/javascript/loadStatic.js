import {callJuliaFunction} from './interface.js';

// export async function loadUserMainScript() {
//     const script = document.createElement('script')
//     script.src = "http://localhost:8085/" + "javascript/main.js"
//     script.type = "module"
//     head.appendChild(script)
// }

/**
 * Inserts the HTML document created by the user into the body and head of the current document.
 * @returns {Promise<void>}
 */
export async function insertHTMLToBody() {
    const body = document.querySelector('body');
    const head = document.querySelector('head');

    const mainSite = await ((await fetch("http://localhost:8085/index.html")).text());

    //get scripts within mainSite and add them to head (Scripts are not executed when inside html added with insertAdjacentHTML)
    const parser = new DOMParser();
    const doc = parser.parseFromString(mainSite, 'text/html');

    // adds all scripts to the head
    const scripts = doc.querySelectorAll('script');
    scripts.forEach(script => {
        const newScript = document.createElement('script');
        newScript.src = script.src;
        newScript.type = script.type;
        head.appendChild(newScript);
        script.remove();
    });

    //adds all links to the head
    const links = doc.querySelectorAll('link');
    links.forEach(link => {
        const newLink = document.createElement('link');
        newLink.href = link.href;
        newLink.rel = link.rel;
        head.appendChild(newLink);
        link.remove();
    });

    //move rest of head to current head, like title and meta tags
    head.insertAdjacentHTML('afterbegin', doc.querySelector('head').innerHTML);

    //get all of body from mainSite and add it to the current body
    body.insertAdjacentHTML('afterbegin', doc.querySelector('body').innerHTML);
}

/**
 * Inserts the settings HTML document into the body of the current document.
 * @returns {Promise<void>}
 */
export async function insertSettingsHTMLToBody() {
    const body = document.querySelector('body');
    const settingsSite = await ((await fetch("http://localhost:8085/internal/static/html/settings.html")).text());
    body.insertAdjacentHTML('afterbegin', settingsSite);
}

/**
 * Adds CSS files to the head of the current document.
 * @returns {Promise<void>}
 */
export async function addCSSToBody() {
    const cssFiles = await callJuliaFunction('get_css_files', {internal: true});
    console.log(cssFiles);
    const head = document.querySelector('head');
    for (const cssFile of cssFiles) {
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = `http://localhost:8085/css/${cssFile}`;
        head.appendChild(link);
    }
}