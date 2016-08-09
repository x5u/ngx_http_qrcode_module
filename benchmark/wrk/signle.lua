counter = 10000000000000000000000000000000000000000000000000

request = function()
    path = "/?&size=200&fg_color=ffffff&bg_color=000000&case=1&margin=2&level=0&hint=2&ver=2&txt=" .. counter
    counter = counter + 1
    return wrk.format(nil, path)
end
