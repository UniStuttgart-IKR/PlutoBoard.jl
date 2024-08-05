// DO NOT LOAD IN IFRAME!

function setupWebsocket() {
    let socket;
    while (socket === undefined) {
        console.log('Waiting for WebSocket to be defined...');
        new Promise(resolve => setTimeout(resolve, 100));
        socket = new WebSocket('ws://localhost:8080');
    }

    socket.addEventListener('open', function (event) {
        console.log('WebSocket is open now.');
    });

    socket.addEventListener('close', function (event) {
        console.log('WebSocket is closed now.');
    });

    socket.addEventListener('error', function (event) {
        console.error('WebSocket error observed:', event);
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

async function callJuliaFunction(func_name, { args = [], kwargs = {}, response_callback = () => { } } = {}) {
    const socket = setupWebsocket();
    await waitForOpenConnection(socket);

    console.log('Calling Julia function:', func_name, 'with args:', args, 'and kwargs:', kwargs, 'and response callback:', response_callback);

    cmd = {
        "type": "julia_function_call",
        "function": func_name,
        "args": args,
        "kwargs": kwargs
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


