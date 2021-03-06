MTCP_DIR = \mtcp
TCP_H_DIR = $(MTCP_DIR)\TCPINC
TCP_C_DIR = $(MTCP_DIR)\TCPLIB
COMMON_H_DIR = $(MTCP_DIR)\INCLUDE

MEMORY_MODEL = -ms
CFLAGS = $(MEMORY_MODEL) @cflags.rsp
CFLAGS += -i=$(TCP_H_DIR) -i=$(COMMON_H_DIR)

MTCP_OBJS = packet.obj dns.obj arp.obj eth.obj ip.obj udp.obj utils.obj timer.obj ipasm.obj trace.obj
OBJS = dbipx.obj dali.obj ipx.obj ints.obj

all : dali.exe

clean : .symbolic
	@del dali.exe
	@del *.obj
	@del *.map

.asm : $(TCP_C_DIR)

.cpp : $(TCP_C_DIR)

.asm.obj :
	wasm -0 $(MEMORY_MODEL) $[*

.cpp.obj :
	wpp $[* $(CFLAGS)

.c.obj
	wcc $[* $(CFLAGS)

dali.exe : $(MTCP_OBJS) $(OBJS)
	wlink system dos option map option eliminate option stack=4096 name $@ file *.obj

