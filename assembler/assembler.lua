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
        labels=nil,
        intformat=">i",
        floatformat="d"
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

    
    local linked = bytecodeutils.link(compiled, (self.intformat == ">i") and 4 or 8)
    return linked
end

function Assembler:iseof()
    return self.current >= #self.src
end

function Assembler:assemblypiece()
    local char = self:getchar()
    if char == "." then
        if self:iseof() then
            error("Invalid dot")
        end

        self.start = self.start + 1

        local id = self:getrawid()

        if id == "usei64" then
            self.intformat = ">l"
        elseif id == "usei32" then
            self.intformat = ">i"
        elseif id == "usef32" then
            self.floatformat = "f"
        elseif id == "usef64" then
            self.floatformat = "d"
        elseif id == "include" then
            while self:peekchar():match(IGNORE) do
                self:getchar()
            end

            local start = self.current

            if self:peekchar() ~= "<" then
                error("Expected less than character.")
            end

            self:getchar()

            while self:peekchar() ~= ">" do
                self:getchar()
            end

            local filename = self.src:sub(start + 1, self.current - 1)
            self:getchar()
            local file, err = io.open(filename, "r")
            if file then
                local content = file:read("*a")
                
                self.src = self.src:sub(1, self.start - 2) .. content ..  self.src:sub(self.current, #self.src) .. " "
                print(self.src.."\n\n\n\n")
                self.start = self.start - 2
                self.current = self.start + 1
                print(self.current, self:peekchar())
            else
                error("Failed to include '"..filename.."': "..err)
            end

            
        else
            error("unknown directive "..id)
        end
    elseif char:match(IDBEGIN) then
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
        error('Unknown char "'..char..'" at '..self.start)
    end
end

function Assembler:getchar()
    local char = self:peekchar()
    self.current = self.current + 1
    return char
end

function Assembler:peekchar()
    if self.current > #self.src then
        error(self.current.." > "..#self.src)
    end
    return self.src:sub(self.current, self.current)
end

function Assembler:prevchar()
    return self.src:sub(self.current - 1, self.current - 1) or '\0'
end


function Assembler:parseid()
    local id = self:getrawid()

    
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

function Assembler:getrawid()
    while self:peekchar():match(IDREST) do
        self:getchar()
    end

    local id = self.src:sub(self.start, self.current - 1)

    return id
end

function Assembler:parsenumber(signal, noinsert)
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

    if noinsert then
        return num
    end
    table.insert(self.bytecode, {tag=float and "float" or "int", (signal == '-') and -num or num, format=float and self.floatformat or self.intformat})
end

function Assembler:parsestring(noinsert)
    while self:peekchar() ~= '"' do
        self:getchar()
    end

    self:getchar()

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
    if noinsert then
        return str
    end
    table.insert(self.bytecode, {tag="string", str})
    
end
function Assembler:skipcomment()
    while self:peekchar() ~= '\n' do
        self:getchar()
    end
end

return Assembler
