-- tabela de acoes pra formosa simplevm
local Code =  require "src.enums.Code"
local bit = require "bit"
local ffi = require "ffi"
local utf8 = require "libraries.utf8"
local struct = require "libraries.struct"

local cases = {
    [Code.ICOPY_1] = function(self)
      local value = self:getint()
      self.regs[1] = value
    end,
    [Code.ICOPY_2] = function(self)
      local value = self:getint()
      
      self.regs[2] = value
    end,
    [Code.ICOPY_3] = function(self)
      local value = self:getint()
      
      self.regs[3] = value
    end,
    [Code.ICOPY_4] = function(self)
      local value = self:getint()
      
      self.regs[4] = value
    end,
    [Code.ICOPY_5] = function(self)
      local value = self:getint()
      
      self.regs[5] = value
    end,
    [Code.ICOPY_6] = function(self)
      local value = self:getint()
      
      self.regs[6] = value
    end,
    [Code.ICOPY_7] = function(self)
      local value = self:getint()
      
      self.regs[7] = value
    end,
    [Code.ICOPY_8] = function(self)
      local value = self:getint()
      
      self.regs[8] = value
    end,
    [Code.FCOPY_1] = function(self)
      local value = self:getfloat()
      
      self.regs[1] = value
    end,
    [Code.FCOPY_2] = function(self)
      local value = self:getfloat()
      
      self.regs[2] = value
    end,
    [Code.FCOPY_3] = function(self)
      local value = self:getfloat()
      
      self.regs[3] = value
    end,
    [Code.FCOPY_4] = function(self)
      local value = self:getfloat()
      
      self.regs[4] = value
    end,
    [Code.FCOPY_5] = function(self)
      local value = self:getfloat()
      
      self.regs[5] = value
    end,
    [Code.FCOPY_6] = function(self)
      local value = self:getfloat()
      
      self.regs[6] = value
    end,
    [Code.FCOPY_7] = function(self)
      local value = self:getfloat()
      
      self.regs[7] = value
    end,
    [Code.FCOPY_8] = function(self)
      local value = self:getfloat()
      
      self.regs[8] = value
    end,
    [Code.SCOPY_1] = function(self)
      local value = self:getstring()
      
      self.regs[1] = value
    end,
    [Code.SCOPY_2] = function(self)
      local value = self:getstring()
      
      self.regs[2] = value
    end,
    [Code.SCOPY_3] = function(self)
      local value = self:getstring()
      
      self.regs[3] = value
    end,
    [Code.SCOPY_4] = function(self)
      local value = self:getstring()
      
      self.regs[4] = value
    end,
    [Code.SCOPY_5] = function(self)
      local value = self:getstring()
      
      self.regs[5] = value
    end,
    [Code.SCOPY_6] = function(self)
      local value = self:getstring()
      
      self.regs[6] = value
    end,
    [Code.SCOPY_7] = function(self)
      local value = self:getstring()
      
      self.regs[7] = value
    end,
    [Code.SCOPY_8] = function(self)
      local value = self:getstring()
      
      self.regs[8] = value
    end,
    [Code.COPY] = function(self)
      local x = self:consomeByte()
      local y = self:consomeByte()
      self.regs[x] = self.regs[y]
    end,
    [Code.ADD] = function(self)
      local x = self:consomeByte()
      local y = self:consomeByte()
      
      self.regs[x] = self.regs[x] + self.regs[y]
    end,
    [Code.IADD_1] = function(self)
      self.regs[1] = self.regs[1] + self:getint()
    end,
    [Code.IADD_2] = function(self)
      self.regs[2] = self.regs[2] + self:getint()
    end,
    [Code.IADD_3] = function(self)
      self.regs[3] = self.regs[3] + self:getint()
    end,
    [Code.IADD_4] = function(self)
      self.regs[4] = self.regs[4] + self:getint()
    end,
    [Code.IADD_5] = function(self)
      self.regs[5] = self.regs[5] + self:getint()
    end,
    [Code.IADD_6] = function(self)
      self.regs[6] = self.regs[6] + self:getint()
    end,
    [Code.IADD_7] = function(self)
      self.regs[7] = self.regs[7] + self:getint()
    end,
    [Code.IADD_8] = function(self)
      self.regs[4] = self.regs[4] + self:getint()
    end,

    [Code.FADD_1] = function(self)
      self.regs[1] = self.regs[1] + self:getfloat()
    end,
    [Code.FADD_2] = function(self)
      self.regs[2] = self.regs[2] + self:getfloat()
    end,
    [Code.FADD_3] = function(self)
      self.regs[3] = self.regs[3] + self:getfloat()
    end,
    [Code.FADD_4] = function(self)
      self.regs[4] = self.regs[4] + self:getfloat()
    end,
    [Code.FADD_5] = function(self)
      self.regs[5] = self.regs[5] + self:getfloat()
    end,
    [Code.FADD_6] = function(self)
      self.regs[6] = self.regs[6] + self:getfloat()
    end,
    [Code.FADD_7] = function(self)
      self.regs[7] = self.regs[7] + self:getfloat()
    end,
    [Code.FADD_8] = function(self)
      self.regs[4] = self.regs[4] + self:getfloat()
    end,


    [Code.MUL] = function(self)
      local x = self:consomeByte()
      local y = self:consomeByte()
      self.regs[x] = self.regs[x] * self.regs[y]
    end,
    [Code.IMUL_1] = function(self)
      self.regs[1] = self.regs[1] * self:getint()
    end,
    [Code.IMUL_2] = function(self)
      self.regs[2] = self.regs[2] * self:getint()
    end,
    [Code.IMUL_3] = function(self)
      self.regs[3] = self.regs[3] * self:getint()
    end,
    [Code.IMUL_4] = function(self)
      self.regs[4] = self.regs[4] * self:getint()
    end,
    [Code.IMUL_5] = function(self)
      self.regs[5] = self.regs[5] * self:getint()
    end,
    [Code.IMUL_6] = function(self)
      self.regs[6] = self.regs[6] * self:getint()
    end,
    [Code.IMUL_7] = function(self)
      self.regs[7] = self.regs[7] * self:getint()
    end,
    [Code.IMUL_8] = function(self)
      self.regs[8] = self.regs[8] * self:getint()
    end,

    [Code.FMUL_1] = function(self)
      self.regs[1] = self.regs[1] * self:getfloat()
    end,
    [Code.FMUL_2] = function(self)
      self.regs[2] = self.regs[2] * self:getfloat()
    end,
    [Code.FMUL_3] = function(self)
      self.regs[3] = self.regs[3] * self:getfloat()
    end,
    [Code.FMUL_4] = function(self)
      self.regs[4] = self.regs[4] * self:getfloat()
    end,
    [Code.FMUL_5] = function(self)
      self.regs[5] = self.regs[5] * self:getfloat()
    end,
    [Code.FMUL_6] = function(self)
      self.regs[6] = self.regs[6] * self:getfloat()
    end,
    [Code.FMUL_7] = function(self)
      self.regs[7] = self.regs[7] * self:getfloat()
    end,
    [Code.FMUL_8] = function(self)
      self.regs[8] = self.regs[8] * self:getfloat()
    end,

    [Code.SUB] = function(self)
      local x = self:consomeByte()
      local y = self:consomeByte()
      
      self.regs[x] = self.regs[x] - self.regs[y]
    end,
    [Code.ISUB_1] = function(self)
      self.regs[1] = self.regs[1] - self:getint()
    end,
    [Code.ISUB_2] = function(self)
      self.regs[3] = self.regs[2] - self:getint()
    end,
    [Code.ISUB_3] = function(self)
      self.regs[3] = self.regs[3] - self:getint()
    end,
    [Code.ISUB_4] = function(self)
      self.regs[4] = self.regs[4] - self:getint()
    end,
    [Code.ISUB_5] = function(self)
      self.regs[5] = self.regs[5] - self:getint()
    end,
    [Code.ISUB_6] = function(self)
      self.regs[6] = self.regs[6] - self:getint()
    end,
    [Code.ISUB_7] = function(self)
      self.regs[7] = self.regs[7] - self:getint()
    end,
    [Code.ISUB_8] = function(self)
      self.regs[8] = self.regs[8] - self:getint()
    end,

    [Code.FSUB_1] = function(self)
      self.regs[1] = self.regs[1] - self:getfloat()
    end,
    [Code.FSUB_2] = function(self)
      self.regs[3] = self.regs[2] - self:getfloat()
    end,
    [Code.FSUB_3] = function(self)
      self.regs[3] = self.regs[3] - self:getfloat()
    end,
    [Code.FSUB_4] = function(self)
      self.regs[4] = self.regs[4] - self:getfloat()
    end,
    [Code.FSUB_5] = function(self)
      self.regs[5] = self.regs[5] - self:getfloat()
    end,
    [Code.FSUB_6] = function(self)
      self.regs[6] = self.regs[6] - self:getfloat()
    end,
    [Code.FSUB_7] = function(self)
      self.regs[7] = self.regs[7] - self:getfloat()
    end,
    [Code.FSUB_8] = function(self)
      self.regs[8] = self.regs[8] - self:getfloat()
    end,

    [Code.DIV] = function(self)
      local x = self:consomeByte()
      local y = self:consomeByte()
      
      self.regs[x] = math.floor(self.regs[x] / self.regs[y])
    end,
    [Code.IDIV_1] = function(self)
      self.regs[1] = math.floor(self.regs[1] / self:getint())
    end,
    [Code.IDIV_2] = function(self)
      self.regs[3] = math.floor(self.regs[2] / self:getint())
    end,
    [Code.IDIV_3] = function(self)
      self.regs[3] = math.floor(self.regs[3] / self:getint())
    end,
    [Code.IDIV_4] = function(self)
      self.regs[4] = math.floor(self.regs[4] / self:getint())
    end,
    [Code.IDIV_5] = function(self)
      self.regs[5] = math.floor(self.regs[5] / self:getint())
    end,
    [Code.IDIV_6] = function(self)
      self.regs[6] = math.floor(self.regs[6] / self:getint())
    end,
    [Code.IDIV_7] = function(self)
      self.regs[7] = math.floor(self.regs[7] / self:getint())
    end,
    [Code.IDIV_8] = function(self)
      self.regs[8] = math.floor(self.regs[8] / self:getint())
    end,

    [Code.FDIV_1] = function(self)
      self.regs[1] = self.regs[1] / self:getfloat()
    end,
    [Code.FDIV_2] = function(self)
      self.regs[3] = self.regs[2] / self:getfloat()
    end,
    [Code.FDIV_3] = function(self)
      self.regs[3] = self.regs[3] / self:getfloat()
    end,
    [Code.FDIV_4] = function(self)
      self.regs[4] = self.regs[4] / self:getfloat()
    end,
    [Code.FDIV_5] = function(self)
      self.regs[5] = self.regs[5] / self:getfloat()
    end,
    [Code.FDIV_6] = function(self)
      self.regs[6] = self.regs[6] / self:getfloat()
    end,
    [Code.IDIV_7] = function(self)
      self.regs[7] = self.regs[7] / self:getfloat()
    end,
    [Code.FDIV_8] = function(self)
      self.regs[8] = self.regs[8] / self:getfloat()
    end,

    [Code.MOD] = function(self)
      local x = self:consomeByte()
      local y = self:consomeByte()
      
      self.regs[x] = self.regs[x] % self.regs[y]
    end,
    [Code.IMOD_1] = function(self)
      self.regs[1] = self.regs[1] % self:getint()
    end,
    [Code.IMOD_2] = function(self)
      self.regs[3] = self.regs[2] % self:getint()
    end,
    [Code.IMOD_3] = function(self)
      self.regs[3] = self.regs[3] % self:getint()
    end,
    [Code.IMOD_4] = function(self)
      self.regs[4] = self.regs[4] % self:getint()
    end,
    [Code.IMOD_5] = function(self)
      self.regs[5] = self.regs[5] % self:getint()
    end,
    [Code.IMOD_6] = function(self)
      self.regs[6] = self.regs[6] % self:getint()
    end,
    [Code.IMOD_7] = function(self)
      self.regs[7] = self.regs[7] % self:getint()
    end,
    [Code.IMOD_8] = function(self)
      self.regs[8] = self.regs[8] % self:getint()
    end,

    [Code.FMOD_1] = function(self)
      self.regs[1] = self.regs[1] % self:getfloat()
    end,
    [Code.FMOD_2] = function(self)
      self.regs[3] = self.regs[2] % self:getfloat()
    end,
    [Code.FMOD_3] = function(self)
      self.regs[3] = self.regs[3] % self:getfloat()
    end,
    [Code.FMOD_4] = function(self)
      self.regs[4] = self.regs[4] % self:getfloat()
    end,
    [Code.FMOD_5] = function(self)
      self.regs[5] = self.regs[5] % self:getfloat()
    end,
    [Code.FMOD_6] = function(self)
      self.regs[6] = self.regs[6] % self:getfloat()
    end,
    [Code.FMOD_7] = function(self)
      self.regs[7] = self.regs[7] % self:getfloat()
    end,
    [Code.FMOD_8] = function(self)
      self.regs[8] = self.regs[8] % self:getfloat()
    end,
    [Code.EQ_1] = function(self)
      self.regs[1] = self.flags.equality and 1 or 0
    end,
    [Code.EQ_2] = function(self)
      self.regs[2] = self.flags.equality and 1 or 0
    end,
    [Code.EQ_3] = function(self)
      self.regs[3] = self.flags.equality and 1 or 0
    end,
    [Code.EQ_4] = function(self)
      self.regs[4] = self.flags.equality and 1 or 0
    end,
    [Code.EQ_5] = function(self)
      self.regs[5] = self.flags.equality and 1 or 0
    end,
    [Code.EQ_6] = function(self)
      self.regs[6] = self.flags.equality and 1 or 0
    end,
    [Code.EQ_7] = function(self)
      self.regs[7] = self.flags.equality and 1 or 0
    end,
    [Code.EQ_8] = function(self)
      self.regs[8] = self.flags.equality and 1 or 0
    end,

    [Code.NE_1] = function(self)
      self.regs[1] = self.flags.equality and 0 or 1
    end,
    [Code.NE_2] = function(self)
      self.regs[2] = self.flags.equality and 0 or 1
    end,
    [Code.NE_3] = function(self)
      self.regs[3] = self.flags.equality and 0 or 1
    end,
    [Code.NE_4] = function(self)
      self.regs[4] = self.flags.equality and 0 or 1
    end,
    [Code.NE_5] = function(self)
      self.regs[5] = self.flags.equality and 0 or 1
    end,
    [Code.NE_6] = function(self)
      self.regs[6] = self.flags.equality and 0 or 1
    end,
    [Code.NE_7] = function(self)
      self.regs[7] = self.flags.equality and 0 or 1
    end,
    [Code.NE_8] = function(self)
      self.regs[8] = self.flags.equality and 0 or 1
    end,

    [Code.GT_1] = function(self)
      self.regs[1] = self.flags.greater and 1 or 0
    end,
    [Code.GT_2] = function(self)
      self.regs[2] = self.flags.greater and 1 or 0
    end,
    [Code.GT_3] = function(self)
      self.regs[3] = self.flags.greater and 1 or 0
    end,
    [Code.GT_4] = function(self)
      self.regs[4] = self.flags.greater and 1 or 0
    end,
    [Code.GT_5] = function(self)
      self.regs[5] = self.flags.greater and 1 or 0
    end,
    [Code.GT_6] = function(self)
      self.regs[6] = self.flags.greater and 1 or 0
    end,
    [Code.GT_7] = function(self)
      self.regs[7] = self.flags.greater and 1 or 0
    end,
    [Code.GT_8] = function(self)
      self.regs[1] = self.flags.greater and 1 or 0
    end,

    [Code.LT_1] = function(self)
      self.regs[1] = self.flags.less and 1 or 0
    end,
    [Code.LT_2] = function(self)
      self.regs[2] = self.flags.less and 1 or 0
    end,
    [Code.LT_3] = function(self)
      self.regs[3] = self.flags.less and 1 or 0
    end,
    [Code.LT_4] = function(self)
      self.regs[4] = self.flags.less and 1 or 0
    end,
    [Code.LT_5] = function(self)
      self.regs[5] = self.flags.less and 1 or 0
    end,
    [Code.LT_6] = function(self)
      self.regs[6] = self.flags.less and 1 or 0
    end,
    [Code.LT_7] = function(self)
      self.regs[7] = self.flags.less and 1 or 0
    end,
    [Code.LT_8] = function(self)
      self.regs[1] = self.flags.less and 1 or 0
    end,

    [Code.GE_1] = function(self)
      self.regs[1] = (self.greater or self.equality) and 1 or 0
    end,
    [Code.GE_2] = function(self)
      self.regs[2] = (self.greater or self.equality) and 1 or 0
    end,
    [Code.GE_3] = function(self)
      self.regs[3] = (self.greater or self.equality) and 1 or 0
    end,
    [Code.GE_4] = function(self)
      self.regs[4] = (self.greater or self.equality) and 1 or 0
    end,
    [Code.GE_5] = function(self)
      self.regs[5] = (self.greater or self.equality) and 1 or 0
    end,
    [Code.GE_6] = function(self)
      self.regs[6] = (self.greater or self.equality) and 1 or 0
    end,
    [Code.GE_7] = function(self)
      self.regs[7] = (self.greater or self.equality) and 1 or 0
    end,
    [Code.GE_8] = function(self)
      self.regs[8] = (self.greater or self.equality) and 1 or 0
    end,

    [Code.LE_1] = function(self)
      self.regs[1] = (self.less or self.equality) and 1 or 0
    end,
    [Code.LE_2] = function(self)
      self.regs[2] = (self.less or self.equality) and 1 or 0
    end,
    [Code.LE_3] = function(self)
      self.regs[3] = (self.less or self.equality) and 1 or 0
    end,
    [Code.LE_4] = function(self)
      self.regs[4] = (self.less or self.equality) and 1 or 0
    end,
    [Code.LE_5] = function(self)
      self.regs[5] = (self.less or self.equality) and 1 or 0
    end,
    [Code.LE_6] = function(self)
      self.regs[6] = (self.less or self.equality) and 1 or 0
    end,
    [Code.LE_7] = function(self)
      self.regs[7] = (self.less or self.equality) and 1 or 0
    end,
    [Code.LE_8] = function(self)
      self.regs[8] = (self.less or self.equality) and 1 or 0
    end,

    [Code.AND] = function(self)
      local x = self:consomeByte()
      local y = self:consomeByte()

      self.regs[x] = bit.band(self.regs[x], self.regs[y])
    end,
    [Code.AND_1] = function(self)
      self.regs[1] = bit.band(self.regs[1], self:getint())
    end,
    [Code.AND_2] = function(self)
      self.regs[2] = bit.band(self.regs[2], self:getint())
    end,
    [Code.AND_3] = function(self)
      self.regs[3] = bit.band(self.regs[3], self:getint())
    end,
    [Code.AND_4] = function(self)
      self.regs[4] = bit.band(self.regs[4], self:getint())
    end,
    [Code.AND_5] = function(self)
      self.regs[5] = bit.band(self.regs[5], self:getint())
    end,
    [Code.AND_6] = function(self)
      self.regs[6] = bit.band(self.regs[6], self:getint())
    end,
    [Code.AND_7] = function(self)
      self.regs[7] = bit.band(self.regs[7], self:getint())
    end,
    [Code.AND_8] = function(self)
      self.regs[8] = bit.band(self.regs[8], self:getint())
    end,

    [Code.OR] = function(self)
      local x = self:consomeByte()
      local y = self:consomeByte()

      self.regs[x] = bit.band(self.regs[x], self.regs[y])
    end,
    [Code.OR_1] = function(self)
      self.regs[1] = bit.bor(self.regs[1], self:getint())
    end,
    [Code.OR_2] = function(self)
      self.regs[2] = bit.bor(self.regs[2], self:getint())
    end,
    [Code.OR_3] = function(self)
      self.regs[3] = bit.bor(self.regs[3], self:getint())
    end,
    [Code.OR_4] = function(self)
      self.regs[4] = bit.bor(self.regs[4], self:getint())
    end,
    [Code.OR_5] = function(self)
      self.regs[5] = bit.bor(self.regs[5], self:getint())
    end,
    [Code.OR_6] = function(self)
      self.regs[6] = bit.bor(self.regs[6], self:getint())
    end,
    [Code.OR_7] = function(self)
      self.regs[7] = bit.bor(self.regs[7], self:getint())
    end,
    [Code.OR_8] = function(self)
      self.regs[8] = bit.bor(self.regs[8], self:getint())
    end,

    [Code.NOT] = function(self)
      local reg = self:consomeByte()

      self.regs[reg] = bit.bnot(self.regs[reg])
    end,
    [Code.COMPARE] = function(self)
      -- resetando as flags pra evitar problemas
      self.flags.equality = false
      self.flags.greater = false
      self.flags.less = false
      local x = self:consomeByte()
      local y = self:consomeByte()

      local a = self.regs[x]

      local b = self.regs[y]

      if type(a) == "string" or type(b) == "string" then
        a = #string
        b = #string
      end
      local result = self.regs[x] - self.regs[y]

      if result == 0 then
        self.flags.equality = true
      elseif result > 0 then
        self.flags.greater = true
      else
        self.flags.less = true
      end
    end,

    [Code.NEWFRAME] = function(self)
      table.insert(self.frames, {locals={}})
      self.frame = self.frames[#self.frames]
    end,
    [Code.POPFRAME] = function(self)
      table.remove(self.frames, #(self.frames))
      self.frame = self.frames[#self.frames]
    end,
    
    [Code.ISTORE] = function(self)
      table.insert(self.frame.locals, self:getint())
    end,
    [Code.FSTORE] = function(self)
      table.insert(self.frame.locals, self:getfloat())
    end,
    [Code.SSTORE] = function(self)
      table.insert(self.frame.locals, self:getstring())
    end,
    [Code.STORE_1] = function(self)
      table.insert(self.frame.locals, self.regs[1])
    end,
    [Code.STORE_2] = function(self)
      table.insert(self.frame.locals, self.regs[2])
    end,
    [Code.STORE_3] = function(self)
      table.insert(self.frame.locals, self.regs[3])
    end,
    [Code.STORE_4] = function(self)
      table.insert(self.frame.locals, self.regs[4])
    end,
    [Code.STORE_5] = function(self)
      table.insert(self.frame.locals, self.regs[5])
    end,
    [Code.STORE_6] = function(self)
      table.insert(self.frame.locals, self.regs[6])
    end,
    [Code.STORE_7] = function(self)
      table.insert(self.frame.locals, self.regs[7])
    end,
    [Code.STORE_8] = function(self)
      table.insert(self.frame.locals, self.regs[8])
    end,

    [Code.LOAD_1] = function(self)
      self.regs[1] = self.frame.locals[self:getint()]
    end,
    [Code.LOAD_2] = function(self)
      self.regs[2] = self.frame.locals[self:getint()]
    end,
    [Code.LOAD_3] = function(self)
      self.regs[3] = self.frame.locals[self:getint()]
    end,
    [Code.LOAD_4] = function(self)
      self.regs[4] = self.frame.locals[self:getint()]
    end,
    [Code.LOAD_5] = function(self)
      self.regs[5] = self.frame.locals[self:getint()]
    end,
    [Code.LOAD_6] = function(self)
      self.regs[6] = self.frame.locals[self:getint()]
    end,
    [Code.LOAD_7] = function(self)
      self.regs[7] = self.frame.locals[self:getint()]
    end,
    [Code.LOAD_8] = function(self)
      self.regs[8] = self.frame.locals[self:getint()]
    end,

    [Code.CALL] = function(self)
      local value = self:getint()
      local previousindex = self.index
      self.index = value
      table.insert(self.retlocals, previousindex)
    end,
    [Code.DYNAMIC_CALL] = function(self)
      local reg = self:consomeByte()

      local index = self.regs[reg]

      self:assert(type(index) == "number", "Non-number point given to call.")
      self:assert(index == math.floor(index), "Non-integer point given to call.")
      self:assert(index >= 1 and index <= #self.instructions, "Attempt to call a invalid point.")

      self.index = index
    end,
    [Code.RETURN] = function(self)
     
      self.index = self.retlocals[#self.retlocals] --or self.index + 1
      table.remove(self.retlocals, #self.retlocals)
    end,

    [Code.LOADSERVICE] = function(self)
      local serviceindex = self:getint()
      if not self.services[serviceindex] then
        self:error("Service "..serviceindex.." not found.")
      end

      self.service = self.services[serviceindex]
    end,
    [Code.INVOKESERVICE] = function(self)
      local subsservice = self.regs[1]
      local args = {self.regs[2], self.regs[3], self.regs[4], self.regs[5]}
      
      local status, err = self.service:invoke(subsservice, args, self.regs)

      if status == 1 then
        self:error(err)
      end
    end,
    [Code.EXIT] = function(self)
      local status = self.regs[1]

      --print('exitting', status)
      os.exit(status)
    end,
    [Code.JUMP_IF_EQ] = function(self)
      local index = self:getint()
      if self.flags.equality then
        self.index = index
      end
    end,
    [Code.JUMP_IF_LT] = function(self)
      local index = self:getint()
      if self.flags.less then
        self.index = index
      end
    end,
    [Code.JUMP_IF_GT] = function(self)
      local index = self:getint()
      if self.flags.greater then
        self.index = index
      end
    end,
    [Code.JUMP_IF_NEQ] = function(self)
      local index = self:getint()
      if not self.flags.equality then
        self.index = index
      end
    end,
    [Code.JUMP_IF_NLT] = function(self)
      local index = self:getint()
      if not self.flags.less then
        self.index = index
      end
    end,
    [Code.JUMP_IF_NGT] = function(self)
      local index = self:getint()
      if not self.flags.greater then
        self.index = index
      end
    end,
    [Code.JUMP] = function(self)
      self.index = self:getint()
    end,
    [Code.IGETPTR] = function(self)
      local mode = self.integersize
      local dest = self:consomeByte()
      local orig = self:consomeByte()

      local address = self.regs[orig]
      local adr = ffi.new("intptr_t", address)
      local ptr

      if mode == 4 then
        ptr = ffi.cast("int*", adr)
      else
        ptr = ffi.cast("long*", adr)
      end
      if not ptr then
        self:error("attempt to access null pointer.")
      end

      
      self.regs[dest] = ptr[0]
    end,
    [Code.FGETPTR] = function(self)
      local mode = self.floatsize
      local dest = self:consomeByte()
      local orig = self:consomeByte()

      local address = self.regs[orig]
      local adr = ffi.new("intptr_t", address)
      local ptr

      if mode == 4 then
        ptr = ffi.cast("float*", adr)
      else
        ptr = ffi.cast("double*", adr)
      end
      if not ptr then
        self:error("attempt to access null pointer.")
      end

      
      self.regs[dest] = ptr[0]
    end,
    [Code.SGETPTR] = function(self)
      local dest = self:consomeByte()
      local orig = self:consomeByte()
      local sizereg = self:consomeByte()
      
      
      local size = self.regs[sizereg]



      local adr = ffi.new("intptr_t", self.regs[orig])
      local ptr = ffi.cast("char*", adr)

      if not ptr then
        self:error("attempt to access null pointer.")
      end
      
      self.regs[dest] = ffi.string(ptr, size)
    end,
    [Code.ISETPTR] = function(self)
      local mode = self.integersize
      local dest = self:consomeByte()
      local orig = self:consomeByte()

      local value = self.regs[orig]
      self:assert(type(value) == "number" and math.floor(value) == value, "Expected integer")
      local adr = ffi.new("intptr_t", self.regs[dest])
      local ptr

      if mode == 4 then
        ptr = ffi.cast("int*", adr)
      else
        ptr = ffi.cast("long*", adr)
      end

      if not ptr then
        self:error("attempt to access null pointer.")
      end

      ptr[0] = value
    end,
    [Code.FSETPTR] = function(self)
      local mode = self.floatsize
      local dest = self:consomeByte()
      local orig = self:consomeByte()

      local value = self.regs[orig]
      local adr = ffi.new("intptr_t", self.regs[dest])
      local ptr

      if mode == 4 then
        ptr = ffi.cast("float*", adr)
      else
        ptr = ffi.cast("double*", adr)
      end

      if not ptr then
        self:error("attempt to access null pointer.")
      end
      ptr[0] = value
    end,
    [Code.SSETPTR] = function(self)
      local dest = self:consomeByte()
      local orig = self:consomeByte()
      local sizereg = self:consomeByte()

      local str = self.regs[orig]
      local size = self.regs[sizereg]

      if size == 0 then
        return
      end
      local adr = ffi.new("intptr_t", dest)
      local ptr = ffi.cast("char*", adr)

      if not ptr then
        self:error("attempt to access null pointer.")
      end

      for i = 1, size do
        ptr[i - 1] = str:byte(i, i)
      end

    end
  }

  return cases