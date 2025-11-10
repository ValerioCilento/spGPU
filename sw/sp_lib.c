#include "sp_lib.h"
#include <stdio.h>
#include "xparameters.h"
#include <xil_io.h>
// This function initialize the DMA
void InitDMA( void )
{
	unsigned int tmpVal;
	tmpVal = Xil_In32( XPAR_AXIDMA_0_BASEADDR + 0x0 );
	tmpVal = tmpVal | 0x1001;
	Xil_Out32( XPAR_AXIDMA_0_BASEADDR + 0x0, tmpVal );
}
// This function uses the DMA to send the instructions. 
//In particular, src contains the address of the source and len_bytes the number of bytes to be send 
void StartDMATransfer( unsigned int *src, unsigned int len_bytes )
{
	Xil_Out32( XPAR_AXIDMA_0_BASEADDR + 0x18, src);
	//xil_printf("Sent: %p\n", src);
	Xil_Out32( XPAR_AXIDMA_0_BASEADDR + 0x28, len_bytes );
	while (!(Xil_In32( XPAR_AXIDMA_0_BASEADDR + 0x04 ) & 0x1000)) {}
	//xil_printf("Transfer completed\n");
}


int SetColor(unsigned int color)
{
	SetColor_t instr = {0};
	if(color > 16777215){
		printf("Color not exists\n");
		return 1;
	}
	instr.opcode = 7;
	instr.color = color;
	printf("SETCOLOR: %llu\n", instr.instr);
	StartDMATransfer(&instr, sizeof(SetColor_t));
	return 0;
}
// The function takes the coordinates of 2 Points and a color and send to the GPU two different instrunctions: 
// SetColor and DrawLine
int DrawLine(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2, unsigned int color, unsigned char z)
{
	DrawLine_t instr = {0};
	if(x1 >= VIDEO_X || x2 >= VIDEO_X){
		printf("X coordinates exceed screen dimension\n");
		return 1; 
	}
	if(y1 >= VIDEO_Y || y2 >= VIDEO_Y){
		printf("Y coordinates exceed screen dimension\n");
		return 1; 
	}
	instr.opcode = 2; // 0b0010
	instr.x1 = x1;
	instr.y1 = y1;
	instr.x2 = x2;
	instr.y2 = y2;
	instr.z = z;
	if (SetColor(color)){
		printf("Error in SetColor Instrunction\n");
		return 1;
	}
	StartDMATransfer(&instr, sizeof(DrawLine_t));
	printf("DRAWLINE: %llu\n", instr.instr);
	return 0;

}
int DrawCircle(unsigned char xc, unsigned char yc, unsigned char r, unsigned int color, unsigned char z)
{
	DrawCircle_t instr = {0};

	if(xc >= VIDEO_X){
		printf("X coordinates exceed screen dimension\n");
		return 1; 
	}
	if(yc >= VIDEO_Y){
		printf("Y coordinates exceed screen dimension\n");
		return 1; 
	}
	instr.opcode = 5; // 0b0101
	instr.xc = xc;
	instr.yc = yc;
	instr.r = r;
	instr.z = z;
	if (SetColor(color)){
		printf("Error in SetColor Instrunction\n");
		return 1;
	}
	StartDMATransfer(&instr, sizeof(DrawCircle_t));
	printf("DRAWCIRCLE: %llu\n", instr.instr);
	return 0;
}

int DrawCircleF(unsigned char xc, unsigned char yc, unsigned char r, unsigned int color, unsigned char z)
{
	DrawCircle_t instr = {0};

	if(xc >= VIDEO_X){
		printf("X coordinates exceed screen dimension\n");
		return 1; 
	}
	if(yc >= VIDEO_Y){
		printf("Y coordinates exceed screen dimension\n");
		return 1; 
	}
	instr.opcode = 6; // 0b0110
	instr.xc = xc;
	instr.yc = yc;
	instr.r = r;
	instr.z = z;
	if (SetColor(color)){
		printf("Error in SetColor Instrunction\n");
		return 1;
	}
	StartDMATransfer(&instr, sizeof(DrawCircle_t));
	printf("DRAWCIRCLEF: %llu\n", instr.instr);
	return 0;
}

int DrawTriangle(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2, unsigned char x3, unsigned char y3, unsigned int color, unsigned char z)
{

	DrawTriangle_t instr = {0};
	if(x1 >= VIDEO_X || x2 >= VIDEO_X || x3 >= VIDEO_X  ){
		printf("X coordinates exceed screen dimension\n");
		return 1; 
	}
	if(y1 >= VIDEO_Y || y2 >= VIDEO_Y || y3 >= VIDEO_Y){
		printf("Y coordinates exceed screen dimension\n");
		return 1; 
	}
	instr.opcode = 3; // 0b0011
	instr.x1 = x1;
	instr.y1 = y1;
	instr.x2 = x2;
	instr.y2 = y2;
	instr.x3 = x3;
	instr.y3 = y3;
	instr.z = z;
	if (SetColor(color)){
		printf("Error in SetColor Instrunction\n");
		return 1;
	}
	StartDMATransfer(&instr, sizeof(DrawTriangle_t));
	printf("DRAWTRIANGLE: %llu\n", instr.instr);
	return 0;
}

int DrawTriangleF(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2, unsigned char x3, unsigned char y3, unsigned int color, unsigned char z)
{

	DrawTriangle_t instr = {0};
	if(x1 >= VIDEO_X || x2 >= VIDEO_X || x3 >= VIDEO_X  ){
		printf("X coordinates exceed screen dimension\n");
		return 1; 
	}
	if(y1 >= VIDEO_Y || y2 >= VIDEO_Y || y3 >= VIDEO_Y){
		printf("Y coordinates exceed screen dimension\n");
		return 1; 
	}
	instr.opcode = 3; // 0b0011
	instr.x1 = x1;
	instr.y1 = y1;
	instr.x2 = x2;
	instr.y2 = y2;
	instr.x3 = x3;
	instr.y3 = y3;
	instr.z = z;
	if (SetColor(color)){
		printf("Error in SetColor Instrunction\n");
		return 1;
	}
	StartDMATransfer(&instr, sizeof(DrawTriangle_t));
	printf("DRAWTRIANGLE: %llu\n", instr.instr);
	return 0;
}

void SwapBuffers(void)
{
	unsigned long long int instr;
	instr = 8; //1000
	StartDMATransfer(&instr, sizeof(unsigned long long));
}
