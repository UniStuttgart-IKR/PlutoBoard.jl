function monitor_folder(;ws)
    folder_path = SERVE_DIR
    
    # file_hashes = Dict{String, UInt}()
    # 
    # function update_hashes()
    #     for file in readdir(folder_path)
    #         @info "Updating hash for $file"
    #         file_path = joinpath(folder_path, file)
    #         if isfile(file_path)
    #             file_hashes[file] = read(file_path, String) |> hash
    #         end
    #     end
    # end
    # 
    # update_hashes()
    

    while true
        name, event = watch_folder(folder_path)
        if event.changed == true
            @info "Files changed"
            send_to_ws(ws, true)
            # new_files = Set(readdir(folder_path))
            # old_files = Set(keys(file_hashes))
            # 
            # if new_files != old_files
            #     @info  "Files changed"
            # end
            
            # for file in new_files
            #     file_path = joinpath(folder_path, file)
            #     if isfile(file_path)
            #         new_hash = read(file_path, String) |> hash
            #         if get(file_hashes, file, 0) != new_hash
            #             @info "File $file changed"
            #             return true
            #         end
            #     end
            # end
            # 
            # update_hashes()
        end
    end
end
