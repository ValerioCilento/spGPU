#include <opencv2/opencv.hpp>
#include <iostream>

using namespace cv;
using namespace std;

// Funzione di upscaling con Nearest Neighbor
Mat nearestNeighborResize(const Mat& input, int scaleX, int scaleY) {
    int newWidth = input.cols * scaleX;
    int newHeight = input.rows * scaleY;
    
    Mat output(newHeight, newWidth, input.type());

    for (int y = 0; y < newHeight; ++y) {
        for (int x = 0; x < newWidth; ++x) {
            // Trova il pixel più vicino nell'immagine originale
            int srcX = x / scaleX;
            int srcY = y / scaleY

            // Copia il valore del pixel
            output.at<Vec3b>(y, x) = input.at<Vec3b>(srcY, srcX);
        }
    }

    return output;
}

int main() {
    // Carica un'immagine
    Mat image = imread("input.jpg");
    if (image.empty()) {
        cerr << "Errore: Impossibile aprire l'immagine!" << endl;
        return -1;
    }

    // Fattori di scala
    int scaleX = 2;// Raddoppia la larghezza
    int scaleY = 2;//Raddoppia l'altezza

    // Applica l'algoritmo di Nearest Neighbor
    Mat resizedImage = nearestNeighborResize(image, scaleX, scaleY);

    // Mostra le immagini originali e scalate
    imshow("Original Image", image);
    imshow("Upscaled Image (Nearest Neighbor)", resizedImage);

    // Salva il risultato
    imwrite("output.jpg", resizedImage);

    waitKey(0);
    return 0;
}
