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
#define SCREEN_WIDTH  320
#define SCREEN_HEIGHT 240
#define NUM_BALLS     10
#define RGB555(r, g, b)  (uint16_t)( ((((r) >> 3) & 0x1F) << 10) | \
                                     ((((g) >> 3) & 0x1F) << 5)  | \
                                     ((((b) >> 3) & 0x1F) << 0) )
typedef struct {
    float x;
    float y;
    float vx;         // Velocità sull'asse X
    float vy;         // Velocità sull'asse Y
    float mass;       // Massa (proporzionale al raggio)
    int radius;
    unsigned int col;
} Ball;
float my_sqrtf(float number) {
    if (number <= 0.0f) return 0.0f;
    float guess = number;
    // 10 iterazioni sono più che sufficienti per la precisione visiva dei pixel
    for (int i = 0; i < 10; i++) {
        guess = 0.5f * (guess + number / guess);
    }
    return guess;
}
// Funzione per gestire la collisione e il rimbalzo tra DUE palline
void ResolveCollision(Ball *a, Ball *b) {
    float dx = b->x - a->x;
    float dy = b->y - a->y;
    float dist_sq = dx * dx + dy * dy;
    float radius_sum = a->radius + b->radius;

    // Controllo se le palline si stanno toccando o compenetrando
    if (dist_sq <= radius_sum * radius_sum && dist_sq > 0.0001f) {
        float dist = my_sqrtf(dist_sq);

        // Vettore normale della collisione
        float nx = dx / dist;
        float ny = dy / dist;

        // 1. Risoluzione della compenetrazione (Static Resolution)
        // Evita che le palline si "incollino" tra loro separandole fisicamente
        float overlap = 0.5f * (radius_sum - dist);
        a->x -= overlap * nx;
        a->y -= overlap * ny;
        b->x += overlap * nx;
        b->y += overlap * ny;

        // 2. Risoluzione Dinamica (Calcolo del nuovo vettore velocità)
        float rvx = b->vx - a->vx;
        float rvy = b->vy - a->vy;

        // Velocità relativa lungo la normale
        float vel_along_normal = rvx * nx + rvy * ny;

        // Se si stanno già allontanando, non fare nulla
        if (vel_along_normal > 0) return;

        // Coefficiente di restituzione (1.0 = elastico perfetto, nessuna perdita di energia)
        float e = 1.0f;

        float inv_mass_a = 1.0f / a->mass;
        float inv_mass_b = 1.0f / b->mass;

        // Calcolo dell'impulso scalare
        float j = -(1.0f + e) * vel_along_normal;
        j /= (inv_mass_a + inv_mass_b);

        // Applica l'impulso alle velocità correnti
        float impulse_x = j * nx;
        float impulse_y = j * ny;

        a->vx -= impulse_x * inv_mass_a;
        a->vy -= impulse_y * inv_mass_a;
        b->vx += impulse_x * inv_mass_b;
        b->vy += impulse_y * inv_mass_b;
    }
}

// Genera un colore RGB555 casuale
unsigned int GenerateColorRGB555() {
    unsigned int r = rand() % 32;
    unsigned int g = rand() % 32;
    unsigned int b = rand() % 32;
    if (r < 5 && g < 5 && b < 5) r = 31; // Fallback per non farle nere
    return (r << 10) | (g << 5) | b;
}
int main()
{
    init_platform();
    ps7_post_config();
    Xil_DCacheDisable();
    xil_printf("Running...\n\r");

    InitDMA();

    Ball balls[NUM_BALLS];
        srand(666);

        // Inizializza le 4 palline in posizioni specifiche per evitare sovrapposizioni iniziali
        float start_x[4] = { 50.0f, 200.0f, 50.0f, 200.0f };
        float start_y[4] = { 50.0f, 50.0f, 140.0f, 140.0f };

        for (int i = 0; i < NUM_BALLS; i++) {
            balls[i].x = start_x[i];
            balls[i].y = start_y[i];

            // Velocità iniziali casuali (tra -3.0 e +3.0) ma non zero
            balls[i].vx = ((rand() % 60) - 30) / 10.0f;
            balls[i].vy = ((rand() % 60) - 30) / 10.0f;
            if(balls[i].vx == 0) balls[i].vx = 2.0f;
            if(balls[i].vy == 0) balls[i].vy = -2.0f;

            balls[i].radius = (rand() % 10); // Raggio tra 0 e 9
            balls[i].mass = (float)balls[i].radius; // Più è grande, più è pesante
            balls[i].col = GenerateColorRGB555();
        }

        while (1) {
            // 1. Aggiorna le posizioni e gestisci i rimbalzi sui muri
            for (int i = 0; i < NUM_BALLS; i++) {
                balls[i].x += balls[i].vx;
                balls[i].y += balls[i].vy;

                // Rimbalzo muro Sinistro / Destro
                if (balls[i].x - balls[i].radius < 0) {
                    balls[i].x = balls[i].radius;
                    balls[i].vx = -balls[i].vx;
                } else if (balls[i].x + balls[i].radius > SCREEN_WIDTH - 1) {
                    balls[i].x = (SCREEN_WIDTH - 1) - balls[i].radius;
                    balls[i].vx = -balls[i].vx;
                }

                // Rimbalzo muro Superiore / Inferiore
                if (balls[i].y - balls[i].radius < 0) {
                    balls[i].y = balls[i].radius;
                    balls[i].vy = -balls[i].vy;
                } else if (balls[i].y + balls[i].radius > SCREEN_HEIGHT - 1) {
                    balls[i].y = (SCREEN_HEIGHT - 1) - balls[i].radius;
                    balls[i].vy = -balls[i].vy;
                }
            }

            // 2. Gestisci le collisioni tra le palline
            // Usiamo un doppio ciclo per controllare ogni coppia di palline una sola volta
            for (int i = 0; i < NUM_BALLS; i++) {
                for (int j = i + 1; j < NUM_BALLS; j++) {
                    ResolveCollision(&balls[i], &balls[j]);
                }
            }

            // 3. Disegna le palline nel backbuffer
            for (int i = 0; i < NUM_BALLS; i++) {
                DrawCircleF((uint64_t)balls[i].x, (uint64_t)balls[i].y,
                           (uint64_t)balls[i].radius, balls[i].col, 0);
            }
            // 4. Scambia i buffer per mostrare il frame senza sfarfallio

            //printf("(%d)\n", 8*sizeof(DrawPixel_t));
            //DrawLine(100, 100, 20, 40, RGB555(255,0,0), 0);
            //DrawLine(1, 1, 319, 239, RGB555(255,0,0), 0);
            //DrawCircleF(300, 200, 10,  RGB555(0,0,255), 0);
            //DrawTriangleF(100, 100, 20, 20, 20, 100, RGB555(255, 255, 0), 0);
            SwapBuffers();

            // Pausa (circa 30 FPS). Sostituisci se usi un microcontrollore senza POSIX.
            //usleep(33000);
        }
}
