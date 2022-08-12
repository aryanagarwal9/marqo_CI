#include <unistd.h>
#include <sys/types.h>
#include <stdio.h>
#include <sys/wait.h>
#include <sys/resource.h>
// compile with: cc -o trivial_process trivial_process.c
// https://0xax.gitbooks.io/linux-insides/content/SysCall/linux-syscall-6.html
// https://www.ibm.com/docs/en/i/7.1?topic=ssw_ibm_i_71/apis/getrlim.htm
int main( ){
   pid_t child_pid;
   child_pid = fork (); // Create a new child process;
   struct rlimit cpu_limit;
   getrlimit(RLIMIT_FSIZE, &cpu_limit);
   printf("Original CPU RLIMIT: %llu\n", &cpu_limit.rlim_cur);
   int divved_2 = cpu_limit.rlim_cur / 2;
   cpu_limit.rlim_cur = divved_2;

   struct rlimit new_limits = {
       65535, 65535
   };
   printf("CPUT RLMIT divved by 2: %llu\n", new_limits.rlim_cur);
   setrlimit(RLIMIT_FSIZE, &new_limits);
   struct rlimit retrieved_lims;
   getrlimit(RLIMIT_FSIZE, &retrieved_lims);
   printf("NEW CPU RLIMIT: %llu\n", &retrieved_lims.rlim_cur);
   if (child_pid < 0) {
      printf("fork failed");
      return 1;
   } else if (child_pid == 0) {
      printf ("child process successfully created!\n");
      printf ("child_PID = %d,parent_PID = %d\n",
      getpid(), getppid( ) );
   } else {
      wait(NULL);
      printf ("parent process successfully created!\n");
      printf ("child_PID = %d, parent_PID = %d", getpid( ), getppid( ) );
   }
   return 0;
}