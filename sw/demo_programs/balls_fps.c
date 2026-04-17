#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "ps7_init.h"
#include <xil_io.h>
#include <stdint.h>
#include "xil_cache.h"
#include "sleep.h"
#include "sp_lib.h"
#include <stdlib.h>
// #include <time.h>  <-- Rimossa per evitare errori col linker bare-metal

#include "xgpio.h"

#define SCREEN_WIDTH  320
#define SCREEN_HEIGHT 240
#define NUM_BALLS     2
#define GPIO_FPS_DEVICE_ID XPAR_AXI_GPIO_0_DEVICE_ID

// FPS Neri su sfondo Bianco
#define FPS_COLOR 0x0000

typedef struct {
    float x; float y; float vx; float vy; float mass; int radius; unsigned int col;
} Ball;

// --- Helper 7 Segmenti ---
const uint8_t digit_map[10] = {
    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
};

void draw_seven_segment(int digit, int x, int y, int size) {
    if (digit < 0 || digit > 9) return;
    uint8_t mask = digit_map[digit];

    if (mask & 0x01) DrawLine(x, y, x + size, y, FPS_COLOR, 0);
    if (mask & 0x02) DrawLine(x + size, y, x + size, y + size, FPS_COLOR, 0);
    if (mask & 0x04) DrawLine(x + size, y + size, x + size, y + 2*size, FPS_COLOR, 0);
    if (mask & 0x08) DrawLine(x, y + 2*size, x + size, y + 2*size, FPS_COLOR, 0);
    if (mask & 0x10) DrawLine(x, y + size, x, y + 2*size, FPS_COLOR, 0);
    if (mask & 0x20) DrawLine(x, y, x, y + size, FPS_COLOR, 0);
    if (mask & 0x40) DrawLine(x, y + size, x + size, y + size, FPS_COLOR, 0);
}

void display_fps(uint32_t val) {
    int x_start = SCREEN_WIDTH - 40;
    int y_start = 10;
    int size = 8;
    int spacing = 15;

    if (val > 99) val = 99; // Cap a 99 per layout a 2 cifre

    draw_seven_segment((val / 10) % 10, x_start, y_start, size);
    draw_seven_segment(val % 10, x_start + spacing, y_start, size);
}

// --- Fisica ---
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

    XGpio fps_gpio;
    XGpio_Initialize(&fps_gpio, GPIO_FPS_DEVICE_ID);
    XGpio_SetDataDirection(&fps_gpio, 1, 0xFFFFFFFF);

    Ball balls[NUM_BALLS];

    // IMPOSTAZIONE COME CODICE A 3 CIFRE: Seed fisso per evitare gettimeofday
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

        // Lettura e Disegno FPS
        uint32_t current_fps = XGpio_DiscreteRead(&fps_gpio, 1);
        display_fps(current_fps);

        SwapBuffers();
    }
    return 0;
}
