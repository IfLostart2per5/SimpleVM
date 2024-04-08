local ITERATIONS = 50
local sum1 = 0
for i = 1, ITERATIONS do
    local simplevm_start = os.clock()
    os.execute("luajit main.lua run bigsum.sc -isize 64")
    local simplevm_end = os.clock()
    sum1 = sum1 + (simplevm_end - simplevm_start)
end
print("\nsimplevm", sum1 / ITERATIONS)

local sum2 = 0
for i = 1, ITERATIONS do
    local lua_start = os.clock()
    os.execute("lua bigsum.luac")
    local lua_end = os.clock()

    sum2 = sum2 + (lua_end - lua_start)
end
print("\nlua:", sum2 / ITERATIONS)

local sum3 = 0
for i = 1, ITERATIONS do
    local py_start = os.clock()
    os.execute("pypy3 bigsum.pypy310.pyc")
    local py_end = os.clock()

    sum3 = sum3 + (py_end - py_start)
end
print("\npython (pypy): ", sum3 / ITERATIONS)