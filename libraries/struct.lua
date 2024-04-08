--[[
 * Copyright (c) 2015-2020 Iryont <https://github.com/iryont/lua-struct>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
]]

-- modificado para desempenho
local unpack = table.unpack or _G.unpack
local bit = require "bit"
local struct = {}

function struct.pack(format, ...)
  local stream = {}
  local vars = {...}
  local endianness = true

  for i = 1, format:len() do
    local opt = format:sub(i, i)

    if opt == '<' then
      endianness = true
    elseif opt == '>' then
      endianness = false
    elseif opt:find('[bBhHiIlL]') then
      local n = opt:find('[hH]') and 2 or opt:find('[iI]') and 4 or opt:find('[lL]') and 8 or 1
      local val = tonumber(table.remove(vars, 1))

      local bytes = {}
      for j = 1, n do
        table.insert(bytes, string.char(val % (2 ^ 8)))
        val = math.floor(val / (2 ^ 8))
      end

      if not endianness then
        table.insert(stream, string.reverse(table.concat(bytes)))
      else
        table.insert(stream, table.concat(bytes))
      end
    elseif opt:find('[fd]') then
      local val = tonumber(table.remove(vars, 1))
      local sign = 0

      if val < 0 then
        sign = 1
        val = -val
      end 

      local mantissa, exponent = math.frexp(val)
      if val == 0 then
        mantissa = 0
        exponent = 0
      else
        mantissa = (mantissa * 2 - 1) * math.ldexp(0.5, (opt == 'd') and 53 or 24)
        exponent = exponent + ((opt == 'd') and 1022 or 126)
      end

      local bytes = {}
      if opt == 'd' then
        val = mantissa
        for i = 1, 6 do
          table.insert(bytes, string.char(math.floor(val) % (2 ^ 8)))
          val = math.floor(val / (2 ^ 8))
        end
      else
        table.insert(bytes, string.char(math.floor(mantissa) % (2 ^ 8)))
        val = math.floor(mantissa / (2 ^ 8))
        table.insert(bytes, string.char(math.floor(val) % (2 ^ 8)))
        val = math.floor(val / (2 ^ 8))
      end

      table.insert(bytes, string.char(math.floor(exponent * ((opt == 'd') and 16 or 128) + val) % (2 ^ 8)))
      val = math.floor((exponent * ((opt == 'd') and 16 or 128) + val) / (2 ^ 8))
      table.insert(bytes, string.char(math.floor(sign * 128 + val) % (2 ^ 8)))
      val = math.floor((sign * 128 + val) / (2 ^ 8))

      if not endianness then
        table.insert(stream, string.reverse(table.concat(bytes)))
      else
        table.insert(stream, table.concat(bytes))
      end
    elseif opt == 's' then
      table.insert(stream, tostring(table.remove(vars, 1)))
      table.insert(stream, string.char(0))
    elseif opt == 'c' then
      local n = format:sub(i + 1):match('%d+')
      local str = tostring(table.remove(vars, 1))
      local len = tonumber(n)
      if len <= 0 then
        len = str:len()
      end
      if len - str:len() > 0 then
        str = str .. string.rep(' ', len - str:len())
      end
      table.insert(stream, str:sub(1, len))
      i = i + n:len()
    end
  end

  return table.concat(stream)
end

function struct.unpack(format, stream, pos)
  local vars = {}
  local iterator = pos or 1
  local endianness = true

  for i = 1, format:len() do
    local opt = format:sub(i, i)

    if opt == '<' then
      endianness = true
    elseif opt == '>' then
      endianness = false
    elseif opt:find('[bBhHiIlL]') then
      local n = opt:find('[hH]') and 2 or opt:find('[iI]') and 4 or opt:find('[lL]') and 8 or 1
      local signed = opt:lower() == opt

      local val = 0
      for j = 1, n do
        local byte = string.byte(stream:sub(iterator, iterator))
        if endianness then
          val = val + byte * (2 ^ ((j - 1) * 8))
        else
          val = val + byte * (2 ^ ((n - j) * 8))
        end
        iterator = iterator + 1
      end

      if signed and val >= 2 ^ (n * 8 - 1) then
        val = val - 2 ^ (n * 8)
      end

      table.insert(vars, math.floor(val))
    elseif opt:find('[fd]') then
      local n = (opt == 'd') and 8 or 4
      local x = stream:sub(iterator, iterator + n - 1)
      iterator = iterator + n

      if not endianness then
        x = string.reverse(x)
      end

      local sign = 1
      local mantissa = string.byte(x, (opt == 'd') and 7 or 3) % ((opt == 'd') and 16 or 128)
      for i = n - 2, 1, -1 do
        mantissa = mantissa * (2 ^ 8) + string.byte(x, i)
      end

      if string.byte(x, n) > 127 then
        sign = -1
      end

      local exponent = (string.byte(x, n) % 128) * ((opt == 'd') and 16 or 2) + math.floor(string.byte(x, n - 1) / ((opt == 'd') and 16 or 128))
      if exponent == 0 then
        table.insert(vars, 0.0)
      else
        mantissa = (math.ldexp(mantissa, (opt == 'd') and -52 or -23) + 1) * sign
        table.insert(vars, math.ldexp(mantissa, exponent - ((opt == 'd') and 1023 or 127)))
      end
    elseif opt == 's' then
      local bytes = {}
      for j = iterator, stream:len() do
        if stream:sub(j,j) == string.char(0) or  stream:sub(j) == '' then
          break
        end

        table.insert(bytes, stream:sub(j, j))
      end

      local str = table.concat(bytes)
      iterator = iterator + str:len() + 1
      table.insert(vars, str)
    elseif opt == 'c' then
      local n = format:sub(i + 1):match('%d+')
      local len = tonumber(n)
      if len <= 0 then
        len = table.remove(vars)
      end

      table.insert(vars, stream:sub(iterator, iterator + len - 1))
      iterator = iterator + len
      i = i + n:len()
    end
  end

  return unpack(vars)
end


--------------------
--funcoes proprias
function struct.packint(number)
  local val = number

  local byte1, byte2, byte3, byte4
  
  byte1 = val % (2 ^ 8)  
  val = math.floor(val / (2 ^ 8))
  byte2 = val % (2 ^ 8)
  val = math.floor(val / (2 ^ 8))
  byte3 = val % (2 ^ 8)
  val = math.floor(val / (2 ^ 8))
  byte4 = val % (2 ^ 8)
  

  return byte4, byte3, byte2, byte1
end

function struct.packlong(number)
  local val = number

  local byte1, byte2, byte3, byte4, byte5, byte6, byte7, byte8
  
  byte1 = val % (2 ^ 8)  
  val = math.floor(val / (2 ^ 8))
  byte2 = val % (2 ^ 8)
  val = math.floor(val / (2 ^ 8))
  byte3 = val % (2 ^ 8)
  val = math.floor(val / (2 ^ 8))
  byte4 = val % (2 ^ 8)
  val = math.floor(val / (2 ^ 8))
  byte5 = val % (2 ^ 8)
  val = math.floor(val / (2 ^ 8))
  byte6 = val % (2 ^ 8)
  val = math.floor(val / (2 ^ 8))
  byte7 = val % (2 ^ 8)
  val = math.floor(val / (2 ^ 8))
  byte8 = val % (2 ^ 8)
  

  return byte8, byte7, byte6, byte5, byte4, byte3, byte2, byte1
end

function struct.packfloat(value)
  local val = value
  local sign = 0

  if val < 0 then
    sign = 1
    val = -val
  end 

  local mantissa, exponent = math.frexp(val)
  if val == 0 then
    mantissa = 0
    exponent = 0
    return 0, 0, 0, 0
  else
    mantissa = (mantissa * 2 - 1) * math.ldexp(0.5, 24)
    exponent = exponent + 126
  end

  local byte1, byte2, byte3, byte4
  
  byte1 = math.floor(mantissa) % (2 ^ 8)
  val = math.floor(mantissa / (2 ^ 8))
  byte2 = math.floor(val) % (2 ^ 8)
  val = math.floor(val / (2 ^ 8))

  byte3 = math.floor(exponent * 128 + val) % (2 ^ 8)
  val = math.floor((exponent * 128 + val) / (2 ^ 8))
  byte4 = math.floor(sign * 128 + val) % (2 ^ 8)
  

  return byte4, byte3, byte2, byte1
end

function struct.packdouble(number)
  if number == 0 or number ~= number then
    if number ~= number then
      return 127, 248, 0, 0, 0, 0, 0, 0
    end
    return 0, 0, 0, 0, 0, 0, 0, 0
  end
  local signal = 0
  if number < 0 then
    signal = 1
    number = -number
  end

  local mantissa, exponent = math.frexp(number)

  print(exponent, mantissa)
  local byte1, byte2, byte3, byte4, byte5, byte6, byte7, byte8

  local num = bit.bor(bit.rshift(mantissa, 12), bit.bor(signal, bit.rshift(exponent + 1023, 1)))
  byte1 = bit.band(num, bit.lshift(0xFF, 56))
  byte2 = bit.band(num, bit.lshift(0xFF, 48))
  byte3 = bit.band(num, bit.lshift(0xFF, 40))
  byte4 = bit.band(num, bit.lshift(0xFF, 32))
  byte5 = bit.band(num, bit.lshift(0xFF, 24))
  byte6 = bit.band(num, bit.lshift(0xFF, 16))
  byte7 = bit.band(num, bit.lshift(0xFF, 8))
  byte8 = bit.band(num, 0xFF)
  return byte1, byte2, byte3, byte4, byte5, byte6, byte7, byte8

end

function struct.unpackint(signed, byte1, byte2, byte3, byte4)
    local n = 4
    local val = ((byte1 * (2 ^ ((n - 1) * 8)))
    + (byte2 * (2 ^ ((n - 2) * 8)))
    + (byte3 * (2 ^ ((n - 3) * 8)))
    + byte4)

    if signed and val >= 2 ^ (n * 8 - 1) then
        val = val - 2 ^ (n * 8)
    end

    return val
end

function struct.unpacklong(signed, byte1, byte2, byte3, byte4, byte5, byte6, byte7, byte8)
  local n = 8
  local val = ((byte1 * (2 ^ ((n - 1) * 8)))
  + (byte2 * (2 ^ ((n - 2) * 8)))
  + (byte3 * (2 ^ ((n - 3) * 8)))
  + (byte4 * (2 ^ ((n - 4) * 8)))
  + (byte5 * (2 ^ ((n - 5) * 8)))
  + (byte6 * (2 ^ ((n - 6) * 8)))
  + (byte7 * (2 ^ ((n - 7) * 8)))
  + byte8)

  if signed and val >= 2 ^ (n * 8 - 1) then
      val = val - 2 ^ (n * 8)
  end

  return val
end

function struct.unpackfloat(byte1, byte2, byte3, byte4)
  
  local sign = 1
  local mantissa = byte2 % 128
  mantissa = mantissa * (2 ^ 8) + byte3
  mantissa = mantissa * (2 ^ 8) + byte4
  
  

  if byte1 > 127 then
    sign = -1
  end

  local exponent = (byte1 % 128) * 2 + math.floor(byte2 / 128)
  if exponent == 0 then
    return 0.0
  else
    mantissa = (math.ldexp(mantissa, -23) + 1) * sign
    return math.ldexp(mantissa, exponent - 127)
  end
end

function struct.unpackdouble(byte1, byte2, byte3, byte4, byte5, byte6, byte7, byte8)
  local signal = (bit.band(byte1, 0x80) == 0) and 1 or -1

  local exponent = bit.bor(bit.band(byte1, 127), bit.rshift(bit.band(byte2, 224), 7)) - 1023
  local mantissa = bit.bor(
  bit.bor(
    bit.bor(
      bit.bor(
        bit.bor(
          bit.bor(bit.band(byte2, 31), bit.rshift(byte3, 5)),
          bit.rshift(byte4, 13)),
        bit.rshift(byte5, 21)),
       bit.rshift(byte6, 29)),
    bit.rshift(byte7, 37)),
  bit.rshift(byte8, 45))

  local result = signal * bit.lshift((math.ldexp(mantissa, -53) + 1), exponent)
  return result
end

return struct
