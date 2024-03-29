function main()
    local path, name = "", nil
    local output
    local i = 1
    while i <= #arg do
        
        local a = arg[i]
        local k = 1
        local j = 1
        while j <= a:len() do
            if a:sub(j, j) == "." then
                name = a:sub(k, j - 1)
                if name == '@parent' then
                    name = '..'
                end
                k = j + 1
                j = j + 1
                if path == "" then
                    path = name .. package.config:sub(1, 1)
                    goto continue
                end
                path = path .. name .. package.config:sub(1, 1)
            else
                j = j + 1
            end
            ::continue::
        end
        if not name then
            path = a
            name = a
        else
            name = a:sub(k, j)
            path = path .. name
        end
        print("dbg", path)
        local enumdesc = dofile(path .. ".enum.lua")
        if not enumdesc then
            os.exit(1)
        end
        
        local file, err = io.open(output and output or (path .. '.lua'), "w")
        j = 0
        if file then
            
            file:write("-- generated by enum.lua\n\n")

            file:write('local '..name..' = {\n')
            for _, ky in ipairs(enumdesc) do
                file:write("    "..ky.." = "..j..",\n")
                j = j + 1
            end

            file:write('}\n\nreturn '..name)
            file:close()
        else
            error(err)
        end
    i = i + 1
    path = ""
    name, output = nil, nil
    end
end
main()