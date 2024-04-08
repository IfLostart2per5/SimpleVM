#include <stdio.h>

typedef union intbuilder_t
{
    unsigned char bytes[8];
    long value;
} intbuilder;

int main() {
    intbuilder b;
    b.value = (long) 2;
    printf("%hhu %hhu %hhu %hhu %hhu %hhu %hhu %hhu\n", b.bytes[0], b.bytes[1], b.bytes[2], b.bytes[3], b.bytes[4], b.bytes[5], b.bytes[6], b.bytes[7]);
    printf("%d\n", __BYTE_ORDER__);
    return 0;
}
