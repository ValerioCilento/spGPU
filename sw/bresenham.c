#include <raylib.h>
#include <stdlib.h>

const int screenWidth = 800;
const int screenHeight = 600;

// Algoritmo di Bresenham
void myDrawLine(Vector2 p1, Vector2 p2, Color color) {
    int dx = abs(p2.x - p1.x);
    int dy = abs(p2.y - p1.y);
    int sx = (p1.x < p2.x) ? 1 : -1;
    int sy = (p1.y < p2.y) ? 1 : -1;
    int err = dx - dy;
    
    while (p1.x != p2.x || p1.y != p2.y) {
        DrawPixel(p1.x, p1.y, color);  // Disegna il pixel corrente
        int e2 = 2 * err;
        if (e2 > -dy) { err -= dy; p1.x += sx; }
        if (e2 < dx) { err += dx; p1.y += sy; }
    }
}

int main(void) {

    
    InitWindow(screenWidth, screenHeight, "Computer Graphics");
    SetTargetFPS(60);
    
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        
        // Vector2: (x, y) coordinates
     	Vector2 p1 = {100, 100};
     	Vector2 p2 = {700, 100};
     	Vector2 p3 = {700, 500};

        
        // Disegna il contorno del triangolo
        myDrawLine(p1, p2, RED);
        myDrawLine(p1, p3, RED);
        myDrawLine(p2, p3, RED);
        //scanLine();

        
        DrawText("Computer Graphics Tests", 10, 10, 20, DARKGRAY);
        EndDrawing();
    }
    
    CloseWindow();
    return 0;
}
