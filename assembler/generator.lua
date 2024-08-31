local bytecodeutils = require "assembler.utils.bytecodeutils"
--Gerador de bytecode pro simple assembly (ou conversor do codigo nutella facil de entender pro codigo raiz)
local AsmGenerator = {}

function AsmGenerator:new(ctx)
    local object = {
        ast = nil,
        bytecode = nil,
        ctx = ctx
    }

    return setmetatable(object, {__index=self})
end

function AsmGenerator:generate(ast)
    self.ast = ast
    self.bytecode = {}

    for i, line in ipairs(ast.body) do
        if line.tag == "Instruction" then
            self:generate_instruction(line)
        elseif line.tag == "Label" then
            table.insert(self.bytecode, {tag="labeldef", line.name})
        elseif line.tag == "LuaFunctionDecl" then
            table.insert(self.bytecode, {tag="external", line.fname})
        end
    end

    local compiled = bytecodeutils.compile(self.bytecode)
    local linked = bytecodeutils.link(compiled, 4, self.ctx) -- esse 4 é o tamanho dos inteiros, depois ajusto isso pra lidar com negocio de header q vou botar
    return linked
end

--botei line aqui pq bom ... uma instrução é uma linha né
function AsmGenerator:generate_instruction(line)
    local opname = line.opname
    if opname == "Add" or
    opname == "Sub" or
    opname == "Mul" or
    opname == "Div" or
    opname == "Mod" then
        local basekey = opname:upper()
        if (not line.optypes) or #line.optypes ~= 2 then
            error(("Expected exactly two operands for instruction '%s'"):format(line.opnameraw))
        end

        if line.optypes[1] ~= "Register" then
            error("Expected a register as first operand.")
        end

        if line.optypes[2] == "Register" then
            table.insert(self.bytecode, {tag="instruction", basekey})
            table.insert(self.bytecode, tonumber(line.operands[1].value:sub(2, 2)))
            table.insert(self.bytecode, tonumber(line.operands[2].value:sub(2, 2)))
        elseif line.optypes[2] == "Float" or line.optypes[2] == "Integer" then
            local initial = line.optypes[2]:sub(1,1)
            local register = line.operands[1].value:sub(2, 2)
            basekey = initial .. basekey .. '_' .. register
            table.insert(self.bytecode, {tag="instruction", basekey})
            table.insert(self.bytecode, {tag=initial == "I" and "int" or "float", format=initial == "I" and "<i" or "<f", line.operands[2].value})
        else
            error(("Unexpected type for 2nd operand '%s'"):format(line.optypes[2]))
        end


    elseif opname == "Copy" then
        local basekey = opname:upper()
        if (not line.optypes) or #line.optypes ~= 2 then
            error(("Expected exactly two operands for instruction '%s'"):format(line.opnameraw))
        end

        if line.optypes[1] ~= "Register" then
            error("Expected a register as first operand.")
        end

        if line.optypes[2] == "Register" then
            table.insert(self.bytecode, {tag="instruction", basekey})
            table.insert(self.bytecode, tonumber(line.operands[1].value:sub(2, 2)))
            table.insert(self.bytecode, tonumber(line.operands[2].value:sub(2, 2)))
        elseif line.optypes[2] == "Float" or line.optypes[2] == "Integer" or line.optypes[2] == "String" then
            local initial = line.optypes[2]:sub(1,1)
            local register = line.operands[1].value:sub(2, 2)
            basekey = initial .. basekey .. '_' .. register
            table.insert(self.bytecode, {tag="instruction", basekey})
            table.insert(self.bytecode, {tag=initial == "I" and "int" or (initial == "F" and "float" or "string"), format=initial == "I" and "<i" or "<f" or nil, line.operands[2].value})
        else
            error(("Unexpected type for 2nd operand '%s'"):format(line.optypes[2]))
        end

    elseif opname == "Exit" then
        if line.optypes then
            error("Expected no operands for instruction 'exit'")
        end

        table.insert(self.bytecode, {tag="instruction", "EXIT"})
    elseif opname == "Call" then
        if not line.optypes then
            error("Expected 1 operand for instruction 'call', but found 0")
        end
        if #line.optypes > 1 then
            error(("Expected 1 operand for instruction 'call', but found %d"):format(#line.optypes))
        end

        if line.optypes[1] ~= "Identifier" then
            error(("Expected a label for instruction 'call', but found a '%s'"):format(line.optypes[1]))
        end

        table.insert(self.bytecode, {tag="instruction", "CALL"})
        table.insert(self.bytecode, {tag="label", line.operands[1].value})
    elseif opname == "LuaCall" then
        if not line.optypes or #line.optypes ~= 2 then
            error(("Expected 2 operands for instruction 'luacall', but found %d"))
        end

        if line.optypes[1] ~= "Integer" then
            error(("Expected an integer as first operand for instruction 'luacall', but got a %s"):format(line.optypes[1] ~= "Identifier" and line.optypes[1]:lower() or "label") )
        end

        if line.optypes[2] ~= "Identifier" then
            error(("Expected an external label as second operand for instruction 'luacall', but got a %s"):format(line.optypes[2] ~= "Identifier" and line.optypes[2]:lower() or "label") )
        end

        table.insert(self.bytecode, {tag="instruction", "LUA_CALL"})
        table.insert(self.bytecode, {tag="int", format="<i", line.operands[1].value})
        table.insert(self.bytecode, {tag="extlabel", line.operands[2].value})
    elseif opname == "Return" then
        if line.optypes then
            error(("Expected no operands for instruction '%s'"):format(line.opnameraw))
        end

        table.insert(self.bytecode, {tag="instruction", "RETURN"})
    elseif opname == "LoadService" then
        if not line.optypes then
            error(("Expected 1 operand for instruction '%s', but found 0"):format(line.opnameraw))
        end

        if #line.optypes ~= 1 then
            error(("Expected 1 operand for instruction '%s', but found %d"):format(line.opnameraw, #line.optypes))
        end

        if line.optypes[1] == "Integer" then
            table.insert(self.bytecode, {tag="instruction", "LOADSERVICE"})
            table.insert(self.bytecode, {tag="int", format="<i", line.operands[1].value})
        else
            error(("Expected an integer as operand for instruction '%s'"):format(line.opnameraw))
        end
    elseif opname == "InvokeService"then
        if line.optypes then
            error(("Expected no operands for instruction '%s'"):format(line.opnameraw))
        end

        table.insert(self.bytecode, {tag="instruction", "INVOKESERVICE"})
    elseif opname == "Negation" then
        if not line.optypes then
            error("Expected 1 operand for instruction 'neg', but found 0")
        end

        if #line.optypes ~= 1 then
            error(("Expected 1 operand for instruction 'neg', but found %d"):format(#line.optypes))
        end

        if line.optypes[1] == "Register" then
            table.insert(self.bytecode, {tag="instruction", "NEG"})
            table.insert(self.bytecode, tonumber(line.operands[1].value:sub(2,2)))
        else
            error(("Expected an register as operand for instruction '%s'"):format(line.opnameraw))
        end
    elseif opname == "Compare" then
        if not line.optypes or #line.optypes ~= 2 then
            error(("Expected 2 operands for instruction 'compare', but found %d"):format(#line.operands))
        end

        local typeids = {
            Integer = 1,
            Float = 2,
            String = 3
        }

        table.insert(self.bytecode, {tag="instruction", "COMPARE"})
        if line.optypes[1] == "Register" then
            if line.optypes[2] == "Register" then
                table.insert(self.bytecode, 0)-- o id de tipo especial da instrucao compare pra "register and register"
                table.insert(self.bytecode, tonumber(line.operands[1].value:sub(2, 2)))
                table.insert(self.bytecode, tonumber(line.operands[2].value:sub(2, 2)))
                return
            end
            local typeid = typeids[line.optypes[2]]
            if not typeid then
                error(("'compare' instruction doesn't need a identifier, right?"))
            end
            table.insert(self.bytecode, typeid)
            table.insert(self.bytecode, tonumber(line.operands[1].value:sub(2, 2)))
            table.insert(self.bytecode, {tag=typeid == 1 and "int" or (typeid == 2 and "float" or "string"), format=typeid == 1 and "<i" or "<f" or nil, line.operands[2].value})


        elseif line.optypes[1] ~= "Identifier" then
            if line.optypes[1]~= line.optypes[2]then
                error("Types here must to be the same!")
            end

            local typeid = typeids[line.optypes[1]] + 3
            table.insert(self.bytecode, typeid)
            table.insert(self.bytecode, {tag=typeid == 4 and "int" or (typeid == 5 and "float" or "string"), format=typeid == 4 and "<i" or "<f" or nil, line.operands[1].value})
            table.insert(self.bytecode, {tag=typeid == 4 and "int" or (typeid == 5 and "float" or "string"), format=typeid == 4 and "<i" or "<f" or nil, line.operands[2].value})
        else
            error(("'compare' instruction doesn't need a identifier, right?"))
        end
    elseif opname == "Equals" or
           opname == "NotEquals" or
           opname == "Greater" or
           opname == "Less" or
           opname == "GreaterEqual" or
           opname == "LessEqual"then
            if not line.optypes or #line.optypes ~= 1 then
                error(("Expected 1 operand for instruction '%s', but found %d"):format(line.opnameraw, #line.operands))
            end

            if line.optypes[1] ~= "Register" then
                error(("Expected an register as operand for instruction '%s', but found %s"):format(line.opnameraw, line.optypes[1]:lower()))
            end

            table.insert(self.bytecode, {tag="instruction", line.opnameraw:upper() .. "_" .. line.operands[1].value:sub(2, 2)})
           end
end

return AsmGenerator