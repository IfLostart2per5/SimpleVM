local Simplevm = require "src.Simplevm"
local assembly = require "assembler.init"
local iter = require "libraries.iter"
local module = {}

function module.api()
    local vm = Simplevm:new()
    local functionindex = 1
    local functionsctx = {}
    vm.env = functionsctx
    local functionmapper = {}
    local api = {}
    vm:putapi(api)

    function api.register_luafunc(name, func)
        functionsctx[functionindex] = func
        functionmapper[name] = functionindex
        functionindex = functionindex + 1
    end
    function api.push_number(num, register)
        vm:assert(type(num) == "number", "Expected an number here!")
        vm:assert(type(register) =="number" and (register > 0 and register <= 8), "Invalid register")
        vm.regs[register] = num
    end

    function api.push_string(str, register)
        vm:assert(type(str) == "string", "Expected an string here!")
        vm:assert(type(register) =="number" and (register > 0 and register <= 8), "Invalid register")
        vm.regs[register] = str
    end

    local function get_value(register)
        vm:assert(type(register) =="number" and (register > 0 and register <= 8), "Invalid register")
        return vm.regs[register]
    end

    function api.get_number(register)
        local value = get_value(register)
        vm:assert(type(value) == "number", "Expected an number here!")
        return value
    end

    function api.get_string(register)
        local value = get_value(register)
        vm:assert(type(value) == "number", "Expected an number here!")
        return value
    end

    function api.compiles(code)
        
        local tabledcode = assembly(code, "<string>", functionmapper)
        local codeobj = {
            bytecode = iter.Iterable:produce(iter.listiter(tabledcode)):map(function(e) return string.char(e) end):reduce(function(acc, cur) return acc .. cur end);
            run = function(self)
                vm:put(self.bytecode)
                local status = vm:start()
                vm.instructions = nil
                vm.index = 1
                return status
            end
        }

        return codeobj
    end
    local object = {}
    setmetatable(object, {
        __newindex = function(t, k, v)
            if k == "intsize" then
                vm:setFloatsize(v / 8)
            elseif k == "floatsize" then
                vm:setIntegersize(v / 8)
            else
                error("SVMAPI object is a restrict object. Yes, you're unable to add a property")
            end
        end,
        __index = api
    })

    return object
end

return module