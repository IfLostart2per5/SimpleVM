local assembler = require"assembler.assembler"
local bytecodeutils = require("assembler.utils.bytecodeutils")
function parse_args()
    local args = {file={}, type="lua"}

    local i = 1

    while i <= #arg do
        local a = arg[i]
        
        if a == '-o' or a == '--output' then
            if args.file.output then
                error('already gave output')
            end
            local out = arg[i + 1]
            if not out then
                error('no output given')
            end
            args.file.output = out
            i = i + 1
        elseif a == '-t' or a == '--type' then
            local t = arg[i + 1]
            if not t then
                error("no source type given.")
            end

            if not ((t == "lua") or
                   (t == "ss"))
                   then
                     error("undefined source type.")
                   end
            args.type = t
            i = i + 1
        else
            if args.file.input then
                error("cannot process more than a once file.")
            end

            args.file.input = a
        end
        i = i + 1
    end
    if not args.file.output then
        args.file.output = "simply.sc"
    end

    return args
end

function main()
    local args = parse_args()

    if args.file.input then
        if args.type == "lua" then
            
           local bytecode = dofile(args.file.input)

           local compiled = bytecodeutils.compile(bytecode)
           local linked = bytecodeutils.link(compiled)
           bytecodeutils.binarize(args.file.output, linked)
        else
            local asm = assembler:new()

            local file, err = io.open(args.file.input)

            if file then
                local content = file:read("*a")
                local bytecode = asm:assemble(content)

                bytecodeutils.binarize(args.file.output, bytecode)
                file:close()
            else
                error(err)
            end
        end
        return
    end
    
    print("SimpleVm debugging compiler. use: luajit compiler.lua file [-o|--output OUTPUT]")
end

main()