#include <raylib.h>

void BresenhamCircle(int xc, int yc, int r) {
    int x = 0;
    int y = r;
    int d = 3 - (2 * r);  // Decision parameter

    while (x <= y) {
        // Plot all 8 symmetric points
        DrawPixel(xc + x, yc + y, RED);
        DrawPixel(xc - x, yc + y, RED);
        DrawPixel(xc + x, yc - y, RED);
        DrawPixel(xc - x, yc - y, RED);
        DrawPixel(xc + y, yc + x, RED);
        DrawPixel(xc - y, yc + x, RED);
        DrawPixel(xc + y, yc - x, RED);
        DrawPixel(xc - y, yc - x, RED);

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

    InitWindow(screenWidth, screenHeight, "Bresenham Circle - Optimized for VHDL");
    SetTargetFPS(60);

    int xc = screenWidth / 2;
    int yc = screenHeight / 2;
    int radius = 100;

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        // Call the optimized function
        BresenhamCircle(xc, yc, radius);

        EndDrawing();
    }

    CloseWindow();
    return 0;
}
