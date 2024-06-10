function hello_world_return()
    time_str = string(time())
    return "Hello from Julia!" * time_str
end

function ping_pong(args...)
    return args
end

function get_square(num)
    return num^2
end