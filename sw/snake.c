#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "ps7_init.h"
#include <xil_io.h>
#include <stdint.h>
#include "xil_cache.h"
#include "sleep.h"
#include "sp_lib.h"
#include <stdlib.h>
#include <math.h>

#define VIDEO_X 256
#define VIDEO_Y 192
#define SEED 3565
#define MAX_SNAKE_LEN 15
// Actions definition
#define ACTION_UP           2
#define ACTION_RIGHT        1
#define ACTION_DOWN         0
#define ACTION_LEFT         3

// Rewards
#define REWARD_GOAL        126  //127
#define REWARD_STEP        -1  //-1
#define EPSILON          20 //0.2

int q_matrix[VIDEO_X][VIDEO_Y][4] = {0};
unsigned int action=0;
double alpha = 0.5;
double gamma_p = 0.95;
int reward = 0;


typedef struct snake_t
{
    unsigned char *x;
    unsigned char *y;
    unsigned char len;
    unsigned int color;
}snake_t;

typedef struct apple_t
{
    unsigned char x;
    unsigned char y;
    unsigned char radius;
    unsigned int color;
}apple_t;

void q_learning(unsigned char x, unsigned char y){
	int max_q;
	double temp;
	max_q = q_matrix[x][y][0];
	for(int i=0;i<4;i++){
	    if(q_matrix[x][y][i] > max_q){
	      	max_q = q_matrix[x][y][i];
	    }
	}
	temp = (1-alpha)*q_matrix[x][y][action] + alpha*(reward + gamma_p*max_q);
    q_matrix[x][y][action] = (int)((int)(temp*128) >> 7);
	//q_matrix[x][y][action] = (int)round((1-alpha)*q_matrix[x][y][action] + (alpha*(reward + gamma_p*max_q)));
}
void policy_gen(unsigned char x, unsigned char y){
	unsigned int epsilon_rand = rand() % 100;
	if(epsilon_rand <= EPSILON){
		action = rand() % 4;

	}else{
		if( (q_matrix[x][y][0] + q_matrix[x][y][1] + q_matrix[x][y][2] + q_matrix[x][y][3]) == 0){
			action = rand() % 4;

		}else{
		unsigned int best_action = 0;
        	for (int i = 0; i < 4; i++) {
            	if (q_matrix[x][y][i] > q_matrix[x][y][best_action]) {
                	best_action = i;
            	}
        	}
        	action = best_action;
		}
	}
}

/*
 * Sostituisci la tua vecchia funzione 'game' con questa.
 * Restituisce 0 per continuare, 1 per terminare il gioco.
 */
int game( snake_t *snake, apple_t *apple )
{
	unsigned char new_snake_x;
	unsigned char new_snake_y;

	/* Questa parte (policy_gen e switch) rimane invariata */
	policy_gen(snake->x[0], snake->y[0]);
	new_snake_x = snake->x[0];
	new_snake_y = snake->y[0];
	switch (action) {
		case 0: new_snake_y++;break;//Giù
		case 1: new_snake_x++;break;//Destra
		case 2: new_snake_y--;break;//Su
		case 3: new_snake_x--;break;//Sinistra
		default: puts("Azione non valida!\n");
	}

	if (new_snake_x == apple->x && new_snake_y == apple->y) {
        // CASO 1: IL SERPENTE RAGGIUNGE IL GOAL (LA MELA)
		reward = REWARD_GOAL;
        // 1. Aumenta la lunghezza
        snake->len++;
        xil_printf("GOAL! Lunghezza attuale: %d\n", snake->len);

        // 2. Rialloca la memoria
        snake->x = realloc(snake->x, snake->len * sizeof(unsigned char));
        snake->y = realloc(snake->y, snake->len * sizeof(unsigned char));

        // 3. *** NUOVO CONTROLLO: VERIFICA TERMINAZIONE ***
        //    Controlla se la *nuova* lunghezza ha raggiunto il massimo
        if (snake->len >= MAX_SNAKE_LEN) {
            xil_printf("LUNGHEZZA MASSIMA RAGGIUNTA! Fine.\n");

            // Esegui l'ultimo Q-learning per questo stato finale
            q_learning(new_snake_x, new_snake_y);

            return 1; // Segnala a 'main' di terminare
        }

        // 4. FA "RESPAWN" IL SERPENTE (se il gioco non è finito)
        snake->x[0] = rand() % VIDEO_X;
        snake->y[0] = rand() % VIDEO_Y;

        while (snake->x[0] == apple->x && snake->y[0] == apple->y) {
            snake->x[0] = rand() % VIDEO_X;
            snake->y[0] = rand() % VIDEO_Y;
        }

        // 5. Costruisci la NUOVA CODA dietro la nuova testa
        for (int i = 1; i < snake->len; i++) {
            if (snake->x[i-1] > 0) {
                snake->x[i] = snake->x[i-1] - 1;
            } else {
                snake->x[i] = VIDEO_X - 1; // wrap-around
            }
            snake->y[i] = snake->y[i-1];
        }

	} else {
        // CASO 2: MOVIMENTO NORMALE (NON MANGIA)
		reward = REWARD_STEP;

        // Logica di scorrimento corretta
        for (int i = snake->len - 1; i > 0; i--) {
            snake->x[i] = snake->x[i - 1];
            snake->y[i] = snake->y[i - 1];
        }
        snake->x[0] = new_snake_x;
        snake->y[0] = new_snake_y;
	}

    /* Le funzioni di Q-Learning e stampa rimangono (come da tua richiesta) */
	q_learning(snake->x[0], snake->y[0]);
	xil_printf("SNAKE:[%d], [%d]\n ", snake->x[0], snake->y[0]);

    return 0; // Segnala a 'main' di continuare
}
/*
 * Sostituisci la tua vecchia funzione 'main' con questa.
 */
int main(void)
{
	init_platform();
	ps7_post_config();
	Xil_DCacheDisable();
	InitDMA();
	srand(SEED);

	apple_t apple;
	snake_t snake;
	apple.x = 149;
	apple.y = 149;
	apple.radius = 1;
	apple.color = 0xFF0000;

	snake.len = 1;
	snake.x = malloc(snake.len * sizeof(unsigned char));
	snake.y = malloc(snake.len * sizeof(unsigned char));

	snake.x[0] = 100;
	snake.y[0] = 100;
	snake.color = 0x006400;

    int game_status = 0; // 0 = in corso, 1 = terminato

	while (1) // Questo loop ora si può interrompere
	{
			// Chiama 'game' e salva il suo stato
		game_status = game(&snake, &apple);

			// Il codice di disegno rimane invariato
		DrawPixel(apple.x, apple.y, apple.color);
		for (int i = 0; i < snake.len; i++) {
			DrawCircleF(snake.x[i], snake.y[i], 2, snake.color, 0);
		}
		SwapBuffers();

				// Se 'game' ha restituito 1, esci dal loop
				if (game_status == 1) {
					break;
				}
		}

			// Codice da eseguire quando il gioco finisce
			xil_printf("--- GIOCO TERMINATO ---");
			// Qui potresti pulire lo schermo o mostrare un messaggio finale
			// Esempio: ClearScreen(0x0000FF); // Sfondo blu

			cleanup_platform();
		return 0;
}



