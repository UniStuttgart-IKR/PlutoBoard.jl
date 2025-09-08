/**
 * @fileoverview Static content loading functions for PlutoBoard.jl
 * @module LoadStatic
 */

import { callJuliaFunction } from './interface.js';

/**
 * Inserts the HTML document created by the user into the body and head of the current document.
 * @memberof module:LoadStatic
 * @returns {Promise<void>}
 */
export async function insertHTMLToBody() {
    const body = document.querySelector('body');
    const head = document.querySelector('head');

    const fileserverPort = document.querySelector('meta[name="fileserver_port"]').content;

    let mainSite = await ((await fetch(`http://localhost:${fileserverPort}/index.html`)).text());

    // replace FILESERVER_PORT in `main_site` with $fileserverPort
    mainSite = mainSite.replace(/FILESERVER_PORT/g, fileserverPort);

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
 * @memberof module:LoadStatic
 * @returns {Promise<void>}
 */
export async function insertSettingsHTMLToBody() {
    const body = document.querySelector('body');
    const fileserverPort = document.querySelector('meta[name="fileserver_port"]').content;
    const settingsSite = await ((await fetch(`http://localhost:${fileserverPort}/internal/static/html/settings.html`)).text());
    body.insertAdjacentHTML('afterbegin', settingsSite);
}

/**
 * Adds CSS files to the head of the current document.
 * @memberof module:LoadStatic
 * @returns {Promise<void>}
 */
export async function addCSSToBody() {
    const cssFiles = await callJuliaFunction('get_css_files', { internal: true });
    console.log(cssFiles);
    const head = document.querySelector('head');
    for (const cssFile of cssFiles) {
        const link = document.createElement('link');
        const fileserverPort = document.querySelector('meta[name="fileserver_port"]').content;
        link.rel = 'stylesheet';
        link.href = `http://localhost:${fileserverPort}/css/${cssFile}`;
        head.appendChild(link);
    }
}