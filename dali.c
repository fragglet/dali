
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <dos.h>
#include <malloc.h>
#include <process.h>

#include "ipx.h"
#include "dbipx.h"

#define DEFAULT_IPX_PORT  213  /* as used by DOSbox */

#pragma pack(__push, 1)
struct mcb {
	char flag;
	unsigned int owner;
	unsigned int size;
};
#pragma pack(__pop)

static void TerminateAndStayResident(int exitcode, size_t heap_size)
{
	struct mcb far *m;
	void *a;

	// Compact the heap to its minimum size, while keeping a block
	// allocated of the size that we want to retain for the heap
	// after we invoke the TSR system call.
	a = malloc(heap_size);
	_heapmin();
	free(a);

	// DOS's memory manager is based around MCBs that delimit the memory
	// blocks assigned to particular programs/TSRs. The MCB header is
	// located 16 bytes before the Program Segment Prefix. So we peek into
	// the MCB header to find the number of paragraphs of memory currently
	// allocated to us. This becomes the amount we pass to _dos_keep.
	m = MK_FP(_psp - 1, 0);
	_dos_keep(0, m->size);
}

static void UnloadTSR(void)
{
	unsigned int psp;
	int r;

	switch (UnhookIPXVectors(&psp)) {
		case IPX_UNLOAD_NOT_LOADED:
			fprintf(stderr, "Error: driver is not loaded.\n");
			exit(1);
		case IPX_UNLOAD_BLOCKED:
			fprintf(stderr,
"Error: Failed to unload driver. Other TSRs may have been loaded on top\n"
"of this driver and are blocking it from being unloaded. Try unloading\n"
"any other TSRs on your system and trying again.\n");
			exit(1);
		case IPX_UNLOAD_SUCCESS:
			break;
	}

	// The driver successfully unhooked all its interrupt vectors and
	// is no longer running. All that now remains is to release the
	// memory range it was using.
	r = _dos_freemem(psp);
	if (r != 0) {
		fprintf(stderr, "Error %d freeing TSR memory.\n", r);
		exit(1);
	}
	printf("Driver unloaded successfully.\n");
	exit(0);
}

int main(int argc, char *argv[])
{
	char *addr;
	int port;

	if (argc == 2 && !strcmp(argv[1], "/u")) {
		UnloadTSR();
	}

	if (argc < 2) {
		printf(
"Dali v0.3 - driver to connect to a DOSbox IPX server.\n\n"
"Usage:\n"
"    %s <addr> [port]  -- Connect to given address\n"
"    %s /u             -- Disconnect and unload\n\n"
"You must configure mTCP first. Please read the included documentation\n"
"in the file connect.bat for details.\n", argv[0], argv[0]);
		exit(1);
	}

	if (getenv("MTCPCFG") == NULL) {
		fprintf(stderr,
"Error: Environment variable MTCPCFG is not set to contain the path to\n"
"an mTCP configuration file. Instead of running this directly, consider\n"
"running connect.bat which will take care of this and other steps.\n");
		exit(1);
	}

	if (argc == 2) {
		port = DEFAULT_IPX_PORT;
	} else {
		port = atoi(argv[2]);
	}

	DBIPX_Connect(argv[1], port);
	printf("Connected successfully to %s port %d.\n", argv[1], port);
	addr = dbipx_local_addr.node;
	printf("Assigned address is %02x:%02x:%02x:%02x:%02x:%02x.\n",
	       addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
	printf("To disconnect, run: %s /u\n", argv[0]);

	HookIPXVectors();
	TerminateAndStayResident(0, 8 * 1024);

	return 0;
}

