#include "raylib.h"
#include <stdio.h>
#include <stdlib.h>

// Struttura per memorizzare i dati di un pixel: coordinate e colore (RGB codificato in un intero)
typedef struct {
    int x;
    int y;
    int color; // Codifica RGB: (R << 16) | (G << 8) | B
} PixelRecord;

int main(int argc, char **argv) {
    // Impostazioni finestra
    const int screenWidth = 800;
    const int screenHeight = 600;
    InitWindow(screenWidth, screenHeight, "C Simulator for graphics");

    // Apertura del file in lettura
    FILE *fp = fopen(argv[1], "r");
    if (fp == NULL) {
        printf("FIle initialization failed\n");
        CloseWindow();
        return 1;
    }

    // Array dinamico per memorizzare i pixel letti dal file
    PixelRecord *pixelRecords = NULL;
    int pixelCount = 0;
    int pixelCapacity = 0;

    
    unsigned int x, y, col;
    while (fscanf(fp, "%d %d %d", &x, &y, &col) == 3) {
        // Rialloca l'array se necessario
        if (pixelCount >= pixelCapacity) {
            pixelCapacity = (pixelCapacity == 0 ? 100 : pixelCapacity * 2);
            pixelRecords = realloc(pixelRecords, pixelCapacity * sizeof(PixelRecord));
            if (pixelRecords == NULL) {
                printf("Memory Allocation failed\n");
                fclose(fp);
                CloseWindow();
                return 1;
            }
        }
        // Salva il pixel letto
        pixelRecords[pixelCount].x = x;
        pixelRecords[pixelCount].y = y;
        pixelRecords[pixelCount].color = col;
        pixelCount++;
    }
    fclose(fp);

    SetTargetFPS(60); 
    
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        // Per ogni pixel letto, estrai i componenti del colore e disegna il pixel
        for (int i = 0; i < pixelCount; i++) {
            int intColor = pixelRecords[i].color;
            Color col = {
                (unsigned char)((intColor >> 16) & 0xFF),  // Rosso
                (unsigned char)((intColor >> 8) & 0xFF),   // Verde
                (unsigned char)(intColor & 0xFF),          // Blu
                255                                       // Opacità
            };
            DrawPixel(pixelRecords[i].x, pixelRecords[i].y, col);
        }

        EndDrawing();
    }

    // Libera la memoria allocata e chiude la finestra
    free(pixelRecords);
    CloseWindow();
    return 0;
}
