local Code = require "src.enums.Code"
local Actions = require "src.Actions"
local BaseService = require "src.services.BaseService"
local IoService = require "src.services.IoService"
local MemoryService = require "src.services.MemoryService"
local struct = require "libraries.struct"
local copy = table.copy or function(tbl)
    local c = {}

    for k, v in pairs(tbl) do
        c[k] = v
    end

    return c
end

---@alias frametype {locals: vmdata_t[]}

---@class simplevm
---@field instructions integer[]?
---@field regs vmdata_t[] tamanho igual a 8
---@field retlocals integer[]
---@field frames frametype[]
---@field frame frametype
---@field services BaseService[]
---@field service BaseService?
---@field index integer
---@field integersize 4 | 8
---@field floatsize 4 | 8
---@field flags table<string, boolean>
---@field paused boolean
local simplevm = {}

---@return simplevm
function simplevm:new()
    local obj = {
        instructions = nil,
        regs = {nil, nil, nil, nil, nil, nil, nil, nil},
        retlocals = {},
        frames = {{locals = {}}},
        services = {IoService, MemoryService},
        service = nil,
        index = 1,
        integersize = 4,
        floatsize = 8,
        flags = {equality = false, greater=false, less=false},
        paused = false
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
        if self.paused then
            return
        end
        
        self:exec()
    end
end

function simplevm:pause()
    self.paused = true
end

function simplevm:resume()
    self.paused = false
    self:start()
end

function simplevm:error(message)
    io.stderr:write(message .. "\n")
    os.exit(1)
end

function simplevm:currentByte()
    if self.index > #self.instructions then
        error("Instruction size finished ("..self.index.." > "..#self.instructions..")", 2)
    end
    return self.instructions[self.index]
end

function simplevm:setIntegersize(n)
    if not (n == 4 or n == 8) then
        error("Unknown integer size.")
    end

    self.integersize = n
end

function simplevm:setFloatsize(n)
    if not (n == 4 or n == 8) then
        error("Unknown float size.")
    end

    self.floatsize = n
end

function simplevm:exec()
    local byte = self:consomeByte()
    --print("byte", byte)
    local action = Actions[byte]

    action(self)
end

function simplevm:getint()
    local bytes = {}

    for i = 1, self.integersize do
        bytes[i] = string.char(self:consomeByte())
    end

    return struct.unpack((self.integersize == 4) and ">i" or ">l", table.concat(bytes, ""))
end

function simplevm:getfloat()
    local bytes = {}

    for i = 1, self.floatsize do
        bytes[i] = string.char(self:consomeByte())
    end

    return struct.unpack((self.floatsize == 4) and "f" or "d", table.concat(bytes, ""))
end

function simplevm:getstring()
    local bytes = {}

    while self:currentByte() ~= 0 do
        table.insert(bytes, string.char(self:consomeByte()))
    end

    local result = table.concat(bytes, "", 1, #bytes)

    self:consomeByte()

    return result
end

function simplevm:assert(condition, message)
    if not condition then
        error(message)
    end
end
function simplevm:consomeByte()
    local b = self:currentByte()
    self.index = self.index + 1
    return b
end

return simplevm