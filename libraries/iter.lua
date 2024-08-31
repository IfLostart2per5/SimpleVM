-- Iterable's library of my "autoria". GitHub = IfLostart2per5


local module = {}
function module.listiter(list)
    local index = 1
    return function()
        local element = list[index]
        index = index + 1
        return element
    end
end
module.Iterable = {
    produce = function(self, f)
        return setmetatable({
            func = f,
            ops = {}
        }, {__index=self})
    end,
    map = function (self, f)
        table.insert(self.ops, {"map", f})
        return self
    end,
    filter = function(self, f)
        table.insert(self.ops, {"filter", f})
        return self
    end,
    reductioner =  function (self)
        local element = self.func()
        local lenops = #self.ops
        local function rdc()
            if element == nil then
                return
            end
            for i = 1, lenops do
                local op = self.ops[i]
                if op[1] == "map" then
                    element = op[2](element)
                elseif op[1] == "filter" then
                    local result = op[2](element)
                    if not result then
                        repeat
                            element = rdc()
                            result = op[2](element)
                        until result
                    end
                end
            end
            local oldelement = element
            element = self.func()
            return oldelement

        end
        return rdc
    end,
    collect_raw = function(self, sup, combiner, finalizer)
        local rdc = self:reductioner()
        local supplied = sup()
        local element = rdc()
        while element do
            combiner(supplied, element)
            element = rdc()
        end

        return finalizer(supplied)
    end,
    collect = function(self)
        local supplier = function() return {} end
        local combiner = table.insert
        local finalizer = function(sup) return sup end

        return self:collect_raw(supplier, combiner, finalizer)
    end,
    reduce = function(self, f, initial)
        local rdc = self:reductioner()
        local accumulator  = initial or rdc()
        local element = rdc()
        while element do
            accumulator = f(accumulator, element)
            element = rdc()
        end

        return accumulator
    end
}

return module