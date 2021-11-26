#define _GNU_SOURCE
#include "data.h"

//用于参数模式的函数声明
static void version(void);
static void help(void);
static void opt_error(char c);

//用于开始界面的函数声明


//用于参数模式的函数定义
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
//用于游戏逻辑的函数定义
void init_status(WINDOW *win_ptr,direct *d_ptr,food *f_ptr,snake greedy,char *name)
{
	char *prompt[]=
	{
		"enter your name: ",
		0
	};
	extern int Current_len;
	int seed;
	seed=rand()%4;
	switch(seed)//随机产生初始方向
	{
		case 0:
			d_ptr->x=0;
			d_ptr->y=-1;
			break;
		case 1:
			d_ptr->x=0;
			d_ptr->y=1;
			break;
		case 2:
			d_ptr->x=-1;
			d_ptr->y=0;
			break;
		case 3:
			d_ptr->x=1;
			d_ptr->y=0;
			break;
	}
	Current_len=0;
	Checkmap(greedy);
	while(true)//产生一个不靠边框的蛇头
	{
		Createfood(&greedy[0]);
		if(greedy[0].x>1&&greedy[0].x<COLS-2&&greedy[0].y>1&&greedy[0].y<LINES-2)
			break;
	}
	greedy[1].x=greedy[0].x-d_ptr->x;
	greedy[1].y=greedy[0].y-d_ptr->y;
	Current_len=2;
	Checkmap(greedy);
	Createfood(f_ptr);
	move(LINES-2,1);
	clrtoeol();
	mvprintw(LINES-2,1,"touch enter to save your name.");
	refresh();
	draw_select_window(win_ptr,prompt,-1,WINDOW_HEIGHT/2-1,WINDOW_WIDTH/2-10);
	wgetnstr(win_ptr,name,STR_LEN-1);
}
void destory_status(snake greedy)
{
	free(greedy);
}
void end_game(WINDOW *win_ptr,char *string)
{
	wclear(win_ptr);
	box(win_ptr,ACS_VLINE,ACS_HLINE);
	mvwprintw(win_ptr,WINDOW_HEIGHT/2-1,WINDOW_WIDTH/2-10,"%s",string);
	wrefresh(win_ptr);
	/*存储得分榜*/
	sleep(2);
}
//用于开始界面的函数定义
void draw_base_window(void)
{
	clear();
	box(stdscr,ACS_VLINE,ACS_HLINE);
	mvprintw(1,COLS/2-7,"%s","Greedy Snake");
	refresh();
}
void draw_select_window(WINDOW *win_ptr,char *options[],int current_highlight,int start_row,int start_col)
{/*不想有高亮显示时将current_highlight设为-1*/
	wclear(win_ptr);
	box(win_ptr,ACS_VLINE,ACS_HLINE);
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
	wrefresh(win_ptr);
}
void clear_start_screen(void)
{
	clear();
	mvprintw(1,COLS/2-7,"%s","Greedy Snake");
	refresh();
}
int getchoice(WINDOW *win_ptr,char *choices[])
{
	static int selected_row=0;
	int max_row=0;
	int start_screenrow=WINDOW_HEIGHT/2-5,start_screencol=WINDOW_WIDTH/2-6;
	char **options;
	int selected;
	int key=0;
	options=choices;
	mvprintw(LINES-2,1,"Move highlight then press enter");
	refresh();
	while(*options)
	{
		max_row++;
		options++;
	}
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
		draw_select_window(win_ptr,choices,selected_row,start_screenrow,start_screencol);
		key=getch();
	}
	keypad(stdscr,false);
	nocbreak();
	echo();
	return selected;
}


//用于游戏界面的函数定义
void draw_snake_window(WINDOW *win_ptr,snake greedy,food f1)
{
	extern int Current_len;
	wclear(win_ptr);
	box(win_ptr,ACS_VLINE,ACS_HLINE);
	mvwaddch(win_ptr,f1.y,f1.x,'@');
	for(int i=Current_len-1;i>=0;i--)
	{
		if(i==0)
			mvwaddch(win_ptr,greedy[i].y,greedy[i].x,'#');
		else
			mvwaddch(win_ptr,greedy[i].y,greedy[i].x,'*');
	}
	wrefresh(win_ptr);
}
void draw_status_window(WINDOW *win_ptr,char *name)
{
	extern int Current_len;
	int score=Current_len;
	char speed_string[STR_LEN];
	char score_string[STR_LEN];
	sprintf(score_string,"Current Score = %d",score);
	sprintf(speed_string,"Current Speed level = %d",(Current_len/35));
	wclear(win_ptr);
	box(win_ptr,ACS_VLINE,ACS_HLINE);
	mvwprintw(win_ptr,WINDOW_HEIGHT/9,WINDOW_WIDTH/4,"Hello %s",name);
	mvwprintw(win_ptr,WINDOW_HEIGHT/5,WINDOW_WIDTH/4,"%s",score_string);
	mvwprintw(win_ptr,WINDOW_HEIGHT/3,WINDOW_WIDTH/4,"%s",speed_string);
	wrefresh(win_ptr);
}
void Checkmap(snake greedy)
{
	extern bool Map[WINDOW_HEIGHT-2][WINDOW_WIDTH-2];
	extern int Current_len;
	int index_x,index_y,i;
	for(index_y=0;index_y<WINDOW_HEIGHT-2;index_y++)
		for(index_x=0;index_x<WINDOW_WIDTH-2;index_x++)
			Map[index_y][index_x]=true;
	for(i=0;i<Current_len;i++)
	{
		Map[greedy[i].y-1][greedy[i].x-1]=false;
	}

}
void update_snake(snake greedy,direct d,bool *eated)
{
	extern bool Map[WINDOW_HEIGHT-2][WINDOW_WIDTH-2];
	extern int Current_len;
	int i;
	if(*eated)
	{
		Current_len++;
		*eated=false;
	}
	node temp;
	temp=greedy[0];
	temp.x+=d.x;
	temp.y+=d.y;
	for(i=Current_len-1;i>0;i--)
	{
		greedy[i]=greedy[i-1];
	}
	greedy[0]=temp;
	Checkmap(greedy);
}
void init_keyboard(WINDOW *w_ptr)
{
	keypad(stdscr,true);
	noecho();
	cbreak();
	leaveok(w_ptr,true);
	timeout(SPEED_MAX);
}
void get_key(direct *d)
{
	int key;
	if((key=getch())!=ERR)
		{
			switch(key)
			{
				case 'A':
				case 'a':
				case KEY_LEFT:
					if(d->x!=1)
					{
						d->x=-1;
						d->y=0;
					}
					break;
				case 'D':
				case 'd':
				case KEY_RIGHT:
					if(d->x!=-1)
					{
						d->x=1;
						d->y=0;
					}
					break;
				case 'W':
				case 'w':
				case KEY_UP:
					if(d->y!=1)
					{
						d->x=0;
						d->y=-1;
					}
					break;
				case 'S':
				case 's':
				case KEY_DOWN:
					if(d->y!=-1)
					{
						d->x=0;
						d->y=1;
					}
					break;
			}
		}
}
void close_keyboard(WINDOW *w_ptr)
{
	keypad(stdscr,false);
	echo();
	timeout(-1);
	nocbreak();
	leaveok(w_ptr,false);
}
bool Eatfood(snake greedy,food f1)
{
	if(greedy[0].x==f1.x&&greedy[0].y==f1.y)
		return true;
	else
		return false;
}
bool Isover(snake greedy)
{
	extern int Current_len;
	bool flag=false;
	if(greedy[0].x==0||greedy[0].x==(WINDOW_WIDTH-1)||greedy[0].y==0||greedy[0].y==(WINDOW_HEIGHT-1))
		flag=true;
	for(int i=1;i<Current_len;i++)
	{
		if(greedy[0].x==greedy[i].x&&greedy[0].y==greedy[i].y)
			flag=true;
	}
	return flag;
}
bool Iswin(void)
{
	extern int Current_len;
	if(Current_len==TOTLE_POINT)
		return true;
	else
		return false;
}
void Createfood(food *fd)
{
	int index_x=0,index_y=0;
	extern bool Map[WINDOW_HEIGHT-2][WINDOW_WIDTH-2];
	extern int Current_len;
	int residue=TOTLE_POINT-Current_len;
	int count=0;
	count=rand()%residue+1;
	while(count!=0)
	{
		if(Map[index_y][index_x])
			count--;
		if(index_x==WINDOW_WIDTH-3)
		{
			index_y++;
			index_x=0;
		}
		else
			index_x++;
	}
	fd->x=index_x+1;
	fd->y=index_y+1;
}
