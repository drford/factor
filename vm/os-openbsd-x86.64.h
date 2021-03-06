#include <amd64/signal.h>

INLINE void *openbsd_stack_pointer(void *uap)
{
	struct sigcontext *sc = (struct sigcontext*) uap;
	return (void *)sc->sc_rsp;
}

#define ucontext_stack_pointer openbsd_stack_pointer
#define UAP_PROGRAM_COUNTER(uap) (((struct sigcontext*)(uap))->sc_rip)
