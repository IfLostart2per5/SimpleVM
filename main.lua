local simplevm = require "src.Simplevm"
local compile = require "assembler.utils.bytecodeutils"

function parse_args()
    
    local args = {}
    if #arg == 0 then
        return args
    end
    local i = 2
    local command = arg[1]

    args.cmd = command
    if command == 'run' then
        args.isize = 32
        args.fsize = 64
        while i <= #arg do
            local a = arg[i]
            if a == "-isize" or a == "--integersize" then
                local size = arg[i + 1]
                if not size then
                    error("no specified integer size")
                end
                local nsize = tonumber(size)
                if not nsize then
                    error("unable to parse size")
                end

                args.isize = nsize
                i = i + 1
            elseif a == "-fsize" or a == "--floatsize" then
                local size = arg[i + 1]
                if not size then
                    error("no specified float size")
                end
                local nsize = tonumber(size)
                if not nsize then
                    error("unable to parse size")
                end

                args.fsize = nsize
                i = i + 1
            

            
            else
                if args.target then
                    error('already specified target')
                end

                args.target = a 
            end
            i = i + 1
        end
    else
        error('Unknown command "'..command..'".')
    end

    return args
end

function run(file, intsize, floatsize)
    local vm = simplevm:new()
    vm:setIntegersize(intsize / 8)
    vm:setFloatsize(floatsize / 8)
    local version, bytecode, size = compile.read(file)
    --[[
    do
        for i = 1, size do
            print('['..i..']', bytecode:byte(i, i))
        end

        return
    end
    ]]
    
    if version ~= "svm0.1" then
        error("Unknown bytecode version.")
    end

    vm:put(bytecode)
    vm:start()
    
end

function main()
    local args = parse_args()

    if args.cmd == 'run' then
        run(args.target, args.isize, args.fsize)
    end
end

main()