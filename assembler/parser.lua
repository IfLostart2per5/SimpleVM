local kwds = require "assembler.keywords"
local iter = require "libraries.iter"
local Iterable= iter.Iterable
local listiter = iter.listiter
local AsmParser = {}


function AsmParser:new()
    local object = {
        tokens = nil,
        index = 1,
        ast = nil
    }
    self.__index = self
    return setmetatable(object, self)
end

function AsmParser:parse(tokens)
    self.tokens = tokens
    self.ast = {
        tag = "Code",
        body = {}
    }
    while not self:is_eof() do
        if not self:at():is("Newline") then
            table.insert(self.ast.body, self:parse_line())
        else
            self:eat()
        end
    end
    return self.ast
end
function AsmParser:is_eof()
    return self:at():is("EndOfFile")
end
function AsmParser:parse_line()
    local tk = self:eat()
    local position = tk.start

    if tk:is("Identifier") then
        local tk2 = self:expect("Colon", "Expected \":\" for label.")
        return {tag="Label", name=tk.value, start=position, endo=tk2.endo}
    elseif tk.value and kwds[tk.value] then
        if kwds[tk.value] == "ExternLuaFunction" then
            local tk2 = self:expect("Identifier", "Expected an identifer for a 'extern_luaf' declaration")
            return {tag="LuaFunctionDecl", fname=tk2.value, start=position, endo=tk2.endo}
        end
        local ins = self:parse_instruction(tk.type, tk.value)
        if not self:is_eof() then
            self:expect("Newline", "Expected a new line (or line break) after instruction")
        end
        return ins
    else
        self:error(("Unexpected token '%s'"):format(tk.type))
    end
end


function AsmParser:eat()
    local tk = self:at()
    self.index = self.index + 1
    return tk
end

function AsmParser:at()
    return self.tokens[self.index]
end

function AsmParser:expect(toktype, message)
    message = message or ('Expected token "%s"'):format(toktype)

    if not self:at():is(toktype) then
        self:error(message)
        return
    end
    return self:eat()
end

function AsmParser:error(message)                                                                                                                                                                                                                                                                             
    print("sorry, it is exactly a something that i did let ....... TO DOOOOOOO!!!")
    print("but here is the message", message)
    print("line: ", self:at().lineno)
end


function AsmParser:parse_instruction(tktype, tkname)
    local operands = self:parse_ops()
    return {
        tag = "Instruction",
        opname = tktype,
        opnameraw = tkname,
        operands = operands,
        optypes = #operands > 0  and Iterable:produce(listiter(operands)):map(function(e) return e.tag end):collect() or nil
    }
end

function AsmParser:parse_ops()
    local ops = {self:parse_primary()}
    if not ops[1] then
        return {}
    end

    while self:at():is("Comma") do
        self:eat()
        table.insert(ops, self:parse_primary())
    end

    return ops
end

function AsmParser:parse_primary()
    if self:at():is("Number") then
        local tk = self:eat()
        local typ = tk.metadata.type
        local extendedType = typ == "i" and "Integer" or "Float"
        return {tag=extendedType, value=tk.value, start=tk.start, endo=tk.endo, lineno=tk.lineno}
    elseif self:at():in_("String", "Identifier", "Register") then
        local tk = self:eat()
        return {tag=tk.type, value=tk.value, start=tk.start, endo=tk.endo, lineno=tk.lineno}
    end
end

return AsmParser