#define _GNU_SOURCE
#include <getopt.h>
#include <stdio.h>
#include "data.h"

//用于参数模式的函数
static void version(void);
static void help(void);
static void opt_error(char c);

//用于开始界面的函数


//用于参数模式的函数
static void version(void)
{
	fprintf(stdout,"greedy snake version %s\n",VERSION);
}
static void help(void)
{
	fprintf(stdout,"Usage: snake [options]\n");
	fprintf(stdout,"Options:\n");
	fprintf(stdout,"\t-v/--version\tdisplay the version information\n");
	fprintf(stdout,"\t-h/--help\tdisplay the help information\n");
	fprintf(stdout,"\t-i/--init\tinitialize the ranking list\n");
	fprintf(stdout,"\t-c/--cheat\tinto the cheat mode, you will not die until got full marks\n");
}
static void opt_error(char c)
{
	fprintf(stderr,"unknown option: %c\nplease use snake --help to get more information\n",c);
}
static void cheat(void)
{
	extern bool Cheat;
	Cheat=true;
}
int command_mode(int argc,char *argv[])
{
	extern bool Cheat;
	int result=0,opt;
	struct option longopts[]=
	{
		{"version",0,NULL,'v'},
		{"help",0,NULL,'h'},
		{"init",0,NULL,'i'},
		{"cheat",0,NULL,'c'},
		{0,0,0,0}
	};
	while((opt=getopt_long(argc,argv,":vhic",longopts,NULL))!=-1)
	{
		switch(opt)
		{
			case 'v':
				version();
				result=1;
				break;
			case 'h':
				help();
				result=1;
				break;
			case 'i':
				/*删除旧的得分榜数据库文件，创建新的*/
				result=0;
				break;
			case 'c':
				cheat();
				result=0;
				break;
			case '?':
				opt_error(optopt);
				result=2;
				break;
		}
	}
	return result;
}


//用于开始界面的函数
void draw_select_menu(WINDOW *win_ptr,char *options[],int current_highlight,int start_row,int start_col)
{
	int current_row=0;
	char **option_ptr;
	char *txt_ptr;
	option_ptr=options;
	while(*option_ptr)
	{
		if(current_row==current_highlight)
			wattron(win_ptr,A_STANDOUT);
		txt_ptr=options[current_row];
		mvwprintw(win_ptr,start_row+current_row*2,start_col,"%s",txt_ptr);
		if(current_row==current_highlight)
			wattroff(win_ptr,A_STANDOUT);
		current_row++;
		option_ptr++;
	}
	mvprintw(LINES-2,1,"move highlight to select");
	refresh();
	wrefresh(win_ptr);
}
void draw_subwin(WINDOW *win_ptr,char *strings[],int start_row,int start_col)
{
	int current_row=0;
	char **option_ptr;
	char *txt_ptr;
	option_ptr=strings;
	while(*option_ptr)
	{
		txt_ptr=strings[current_row];
		mvwprintw(win_ptr,start_row+current_row,start_col,"%s",txt_ptr);
		current_row++;
		option_ptr++;
	}
	wrefresh(win_ptr);
}
void clear_start_screen(void)
{
	clear();
	mvprintw(1,COLS/2-2,"%s","Greedy Snake");
	refresh();
}
int getchoice(WINDOW *win_ptr,char *choices[])
{
	static int selected_row=0;
	int max_row=0;
	int start_screenrow=6,start_screencol=2;
	char **options;
	int selected;
	int key=0;
	options=choices;
	while(*options)
	{
		max_row++;
		options++;
	}
	//clear_start_screen();
	keypad(stdscr,true);
	cbreak();
	noecho();
	while(key!=KEY_ENTER&&key!='\n')
	{
		if(key==KEY_UP)
		{
			if(selected_row==0)
				selected_row=max_row-1;
			else
				selected_row--;
		}
		if(key==KEY_DOWN)
		{
			if(selected_row==max_row-1)
				selected_row=0;
			else
				selected_row++;
		}
		selected=*choices[selected_row];
		draw_select_menu(win_ptr,choices,selected_row,start_screenrow,start_screencol);
		key=getch();
	}
	keypad(stdscr,false);
	nocbreak();
	echo();
	return selected;
}
