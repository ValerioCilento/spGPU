#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xgpio.h"
#include "ps7_init.h"
#include <xil_io.h>
#include <stdint.h>
#include "xil_cache.h"
#include "sleep.h"
#include "sp_lib.h"
#include <stdlib.h>
#include "xtime_l.h"
#include "xscugic.h"
#include "xil_exception.h"

#define SCREEN_WIDTH   320
#define SCREEN_HEIGHT  240
#define NUM_BALLS      10
#define TARGET_FPS     60
#define FRAME_TIME_US  (1000000 / TARGET_FPS)
#define INTC_DEVICE_ID    XPAR_SCUGIC_0_DEVICE_ID
#define CORE0NIRQ_INT_ID  61

static XScuGic InterruptController;

static volatile int g_interrupt_occurred = 0;
static volatile u32 g_gpio_val = 0;

typedef struct {
    float x; float y; float vx; float vy; float mass; int radius; unsigned int col;
} Ball;

//Interrupt Handler
void Core0nIRQ_Handler(void *CallbackRef) {
    XGpio *GpioInstancePtr = (XGpio *)CallbackRef;
    g_gpio_val = XGpio_DiscreteRead(GpioInstancePtr, 1);
    g_interrupt_occurred = 1;
}
//Interrupt Inizialization
int SetupInterruptSystem(XScuGic *IntcInstancePtr, XGpio *GpioInstancePtr) {
    int status;
    XScuGic_Config *IntcConfig;

    IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
    if (NULL == IntcConfig) {
        return XST_FAILURE;
    }

    status = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig, IntcConfig->CpuBaseAddress);
    if (status != XST_SUCCESS) {
        return XST_FAILURE;
    }
    XScuGic_SetPriorityTriggerType(IntcInstancePtr, CORE0NIRQ_INT_ID, 0xA0, 0x03);
    status = XScuGic_Connect(IntcInstancePtr, CORE0NIRQ_INT_ID, (Xil_ExceptionHandler)Core0nIRQ_Handler, (void *)GpioInstancePtr);
    if (status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    XScuGic_Enable(IntcInstancePtr, CORE0NIRQ_INT_ID);
    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, IntcInstancePtr);
    Xil_ExceptionEnable();

    return XST_SUCCESS;
}

float my_sqrtf(float number) {
    if (number <= 0.0f) return 0.0f;
    float guess = number;
    for (int i = 0; i < 10; i++) guess = 0.5f * (guess + number / guess);
    return guess;
}

void ResolveCollision(Ball *a, Ball *b) {
    float dx = b->x - a->x; float dy = b->y - a->y;
    float dist_sq = dx * dx + dy * dy;
    float radius_sum = a->radius + b->radius;
    if (dist_sq <= radius_sum * radius_sum && dist_sq > 0.0001f) {
        float dist = my_sqrtf(dist_sq);
        float nx = dx / dist; float ny = dy / dist;
        float overlap = 0.5f * (radius_sum - dist);
        a->x -= overlap * nx; a->y -= overlap * ny;
        b->x += overlap * nx; b->y += overlap * ny;
        float rvx = b->vx - a->vx; float rvy = b->vy - a->vy;
        float vel_along_normal = rvx * nx + rvy * ny;
        if (vel_along_normal > 0) return;
        float j = -(2.0f) * vel_along_normal / (1.0f/a->mass + 1.0f/b->mass);
        a->vx -= (j / a->mass) * nx; a->vy -= (j / a->mass) * ny;
        b->vx += (j / b->mass) * nx; b->vy += (j / b->mass) * ny;
    }
}

int main() {
    init_platform();
    ps7_post_config();
    Xil_DCacheDisable();
    InitDMA();

    //GPIO Inizialization
    XGpio *fps = malloc(sizeof(XGpio));
    if (fps == NULL || XGpio_Initialize(fps, XPAR_AXI_GPIO_0_DEVICE_ID) != XST_SUCCESS) {
        xil_printf("Inizializzazione GPIO fallita\r\n");
    }
    XGpio_SetDataDirection(fps, 1, 0xFFFF);

    //Interrupt Inizialization
    if (SetupInterruptSystem(&InterruptController, fps) != XST_SUCCESS) {
        xil_printf("Inizializzazione Sistema Interrupt Fallita!\r\n");
    } else {
        xil_printf("Sistema Interrupt Inizializzato con Successo.\r\n");
    }

    Ball balls[NUM_BALLS];
    XTime tStart, tEnd;
    uint64_t elapsed_us;

    srand(666);

    for (int i = 0; i < NUM_BALLS; i++) {
        balls[i].x = (rand() % 200) + 50;
        balls[i].y = (rand() % 150) + 50;
        balls[i].vx = ((rand() % 40) - 20) / 10.0f;
        balls[i].vy = ((rand() % 40) - 20) / 10.0f;
        balls[i].radius = (rand() % 8) + 5;
        balls[i].mass = (float)balls[i].radius;
        balls[i].col = (rand() % 0x7FFF);
    }

    while (1) {
        XTime_GetTime(&tStart);

        if (g_interrupt_occurred) {
            g_interrupt_occurred = 0;
            xil_printf("FPS: %u\r\n", g_gpio_val);
        }

        for (int i = 0; i < NUM_BALLS; i++) {
            balls[i].x += balls[i].vx; balls[i].y += balls[i].vy;
            if (balls[i].x - balls[i].radius < 0 || balls[i].x + balls[i].radius > SCREEN_WIDTH-1) balls[i].vx = -balls[i].vx;
            if (balls[i].y - balls[i].radius < 0 || balls[i].y + balls[i].radius > SCREEN_HEIGHT-1) balls[i].vy = -balls[i].vy;
        }
        for (int i = 0; i < NUM_BALLS; i++) {
            for (int j = i + 1; j < NUM_BALLS; j++) ResolveCollision(&balls[i], &balls[j]);
        }

        for (int i = 0; i < NUM_BALLS; i++) {
            DrawCircleF((uint64_t)balls[i].x, (uint64_t)balls[i].y, (uint64_t)balls[i].radius, balls[i].col, 0);
        }

        SwapBuffers();

        XTime_GetTime(&tEnd);
        elapsed_us = (uint64_t)((tEnd - tStart) * 1000000ULL / COUNTS_PER_SECOND);
        if (elapsed_us < FRAME_TIME_US) {
            usleep(FRAME_TIME_US - elapsed_us);
        }
    }

    free(fps);
    return 0;
}
