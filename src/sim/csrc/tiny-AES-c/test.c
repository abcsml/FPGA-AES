#include "aes.h"

void display(uint8_t* c) {
    printf("ans:");
    for (int i = 0; i < 16; i++) {
        printf("%x", (uint8_t)(c[i]));
    }
    printf("\n");
}

int main(int argc, char const *argv[]) {
    uint8_t text[16] = {0x6b, 0xc1, 0xbe, 0xe2,
                        0x2e, 0x40, 0x9f, 0x96,
                        0xe9, 0x3d, 0x7e, 0x11,
                        0x73, 0x93, 0x17, 0x2a};
    uint8_t key[16] = {0x2b, 0x7e, 0x15, 0x16,
                       0x28, 0xae, 0xd2, 0xa6,
                       0xab, 0xf7, 0x15, 0x88,
                       0x09, 0xcf, 0x4f, 0x3c};
    struct AES_ctx ctx;
    AES_init_ctx(&ctx, key);
    AES_ECB_encrypt(&ctx, text);
    // display(text);
    // for (int i = 0; i < 13; i++)
    // {
    //     display(ctx.RoundKey+16*i);
    // }
    
    return 0;
}

