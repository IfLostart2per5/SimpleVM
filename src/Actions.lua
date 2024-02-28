-- tabela de acoes pra formosa simplevm
local Code =  require "src.enums.Code"
local bit = require "bit"

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


    [Code.EQ] = function(self)
      local x = self:consomeByte()
      local y = self:consomeByte()
      
      self.regs[x] = (self.regs[x] == self.regs[y]) and 1 or 0
    end,
    [Code.IEQ_1] = function(self)
      self.regs[1] = (self.regs[1] == self:getint()) and 1 or 0
    end,
    [Code.IEQ_2] = function(self)
      self.regs[2] = (self.regs[2] == self:getint()) and 1 or 0
    end,
    [Code.IEQ_3] = function(self)
      self.regs[3] = (self.regs[3] == self:getint()) and 1 or 0
    end,
    [Code.IEQ_4] = function(self)
      self.regs[4] = (self.regs[4] == self:getint()) and 1 or 0
    end,
    [Code.IEQ_5] = function(self)
      self.regs[5] = (self.regs[5] == self:getint()) and 1 or 0
    end,
    [Code.IEQ_6] = function(self)
      self.regs[6] = (self.regs[6] == self:getint()) and 1 or 0
    end,
    [Code.IEQ_7] = function(self)
      self.regs[7] = (self.regs[7] == self:getint()) and 1 or 0
    end,
    [Code.IEQ_8] = function(self)
      self.regs[8] = (self.regs[8] == self:getint()) and 1 or 0
    end,
    [Code.FEQ_1] = function(self)
      self.regs[1] = (self.regs[1] == self:getfloat()) and 1 or 0
    end,
    [Code.FEQ_2] = function(self)
      self.regs[2] = (self.regs[2] == self:getfloat()) and 1 or 0
    end,
    [Code.FEQ_3] = function(self)
      self.regs[3] = (self.regs[3] == self:getfloat()) and 1 or 0
    end,
    [Code.FEQ_4] = function(self)
      self.regs[4] = (self.regs[4] == self:getfloat()) and 1 or 0
    end,
    [Code.FEQ_5] = function(self)
      self.regs[5] = (self.regs[5] == self:getfloat()) and 1 or 0
    end,
    [Code.FEQ_6] = function(self)
      self.regs[6] = (self.regs[6] == self:getfloat()) and 1 or 0
    end,
    [Code.FEQ_7] = function(self)
      self.regs[7] = (self.regs[7] == self:getfloat()) and 1 or 0
    end,
    [Code.FEQ_8] = function(self)
      self.regs[8] = (self.regs[8] == self:getfloat()) and 1 or 0
    end,

    [Code.SEQ_1] = function(self)
      self.regs[1] = (self.regs[1] == self:getstring()) and 1 or 0
    end,
    [Code.SEQ_2] = function(self)
      self.regs[2] = (self.regs[2] == self:getstring()) and 1 or 0
    end,
    [Code.SEQ_3] = function(self)
      self.regs[3] = (self.regs[3] == self:getstring()) and 1 or 0
    end,
    [Code.SEQ_4] = function(self)
      self.regs[4] = (self.regs[4] == self:getstring()) and 1 or 0
    end,
    [Code.SEQ_5] = function(self)
      self.regs[5] = (self.regs[5] == self:getstring()) and 1 or 0
    end,
    [Code.SEQ_6] = function(self)
      self.regs[6] = (self.regs[6] == self:getstring()) and 1 or 0
    end,
    [Code.SEQ_7] = function(self)
      self.regs[7] = (self.regs[7] == self:getstring()) and 1 or 0
    end,
    [Code.SEQ_8] = function(self)
      self.regs[8] = (self.regs[8] == self:getstring()) and 1 or 0
    end,
    [Code.NE] = function(self)
      local x = self:consomeByte()
      local y = self:consomeByte()
      
      self.regs[x] = (self.regs[x] ~= self.regs[y]) and 1 or 0
    end,
    [Code.INE_1] = function(self)
      self.regs[1] = (self.regs[1] ~= self:getint()) and 1 or 0
    end,
    [Code.INE_2] = function(self)
      self.regs[2] = (self.regs[2] ~= self:getint()) and 1 or 0
    end,
    [Code.INE_3] = function(self)
      self.regs[3] = (self.regs[3] ~= self:getint()) and 1 or 0
    end,
    [Code.INE_4] = function(self)
      self.regs[4] = (self.regs[4] ~= self:getint()) and 1 or 0
    end,
    [Code.INE_5] = function(self)
      self.regs[5] = (self.regs[5] ~= self:getint()) and 1 or 0
    end,
    [Code.INE_6] = function(self)
      self.regs[6] = (self.regs[6] ~= self:getint()) and 1 or 0
    end,
    [Code.INE_7] = function(self)
      self.regs[7] = (self.regs[7] ~= self:getint()) and 1 or 0
    end,
    [Code.INE_8] = function(self)
      self.regs[8] = (self.regs[8] ~= self:getint()) and 1 or 0
    end,

    [Code.FNE_1] = function(self)
      self.regs[1] = (self.regs[1] ~= self:getfloat()) and 1 or 0
    end,
    [Code.FNE_2] = function(self)
      self.regs[2] = (self.regs[2] ~= self:getfloat()) and 1 or 0
    end,
    [Code.FNE_3] = function(self)
      self.regs[3] = (self.regs[3] ~= self:getfloat()) and 1 or 0
    end,
    [Code.FNE_4] = function(self)
      self.regs[4] = (self.regs[4] ~= self:getfloat()) and 1 or 0
    end,
    [Code.FNE_5] = function(self)
      self.regs[5] = (self.regs[5] ~= self:getfloat()) and 1 or 0
    end,
    [Code.FNE_6] = function(self)
      self.regs[6] = (self.regs[6] ~= self:getfloat()) and 1 or 0
    end,
    [Code.FNE_7] = function(self)
      self.regs[7] = (self.regs[7] ~= self:getfloat()) and 1 or 0
    end,
    [Code.FNE_8] = function(self)
      self.regs[8] = (self.regs[8] ~= self:getfloat()) and 1 or 0
    end,

    [Code.SNE_1] = function(self)
      self.regs[1] = (self.regs[1] ~= self:getstring()) and 1 or 0
    end,
    [Code.SNE_2] = function(self)
      self.regs[2] = (self.regs[2] ~= self:getstring()) and 1 or 0
    end,
    [Code.SNE_3] = function(self)
      self.regs[3] = (self.regs[3] ~= self:getstring()) and 1 or 0
    end,
    [Code.SNE_4] = function(self)
      self.regs[4] = (self.regs[4] ~= self:getstring()) and 1 or 0
    end,
    [Code.SNE_5] = function(self)
      self.regs[5] = (self.regs[5] ~= self:getstring()) and 1 or 0
    end,
    [Code.SNE_6] = function(self)
      self.regs[6] = (self.regs[6] ~= self:getstring()) and 1 or 0
    end,
    [Code.SNE_7] = function(self)
      self.regs[7] = (self.regs[7] ~= self:getstring()) and 1 or 0
    end,
    [Code.SNE_8] = function(self)
      self.regs[8] = (self.regs[8] ~= self:getstring()) and 1 or 0
    end,

    [Code.GT] = function(self)
      local x = self:consomeByte()
      local y = self:consomeByte()
      
      self.regs[x] = (self.regs[x] > self.regs[y]) and 1 or 0
    end,
    [Code.IGT_1] = function(self)
      self.regs[1] = (self.regs[1] > self:getint()) and 1 or 0
    end,
    [Code.IGT_2] = function(self)
      self.regs[2] = (self.regs[2] > self:getint()) and 1 or 0
    end,
    [Code.IGT_3] = function(self)
      self.regs[3] = (self.regs[3] > self:getint()) and 1 or 0
    end,
    [Code.IGT_4] = function(self)
      self.regs[4] = (self.regs[4] > self:getint()) and 1 or 0
    end,
    [Code.IGT_5] = function(self)
      self.regs[5] = (self.regs[5] > self:getint()) and 1 or 0
    end,
    [Code.IGT_6] = function(self)
      self.regs[6] = (self.regs[6] > self:getint()) and 1 or 0
    end,
    [Code.IGT_7] = function(self)
      self.regs[7] = (self.regs[7] > self:getint()) and 1 or 0
    end,
    [Code.IGT_8] = function(self)
      self.regs[8] = (self.regs[8] > self:getint()) and 1 or 0
    end,

    [Code.FGT_1] = function(self)
      self.regs[1] = (self.regs[1] > self:getfloat()) and 1 or 0
    end,
    [Code.FGT_2] = function(self)
      self.regs[2] = (self.regs[2] > self:getfloat()) and 1 or 0
    end,
    [Code.FGT_3] = function(self)
      self.regs[3] = (self.regs[3] > self:getfloat()) and 1 or 0
    end,
    [Code.FGT_4] = function(self)
      self.regs[4] = (self.regs[4] > self:getfloat()) and 1 or 0
    end,
    [Code.FGT_5] = function(self)
      self.regs[5] = (self.regs[5] > self:getfloat()) and 1 or 0
    end,
    [Code.FGT_6] = function(self)
      self.regs[6] = (self.regs[6] > self:getfloat()) and 1 or 0
    end,
    [Code.FGT_7] = function(self)
      self.regs[7] = (self.regs[7] > self:getfloat()) and 1 or 0
    end,
    [Code.FGT_8] = function(self)
      self.regs[8] = (self.regs[8] > self:getfloat()) and 1 or 0
    end,

    [Code.LT] = function(self)
      local x = self:consomeByte()
      local y = self:consomeByte()
      
      self.regs[x] = (self.regs[x] < self.regs[y]) and 1 or 0
    end,
    [Code.ILT_1] = function(self)
      self.regs[1] = (self.regs[1] < self:getint()) and 1 or 0
    end,
    [Code.ILT_2] = function(self)
      self.regs[2] = (self.regs[2] < self:getint()) and 1 or 0
    end,
    [Code.ILT_3] = function(self)
      self.regs[3] = (self.regs[3] < self:getint()) and 1 or 0
    end,
    [Code.ILT_4] = function(self)
      self.regs[4] = (self.regs[4] < self:getint()) and 1 or 0
    end,
    [Code.ILT_5] = function(self)
      self.regs[5] = (self.regs[5] < self:getint()) and 1 or 0
    end,
    [Code.ILT_6] = function(self)
      self.regs[6] = (self.regs[6] < self:getint()) and 1 or 0
    end,
    [Code.ILT_7] = function(self)
      self.regs[7] = (self.regs[7] < self:getint()) and 1 or 0
    end,
    [Code.ILT_8] = function(self)
      self.regs[8] = (self.regs[8] < self:getint()) and 1 or 0
    end,

    [Code.FLT_1] = function(self)
      self.regs[1] = (self.regs[1] < self:getfloat()) and 1 or 0
    end,
    [Code.FLT_2] = function(self)
      self.regs[2] = (self.regs[2] < self:getfloat()) and 1 or 0
    end,
    [Code.FLT_3] = function(self)
      self.regs[3] = (self.regs[3] < self:getfloat()) and 1 or 0
    end,
    [Code.FLT_4] = function(self)
      self.regs[4] = (self.regs[4] < self:getfloat()) and 1 or 0
    end,
    [Code.FLT_5] = function(self)
      self.regs[5] = (self.regs[5] < self:getfloat()) and 1 or 0
    end,
    [Code.FLT_6] = function(self)
      self.regs[6] = (self.regs[6] < self:getfloat()) and 1 or 0
    end,
    [Code.FLT_7] = function(self)
      self.regs[7] = (self.regs[7] < self:getfloat()) and 1 or 0
    end,
    [Code.FLT_8] = function(self)
      self.regs[8] = (self.regs[8] < self:getfloat()) and 1 or 0
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
    [Code.LOADNAN] = function(self)
      local reg = self:consomeByte()
      self.regs[reg] = 0 / 0
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
        self:error("Service not found.")
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
      local status = self.refs[8]

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
    end
  }

  return cases