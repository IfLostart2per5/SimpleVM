--MemoryService: um serviço da simple vm pra alocar e desalocar memoria
local BaseService = require "src.services.BaseService"
local ffi = require "ffi"
ffi.cdef[[
    void* malloc(size_t);
    void free(void*);
]]

if ffi.os == "Windows" then
    ffi.cdef[[
        typedef unsigned int size_t;
    ]]
else
    ffi.cdef[[
        typedef unsigned long size_t
    ]]
end

---@alias memory_block {ptr: ffi.ctype*, size: integer}
---@class MemoryService : BaseService
---@field addresses table<integer, memory_block>
local MemoryService = {addresses={}}
setmetatable(MemoryService, {__index=BaseService})

function MemoryService:init()
    BaseService.init(self)

    self.opcodes[1] = "alloc"
    self.opcodes[2] = "free"
end
MemoryService:init()

--Subsserviço: MemoryService::alloc
--Ele aloca um bloco de memoria com um dado tamanho, e armazena o endereço resultante no registrador 1
---@args {size: integer = $1}
function MemoryService.subsservices:alloc(args, regs)
    local size = args[1]

    local block = ffi.C.malloc(size)

    if not block then
        return 1, "Error on allocating memory."
    end
    local address = tonumber(ffi.cast("intptr_t", block))
    regs[1] = address
    MemoryService.addresses[address] = {ptr=block, size=size}
    print("foi alocado com sucesso!")
    return 0
end

--Subsserviço: MemoryService::free
--Ele desaloca um bloco de memoria previamente alocado
---@args {address: integer = $1}
function MemoryService.subsservices:free(args)
    local address = args[1]

    if not address then
        return 1, "Attempt to free a null value."
    end

    if not MemoryService.addresses[address] then
        return 1, "Attempt to free a non-alocated block."
    end

    ffi.C.free(MemoryService.addresses[address].ptr)

    MemoryService.addresses[address] = nil
    print("foi liberado com sucesso!")
    return 0
end

return MemoryService