"""
    monitor_folder(; ws)

    Watches the folder specified by `SERVE_DIR` for changes. When a file change is detected, sends a notification to the provided WebSocket `ws`.
"""
function monitor_folder(; ws)
    folder_path = SERVE_DIR
    while true
        _, event = watch_folder(folder_path)
        if event.changed == true
            @info "Files changed"
            send_to_ws(ws, true)
        end
    end
end
