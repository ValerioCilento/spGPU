.PHONY: simulator
.PHONY: testgen
.PHONY: clean

simulator : 
	cc simulator.c -o simulator -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
testgen : 
	cc testgen.c -o testgen -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
clean : 
	rm simulator testgen