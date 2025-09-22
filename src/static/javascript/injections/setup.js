//check if in iframe 
if (window.location !== window.parent.location) {
    //exit this script 
    return
}

console.log(websocket_port, fileserver_port)

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

const url = `http://127.0.0.1:${fileserver_port}/`

//wait for fileserver to be ready
const interval = setInterval(async () => {
    try {
        const response = await fetch(url, { method: "HEAD" });
        if (response.status == 200) {
            clearInterval(interval)

            // return if fileserver_port is already set
            if (head.querySelector('meta[name="fileserver_port"]')) {
                return
            }

            // add fileserver_port and websocket_port to <head>
            const meta_websocket_port = document.createElement('meta');
            meta_websocket_port.name = "websocket_port";
            meta_websocket_port.content = websocket_port;
            head.appendChild(meta_websocket_port);

            const meta_fileserver_port = document.createElement('meta');
            meta_fileserver_port.name = "fileserver_port";
            meta_fileserver_port.content = fileserver_port;
            head.appendChild(meta_fileserver_port);

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
            // const script = document.createElement('script')
            // script.src = url + "javascript/main.js"
            // script.type = "module"
            // head.appendChild(script)

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


