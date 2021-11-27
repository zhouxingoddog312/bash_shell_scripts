#include <unistd.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include "data.h"

bool Cheat=false;
int Current_len;
bool Map[WINDOW_HEIGHT-2][WINDOW_WIDTH-2];
int main(int argc,char *argv[])
{
	char *start_menu[]=
	{
		"new game",
		"load game",
		"delete data",
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
	snake greedy;
	greedy=malloc(sizeof(food)*TOTLE_POINT);
	bool eatedfood=false;
	int key;
	food f;
	direct d;
	char name[STR_LEN];
//参数处理
	int command_result;
	if(argc>1)
	{
		command_result=command_mode(argc,argv);
		if(command_result)
			exit(command_result);
	}
//开始界面
	initscr();
	draw_base_window();
	WINDOW *start_rank_win=newwin(WINDOW_HEIGHT,WINDOW_WIDTH,(LINES-WINDOW_HEIGHT)/2,COLS/2+3);
	WINDOW *select_win=newwin(WINDOW_HEIGHT,WINDOW_WIDTH,2,6);
	draw_select_window(start_rank_win,start_menu,-1,1,1);
	do
	{
		command_result=getchoice(select_win,start_menu);
		switch(command_result)
		{
			case 'n':
				/*设置新的初始状态*/
				init_status(select_win,&d,&f,greedy,name);
				command_result='g';
				break;
			case 'l':
				/*载入存档中的状态*/
				command_result='g';
				break;
			case 'd':
				/*删除存档*/
				break;
			case 'q':
				exit(EXIT_SUCCESS);
		}
	}while(command_result!='g');
	delwin(start_rank_win);
	draw_base_window();
//游戏界面
//现在select_win作为游戏窗口
	WINDOW *instructions_win=newwin(WINDOW_HEIGHT/2,WINDOW_WIDTH,(LINES-WINDOW_HEIGHT)/2,COLS/2+3);
	WINDOW *status_win=newwin(WINDOW_HEIGHT/2,WINDOW_WIDTH,LINES/2,COLS/2+3);
	draw_select_window(instructions_win,instructions,-1,1,WINDOW_WIDTH/4);

	init_keyboard(select_win);

	while(true)
	{
		timeout(SPEED_MAX-(Current_len/35)*50);//改变速度
		draw_status_window(status_win,name);
		draw_snake_window(select_win,greedy,f);
		if(Isover(greedy))
		{
			end_game(select_win,"Game Over!");
			break;
		}
		if(Iswin())
		{
			end_game(select_win,"You Win!");
			break;
		}
		if(Eatfood(greedy,f))
		{
			Createfood(&f);
			eatedfood=true;
		}
		get_key(&d);
		update_snake(greedy,d,&eatedfood);
	}

	close_keyboard(select_win);

	delwin(select_win);
	delwin(instructions_win);
	delwin(status_win);


	endwin();
	destory_status(greedy);
	exit(EXIT_SUCCESS);
}
