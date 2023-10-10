default0: compile stream_temp.s

override JFLAGS += -arch arm-m4
SRCS := stream.jazz
include ../../../../../Makefile.common

stream_temp.s: stream_temp.c
	$(CC) $(CFLAGS) -S -o $@ $<
