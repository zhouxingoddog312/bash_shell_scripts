#ifndef _DATA_H
#define _DATA_H

#include <curses.h>
#include <stdbool.h>
#include <ndbm.h>
#define WINDOW_WIDTH 40
#define WINDOW_HEIGHT 20
#define TOTLE_POINT (18*38)

#define VERSION ("1.00")

typedef struct
{
	int x;
	int y;
}node;
typedef node food;
typedef node *snake;

//存档数据和得分榜数据处理函数



//游戏逻辑函数

/*开始界面所用函数*/
int command_mode(int argc,char *argv[]);
void draw_menu(char *options[],int current_highlight,int start_row,int start_col);



#endif
