#include "raylib.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Struttura per memorizzare un pixel: posizione e colore
typedef struct {
    int x;
    int y;
    int color; // Codifica RGB in un intero: (R<<16) | (G<<8) | B
} PixelRecord;

// Array dinamico per memorizzare i pixel disegnati
PixelRecord *pixelRecords = NULL;
int pixelCount = 0;
int pixelCapacity = 0;

// Funzione per aggiungere un pixel all'array (con riallocazione se necessario)
void addPixelRecord(int x, int y, int color) {
    if (pixelCount >= pixelCapacity) {
        pixelCapacity = (pixelCapacity == 0 ? 100 : pixelCapacity * 2);
        pixelRecords = realloc(pixelRecords, pixelCapacity * sizeof(PixelRecord));
        if (!pixelRecords) {
            fprintf(stderr, "Errore nell'allocazione della memoria\n");
            exit(1);
        }
    }
    pixelRecords[pixelCount].x = x;
    pixelRecords[pixelCount].y = y;
    pixelRecords[pixelCount].color = color;
    pixelCount++;
}

// Implementazione dell'algoritmo di Bresenham per disegnare una linea
void DrawLineBresenham(int x0, int y0, int x1, int y1, Color color) {
    int dx = abs(x1 - x0);
    int dy = abs(y1 - y0);
    int sx = (x0 < x1) ? 1 : -1;
    int sy = (y0 < y1) ? 1 : -1;
    int err = dx - dy;

    while (true) {
        // Calcola il valore intero del colore RGB
        int intColor = (color.r << 16) | (color.g << 8) | color.b;
        addPixelRecord(x0, y0, intColor);

        if (x0 == x1 && y0 == y1) break;
        int e2 = 2 * err;
        if (e2 > -dy) {
            err -= dy;
            x0 += sx;
        }
        if (e2 < dx) {
            err += dx;
            y0 += sy;
        }
    }
}

int main(void) {
    // Impostazioni finestra
    const int screenWidth = 800;
    const int screenHeight = 600;
    InitWindow(screenWidth, screenHeight, "Linea con Bresenham e Triangolo con Raylib");

    // Definizione dei vertici del triangolo
    int ax = 200, ay = 200;
    int bx = 500, by = 200;
    int cx = 200, cy = 550;

    // Inizializzazione dell'array dei pixel
    pixelRecords = NULL;
    pixelCount = 0;
    pixelCapacity = 0;

    // Disegna i lati del triangolo con il colore RED (predefinito in Raylib)
    Color lineColor = RED;
    DrawLineBresenham(ax, ay, bx, by, lineColor);
    DrawLineBresenham(bx, by, cx, cy, lineColor);
    DrawLineBresenham(cx, cy, ax, ay, lineColor);

    // Salva i pixel disegnati in un file .txt (formato: X Y Color)
    FILE *fp = fopen("pixels.txt", "w");
    if (fp == NULL) {
        fprintf(stderr, "Errore nell'apertura del file per la scrittura.\n");
        return 1;
    }
    for (int i = 0; i < pixelCount; i++) {
        fprintf(fp, "%d %d %d\n", pixelRecords[i].x, pixelRecords[i].y, pixelRecords[i].color);
    }
    fclose(fp);

    SetTargetFPS(60); // Imposta i fotogrammi per secondo

    // Ciclo principale di disegno
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        // Ridisegna ogni pixel registrato
        for (int i = 0; i < pixelCount; i++) {
            int intColor = pixelRecords[i].color;
            // Estrae i componenti R, G, B dall'intero
            Color col = {
                (unsigned char)((intColor >> 16) & 0xFF),
                (unsigned char)((intColor >> 8) & 0xFF),
                (unsigned char)(intColor & 0xFF),
                255
            };
            DrawPixel(pixelRecords[i].x, pixelRecords[i].y, col);
        }

        EndDrawing();
    }

    // Libera la memoria e chiude la finestra
    free(pixelRecords);
    CloseWindow();

    return 0;
}
