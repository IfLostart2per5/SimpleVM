local MemoryService = require "src.services.MemoryService"
local ffi           = require "ffi"

local regs = {}

MemoryService:invoke(1, {4}, regs)
local address = regs[1]
local adr = ffi.new("intptr_t", address)
local ptr = ffi.cast("int*", adr)

ptr[0] = 257

print(ptr[0])

MemoryService:invoke(2, {address}, regs)







