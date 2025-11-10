#define VIDEO_X 256
#define VIDEO_Y 192

typedef struct{
	unsigned char x;
	unsigned char y;
}Point_t;

typedef union
{	
	struct{
		unsigned char opcode;
		unsigned int color:24;
		unsigned int padding;
	};
	unsigned long long instr;
}SetColor_t;

typedef union
{	
	struct{
        unsigned char opcode: 4;
        unsigned char z : 4;
        unsigned char x1;
        unsigned char y1;
        unsigned char x2;
        unsigned char y2;
        //unsigned int padding: 20;
	};
	unsigned long long instr;
}DrawLine_t;

typedef union
{	
	struct{
        unsigned char opcode : 4;
        unsigned char z : 4;
        unsigned char xc;
        unsigned char yc;
        unsigned char r;
        //unsigned int padding;
	};
	unsigned long long instr;
}DrawCircle_t;


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
int DrawLine(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2, unsigned int color, unsigned char z);
int DrawCircle(unsigned char xc, unsigned char yc, unsigned char r, unsigned int color, unsigned char z);
int DrawCircleF(unsigned char xc, unsigned char yc, unsigned char r, unsigned int color, unsigned char z);
int DrawTriangle(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2, unsigned char x3, unsigned char y3, unsigned int color, unsigned char z);
int DrawTriangleF(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2, unsigned char x3, unsigned char y3, unsigned int color, unsigned char z);
void SwapBuffers(void);
void InitDMA( void );
void StartDMATransfer( unsigned int *src, unsigned int len_bytes );
