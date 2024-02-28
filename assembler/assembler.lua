local Code = require "src.enums.Code"
local bytecodeutils = require "assembler.utils.bytecodeutils"
local Assembler = {}

--assembler da simplevm: "algo" feito em pouquissimo tempo que parseia isso daq: "icopy_1 1" em bytecode ({1, 0,0,0,1}) dentre outras coisas


IDBEGIN = "[_%a]"
IDREST = "[_%w]"
DIGIT = "%d"
IGNORE = "[ \t\r\n]"

function Assembler:new()
    local object = {
        src = nil,
        bytecode = nil,
        start=1,
        current=1,
        labels=nil
    }

    self.__index = self
    setmetatable(object, self)

    return object
end

function Assembler:assemble(code)
    self.src = code 
    self.bytecode = {}

    self.labels = {}
    while not self:iseof() do
        self.start = self.current
        self:assemblypiece()
    end
    local compiled = bytecodeutils.compile(self.bytecode)

    
    local linked = bytecodeutils.link(compiled)
    return linked
end

function Assembler:iseof()
    return self.current >= #self.src
end

function Assembler:assemblypiece()
    local char = self:getchar()

    if char:match(IDBEGIN) then
        self:parseid()
    elseif char:match(DIGIT) then
        self:parsenumber()
    elseif char == '"' then
        self:parsestring()
    elseif char:match(IGNORE) then
        return
    elseif char == ';' then
        self:skipcomment()
    elseif char == '+' or char == '-' then
        if self:peekchar():match(DIGIT) then
            self:parsenumber(char)
        else
            error("Invalid signal indicator.")
        end
    else
        error('Unknown char "'..char..'"')
    end
end

function Assembler:getchar()
    local char = self:peekchar()
    self.current = self.current + 1
    return char
end

function Assembler:peekchar()
    return self.src:sub(self.current, self.current) or '\0'
end

function Assembler:prevchar()
    return self.src:sub(self.current - 1, self.current - 1) or '\0'
end


function Assembler:parseid()
    while self:peekchar():match(IDREST) do
        self:getchar()
    end

    local id = self.src:sub(self.start, self.current - 1)

    
    if self:peekchar() == ":" then
        if Code[id:upper()] then
            error('Cannot name a label with a instruction.')
        end
        self:getchar()
        self.labels[id] = id
        table.insert(self.bytecode, {tag='labeldef', id})
    else
        if Code[id:upper()] then
            table.insert(self.bytecode, Code[id:upper()])
        elseif self.labels[id] then
            table.insert(self.bytecode, {tag='label', id})
        elseif id:match("r[1-8]") then
            table.insert(self.bytecode, tonumber(id:sub(2, 2)))
        else
            table.insert(self.bytecode, {tag='label', id})
        end
    end
end

function Assembler:parsenumber(signal)
    signal = signal or '+'

    local float = false
    while self:peekchar():match(DIGIT) do
        self:getchar()
    end

    if self:peekchar() == '.' then
        self:getchar()

        if not self:peekchar():match(DIGIT) then
            error("malformed float.")
        end

        float = true
        while self:peekchar():match(DIGIT) do
            self:getchar()
        end
    end

    local num = tonumber(self.src:sub(self.start, self.current - 1))

    if not num then
        error("Malformed number.")
    end

    table.insert(self.bytecode, {tag=float and "float" or "int", (signal == '-') and -num or num})
end

function Assembler:parsestring()
    while self:peekchar() ~= '"' do
        if self:peekchar() == '\\' then
            goto continue
        end
        self:getchar()
        ::continue::
    end

    ---@type string
    local str = self.src:sub(self.start + 1, self.current - 2)

    str = str:gsub('\\n', '\n')
    :gsub("\\t", '\t')
    :gsub('\\v', '\v')
    :gsub('\\\\', '\\')
    :gsub('\\f', '\f')
    :gsub('\\a', '\a')
    :gsub('\\r', '\r')
    :gsub('\\"', '"')
    
    table.insert(self.bytecode, {tag="string", str})

end
function Assembler:skipcomment()
    while self:peekchar() ~= '\n' do
        self:getchar()
    end
end

return Assembler
