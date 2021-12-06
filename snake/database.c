#include "data.h"
static GDBM_FILE rank_db_ptr=NULL;
static GDBM_FILE savedata_db_ptr=NULL;
//得分榜数据处理函数
int rank_db_init(bool new_database)
{
	if(rank_db_ptr)
		gdbm_close(rank_db_ptr);
	if(new_database)
		unlink(RANK_FILE);
	rank_db_ptr=gdbm_open(RANK_FILE,0,GDBM_WRCREAT|GDBM_SYNC,00640,NULL);
	if(rank_db_ptr==NULL)
	{
		fprintf(stderr,"Can not open rank database,\n%s\n",gdbm_strerror(gdbm_errno));
		return 0;
	}
	return 1;
}
void rank_db_close(void)
{
	if(rank_db_ptr)
		gdbm_close(rank_db_ptr);
	rank_db_ptr=NULL;
}
rank_entry get_rank_entry(int index)
{
	rank_entry entry_to_return;
	datum key,data;
	memset(&entry_to_return,'\0',sizeof(rank_entry));
	key.dptr=(void *)&index;
	key.dsize=sizeof(int);
	data=gdbm_fetch(rank_db_ptr,key);
	if(data.dptr)
		memcpy(&entry_to_return,data.dptr,data.dsize);
	return entry_to_return;
}
void add_rank_entry(rank_entry entry_add,int index)
{
	datum key,data;
	data.dptr=(void *)&entry_add;
	data.dsize=sizeof(entry_add);
	key.dptr=(void *)&index;
	key.dsize=sizeof(index);
	gdbm_store(rank_db_ptr,key,data,GDBM_INSERT);
}
void print_rank(WINDOW *win_ptr)
{
	wclear(win_ptr);
	box(win_ptr,ACS_VLINE,ACS_HLINE);

	char rank_list[MAX_RANK_RECORD][STR_LEN];

	rank_entry temp_data;
	int temp_key;
	int index=0;
	int startrow=1;
	datum key,data;
	key=gdbm_firstkey(rank_db_ptr);
	while(key.dptr!=NULL)
	{
		data=gdbm_fetch(rank_db_ptr,key);
		memcpy(&temp_data,data.dptr,data.dsize);
		memcpy(&temp_key,key.dptr,key.dsize);
		sprintf(rank_list[index],"%d %s %d",temp_key,temp_data.rank_name,temp_data.rank_point);
		index++;
		key=gdbm_nextkey(rank_db_ptr,key);
	}
	if(index==0)
		mvwprintw(win_ptr,WINDOW_HEIGHT/2,1,"There are no rank list.");
	else
	{
		for(int i=0;i<index;i++)
		{
			mvwprintw(win_ptr,startrow,1,"%s",rank_list[i]);
			startrow+=2;
		}
	}
	wrefresh(win_ptr);
}
//存档数据处理函数
