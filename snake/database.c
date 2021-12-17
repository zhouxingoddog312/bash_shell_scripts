#include "data.h"
static GDBM_FILE rank_db_ptr=NULL;
static GDBM_FILE savedata_db_ptr=NULL;
static int cmprank(const void *p1,const void *p2);




static int cmprank(const void *p1,const void *p2)
{
	return (*(rank_entry *)p2).rank_point-(*(rank_entry *)p1).rank_point;
}
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
	int count;
	int index=0;
	int startrow=2;
	int startcol=8;
	gdbm_count(rank_db_ptr,(gdbm_count_t *)&count);
	for(index=1;index<=count;index++)
	{
		temp_data=get_rank_entry(index);
		sprintf(rank_list[index-1],"%d -- name:%s\tscore:%d",index,temp_data.rank_name,temp_data.rank_point);
	}
	if(count==0)
		mvwprintw(win_ptr,WINDOW_HEIGHT/2,startcol,"There are no rank list.");
	else
	{
		for(int i=0;i<count;i++)
		{
			mvwprintw(win_ptr,startrow,startcol,"%s",rank_list[i]);
			startrow+=2;
		}
	}
	wrefresh(win_ptr);
}
void save_rank(char *name,int point)
{
	int count;
	int index=0;
	datum key,data;
	rank_entry *array;
	rank_entry temp;
	strncpy(temp.rank_name,name,STR_LEN);
	temp.rank_point=point;
	gdbm_count(rank_db_ptr,(gdbm_count_t *)&count);
	if(count<MAX_RANK_RECORD)
		count+=1;
	else
		count=MAX_RANK_RECORD;
	array=malloc(sizeof(rank_entry)*count);

	key=gdbm_firstkey(rank_db_ptr);
	while(key.dptr!=NULL)
	{
		data=gdbm_fetch(rank_db_ptr,key);
		memcpy(&array[index],data.dptr,data.dsize);
		index++;
		key=gdbm_nextkey(rank_db_ptr,key);
	}
	array[count-1]=temp;
	qsort(array,count,sizeof(rank_entry),cmprank);
	rank_db_init(true);
	for(index=0;index<count;index++)
	{
		add_rank_entry(array[index],index+1);
	}

	rank_db_close();
}
//存档数据处理函数
int save_db_init(bool new_database)
{
	if(savedata_db_ptr)
		gdbm_close(savedata_db_ptr);
	if(new_database)
		unlink(SAVEDATA_FILE);
	savedata_db_ptr=gdbm_open(SAVEDATA_FILE,0,GDBM_WRCREAT|GDBM_SYNC,00640,NULL);
	if(savedata_db_ptr==NULL)
	{
		fprintf(stderr,"Can not open savedata database,\n%s\n",gdbm_strerror(gdbm_errno));
		return 0;
	}
	return 1;

}
void save_db_close(void)
{
	if(savedata_db_ptr)
		gdbm_close(savedata_db_ptr);
	savedata_db_ptr=NULL;
}
save_entry get_save_entry(int index)
{
	save_entry entry_to_return;
	datum key,data;
	memset(&entry_to_return,'\0',sizeof(save_entry));
	key.dptr=(void *)&index;
	key.dsize=sizeof(int);
	data=gdbm_fetch(savedata_db_ptr,key);
	if(data.dptr)
		memcpy(&entry_to_return,data.dptr,data.dsize);
	return entry_to_return;
}
void add_save_entry(save_entry entry_add,int index)
{
	datum key,data;
	data.dptr=(void *)&entry_add;
	data.dsize=sizeof(entry_add);
	key.dptr=(void *)&index;
	key.dsize=sizeof(index);
	gdbm_store(savedata_db_ptr,key,data,GDBM_INSERT);
}
void force_add_save_entry(save_entry entry_add,int index)
{
	datum key,data;
	data.dptr=(void *)&entry_add;
	data.dsize=sizeof(entry_add);
	key.dptr=(void *)&index;
	key.dsize=sizeof(index);
	gdbm_store(savedata_db_ptr,key,data,GDBM_REPLACE);
}
void del_save_entry(int index)
{
	int flag;
	key.dptr=(void *)&index;
	key.dsize=sizeof(int);
	flag=gdbm_delete(savedata_db_ptr,key);
	if(flag)
	{
		move(LINES-2,1);
		clrtoeol();
		mvprintw(LINES-2,1,"%s",gdbm_strerror(gdbm_errno));
	}
}
bool save_isfull(void)
{
	int count,flag;
	flag=gdbm_count(rank_db_ptr,(gdbm_count_t *)&count);
	if(!flag&&(count>=MAX_RANK_RECORD))
		return true;
	else
		return false;
}
bool save_isempty(void)
{
	int count,flag;
	flag=gdbm_count(rank_db_ptr,(gdbm_count_t *)&count);
	if(!flag&&(count>0))
		return false;
	else
		return true;
}
