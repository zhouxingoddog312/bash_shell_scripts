.PHONY:all debug install clean
LDFLAGS=-lcurses
INCLUDE=-I/usr/include/gdbm


all:

main:
	$(CC) $(INCLUDE) main.c frontend.c $(LDFLAGS) -o $@

debug:
	$(CC) -g $(INCLUDE) main.c frontend.c $(LDFLAGS) -o $@
install:

clean:
	$(RM) a.out main debug
