import { error, info } from "./logger.js";

function setupWebsocket() {
    let socket;
    while (socket === undefined) {
        info('Waiting for WebSocket to be defined');
        new Promise(resolve => setTimeout(resolve, 100));
        socket = new WebSocket('ws://localhost:8080');
    }

    socket.addEventListener('open', function (event) {
        info('WebSocket is open now.');
    });

    socket.addEventListener('close', function (event) {
        info('WebSocket is closed now.');
    });

    socket.addEventListener('error', function (event) {
        error('WebSocket error observed:', event);
    });
    return socket;
}

function waitForOpenConnection(socket) {
    return new Promise((resolve, reject) => {
        if (socket.readyState === WebSocket.OPEN) {
            resolve();
        } else {
            socket.addEventListener('open', () => {
                resolve();
            });

            socket.addEventListener('error', (err) => {
                reject(new Error('WebSocket connection failed: ' + err.message));
            });
        }
    });
}

export async function callJuliaFunction(func_name, { args = [], kwargs = {}, response_callback = () => { }, internal = false } = {}) {
    const socket = setupWebsocket();
    await waitForOpenConnection(socket);

    info(`Calling Julia function ${func_name} with args: ${args}, kwargs: ${JSON.stringify(kwargs)}, internal: ${internal}`);

    const cmd = {
        "type": "julia_function_call",
        "function": func_name,
        "args": args,
        "kwargs": kwargs,
        "internal": internal
    }
    socket.send(JSON.stringify(cmd));

    return new Promise((resolve, reject) => {
        socket.addEventListener('message', (event) => {
            if (JSON.parse(event.data).type === 'return') {
                socket.close();
                resolve(JSON.parse(event.data).return);
            }
            else if (JSON.parse(event.data).type === 'response') {
                response_callback(JSON.parse(event.data).response);
            }
        });
    });
}


