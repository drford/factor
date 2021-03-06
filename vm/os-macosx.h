#define DLLEXPORT __attribute__((visibility("default")))
#define FACTOR_OS_STRING "macosx"
#define NULL_DLL "libfactor.dylib"
#define UNKNOWN_TYPE_P(file) ((file)->d_type == DT_UNKNOWN)
#define DIRECTORY_P(file) ((file)->d_type == DT_DIR)

void init_signals(void);
void early_init(void);

const char *vm_executable_path(void);
const char *default_image_path(void);

DLLEXPORT void c_to_factor_toplevel(CELL quot);

#ifndef environ
	extern char ***_NSGetEnviron(void);
	#define environ (*_NSGetEnviron())
#endif

INLINE void *ucontext_stack_pointer(void *uap)
{
	ucontext_t *ucontext = (ucontext_t *)uap;
	return ucontext->uc_stack.ss_sp;
}
