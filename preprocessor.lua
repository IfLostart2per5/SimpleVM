local pp = require "libraries.preprocess"
local pathsep = package.config:sub(1, 1)
function main()
    local info, err = pp.processFile{
        pathIn = "src" .. pathsep .. "Simplevm.lua2p",
        pathOut = "src" .. pathsep .. "Simplevm.lua"
    }

    if not info then
        error(err)
    end
end

main()