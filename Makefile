CFLAGS=-g -Wall -O2 `pkg-config --cflags libavcodec libavformat libavutil libswscale sdl`
LIBS=`pkg-config --libs libavcodec libavformat libavutil libswscale sdl`

BUILD_DIR=build

all: libSimpleAV.a saplayer-old

libSimpleAV.a: $(BUILD_DIR)/SAMutex.o $(BUILD_DIR)/SAQueue.o $(BUILD_DIR)/SimpleAV.o
	ar cr libSimpleAV.a $(BUILD_DIR)/SAMutex.o $(BUILD_DIR)/SAQueue.o $(BUILD_DIR)/SimpleAV.o

$(BUILD_DIR)/SAMutex.o: SimpleAV.h SAMutex.c
	gcc $(CFLAGS) -fPIC -c SAMutex.c -o $(BUILD_DIR)/SAMutex.o

$(BUILD_DIR)/SAQueue.o: SimpleAV.h SAQueue.c
	gcc $(CFLAGS) -fPIC -c SAQueue.c -o $(BUILD_DIR)/SAQueue.o

$(BUILD_DIR)/SimpleAV.o: SimpleAV.c SimpleAV.h
	gcc $(CFLAGS) -fPIC -c SimpleAV.c -o $(BUILD_DIR)/SimpleAV.o

saplayer-old: $(BUILD_DIR)/saplayer-old.o libSimpleAV.a
	gcc $(LIBS) -o saplayer-old $(BUILD_DIR)/saplayer-old.o libSimpleAV.a

$(BUILD_DIR)/saplayer-old.o: SimpleAV.h saplayer-old.c
	gcc $(CFLAGS) -c saplayer-old.c -o $(BUILD_DIR)/saplayer-old.o

### install & uninstall & clean up

install:
	mkdir -p /usr/local/lib /usr/local/include /usr/local/bin
	cp libSimpleAV.a /usr/local/lib
	cp SimpleAV.h /usr/local/include
	cp saplayer-old /usr/local/bin

uninstall:
	rm /usr/local/lib/libSimpleAV.a
	rm /usr/local/include/SimpleAV.h
	rm /usr/local/bin/saplayer-old

clean:
	rm $(BUILD_DIR)/*
