#include <unistd.h>
#include <stdlib.h>
#include <stdbool.h>

#include "data.h"

bool Cheat=false;
int Current_len=2;
bool Map[WINDOW_HEIGHT-2][WINDOW_WIDTH-2]={{false}};
int main(int argc,char *argv[])
{
	direct d={1,0};
	snake greedy=malloc(sizeof(food)*TOTLE_POINT);
	greedy[0].x=2;
	greedy[0].y=1;
	greedy[1].x=1;
	greedy[1].y=1;
	food f={3,3};
//参数处理
	int command_result;
	if(argc>1)
	{
		command_result=command_mode(argc,argv);
		if(command_result)
			exit(command_result);
	}
	initscr();
	box(stdscr,ACS_VLINE,ACS_HLINE);
	mvprintw(1,COLS/2-7,"%s","Greedy Snake");
	refresh();
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
//开始界面
	WINDOW *start_rank_win=newwin(WINDOW_HEIGHT,WINDOW_WIDTH,(LINES-WINDOW_HEIGHT)/2,COLS/2+3);
	WINDOW *select_win=newwin(WINDOW_HEIGHT,WINDOW_WIDTH,2,6);
	box(start_rank_win,ACS_VLINE,ACS_HLINE);
	box(select_win,ACS_VLINE,ACS_HLINE);
	draw_select_window(start_rank_win,start_menu,-1,1,1);
	do
	{
		command_result=getchoice(select_win,start_menu);
		switch(command_result)
		{
			case 'n':
				/*设置新的初始状态*/
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
	clear();
	box(stdscr,ACS_VLINE,ACS_HLINE);
	mvprintw(1,COLS/2-7,"%s","Greedy Snake");
	refresh();

//游戏界面，现在select_win作为游戏窗口
	WINDOW *instructions_win=newwin(WINDOW_HEIGHT/2,WINDOW_WIDTH,(LINES-WINDOW_HEIGHT)/2,COLS/2+3);
	WINDOW *status_win=newwin(WINDOW_HEIGHT/2,WINDOW_WIDTH,LINES/2,COLS/2+3);
	box(instructions_win,ACS_VLINE,ACS_HLINE);
	box(status_win,ACS_VLINE,ACS_HLINE);
	draw_select_window(instructions_win,instructions,-1,1,1);

	while(true)
	{
		draw_status_window(status_win,1.0003);
		draw_snake_window(select_win,greedy,f);
		update_snake(greedy,d);
		usleep(100000);
	}
	getchar();
	delwin(select_win);
	delwin(instructions_win);
	delwin(status_win);


	endwin();
	exit(EXIT_SUCCESS);
}
