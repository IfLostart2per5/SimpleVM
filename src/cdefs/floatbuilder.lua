local ffi = require "ffi"

ffi.cdef[[
    typedef union {
        unsigned char bytes[4];
        float value;
    } floatbuilder;

    typedef union {
        unsigned char bytes[8];
        double value;
    } doublebuilder;
]]