#ifndef _DATA_H
#define _DATA_H

#include <unistd.h>
#include <curses.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <gdbm.h>
#include <getopt.h>
#include <stdio.h>
#define WINDOW_WIDTH 40
#define WINDOW_HEIGHT 20
#define TOTLE_POINT ((WINDOW_WIDTH-2)*(WINDOW_HEIGHT-2))
#define SPEED_MAX 1000
#define STR_LEN 38
#define MAX_RANK_RECORD 9

#define RANK_FILE "rank.db"
#define SAVEDATA_FILE "save_data.db"

#define VERSION ("1.00")


typedef struct
{
	int x;
	int y;
}node;
typedef node food;
typedef node direct;
typedef node *snake;

typedef struct
{
	snake save_greedy[TOTLE_POINT];
	char save_name[STR_LEN];
	food save_f;
	direct save_d;
}save_data_entry;
typedef struct
{
	char rank_name[STR_LEN];
	int rank_point;
}rank_entry;
//数据库函数
int rank_db_init(bool new_database);
void rank_db_close(void);
rank_entry get_rank_entry(int index);
void add_rank_entry(rank_entry entry_add,int index);


//得分榜数据处理函数
void print_rank(WINDOW *win_ptr);

//存档数据处理函数




//游戏逻辑函数
void init_status(WINDOW *win_ptr,direct *d_ptr,food *f_ptr,snake greedy,bool Map[][WINDOW_WIDTH-2],char *name,int *Current_len);
void destory_status(snake greedy);
void end_game(WINDOW *win_ptr,char *string);
//用于参数模式的函数
int command_mode(int argc,char *argv[],bool *Cheat);

//用于开始界面的函数
void draw_base_window(void);
void draw_select_window(WINDOW *win_ptr,char *options[],int current_highlight,int start_row,int start_col);
void clear_start_screen(void);
int getchoice(WINDOW *win_ptr,char *choices[]);

//用于游戏界面的函数
void Checkmap(snake greedy,int Current_len,bool Map[][WINDOW_WIDTH-2]);
void draw_snake_window(WINDOW *win_ptr,snake greedy,food f1,int Current_len);
void draw_status_window(WINDOW *win_ptr,char *name,int Current_len);
void update_snake(snake greedy,direct d,int *Current_len,bool Map[][WINDOW_WIDTH-2],bool *eated);
void init_keyboard(WINDOW *w_ptr);
void get_key(direct *d);
void close_keyboard(WINDOW *w_ptr);
bool Eatfood(snake greedy,food f1);
bool Isover(snake greedy,int Current_len);
bool Iswin(int Current_len);
void Createfood(food *fd,int Current_len,bool Map[][WINDOW_WIDTH-2]);
#endif
