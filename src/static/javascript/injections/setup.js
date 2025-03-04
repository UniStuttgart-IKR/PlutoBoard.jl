//check if in iframe 
if (window.location !== window.parent.location) {
    //exit this script 
    return
}

const head = document.getElementsByTagName('head')[0]

const script_locations = [
    "internal/static/javascript/main.js",
];

const css_locations = [
    "internal/static/css/alwaysLoad.css",
];

if (notebookHidden === true) {
    css_locations.push("internal/static/css/internal.css")
}

const url = "http://localhost:8085/"

//wait for fileserver to be ready
const interval = setInterval(async () => {
    try {
        const response = await fetch(url, { method: "HEAD" });
        if (response.status == 200) {
            clearInterval(interval)

            // add internal scripts
            script_locations.forEach(location => {
                const script = document.createElement('script')
                script.src = url + location
                script.type = "module"
                head.appendChild(script)
            });

            //add internal css
            css_locations.forEach(location => {
                const link = document.createElement('link')
                link.href = url + location
                link.rel = "stylesheet"
                head.appendChild(link)
            });

            //add main script 
            const script = document.createElement('script')
            script.src = url + "javascript/main.js"
            script.type = "module"
            head.appendChild(script)

            //add plugin scripts
            for (let i = 0; i < js_files_to_load.length; i++) {
                const script = document.createElement('script')
                script.type = "module"
                script.src = url + "absolute/" + js_files_to_load[i]
                head.appendChild(script)
            }
        }
    }
    catch {
    }


}, 100)


