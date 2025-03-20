#include <opencv2/opencv.hpp>
#include <iostream>

using namespace cv;
using namespace std;

const int screenWidth = 800;
const int screenHeight = 600;

// Funzione per disegnare un pixel su una Mat di OpenCV
void DrawPixel(Mat &img, int x, int y, Vec3b color) {
    if (x >= 0 && x < img.cols && y >= 0 && y < img.rows) {
        img.at<Vec3b>(y, x) = color;
    }
}

// Algoritmo di Bresenham per disegnare una linea
void myDrawLine(Mat &img, Point p1, Point p2, Vec3b color) {
    int dx = abs(p2.x - p1.x), dy = abs(p2.y - p1.y);
    int sx = (p1.x < p2.x) ? 1 : -1;
    int sy = (p1.y < p2.y) ? 1 : -1;
    int err = dx - dy, e2;
    
    while (true) {
        DrawPixel(img, p1.x, p1.y, color);
        if (p1.x == p2.x && p1.y == p2.y) break;
        e2 = 2 * err;
        if (e2 > -dy) { err -= dy; p1.x += sx; }
        if (e2 < dx) { err += dx; p1.y += sy; }
    }
}

// Algoritmo Boundary-Fill per riempire il triangolo
void boundaryFill(Mat &img, int x, int y, Vec3b fillColor, Vec3b borderColor) {
    // Controlla se il pixel è dentro l'immagine e se deve essere colorato
    if (x < 0 || x >= img.cols || y < 0 || y >= img.rows) return;
    Vec3b pixelColor = img.at<Vec3b>(y, x);
    if (pixelColor == borderColor || pixelColor == fillColor) return;

    // Colora il pixel
    img.at<Vec3b>(y, x) = fillColor;

    // Chiamate ricorsive per i pixel vicini
    boundaryFill(img, x + 1, y, fillColor, borderColor);
    boundaryFill(img, x - 1, y, fillColor, borderColor);
    boundaryFill(img, x, y + 1, fillColor, borderColor);
    boundaryFill(img, x, y - 1, fillColor, borderColor);
}

// Funzione per disegnare e riempire un triangolo
void drawAndFillTriangle(Mat &img, Point p1, Point p2, Point p3, Vec3b borderColor, Vec3b fillColor) {
    // Disegna i lati del triangolo con Bresenham
    myDrawLine(img, p1, p2, borderColor);
    myDrawLine(img, p2, p3, borderColor);
    myDrawLine(img, p3, p1, borderColor);

    // Trova un punto all'interno del triangolo (centroide approssimato)
    int centerX = (p1.x + p2.x + p3.x) / 3;
    int centerY = (p1.y + p2.y + p3.y) / 3;

    // Riempie il triangolo con Boundary-Fill
    boundaryFill(img, centerX, centerY, fillColor, borderColor);
}

int main() {
    // Crea un'immagine bianca
    Mat image(screenHeight, screenWidth, CV_8UC3, Scalar(255, 255, 255));

    // Definizione dei vertici del triangolo
    Point p1(100, 100);
    Point p2(200, 100);
    Point p3(150, 50);

    // Colori
    Vec3b red = {0, 0, 255};   // Rosso (BGR)
    Vec3b blue = {255, 0, 0};  // Blu (BGR)

    // Disegna e riempi il triangolo
    drawAndFillTriangle(image, p1, p2, p3, red, blue);

    // Mostra l'immagine
    imshow("Triangle with Bresenham and Boundary-Fill", image);
    waitKey(0);

    // Salva l'immagine
    imwrite("triangle.png", image);

    return 0;
}
