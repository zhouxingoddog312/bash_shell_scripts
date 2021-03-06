#include <unistd.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include "data.h"
int main(int argc,char *argv[])
{
	char *start_menu[]=
	{
		"new game",
		"load game",
		"quit",
		0
	};
	char *instructions[]=
	{
		"use up/down/left/right",
		"or w/s/a/d",
		"to control the snake",
		"Esc to save/end the game",
		0
	};
	srand(time(0));
	int Current_len=0;
	snake greedy;
	greedy=malloc(sizeof(food)*TOTLE_POINT);
	bool Map[WINDOW_HEIGHT-2][WINDOW_WIDTH-2];
	bool eatedfood=false;
	int key;
	food f;
	direct d;
	char name[STR_LEN];
//参数处理
	bool Cheat=false;
	int command_result;
	if(argc>1)
	{
		command_result=command_mode(argc,argv,&Cheat);
		if(command_result)
			exit(command_result);
	}
	rank_db_init(false);
//开始界面

	initscr();
	draw_base_window();
	WINDOW *start_rank_win=newwin(WINDOW_HEIGHT,WINDOW_WIDTH,(LINES-WINDOW_HEIGHT)/2,(COLS-WINDOW_WIDTH*2)/3*2+WINDOW_WIDTH);
	WINDOW *select_win=newwin(WINDOW_HEIGHT,WINDOW_WIDTH,(LINES-WINDOW_HEIGHT)/2,(COLS-WINDOW_WIDTH*2)/3);
	
	print_rank(start_rank_win);

	do
	{
		command_result=getchoice(select_win,start_menu);
		switch(command_result)
		{
			case 'n':
				/*设置新的初始状态*/
				command_result=init_status(select_win,&d,&f,greedy,Map,name,&Current_len);
				break;
			case 'l':
				/*载入存档中的状态*/
				command_result=load_savedata(select_win,&d,&f,greedy,Map,name,&Current_len);
				break;
			case 'q':
				endwin();
				destory_status(greedy);
				exit(EXIT_SUCCESS);
		}
	}while(command_result!=0);
	delwin(start_rank_win);
	draw_base_window();
//游戏界面
//现在select_win作为游戏窗口
	WINDOW *instructions_win=newwin(WINDOW_HEIGHT/2,WINDOW_WIDTH,(LINES-WINDOW_HEIGHT)/2,(COLS-WINDOW_WIDTH*2)/3*2+WINDOW_WIDTH);
	WINDOW *status_win=newwin(WINDOW_HEIGHT/2,WINDOW_WIDTH,LINES/2,(COLS-WINDOW_WIDTH*2)/3*2+WINDOW_WIDTH);
	draw_select_window(instructions_win,instructions,-1,1,WINDOW_WIDTH/4);

	init_keyboard(select_win);

	while(true)
	{
		timeout(SPEED_MAX-(Current_len/35)*50);//改变速度
		draw_status_window(status_win,name,Current_len);
		draw_snake_window(select_win,greedy,f,Current_len);
		if((!Cheat)&&Isover(greedy,Current_len))
		{
			end_game(select_win,"Game Over!",name,Current_len);
			break;
		}
		if(Iswin(Current_len))
		{
			end_game(select_win,"You Win!",name,Current_len);
			break;
		}
		if(Eatfood(greedy,f))
		{
			Createfood(&f,Current_len,Map);
			eatedfood=true;
		}

		if((key=getch())!=ERR)
			{
				switch(key)
				{
					case 'A':
					case 'a':
					case KEY_LEFT:
						if(d.x!=1)
						{
							d.x=-1;
							d.y=0;
						}
						break;
					case 'D':
					case 'd':
					case KEY_RIGHT:
						if(d.x!=-1)
						{
							d.x=1;
							d.y=0;
						}
						break;
					case 'W':
					case 'w':
					case KEY_UP:
						if(d.y!=1)
						{
							d.x=0;
							d.y=-1;
						}
						break;
					case 'S':
					case 's':
					case KEY_DOWN:
						if(d.y!=-1)
						{
							d.x=0;
							d.y=1;
						}
						break;
					case 10/*Enter键*/:
					case 27/*Esc键*/:
						/*存入存档*/
						save_savedata(select_win,&d,&f,greedy,name,&Current_len);
						goto endgame;
				}
			}

		update_snake(greedy,d,&Current_len,Map,&eatedfood);
	}

	endgame:close_keyboard(select_win);

	delwin(select_win);
	delwin(instructions_win);
	delwin(status_win);


	endwin();
	destory_status(greedy);
	exit(EXIT_SUCCESS);
}
