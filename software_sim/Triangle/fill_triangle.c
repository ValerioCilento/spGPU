#include <raylib.h>
#include <stdlib.h>

const int screenWidth = 800;
const int screenHeight = 600;
Vector2 temp;

int myFill(Vector2 p3, Color color){  
    int done = 0;
    int dx = abs(p3.x - temp.x);
    int dy = abs(p3.y - temp.y);
    int sx = (p3.x < temp.x) ? 1 : -1;
    int sy = (p3.y < temp.y) ? 1 : -1;
    int err = dx - dy;
    
    while (p3.x != temp.x || p3.y != temp.y) {
        DrawPixel(p3.x, p3.y, color);  // Disegna il pixel corrente
        int e2 = 2 * err;
        if (e2 > -dy) { 
            err -= dy; p3.x += sx; 
        }
        if (e2 < dx) { 
            err += dx; p3.y += sy; 
        }
    }
    done = 1;
    return done;

}
// Algoritmo di Bresenham
void myDrawTriangle(Vector2 p1, Vector2 p2, Vector2 p3, Color color, Color color_fill ) {
    int dx = abs(p2.x - p1.x);
    int dy = abs(p2.y - p1.y);
    int sx = (p1.x < p2.x) ? 1 : -1;
    int sy = (p1.y < p2.y) ? 1 : -1;
    int err = dx - dy;
    
    while (p1.x != p2.x || p1.y != p2.y) {
        temp.x = p1.x;
        temp.y = p1.y;
        DrawPixel(p1.x, p1.y, color);  // Disegna il pixel corrente
        while(!myFill(p3, color_fill));
        int e2 = 2 * err;
        if (e2 > -dy) { 
            err -= dy; p1.x += sx; 
        }
        if (e2 < dx) { 
            err += dx; p1.y += sy; 
        }
    }
}


int main(void) {

    
    InitWindow(screenWidth, screenHeight, "Computer Graphics");
    SetTargetFPS(60);
    
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        Vector2 p1 = {100, 100};
        Vector2 p2 = {200, 200};
        Vector2 p3 = {300, 150};
        // Disegna il contorno del triangolo e lo riempie con il BLUE
        myDrawTriangle(p1, p2, p3, RED, BLUE);
        
        DrawText("Computer Graphics Tests", 10, 10, 20, DARKGRAY);
        EndDrawing();
    }
    
    CloseWindow();
    return 0;
}
