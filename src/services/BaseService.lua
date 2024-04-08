--# BaseService:  
--serviço base para outros serviços na simplevm
---@class BaseService
---@field opcodes table<integer, string>
---@field subsservices table<string, function>
local BaseService = {}

---@alias bool 1 | 0

--vmdata_t: representa os tipos de dados representaveis na simplevm
---@alias vmdata_t integer | number | string | bool

--[[
     Documentação de subsserviços  
    para indicar que uma função é um subserviço, será indicado na forma "NomeDoServico::subservico", oque pode ser interpretado como "NomeDoService.subsservices:subservico".

    para indicar os argumentos, será utilizada uma notacao como:
      ---@args = {a: integer = $1, b: integer = $2}

    onde "$n" representa o indice do array de argumentos.
    E lembrando que os tipos dos argumentos sao restritos a vmdata_t
]]




function BaseService:init()
    self.opcodes = {}
    self.subsservices = {}
end


--Método primário: BaseService:invoke  
--Ele invoca algum subserviço dentro do serviço, e retorna um codigo de status 0 caso tenha houve sucesso, caso contrário retorna 1 mais uma mensagem de erro.
---@param opcode integer
---@param args table<integer, vmdata_t>
---@param registers table<integer, vmdata_t?>?
---@return integer, string?
function BaseService:invoke(opcode, args, registers)
    local subsservice = self.subsservices[self.opcodes[opcode]]

    if not subsservice then
        return 1, "Attempt to get a nil subsservice."
    end

    local status, err = subsservice(self, args, registers)

    return status, err
end


return BaseService