counter = 10000000000000

request = function()
    path = "/qrcode/batch?&size=200&fg_color=ffffff&bg_color=000000&case=1&margin=0&level=2&hint=2&ver=3&"
    for i = 0, 20 do
        path = path .. "txt[]=" ..counter .. "&"
    end
    counter = counter + 1
    return wrk.format(nil, path)
end
