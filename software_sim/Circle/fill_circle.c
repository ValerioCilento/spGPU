#include <raylib.h>

void FillCircle(int xc, int yc, int r) {
    int x = 0, y = r;
    int d = 3 - (2 * r);

    while (y >= x) {
        // Disegna le scanline tra i punti estremi
        for (int i = xc - x; i <= xc + x; i++) {
            DrawPixel(i, yc + y, RED);
            DrawPixel(i, yc - y, RED);
        }
        for (int i = xc - y; i <= xc + y; i++) {
            DrawPixel(i, yc + x, RED);
            DrawPixel(i, yc - x, RED);
        }

        // Bresenham update
        if (d > 0) {
            y--;
            d += 4 * (x - y) + 10;
        } else {
            d += 4 * x + 6;
        }
        x++;
    }
}

int main() {
    const int screenWidth = 500;
    const int screenHeight = 500;
    
    InitWindow(screenWidth, screenHeight, "Filled Circle - No Sqrt");
    SetTargetFPS(60);

    int xc = screenWidth / 2;
    int yc = screenHeight / 2;
    int radius = 100;

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        FillCircle(xc, yc, radius);  // Riempie il cerchio senza radice quadrata

        EndDrawing();
    }

    CloseWindow();
    return 0;
}
