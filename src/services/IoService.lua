--IoService: um serviço da simplevm que cuida de operacoes de E/S
local struct = require"libraries.struct"

local unpack = unpack or table.unpack
local BaseService = require"src.services.BaseService"

---@alias fileinfo_t {file: file*, binary: boolean?, type: ("r" | "w" | "a")}

---@class IoService : BaseService
---@field files table<integer, fileinfo_t>
local IoService = {files={
    {file=io.stdout, binary=false, type="w"},
    {file=io.stderr, binary=false, type="w"},
    {file=io.stdin, binary=false, type="r"}
}}

setmetatable(IoService, {__index=BaseService})

function IoService:init()
    BaseService.init(self) 
    self.opcodes[1] = "open"
    self.opcodes[2] = "write"
    self.opcodes[3] = "read"
    self.opcodes[4] = "close"
end
IoService:init()
--Subserviço: IoService::open
--Ele abre um arquivo `name`, no modo "mode", especificando se é binario ou nao.
---@args {name: string = $1, mode: integer = $2, binary: bool = $3}
function IoService.subsservices:open(args)
    local name, mode, binary = unpack(args)
    local m
    if mode == 1 then
      m = 'r'
    elseif mode == 2 then
      m = 'w'
    elseif mode == 3 then
      m = 'a'
    elseif mode == 4 then
      m = 'r+'
    elseif mode == 5 then
      m = 'w+'
    elseif mode == 6 then
      m = 'a+'
    else
      self:error("Unknown file mode.")
      return
    end

    if binary == 1 then
      m = m .. 'b'
    end

    local file, err = io.open(name --[[@as string]], m)
    if not file then
        return 1, err
    end

    local fl = {file=file, binary=binary, type=m:sub(1, 1)}
    table.insert(IoService.files, fl)

    return 0
end

--Subserviço: IoService::write
--escreve algo em um arquivo especificando seu descritor e o conteudo
--caso o conteudo seja um numero e o arquivo seja binario, ele faz certas acoes dependendo do numero:
--  . | caso o numero seja um inteiro e tiver na faixa de um byte nao assinado (0 a 2 ^ 8 - 1), ele é escrito como um byte, caso contrario, é escrito como um inteiro ou float de 64 bits normal
---@args {descriptor: integer = $1, content: vmdata_t = $2}
function IoService.subsservices:write(args)
    local descriptor, content = unpack(args)
    local file = IoService._search(descriptor)

    if not file then
        return 1, "Attempt to write in a non-open file"
    end

    if not (file.type == "a" or file.type == "w") then
        return 1, "Attempt to write in a non-writeable file"
    end

    if file.binary == 1 then
        if type(content) == "string" then
            file.file:write(content)
        else
            local integer = true
            if content ~= math.floor(content) then
                integer = false
            end

            if integer and (content >= 0 and content < (2 ^ 8)) then
                file.file:write(string.char(content))
            else
                file.file:write(content)
            end
        end
    else
        file.file:write(content)
    end

    return 0
end

--pesquisa um arquivo nos arquivos abertos, utilizando um indice, e retorna nil caso nao o encontre
function IoService._search(index)
    for i, file in ipairs(IoService.files) do
        if i == index then
            return file
        end
    end
    return nil
end

--Subserviço: IoService::read
--lê algo de um dado tamanho de um arquivo dado por um descritor, e armazena o resultado em um registrador especificado.
---@args {descriptor: integer = $1, size: integer = $2, dest: integer = $3 --[[indica um registrador]]}
function IoService.subsservices:read(args, registers)
    local descriptor, size, dest = unpack(args)

    local file = IoService._search(descriptor)

    if not file then
        return 1, "Attempt to read a non-open file"
    end

    if file.type ~= 'r' then
        return 1, "Attempt to read a non-readable file"
    end

    local result = file.file:read(size)
    registers[dest] = result

    return 0
end

--Subserviço: IoService::close 
--fecha um arquivo dado por um descritor, e o torna indisponivel para uso, sendo necessario reabri-lo caso queira usa-lo
---@args {descriptor: integer = $1}
function IoService.subsservices:close(args)
    local descriptor = args[1]
    local file = IoService._search(descriptor)

    if not file then
        return 1, "Attempt to close a non-open file."
    end

    file.file:close()
    table.remove(IoService.files, descriptor)
    return 0
end

return IoService
