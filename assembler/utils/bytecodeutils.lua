local struct = require "libraries.struct"
local Code = require "src.enums.Code"
function linklabels(bytecode, intformat, env)
    local externals = {}
    local labels = {}
    local labelrefs = {}
    local linked = {}
    local nlabeldefs = 0
    for i, byte in ipairs(bytecode) do
        
        if type(byte) == 'table' then
            
            if byte.tag == "labeldef" then
                local name = byte[1]

                if labels[name] then
                    io.stderr:write(("Attempt to redefine label '%s'"):format(name))
                end
                labels[name] = 1
                nlabeldefs = nlabeldefs + 1
                table.insert(linked, byte)
            elseif byte.tag == 'label' then
                local name = byte[1]

                table.insert(labelrefs, {name, #linked - nlabeldefs})
                
                for j = 1, intformat do
                    table.insert(linked, 255)
                end
            elseif byte.tag == "external" then
                local name = byte[1]
                local index = env[name]
                if not index then
                    io.stderr:write(("Attempt to use an undeclared external label '%s'"):format(name))
                end

                externals[name] = index
            elseif byte.tag == "extlabel" then
                table.insert(linked, byte)
            end

            
        else
            table.insert(linked, byte)
        end
    end
    local size = #linked
    for i = 1, size do
        
        local byte = linked[i]
        if type(byte) == "table" then
            
            if byte.tag == "labeldef" then
                
                local name = byte[1]
                labels[name] = i
                
                table.remove(linked, i)
                size = size - 1
            elseif byte.tag == "extlabel" then
                local name = byte[1]
                local idx = externals[name]
                --print("de bytecodeutils:", name, idx)
                local packed = struct.pack((intformat == 4) and "i" or "l", idx)
                linked[i] = packed:byte(1,1)
                for j = intformat, 2, -1 do
                    table.insert(linked, i + 1, packed:byte(j,j))
                end
                size = size + 3
            end
        end

    end


    for _, labelinfo in ipairs(labelrefs) do
        local name, idx = unpack(labelinfo)

        local index = labels[name]

        if not index then
            error('attempt to use undefined label "'..name..'"')
        end

        local packed = struct.pack((intformat == 4) and "i" or "l", index)
        for j = 1, intformat do
            linked[idx + j] = packed:byte(j, j)
        end
    end
    return linked
end

function compile(bytecode) 
    local compiled = {}
    for i, byte in ipairs(bytecode) do
        if type(byte) == "table" then
            if byte.tag == "instruction" then
                local opname = byte[1]
                table.insert(compiled, Code[opname])
            elseif byte.tag == "int" then
                local n = byte[1]
                local packed = struct.pack(byte.format, n)

                for j = 1, #packed do
                    table.insert(compiled, packed:byte(j, j))
                end

                --print("teste: ", struct.unpack("l", packed), struct.unpack(">l", packed))
            elseif byte.tag == "float" then
                local n = byte[1]
                local packed = struct.pack(byte.format, n)

                for j = 1, #packed do
                    table.insert(compiled, packed:byte(j, j))
                end
            elseif byte.tag == "string" then
                local s = byte[1]
                for j = 1, #s do
                    table.insert(compiled, s:byte(j))
                end
                table.insert(compiled, 0)
            else
                if byte.tag == "label" or byte.tag == "labeldef" or byte.tag == "external" or byte.tag == "extlabel" then
                    table.insert(compiled, byte)
                    goto continue
                end
                error("unrecognized special-instruction type")
            end
        else
            table.insert(compiled, byte)
        end
        ::continue::
    end

    --[[for i, byte in ipairs(compiled) do
        io.write('['..i.."] ")
        if type(byte) == "table" then
            print(byte.tag.."{"..byte[1]..'}')
        else
            print(byte)
        end
    end]]
    return compiled
end

function binarize(output, bytecode)
    local file, err = io.open(output, "wb")
    
    if file then
        file:write("svm0.1")
        for _, byte in ipairs(bytecode) do
            file:write(string.char(byte))
        end

        file:close()
        return
    end

    error("failed to open file: "..err)
end

function read(input)
    local file, err = io.open(input, "rb")
    local version = ""
    if file then
        
        local byte = file:read(1)
        for _ = 1, 6 do
            version = version .. byte
            byte = file:read(1)
        end
        local bytes
        if byte then
            bytes = byte .. file:read("*a")
        end

        local size = file:seek("end") - 6

        file:close()
        return version, bytes, size
    end

    error("failed to open file: "..err)
end



return {compile=compile, binarize=binarize, link=linklabels, read=read}