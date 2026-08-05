#define VIDEO_X 320
#define VIDEO_Y 240
#include <stdint.h>
typedef struct{
	short x:9;
	short y:9;
}Point_t;

typedef union
{	
	struct{
		unsigned char opcode;
		unsigned int color:15;
		unsigned int padding;
	};
	unsigned long long instr;
}SetColor_t;

typedef union
{
    // Forza il compilatore a non inserire byte di allineamento nascosti
    struct __attribute__((packed)) {
        uint64_t opcode  : 4;  // 4 bit  (Bit 0-3)
        uint64_t z       : 4;  // 4 bit  (Bit 4-7)
        uint64_t x1      : 9;  // 9 bit  (Bit 8-16)
        uint64_t y1      : 9;  // 9 bit  (Bit 17-25)
        uint64_t padding : 38; // 20 bit (Bit 44-63) - Riempitivo
    };
    uint64_t instr; // L'istruzione finale da 64 bit
} DrawPixel_t;

typedef union
{	
    // Forza il compilatore a non inserire byte di allineamento nascosti
    struct __attribute__((packed)) {
        uint64_t opcode  : 4;  // 4 bit  (Bit 0-3)
        uint64_t z       : 4;  // 4 bit  (Bit 4-7)
        uint64_t x1      : 9;  // 9 bit  (Bit 8-16)
        uint64_t y1      : 9;  // 9 bit  (Bit 17-25)
        uint64_t x2      : 9;  // 9 bit  (Bit 26-34)
        uint64_t y2      : 9;  // 9 bit  (Bit 35-43)
        uint64_t padding : 20; // 20 bit (Bit 44-63) - Riempitivo
    };
    uint64_t instr; // L'istruzione finale da 64 bit
} DrawLine_t;

typedef union
{	
    // Forza il compilatore a non inserire byte di allineamento nascosti
    struct __attribute__((packed)) {
        uint64_t opcode  : 4;  // 4 bit  (Bit 0-3)
        uint64_t z       : 4;  // 4 bit  (Bit 4-7)
        uint64_t xc      : 9;  // 9 bit  (Bit 8-16)
        uint64_t yc      : 9;  // 9 bit  (Bit 17-25)
        uint64_t r       : 9;  // 9 bit  (Bit 26-34)
        uint64_t padding : 29; // 20 bit (Bit 44-63) - Riempitivo
    };
    uint64_t instr; // L'istruzione finale da 64 bit
} DrawCircle_t;



typedef union
{	
	struct{
        unsigned char opcode : 4;
        unsigned char z : 4;
        unsigned char x1;
        unsigned char y1;
        unsigned char x2;
        unsigned char y2;
        unsigned char x3;
        unsigned char y3;
        // unsigned char padding;
	};
	unsigned long long instr;
}DrawTriangle_t;




int SetColor(unsigned int color);
int DrawLine(uint64_t x1, uint64_t y1, uint64_t x2,uint64_t y2, unsigned int color, unsigned char z);
int DrawCircle(uint64_t xc, uint64_t yc, uint64_t r, unsigned int color, unsigned char z);
int DrawCircleF(uint64_t xc, uint64_t yc, uint64_t r, unsigned int color, unsigned char z);
int DrawTriangle(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2, unsigned char x3, unsigned char y3, unsigned int color, unsigned char z);
int DrawTriangleF(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2, unsigned char x3, unsigned char y3, unsigned int color, unsigned char z);
void SwapBuffers(void);
void InitDMA( void );
void StartDMATransfer( unsigned int *src, unsigned int len_bytes );
int DrawPixel(uint64_t x1, uint64_t y1, unsigned int color);
