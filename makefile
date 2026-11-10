MTCP_DIR = \mtcp\src
TCP_H_DIR = $(MTCP_DIR)\TCPINC
TCP_C_DIR = $(MTCP_DIR)\TCPLIB
COMMON_H_DIR = $(MTCP_DIR)\INCLUDE

MEMORY_MODEL = -ms
CFLAGS = $(MEMORY_MODEL) @cflags.rsp
CFLAGS += -i=$(TCP_H_DIR) -i=$(COMMON_H_DIR)

OBJ_DIR = o

MTCP_OBJS = $(OBJ_DIR)\packet.obj &
            $(OBJ_DIR)\dns.obj    &
            $(OBJ_DIR)\arp.obj    &
            $(OBJ_DIR)\eth.obj    &
            $(OBJ_DIR)\ip.obj     &
            $(OBJ_DIR)\udp.obj    &
            $(OBJ_DIR)\utils.obj  &
            $(OBJ_DIR)\timer.obj  &
            $(OBJ_DIR)\ipasm.obj  &
            $(OBJ_DIR)\trace.obj
OBJS = $(OBJ_DIR)\dbipx.obj &
       $(OBJ_DIR)\dali.obj  &
       $(OBJ_DIR)\ipx.obj   &
       $(OBJ_DIR)\ints.obj

all : dali.exe

clean : .symbolic
	@del dali.exe
	@del $(OBJ_DIR)\*.obj
	@del *.map

.asm : $(TCP_C_DIR)

.cpp : $(TCP_C_DIR)

.asm.obj :
	wasm -0 $(MEMORY_MODEL) -fo$@ $[*

.cpp.obj :
	wpp $[* -fo$@ $(CFLAGS)

.c.obj
	wcc $[* -fo$@ $(CFLAGS)

dali.exe : $(MTCP_OBJS) $(OBJS)
	wlink system dos option map option eliminate option stack=4096 name $@ file $(OBJ_DIR)\*.obj

