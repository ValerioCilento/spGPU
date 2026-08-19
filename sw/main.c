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
#define VSYNC_INT_ID      62

static XScuGic InterruptController;

static volatile int g_fps_ready = 0;
static volatile u32 g_fps_val = 0;
static volatile int g_vsync_occurred = 0;

typedef struct {
    float x; float y; float vx; float vy; float mass; int radius; unsigned int col;
} Ball;

void Core0nIRQ_Handler(void *CallbackRef) {
    XGpio *GpioInstancePtr = (XGpio *)CallbackRef;
    g_fps_val = XGpio_DiscreteRead(GpioInstancePtr, 1);
    g_fps_ready = 1;
}

void VSync_Handler(void *CallbackRef) {
    (void)CallbackRef;
    g_vsync_occurred = 1;
}

void WaitForVsync(void) {
    while (!g_vsync_occurred) {
        // Attende che scatti l'interrupt hardware VSYNC
    }
    g_vsync_occurred = 0;
}

int SetupInterruptSystem(XScuGic *IntcInstancePtr, XGpio *GpioInstancePtr) {
    int status;
    XScuGic_Config *IntcConfig;

    IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
    if (NULL == IntcConfig) return XST_FAILURE;

    status = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig, IntcConfig->CpuBaseAddress);
    if (status != XST_SUCCESS) return XST_FAILURE;

    // Configurazione Interrupt 61 (FPS 1 sec) - Trigger Edge (0x03)
    XScuGic_SetPriorityTriggerType(IntcInstancePtr, CORE0NIRQ_INT_ID, 0xA0, 0x03);
    status = XScuGic_Connect(IntcInstancePtr, CORE0NIRQ_INT_ID,
                             (Xil_ExceptionHandler)Core0nIRQ_Handler,
                             (void *)GpioInstancePtr);
    if (status != XST_SUCCESS) return XST_FAILURE;
    XScuGic_Enable(IntcInstancePtr, CORE0NIRQ_INT_ID);

    // Configurazione Interrupt 62 (VSYNC 60 Hz) - Trigger Edge (0x03)
    XScuGic_SetPriorityTriggerType(IntcInstancePtr, VSYNC_INT_ID, 0x90, 0x03);
    status = XScuGic_Connect(IntcInstancePtr, VSYNC_INT_ID,
                             (Xil_ExceptionHandler)VSync_Handler,
                             NULL);
    if (status != XST_SUCCESS) return XST_FAILURE;
    XScuGic_Enable(IntcInstancePtr, VSYNC_INT_ID);

    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
                                 (Xil_ExceptionHandler)XScuGic_InterruptHandler,
                                 IntcInstancePtr);
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

    XGpio *fps = malloc(sizeof(XGpio));

    if (fps == NULL || XGpio_Initialize(fps, XPAR_AXI_GPIO_0_DEVICE_ID) != XST_SUCCESS) {
        xil_printf("Inizializzazione GPIO fallita\r\n");
    }
    XGpio_SetDataDirection(fps, 1, 0xFFFF);

    if (SetupInterruptSystem(&InterruptController, fps) != XST_SUCCESS) {
        xil_printf("Inizializzazione Sistema Interrupt Fallita!\r\n");
    } else {
        xil_printf("Sistema Interrupt Inizializzato con Successo (ID 61: FPS, ID 62: VSYNC).\r\n");
    }

    Ball balls[NUM_BALLS];
    int frame_count = 0;

    srand(666);

    // Inizializzazione sicura con posizionamento e margini rispetto ai bordi
    for (int i = 0; i < NUM_BALLS; i++) {
        balls[i].radius = (rand() % 8) + 5;
        balls[i].x = (rand() % (SCREEN_WIDTH - 2 * balls[i].radius - 20)) + balls[i].radius + 10;
        balls[i].y = (rand() % (SCREEN_HEIGHT - 2 * balls[i].radius - 20)) + balls[i].radius + 10;
        balls[i].vx = ((rand() % 40) - 20) / 10.0f;
        balls[i].vy = ((rand() % 40) - 20) / 10.0f;
        balls[i].mass = (float)balls[i].radius;
        balls[i].col = (rand() % 0x7FFF);
    }

    // Disegna il primo frame di partenza
    for (int i = 0; i < NUM_BALLS; i++) {
        DrawCircleF((uint64_t)balls[i].x, (uint64_t)balls[i].y, (uint64_t)balls[i].radius, balls[i].col, 0);
    }
    SwapBuffers();

    while (1) {
        // 1. Sincronizzazione con il VSYNC hardware della GPU (Interrupt ID 62)
        WaitForVsync();
        frame_count++;

        // 2. Stampa FPS quando scatta l'interrupt di 1 secondo (Interrupt ID 61)
        if (g_fps_ready) {
            g_fps_ready = 0;
            xil_printf("FPS (HW): %u | Frames (VSYNC): %d\r\n", g_fps_val, frame_count);
            frame_count = 0;
        }

        // 3. Aggiornamento delle posizioni tramite velocità
        for (int i = 0; i < NUM_BALLS; i++) {
            balls[i].x += balls[i].vx;
            balls[i].y += balls[i].vy;
        }

        // 4. Risoluzione delle collisioni tra palline
        for (int i = 0; i < NUM_BALLS; i++) {
            for (int j = i + 1; j < NUM_BALLS; j++) {
                ResolveCollision(&balls[i], &balls[j]);
            }
        }

        // 5. Risoluzione dei bordi dello schermo (con CLAMP)
        for (int i = 0; i < NUM_BALLS; i++) {
            // Asse X - Bordo Sinistro
            if (balls[i].x - balls[i].radius < 0) {
                balls[i].x = balls[i].radius;
                if (balls[i].vx < 0) balls[i].vx = -balls[i].vx;
            }
            // Asse X - Bordo Destro
            else if (balls[i].x + balls[i].radius >= SCREEN_WIDTH) {
                balls[i].x = SCREEN_WIDTH - 1 - balls[i].radius;
                if (balls[i].vx > 0) balls[i].vx = -balls[i].vx;
            }

            // Asse Y - Bordo Superiore
            if (balls[i].y - balls[i].radius < 0) {
                balls[i].y = balls[i].radius;
                if (balls[i].vy < 0) balls[i].vy = -balls[i].vy;
            }
            // Asse Y - Bordo Inferiore
            else if (balls[i].y + balls[i].radius >= SCREEN_HEIGHT) {
                balls[i].y = SCREEN_HEIGHT - 1 - balls[i].radius;
                if (balls[i].vy > 0) balls[i].vy = -balls[i].vy;
            }
        }

        // 6. Rendering
        for (int i = 0; i < NUM_BALLS; i++) {
            DrawCircleF((uint64_t)balls[i].x, (uint64_t)balls[i].y, (uint64_t)balls[i].radius, balls[i].col, 0);
        }

        // 7. Invio comando di swap alla GPU
        SwapBuffers();
    }

    free(fps);
    return 0;
}
