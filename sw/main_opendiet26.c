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
#include <time.h>

// =========================================================
// DEFINIZIONI COMUNI
// =========================================================
#define SCREEN_WIDTH  320
#define SCREEN_HEIGHT 240

// Nuovo margine superiore di 15 pixel. Il campo utile diventa 320x225.
#define GAME_AREA_START_Y  15

// DA MODIFICARE: Inserisci l'indirizzo base del tuo GPIO (leggi da xparameters.h)
#define SWITCH_GPIO_ADDR XPAR_AXI_GPIO_0_BASEADDR

// =========================================================
// DEFINIZIONI GIOCO PALLINE
// =========================================================
#define NUM_BALLS     8
#define RGB555(r, g, b)  (uint16_t)( ((((r) >> 3) & 0x1F) << 10) | \
                                     ((((g) >> 3) & 0x1F) << 5)  | \
                                     ((((b) >> 3) & 0x1F) << 0) )

typedef struct {
    float x;
    float y;
    float vx;
    float vy;
    float mass;
    int radius;
    unsigned int col;
} Ball;

Ball balls[NUM_BALLS];

// =========================================================
// DEFINIZIONI GIOCO SNAKE
// =========================================================
#define GRID_SIZE          6
#define TEXT_MARGIN_X      10
#define TEXT_MARGIN_Y      10
#define COLS               (SCREEN_WIDTH / GRID_SIZE)
#define ROWS               ((SCREEN_HEIGHT - GAME_AREA_START_Y) / GRID_SIZE)

#define MAX_SNAKE_LEN  20
#define MIN_SNAKE_LEN  1
#define START_LEN      10

#define COLOR_SNAKE_DARK 0x0200
#define COLOR_YELLOW     0x7FE0
#define COLOR_BLACK      0x0000
#define COLOR_RED_APP    0x7C00
#define COLOR_BLU_APP    0x001F

#define FRUIT_GROW     0
#define FRUIT_SHRINK   1

int snake_x[MAX_SNAKE_LEN];
int snake_y[MAX_SNAKE_LEN];
int current_length = START_LEN;
int dir_x = 1;
int dir_y = 0;
int fruit_x;
int fruit_y;
int fruit_type;

// =========================================================
// FUNZIONI GIOCO PALLINE
// =========================================================
float my_sqrtf(float number) {
    if (number <= 0.0f) return 0.0f;
    float guess = number;
    for (int i = 0; i < 10; i++) {
        guess = 0.5f * (guess + number / guess);
    }
    return guess;
}

void ResolveCollision(Ball *a, Ball *b) {
    float dx = b->x - a->x;
    float dy = b->y - a->y;
    float dist_sq = dx * dx + dy * dy;
    float radius_sum = a->radius + b->radius;

    if (dist_sq <= radius_sum * radius_sum && dist_sq > 0.0001f) {
        float dist = my_sqrtf(dist_sq);
        float nx = dx / dist;
        float ny = dy / dist;

        float overlap = 0.5f * (radius_sum - dist);
        a->x -= overlap * nx;
        a->y -= overlap * ny;
        b->x += overlap * nx;
        b->y += overlap * ny;

        float rvx = b->vx - a->vx;
        float rvy = b->vy - a->vy;
        float vel_along_normal = rvx * nx + rvy * ny;

        if (vel_along_normal > 0) return;

        float e = 1.0f;
        float inv_mass_a = 1.0f / a->mass;
        float inv_mass_b = 1.0f / b->mass;

        float j = -(1.0f + e) * vel_along_normal;
        j /= (inv_mass_a + inv_mass_b);

        float impulse_x = j * nx;
        float impulse_y = j * ny;

        a->vx -= impulse_x * inv_mass_a;
        a->vy -= impulse_y * inv_mass_a;
        b->vx += impulse_x * inv_mass_b;
        b->vy += impulse_y * inv_mass_b;
    }
}

unsigned int GenerateColorRGB555() {
    unsigned int r = rand() % 32;
    unsigned int g = rand() % 32;
    unsigned int b = rand() % 32;
    if (r < 5 && g < 5 && b < 5) r = 31;
    return (r << 10) | (g << 5) | b;
}

void InitBallsGame() {
    float start_x[4] = { 50.0f, 200.0f, 50.0f, 200.0f };
    float start_y[4] = { 50.0f, 50.0f, 140.0f, 140.0f };

    for (int i = 0; i < NUM_BALLS; i++) {
        if (i < 4) {
            balls[i].x = start_x[i];
            balls[i].y = start_y[i];
        } else {
            balls[i].x = (float)(rand() % (SCREEN_WIDTH - 20) + 10);
            // Genera la Y tenendo conto del nuovo margine superiore
            balls[i].y = (float)(rand() % (SCREEN_HEIGHT - GAME_AREA_START_Y - 20) + GAME_AREA_START_Y + 10);
        }

        balls[i].vx = ((rand() % 60) - 30) / 10.0f;
        balls[i].vy = ((rand() % 60) - 30) / 10.0f;
        if(balls[i].vx == 0) balls[i].vx = 2.0f;
        if(balls[i].vy == 0) balls[i].vy = -2.0f;

        balls[i].radius = 8 + (rand() % 10);
        if (balls[i].radius < 3) balls[i].radius = 3;
        balls[i].mass = (float)balls[i].radius;
        balls[i].col = GenerateColorRGB555();
    }
}

void UpdateAndDrawBalls() {
    for (int i = 0; i < NUM_BALLS; i++) {
        balls[i].x += balls[i].vx;
        balls[i].y += balls[i].vy;

        // Rimbalzo orizzontale
        if (balls[i].x - balls[i].radius < 0) {
            balls[i].x = balls[i].radius;
            balls[i].vx = -balls[i].vx;
        } else if (balls[i].x + balls[i].radius > SCREEN_WIDTH - 1) {
            balls[i].x = (SCREEN_WIDTH - 1) - balls[i].radius;
            balls[i].vx = -balls[i].vx;
        }

        // Rimbalzo verticale (aggiornato con il nuovo margine superiore)
        if (balls[i].y - balls[i].radius < GAME_AREA_START_Y) {
            balls[i].y = GAME_AREA_START_Y + balls[i].radius;
            balls[i].vy = -balls[i].vy;
        } else if (balls[i].y + balls[i].radius > SCREEN_HEIGHT - 1) {
            balls[i].y = (SCREEN_HEIGHT - 1) - balls[i].radius;
            balls[i].vy = -balls[i].vy;
        }
    }

    for (int i = 0; i < NUM_BALLS; i++) {
        for (int j = i + 1; j < NUM_BALLS; j++) {
            ResolveCollision(&balls[i], &balls[j]);
        }
    }

    for (int i = 0; i < NUM_BALLS; i++) {
        DrawCircleF((uint64_t)balls[i].x, (uint64_t)balls[i].y,
                    (uint64_t)balls[i].radius, balls[i].col, 0);
        //DrawCircle((uint64_t)balls[i].x, (uint64_t)balls[i].y, (uint64_t)balls[i].radius, 0, 0);
    }
}

// =========================================================
// FUNZIONI GIOCO SNAKE
// =========================================================
void DrawSnakeBlock(int gx, int gy, int is_head, int dx, int dy) {
    uint64_t px = gx * GRID_SIZE;
    uint64_t py = (gy * GRID_SIZE) + GAME_AREA_START_Y;
    uint64_t s  = GRID_SIZE;

    DrawTriangleF(px, py, px, py + s, px + s, py + s, COLOR_SNAKE_DARK, 0);
    DrawTriangleF(px, py, px + s, py + s, px + s, py, COLOR_SNAKE_DARK, 0);

    if (is_head) {
        uint16_t e1_x, e1_y, e2_x, e2_y;
        if (dx == 1) {
            e1_x = px + 4; e1_y = py + 1; e2_x = px + 4; e2_y = py + 4;
        } else if (dx == -1) {
            e1_x = px + 1; e1_y = py + 1; e2_x = px + 1; e2_y = py + 4;
        } else if (dy == 1) {
            e1_x = px + 1; e1_y = py + 4; e2_x = px + 4; e2_y = py + 4;
        } else {
            e1_x = px + 1; e1_y = py + 1; e2_x = px + 4; e2_y = py + 1;
        }
        DrawPixel(e1_x, e1_y, COLOR_BLACK);
        DrawPixel(e2_x, e2_y, COLOR_BLACK);
    } else {
        if (dx != 0) {
            DrawLine(px + 1, py + 1, px + 1, py + 4, COLOR_YELLOW, 0);
            DrawLine(px + 4, py + 1, px + 4, py + 4, COLOR_YELLOW, 0);
        } else {
            DrawLine(px + 1, py + 1, px + 4, py + 1, COLOR_YELLOW, 0);
            DrawLine(px + 1, py + 4, px + 4, py + 4, COLOR_YELLOW, 0);
        }
    }
}

void DrawFruit(int gx, int gy, unsigned int color) {
    uint16_t center_x = (gx * GRID_SIZE) + (GRID_SIZE / 2);
    uint16_t center_y = (gy * GRID_SIZE) + GAME_AREA_START_Y + (GRID_SIZE / 2);
    uint16_t radius   = (GRID_SIZE / 2) - 1;
    DrawCircleF(center_x, center_y, radius, color, 0);
}

void SpawnFruit() {
    fruit_x = rand() % COLS;
    // Workaround bug bordo inferiore: sottraiamo 1 da ROWS per escludere l'ultima riga
    fruit_y = rand() % (ROWS - 1);
    fruit_type = (rand() % 2 == 0) ? FRUIT_GROW : FRUIT_SHRINK;
}

void ResetSnakeGame() {
    int start_x = COLS / 2;
    int start_y = ROWS / 2;

    current_length = START_LEN;
    dir_x = 1;
    dir_y = 0;

    for (int i = 0; i < MAX_SNAKE_LEN; i++) {
        snake_x[i] = start_x - i;
        snake_y[i] = start_y;
    }
    SpawnFruit();
}

void UpdateAndDrawSnake() {
    if (snake_x[0] < fruit_x && dir_x != -1) {
        dir_x = 1; dir_y = 0;
    } else if (snake_x[0] > fruit_x && dir_x != 1) {
        dir_x = -1; dir_y = 0;
    } else if (snake_y[0] < fruit_y && dir_y != -1) {
        dir_x = 0; dir_y = 1;
    } else if (snake_y[0] > fruit_y && dir_y != 1) {
        dir_x = 0; dir_y = -1;
    }

    for (int i = current_length - 1; i > 0; i--) {
        snake_x[i] = snake_x[i - 1];
        snake_y[i] = snake_y[i - 1];
    }
    snake_x[0] += dir_x;
    snake_y[0] += dir_y;

    if (snake_x[0] < 0 || snake_x[0] >= COLS || snake_y[0] < 0 || snake_y[0] >= ROWS) {
        ResetSnakeGame();
    }
    for (int i = 1; i < current_length; i++) {
        if (snake_x[0] == snake_x[i] && snake_y[0] == snake_y[i]) {
            ResetSnakeGame();
        }
    }

    if (snake_x[0] == fruit_x && snake_y[0] == fruit_y) {
        if (fruit_type == FRUIT_GROW && current_length < MAX_SNAKE_LEN) {
            snake_x[current_length] = snake_x[current_length - 1];
            snake_y[current_length] = snake_y[current_length - 1];
            current_length++;
        } else if (fruit_type == FRUIT_SHRINK && current_length > MIN_SNAKE_LEN) {
            current_length--;
        }
        SpawnFruit();
    }

    if (fruit_type == FRUIT_GROW) {
        DrawFruit(fruit_x, fruit_y, COLOR_RED_APP);
    } else {
        DrawFruit(fruit_x, fruit_y, COLOR_BLU_APP);
    }

    for (int i = 1; i < current_length; i++) {
        int local_dx = snake_x[i - 1] - snake_x[i];
        int local_dy = snake_y[i - 1] - snake_y[i];

        if (local_dx == 0 && local_dy == 0) {
            local_dx = dir_x;
            local_dy = dir_y;
        }
        DrawSnakeBlock(snake_x[i], snake_y[i], 0, local_dx, local_dy);
    }

    DrawSnakeBlock(snake_x[0], snake_y[0], 1, dir_x, dir_y);
}


// =========================================================
// MAIN
// =========================================================
int main()
{
    init_platform();
    ps7_post_config();
    Xil_DCacheDisable();
    xil_printf("Avvio Multigame (Snake / Palline)...\n\r");

    InitDMA();
    srand(2026);

    InitBallsGame();
    ResetSnakeGame();

    while (1) {
        uint32_t switch_state = Xil_In32(SWITCH_GPIO_ADDR);


        if (switch_state & 0x01) {
            UpdateAndDrawBalls();
        } else {
            UpdateAndDrawSnake();
        }

        SwapBuffers();
    }

    cleanup_platform();
    return 0;
}
