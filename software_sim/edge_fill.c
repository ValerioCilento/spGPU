#include "raylib.h"
#include <math.h>

// Calcola l'edge function per l'arco definito da 'a' e 'b' e il punto 'p'
float EdgeFunction(Vector2 a, Vector2 b, Vector2 p) {
    return (p.x - a.x) * (b.y - a.y) - (p.y - a.y) * (b.x - a.x);
}

int main(void)
{
    const int screenWidth = 800;
    const int screenHeight = 600;
    InitWindow(screenWidth, screenHeight, "Rasterizzazione triangolo con Edge Equations");

    // Definizione dei vertici del triangolo
    Vector2 v0 = {200, 100};
    Vector2 v1 = {600, 150};
    Vector2 v2 = {400, 500};

    // Calcolo dell'area del triangolo (usando l'edge function tra v0, v1, v2)
    float area = EdgeFunction(v0, v1, v2);

    // Calcolo della bounding box del triangolo per limitare l'iterazione
    float minX = fminf(fminf(v0.x, v1.x), v2.x);
    float minY = fminf(fminf(v0.y, v1.y), v2.y);
    float maxX = fmaxf(fmaxf(v0.x, v1.x), v2.x);
    float maxY = fmaxf(fmaxf(v0.y, v1.y), v2.y);

    int xmin = (int)floorf(minX);
    int ymin = (int)floorf(minY);
    int xmax = (int)ceilf(maxX);
    int ymax = (int)ceilf(maxY);

    SetTargetFPS(60);

    while (!WindowShouldClose())
    {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        // Rasterizzazione: iterazione sui pixel della bounding box
        for (int y = ymin; y < ymax; y++) {
            for (int x = xmin; x < xmax; x++) {
                // Uso del centro del pixel
                Vector2 p = {(float)x + 0.5f, (float)y + 0.5f};

                // Calcolo delle edge functions per ciascun bordo
                float w0 = EdgeFunction(v1, v2, p);
                float w1 = EdgeFunction(v2, v0, p);
                float w2 = EdgeFunction(v0, v1, p);

                // Se l'area è negativa, il triangolo ha winding inverso:
                if (area < 0) {
                    if (w0 <= 0 && w1 <= 0 && w2 <= 0) {
                        DrawPixel(x, y, MAROON);
                    }
                } else {
                    if (w0 >= 0 && w1 >= 0 && w2 >= 0) {
                        DrawPixel(x, y, MAROON);
                    }
                }
            }
        }

        // Disegno dei bordi del triangolo per confronto
        DrawLineV(v0, v1, BLACK);
        DrawLineV(v1, v2, BLACK);
        DrawLineV(v2, v0, BLACK);

        EndDrawing();
    }

    CloseWindow();
    return 0;
}
