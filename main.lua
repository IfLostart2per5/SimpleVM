local simplevm = require "src.Simplevm"
local compile = require "src.utils.bytecodeutils"

function parse_args()
    
    local args = {}
    if #arg == 0 then
        return args
    end
    local i = 2
    local command = arg[1]

    args.cmd = command
    if command == 'run' then
        local file = arg[i]

        if not file then
            error("No input file given to run")
        end

        args.target = file
    else
        error('Unknown command "'..command..'".')
    end

    return args
end

function run(file)
    local vm = simplevm:new()

    local version, bytecode = compile.read(file)
    --[[
    do
        for i, byte in ipairs(bytecode) do
            print('['..i..']', byte)
        end

        return
    end
    ]]
    if version ~= "svm0.1" then
        error("Unknown bytecode version.")
    end

    vm:put(bytecode)
    local i = os.clock()
    vm:start()
    local e = os.clock()
    print("\ntempo", e - i)
end

function main()
    local args = parse_args()

    if args.cmd == 'run' then
        run(args.target)
    end
end

main()