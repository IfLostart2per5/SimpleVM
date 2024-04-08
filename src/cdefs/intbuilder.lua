local ffi = require "ffi"

ffi.cdef[[
    typedef union {
        unsigned char bytes[4];
        int value;
    } intbuilder;

    typedef union {
        unsigned char bytes[8];
        long value;
    } longbuilder;
]]

