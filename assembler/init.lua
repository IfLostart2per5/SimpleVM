local AsmPreprocessor = require "assembler.preprocessor"
local AsmLexer = require "assembler.lexer"
local AsmParser = require "assembler.parser"
local AsmGenerator = require "assembler.generator"

function assembly(code, path, funcctx)
    path = path or "<string>"
    local prep = AsmPreprocessor:new()
    local lexer = AsmLexer:new(path)
    local parser = AsmParser:new()
    local gen = AsmGenerator:new(funcctx)

    return gen:generate(parser:parse(lexer:tokenize(prep:preprocess(code))))
end

return assembly