local Code = require "src.enums.Code"
local Actions = require "src.Actions"
local BaseService = require "src.services.BaseService"
local IoService = require "src.services.IoService"
local MemoryService = require "src.services.MemoryService"
local ffi = require "ffi"
require("src.cdefs.intbuilder")
require("src.cdefs.floatbuilder")



local intbuilder = ffi.new("intbuilder")
local floatbuilder = ffi.new("doublebuilder")
local copy = table.copy or function(tbl)
    local c = {}

    for k, v in pairs(tbl) do
        c[k] = v
    end

    return c
end


---@class simplevm
---@field instructions string?
---@field regs vmdata_t[] tamanho igual a 8
---@field retlocals integer[]
---@field frames vmdata_t[][]
---@field frame vmdata_t[]
---@field services BaseService[]
---@field service BaseService?
---@field index integer
---@field intsize 4 | 8
---@field floatsize 4 | 8
---@field flags integer
---@field paused boolean
local simplevm = {}

---@return simplevm
function simplevm:new()
    local obj = {
        instructions = nil,
        regs = {nil, nil, nil, nil, nil, nil, nil, nil},
        retlocals = {},
        frames = {{}},
        services = {IoService, MemoryService},
        service = nil,
        index = 1,
        intsize = 4,
        floatsize = 8,
        flags = 0,
    }
    obj.frame = obj.frames[1]
    setmetatable(obj, {__index = self})

    return obj
end

function simplevm:getstate()
    local state = {
        registers=copy(self.regs),
        service=self.service,
        flags={equality=self.flags.equality},
        instructionindex=self.index,
        frames={}
    }

    for i, frame in ipairs(self.frames) do
        table.insert(state.frames, {locals=copy(frame.locals)})
    end

    state.frame = state.frames[#state.frames]

    return state
end
function simplevm:put(instructions)
    self.instructions = instructions
end

function simplevm:start()
    --vai aguardar por uma instrucao de saida (EXIT)
    while true do
        local byte = self:consomeByte()
        --print("byte", byte)
        local action = Actions[byte]
        
        action(self)
    end
end



function simplevm:error(message)
    io.stderr:write(message .. "\n")
    os.exit(1)
end

function simplevm:currentByte()
    return string.byte(self.instructions, self.index, self.index)
end

function simplevm:setIntegersize(n)
    if not (n == 4 or n == 8) then
        error("Unknown integer size.")
    end

    self.intsize = n
    if n == 8 then
        intbuilder = ffi.new("longbuilder")
    else
        intbuilder = ffi.new("intbuilder")
    end
end

function simplevm:setFloatsize(n)
    if not (n == 4 or n == 8) then
        error("Unknown float size.")
    end

    self.floatsize = n
    if n == 8 then
        floatbuilder = ffi.new("doublebuilder")
    else
        floatbuilder = ffi.new("floatbuilder")
    end
end

function simplevm:getint()
    
    for i = 0, self.intsize - 1 do
        intbuilder.bytes[i] = ffi.new("unsigned char", self:consomeByte())
    end
    

    return tonumber(intbuilder.value)
end

function simplevm:getfloat()
    
    for i = 0, self.floatsize - 1 do
        floatbuilder.bytes[i] = ffi.new("unsigned char", self:consomeByte())
    end
    
    
    return tonumber(floatbuilder.value)
end

function simplevm:getstring()
    local start = self.index
    
    while self:currentByte() ~= 0 do
        self:consomeByte()
    end

    local result = string.sub(self.instructions, start, self.index)

    self:consomeByte()

    return result
end

function simplevm:assert(condition, message)
    if not condition then
        error(message)
    end
end
function simplevm:consomeByte()
    local b = string.byte(self.instructions, self.index, self.index)
    self.index = self.index + 1
    return b
end

return simplevm
