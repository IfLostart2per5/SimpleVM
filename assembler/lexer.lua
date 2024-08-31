local kwds = require "assembler.keywords"
local AsmLexer = {}
local Token = {}

function Token:new(toktype, value, spos, cpos, lineno, metadata)
    local object = {
        type = toktype;
        value = value;
        start = spos;
        endo = cpos;
        lineno = lineno;
        metadata = metadata or {};
    }

    self.__index = self
    setmetatable(object, self) 
    return object
end

function Token:is(toktype)
    return toktype and self.type == toktype
end

function Token:in_(...)
    local args = {...}
    for i, p in ipairs(args) do
        if self:is(p) then return true end
    end
    return false
end
IDBEGIN = "[_%.%a]"
IDREST = "[_%.%w]"
DIGIT = "%d"
IGNORE = "[ \t\r\f]"
function AsmLexer:new(filename)
    local object = {
        src = nil,
        filename = filename,
        current = 1,
        start = 1,
        lineno = 1,
        tokens = {},
        keywords = kwds,
        err_state = false
    }
    self.__index = self
    setmetatable(object, self)
    return object
end

function AsmLexer:tokenize(code)
    self.src = code
    while not self:is_eof() do
        self.start = self.current
        self:scan_token()
    end
    self:push_token("EndOfFile")
    return self.tokens
end

function AsmLexer:is_eof()
    return self.current > #self.src
end

function AsmLexer:scan_token()
    local char = self:eat_char()
    if char:match(IGNORE) then
    elseif char == '\n' then
        self:push_token("Newline")
        self.lineno = self.lineno + 1
    elseif char == ";" then
        self:skip()
    elseif char == "," then
        self:push_token("Comma")
    elseif char == ":" then
        self:push_token("Colon")
    elseif char == '"' then
        self:scan_string()
    elseif char:match(IDBEGIN) then
        self:scan_identifier()
    elseif char:match(DIGIT) then
        self:scan_number()
    else
        self:error(("unrecognized character '%s'"):format(char))
    end
   
end

function AsmLexer:eat_char()
    local c = self:cur_char()
    self.current = self.current + 1
    return c
end

function AsmLexer:cur_char()

    return self.src:sub(self.current, self.current) or '\0'
end

function AsmLexer:skip()
    while self:cur_char() ~= "\n" do
        self:eat_char()
    end
end

function AsmLexer:push_token(toktype, value, metadata)
    table.insert(self.tokens, Token:new(toktype, value, self.start, self.current, self.lineno, metadata))
end

function AsmLexer:scan_string()
    while self:cur_char() ~= '"'  and not self:is_eof() do
        local c = self:eat_char()
        if c == "\\" then
            if self:cur_char() == '"' then
                goto continue
            end
        end
        ::continue::
    end
    self:eat_char()
    ---@type string
    local str = self.src:sub(self.start + 1, self.current - 2)
    
    self:push_token("String", str:gsub("\\n", "\n"):
gsub("\\t", "\t"):
gsub("\\\\", "\\"):
gsub("\\\"", '"'))
end

function AsmLexer:scan_identifier()
    while self:cur_char():match(IDREST) do
        self:eat_char()
    end
    

    local id = self.src:sub(self.start, self.current - 1)
    if id:match("r[1-8]") then
        self:push_token("Register", id)
    else
        self:push_token(self.keywords[id] or "Identifier", id)
    end
end

function AsmLexer:scan_number()
    local typo
    while self:cur_char():match(DIGIT) do
        self:eat_char()
    end

    if self:cur_char() == "." then
        typo = "f"
        self:eat_char()
        while self:cur_char():match(DIGIT) do
            self:eat_char()
        end
    end

    if not typo then typo = "i" end
    local metadata = {type=typo}
    self:push_token("Number", tonumber(self.src:sub(self.start, self.current - 1)), metadata)
end

function AsmLexer:error(message)
    if not self.err_state then
        io.stderr:write(('=== simplevm assembler: "%s" errors ===\n'):format(self.filename))
        self.err_state = true
    end
    io.stderr:write(("%sERROR: %s\n"):format(self.err_state and "\t" or "", message))
end

return AsmLexer