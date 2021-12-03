#include "data.h"
static GDBM_FILE rank_db_ptr=NULL;
static GDBM_FILE savedata_db_ptr=NULL;
//存档数据和得分榜数据处理函数
int rank_db_init(bool new_database)
{
	if(rank_db_ptr)
		gdbm_close(rank_db_ptr);
	if(new_database)
		unlink(RANK_FILE);
	rank_db_ptr=gdbm_open(RANK_FILE,0,GDBM_WRCREAT|GDBM_SYNC,S_IRUSR|S_IWUSR,NULL);
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
