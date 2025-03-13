Inside this folder, there are various programs that we use in the project design. 

`simulator.c` allows us to verify whether the outputs of the graphics accelerators are correct or not.
The idea is to simulate the hardware on Vivado through a testbench that allows writing the circuit's outputs to a file. The outputs, for now, will have the following format inside the file: `X_COORDINATES Y_COORDINATES RGB_NUMBER`, where X_COORDINATES and Y_COORDINATES are the (x, y) coordinates of the point, and RGB_NUMBER is the integer value derived from the RGB encoding of the colors (24-bit). Later, the file will be read by the software, and through the Raylib graphics library, the pixels will be drawn on the screen.
The file `pixels.txt` is an example of the output file from the testbench.

`bresenham.c` is the C implementation of the Bresenham's line algorithm, used to draw a line given two points. This type of implementation uses only integer operations, so that is perfect for future hardware design.
