.PHONY:all debug install clean
LDFLAGS=-lcurses -lgdbm
INCLUDE=-I/usr/local/include -L/usr/local/lib


all:

main:
	$(CC) $(INCLUDE) main.c frontend.c database.c $(LDFLAGS) -o $@

debug:
	$(CC) -g $(INCLUDE) main.c frontend.c database.c $(LDFLAGS) -o $@
install:

clean:
	$(RM) a.out main debug rank.db
