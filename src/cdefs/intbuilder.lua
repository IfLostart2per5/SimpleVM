local ffi = require "ffi"

ffi.cdef[[
    typedef union {
        unsigned char bytes[4];
        int32_t value;
    } intbuilder;

    typedef union {
        unsigned char bytes[8];
        int64_t value;
    } longbuilder;
]]

