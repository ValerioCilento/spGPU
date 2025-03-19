CXX = g++
CXXFLAGS = -Wall -O2 `pkg-config --cflags opencv4`
LDFLAGS = `pkg-config --libs opencv4`
TARGET = output
SRC = nn_interpolation.cpp

all:
	$(CXX) $(CXXFLAGS) $(SRC) -o $(TARGET) $(LDFLAGS)

clean:
	rm -f $(TARGET)
