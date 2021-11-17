#define _GNU_SOURCE
#include <getopt.h>
#include <stdio.h>
#include "data.h"


static void version(void);
static void help(void);
static void opt_error(char c);


//作为参数模式的函数
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

//用于开始界面的函数
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
void draw_menu(char *options[],int current_highlight,int start_row,int start_col)
{
	int current_row=0;
	char **option_ptr;
	char *txt_ptr;
	option_ptr=options;
	while(*option_ptr)
	{
		if(current_row==current_highlight)
			attron(A_STANDOUT);
		txt_ptr=options[current_row];
		mvprintw(start_row+current_row*2,start_col,"%s",txt_ptr);
		if(current_row==current_highlight)
			attroff(A_STANDOUT);
		current_row++;
		option_ptr++;
	}
	mvprintw(LINES-2,1,"Move highlight then press enter");
	refresh();
}
