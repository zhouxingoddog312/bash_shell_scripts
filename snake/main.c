#include <unistd.h>
#include <stdlib.h>
#include <stdbool.h>

#include "data.h"

bool Cheat=false;
int Current_len=2;
bool Map[WINDOW_HEIGHT-2][WINDOW_WIDTH-2]={{false}};
int main(int argc,char *argv[])
{
	int command_result;
	if(argc>1)
	{
		command_result=command_mode(argc,argv);
		if(command_result)
			exit(command_result);
	}
	initscr();
	box(stdscr,ACS_VLINE,ACS_HLINE);
	clear_start_screen();
	char *start_menu[]=
	{
		"new game",
		"load game",
		"delete data",
		"quit",
		0
	};
//开始界面
	WINDOW *start_rank_win=newwin(WINDOW_HEIGHT,WINDOW_WIDTH,(LINES-WINDOW_HEIGHT)/2,COLS/2+3);
	WINDOW *select_win=newwin(WINDOW_HEIGHT,WINDOW_WIDTH,2,6);
	box(start_rank_win,ACS_VLINE,ACS_HLINE);
	box(select_win,ACS_VLINE,ACS_HLINE);
	draw_subwin(start_rank_win,start_menu,1,1);
	do
	{
		command_result=getchoice(select_win,start_menu);
		switch(command_result)
		{
			case 'n':
				mvprintw(LINES-1,1,"new");
				refresh();
				/*设置新的初始状态*/
				command_result='g';
				break;
			case 'l':
				mvprintw(LINES-1,1,"load");
				refresh();
				/*载入存档中的状态*/
				command_result='g';
				break;
			case 'd':
				mvprintw(LINES-1,1,"delete");
				refresh();
				/*删除存档*/
				break;
			case 'q':
				mvprintw(LINES-1,1,"quit");
				refresh();
				getchar();
				//exit(EXIT_SUCCESS);
		}
	}while(command_result!='g');

	getchar();
	delwin(start_rank_win);
	endwin();
	exit(0);
}
