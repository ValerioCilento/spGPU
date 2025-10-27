#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "ps7_init.h"
#include <xil_io.h>
#include <stdint.h>
#include "xil_cache.h"
#include "sleep.h"

void StartDMATransfer( unsigned int *src, unsigned int len_bytes )
{
	// Indirizzo sorgente
	Xil_Out32( XPAR_AXIDMA_0_BASEADDR + 0x18, src);
	xil_printf("Sent: %p\n", src);
	// Scrittura della lunghezza della transazione ed effettivo inizio della stessa!!
	Xil_Out32( XPAR_AXIDMA_0_BASEADDR + 0x28, len_bytes );
	while (!(Xil_In32( XPAR_AXIDMA_0_BASEADDR + 0x04 ) & 0x1000)) {}
	xil_printf("Transfer completed\n");
}




void InitDMA( void )
{
	unsigned int tmpVal;

	tmpVal = Xil_In32( XPAR_AXIDMA_0_BASEADDR + 0x0 );
	tmpVal = tmpVal | 0x1001;
	Xil_Out32( XPAR_AXIDMA_0_BASEADDR + 0x0, tmpVal );

}
int main()
{
    init_platform();
    ps7_post_config();
    Xil_DCacheDisable();

    unsigned long long int setcolor;
    unsigned long long int instr[3];
    unsigned long long int swap;
    xil_printf("Running...\n\r");

    InitDMA();


    instr[0] = 0xA190645; //Circle
	instr[1] = 0xA01E05028050144;
	instr[2] = 0x25896004012;
	swap = 0x3E8;

	while(1){
	setcolor = 0xFF00007;
    StartDMATransfer(&setcolor, 1*sizeof(unsigned long long int));
    StartDMATransfer(&instr[0], 1*sizeof(unsigned long long int));
    setcolor = 0x0000FF7;
    StartDMATransfer(&setcolor, 1*sizeof(unsigned long long int));
    StartDMATransfer(&instr[1], 1*sizeof(unsigned long long int));
    setcolor = 0xFF00FF7;
    StartDMATransfer(&setcolor, 1*sizeof(unsigned long long int));
    StartDMATransfer(&instr[2], 1*sizeof(unsigned long long int));

    StartDMATransfer(&swap, 1*sizeof(unsigned long long int));
	}
}
