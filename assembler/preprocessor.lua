local AsmPreprocessor = {}

IDBEGIN = "[_%.%a]"
IDREST = "[_%.%w]"
IGNORE = "[ \t\r\f]"

function readnclose(file, errmsg, errfunc)
    if file then
        local content = file:read("a*")
        file:close()
        return content
    end
    errfunc(errmsg)
end

function AsmPreprocessor:new()
    local object = {
        src = nil,
        start = 1,
        current = 1,
        column1 = 1,
        column2 = 1,
        lineno = 1
    }
    self.__index = self
    setmetatable(object, self)
    return object
end

function AsmPreprocessor:preprocess(code)
    self.src = code
    while not self:is_eof() do
        self.start = self.current
        self:process()
    end
    return self.src
end

function AsmPreprocessor:is_eof()
    return self.current > #self.src
end
function AsmPreprocessor:process()
    local char = self:eat_char()
    if char == '\n' then
        self.lineno = self.lineno + 1
        self.column1 = 1
        self.column2 = 1
    elseif char:match(IGNORE) then
        --empty void
    elseif char == "#" then
        local direc = self:getid()
        if direc == "entry" then
            self:expect('[', "Expected '[' here")
            ---@type string
            local entry = self:getid()
            self:expect("]", "Expected ']' here")
            self.src = (self.start == 1 and "" or self.src:sub(1, self.start)) .. self.src:sub(self.current, self.src:len())
            self.current = self.start + 1
            local out = ".start:\n\tcall "..entry.."\n"
            local lenout = out:len()
            local diff1 = self.current - self.start + 1
            self.src = out .. self.src
            self.start = self.start + lenout
            self.current = self.current + diff1
           --print(self.src)
        elseif direc == "include" then
            while self:get_char():match(IGNORE) do
                self:eat_char()
            end
            local start = self.current
            self:expect('"', "Expected a quote for include directive argument")
            local path = self:getstring(start)
            local file, err = io.open(path, "r")
            local content = readnclose(file, err, function(message) self:error(message) end)
            
            self.src = self.src:sub(1, self.start - 1) .. content .. "\n\n" .. self.src:sub(self.current, self.src:len())
            self.current = self.start + 1
        else
            self:error("Invalid directive")
        end
    elseif char == ";" then
        self:skipcomment()
    elseif char == '"' then
        self:getstring()
    end
end

function AsmPreprocessor:eat_char()
    local char = self:get_char()
    self.current = self.current + 1
    self.column2 = self.column2 + 1
    return char
end

function AsmPreprocessor:get_char()
    return self.src:sub(self.current, self.current)
end

function AsmPreprocessor:getid(has_firstchar, start)
    start = start or self.start
    if has_firstchar then
        while self:get_char():match(IDREST) do
            self:eat_char()
        end

        return self.src:sub(start, self.current - 1)
    else
        local s = self.current
        local char1 = self:eat_char()
        if not char1:match(IDBEGIN) then
            return ""
        end
        return self:getid(true, s)
    end
end

function AsmPreprocessor:expect_or(char, alternative)
    if self:get_char() ~= char then
        if type(alternative) == "function" then
            return alternative(self:get_char())
        else
            return alternative
        end
    end

    return self:eat_char()
end

function AsmPreprocessor:expect_pattern_or(pattern, alternative)
    if not self:get_char():match(pattern) then
        if type(alternative) == "function" then
            return alternative(self:get_char())
        else
            return alternative
        end
    end

    return self:eat_char()
end

function AsmPreprocessor:expect(char, message)
    return self:expect_or(char, function(ch)
        self:error(message or ("Expected character '%s', but found '%s'"):format(char, ch))
    end)
end

function AsmPreprocessor:expect_pattern(pattern, message)
    return self:expect_or(pattern, function(ch)
        self:error(message or ("Expected character pattern '%s', but the found char doesn't match pattern '%s'"):format(pattern, ch))
    end)
end

function AsmPreprocessor:error(message)
    error(("ERROR at line %d: %s"):format(self.lineno, message))
end

function AsmPreprocessor:skipcomment()
    while self:get_char() ~= '\n' do
        self:eat_char()
    end
end

function AsmPreprocessor:getstring(start)
    start = start or self.start
    
    while self:get_char() ~= '"' do
        self:eat_char()
        if self:is_eof() then
            self:error("'-' guy ... you forgot a quote? serious?")
            return
        end
    end
    self:eat_char()
    return self.src:sub(start + 1, self.current - 2)
end

return AsmPreprocessor