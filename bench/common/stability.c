#ifndef STABILITY_C
#define STABILITY_C

#if defined(ST_ON)

// checks

#if (RUNS <= 1)
#error "error: stability.c : RUNS should be greater or equal than 2"
#endif

// assuming sizeof(uint64_t) == sizeof(unsigned long)
#define _st_static_check(c) ((void)sizeof(char[0 - (int)!(c)]))
void check_uint64_t_ulong(void){ _st_static_check(sizeof(uint64_t) == sizeof(unsigned long)); }

// includes

#include "config.h"
#include "cpucycles.c" // cmp_uint64
#include <gsl/gsl_statistics_ulong.h> // gsl_stats_ulong_{mean,sd}

// common macros / functions

#define _st_while_b int _st_ok = 0, _st_it = ST_MAX; while(_st_it > 0 && _st_ok == 0){
#define _st_while_e _st_it--; }
#define _st_reset_notrandombytes resetnotrandombytes();
#define _st_ifnotst(a)

extern void resetnotrandombytes();

static uint64_t st_median(uint64_t *r, size_t length)
{
  if((length & 1) == 1)
  { return r[length>>1]; }
  else
  { return (r[(length>>1)-1] + r[(length>>1)]) >> 1; }
}

// OPx specific macros

// ////////////////////////////////////////////////////////////////////////////
#if defined(OP1)

 #define _st_store_1(median_r, run, median_l) st_store_1(median_r, run, median_l);
 #define _st_check_1(sd_r, mean_r, median_r) if(st_check_1(sd_r, mean_r, median_r) == 1){ _st_ok = 1; }
 #define _st_print_1(argc, sd_r, mean_r, median_r, op1_str) st_print_1(argc, _st_it, _st_ok, sd_r, mean_r, median_r, op1_str);

 static void st_store_1(uint64_t median_runs[OP1][RUNS], int run, uint64_t median_loops[OP1][LOOPS])
 {
   size_t op;
   min_1(median_loops);
   for (op = 0; op < OP1; op++)
   { median_runs[op][run] = median_loops[op][0]; }
 }

 static int st_check_1(double sd_runs[OP1], double mean_runs[OP1], uint64_t median_runs[OP1][RUNS])
 {
   size_t op;
   double mean, sd;
   int ok = 1;
 
   for (op = 0; op < OP1; op++)
   {
     qsort(&(median_runs[op][0]), RUNS, sizeof(uint64_t), cmp_uint64);
 
     mean = gsl_stats_ulong_mean(&(median_runs[op][0]), 1, RUNS);
     sd   = gsl_stats_ulong_sd(&(median_runs[op][0]), 1, RUNS);
 
     mean_runs[op] = mean;
     sd_runs[op]   = sd;

     // TODO fine-tune this // isolate
     if(sd > (mean * ST_CHK))
     { ok = 0; }
   }
 
   return ok;
 }

 static void st_print_1(int argc, int _st_it, int _st_ok, double sd_runs[OP1], double mean_runs[OP1], uint64_t median_runs[OP1][RUNS], char *op_str[])
 {
   size_t op, run;
   FILE *f;

   // print to file or stdout: number_of_iterations, check_is_ok, sdev, mean, median, list_of_results 
   f = stdout;
   for (op = 0; op < OP1; op++)
   { if(argc == 1) { f = fopen(op_str[op], "a"); }
     fprintf(f, "%d, %d", (ST_MAX-_st_it), _st_ok);
     fprintf(f, ", %.2lf, %.2lf, %" PRIu64 "", sd_runs[op], mean_runs[op], st_median(&(median_runs[op][0]), RUNS));

     for(run = 0; run < RUNS-1; run++)
     { fprintf(f, ", %" PRIu64 "", median_runs[op][run]); }
     fprintf(f, ", %" PRIu64 "\n", median_runs[op][RUNS-1]);

     if(argc == 1) { fclose(f); }
   }
 }

#endif

// ////////////////////////////////////////////////////////////////////////////
#if defined(OP2)

 #define _st_alloc_2(r,x) st_alloc_2(r,x);
 #define _st_d_alloc_2(r,x) st_d_alloc_2(r,x);
 #define _st_free_2(r,x) st_free_2(r,x);
 #define _st_d_free_2(r) st_d_free_2(r);

 #define _st_store_2(median_r, run, median_l) st_store_2(median_r, run, median_l);
 #define _st_check_2(sd_r, mean_r, median_r) if(st_check_2(sd_r, mean_r, median_r) == 1){ _st_ok = 1; }
 #define _st_print_2(argc, sd_r, mean_r, median_r, op2_str) st_print_2(argc, _st_it, _st_ok, sd_r, mean_r, median_r, op2_str);

 static void st_alloc_2(uint64_t** r[OP2], size_t _x)
 {
   size_t o, l;
   for (o=0; o<OP2; o++)
   { r[o] = (uint64_t**) malloc(sizeof(uint64_t*) * _x);
     for (l=0; l<_x; l++)
     { r[o][l] = (uint64_t*) malloc(sizeof(uint64_t)*RUNS); }
   }
 }

 static void st_d_alloc_2(double* r[OP2], size_t _x)
 {
   size_t o;
   for (o=0; o<OP2; o++)
   { r[o] = (double*) malloc(sizeof(double) * _x); }
 }

 static void st_free_2(uint64_t** r[OP2], size_t _x)
 {
   size_t o, l;
   for (o=0; o<OP2; o++)
   { for (l=0; l<_x; l++)
     { free(r[o][l]); }
     free(r[o]);
   }
 }

 static void st_d_free_2(double* r[OP2])
 {
   size_t o;
   for (o=0; o<OP2; o++)
   { free(r[o]); }
 }

 static void st_store_2(uint64_t** median_runs[OP2], int run, uint64_t* median_loops[OP2][LOOPS])
 {
   size_t op, r, len;

   min_2(median_loops);

   for (op = 0; op < OP2; op++)
   { for (len = MININBYTES, r=0; len <= MAXINBYTES; len = inc_in(len), r +=1)
     { median_runs[op][r][run] = median_loops[op][0][r]; }
   }
 }

 static int st_check_2(double* sd_runs[OP2], double* mean_runs[OP2], uint64_t** median_runs[OP2])
 {
   size_t op, r, len;
   double mean, sd;
   int ok = 1;
 
   for (op = 0; op < OP2; op++)
   { for (len = MININBYTES, r=0; len <= MAXINBYTES; len = inc_in(len), r +=1)
     {
       qsort(&(median_runs[op][r][0]), RUNS, sizeof(uint64_t), cmp_uint64);
 
       mean = gsl_stats_ulong_mean(&(median_runs[op][r][0]), 1, RUNS);
       sd   = gsl_stats_ulong_sd(&(median_runs[op][r][0]), 1, RUNS);
   
       mean_runs[op][r] = mean;
       sd_runs[op][r]   = sd;

       // TODO fine-tune this // isolate
       if(sd > (mean * ST_CHK))
       { ok = 0; }
     }
   }
 
   return ok;
 }

 static void st_print_2(int argc, int _st_it, int _st_ok, double* sd_runs[OP2], double* mean_runs[OP2], uint64_t** median_runs[OP2], char *op_str[])
 {
   size_t op, r, len, run;
   FILE *f;

   // print to file or stdout: number_of_iterations, check_is_ok, sdev, mean, median, list_of_results 
   f = stdout;
   for (op = 0; op < OP2; op++)
   { if(argc == 1) { f = fopen(op_str[op], "a"); }
     for (len = MININBYTES, r=0; len <= MAXINBYTES; len = inc_in(len), r +=1)
     {
       fprintf(f, "%" PRIu64 "", len);
       fprintf(f, ", %d, %d", (ST_MAX-_st_it), _st_ok);
       fprintf(f, ", %.2lf, %.2lf, %" PRIu64 "", sd_runs[op][r], mean_runs[op][r], st_median(&(median_runs[op][r][0]), RUNS));

       for(run = 0; run < RUNS-1; run++)
       { fprintf(f, ", %" PRIu64 "", median_runs[op][r][run]); }
       fprintf(f, ", %" PRIu64 "\n", median_runs[op][r][RUNS-1]);
     }
     if(argc == 1) { fclose(f); }
   }
 }
#endif

#if (defined OP1) && (defined OP2)

 #define _st_check_1_2(sd_r1, mean_r1, median_r1, sd_r2, mean_r2, median_r2) \
  if(st_check_1(sd_r1, mean_r1, median_r1) == 1 && \
     st_check_2(sd_r2, mean_r2, median_r2) == 1   )\
  { _st_ok = 1; }

#endif

// ////////////////////////////////////////////////////////////////////////////
#if defined(OP3)

 #define _st_alloc_3(r,x,y) st_alloc_3(r,x,y);
 #define _st_d_alloc_3(r,x,y) st_d_alloc_3(r,x,y);
 #define _st_free_3(r,x,y) st_free_3(r,x,y);
 #define _st_d_free_3(r,x) st_d_free_3(r,x);

 #define _st_store_3(median_r, run, median_l) st_store_3(median_r, run, median_l);
 #define _st_check_3(sd_r, mean_r, median_r) if(st_check_3(sd_r, mean_r, median_r) == 1){ _st_ok = 1; }
 #define _st_print_3(argc, sd_r, mean_r, median_r, op2_str) st_print_3(argc, _st_it, _st_ok, sd_r, mean_r, median_r, op3_str);

 static void st_alloc_3(uint64_t*** r[OP3], size_t _x, size_t _y)
 {
   size_t o, x, y;
   for (o=0; o<OP3; o++)
   { r[o] = (uint64_t***) malloc(sizeof(uint64_t**) * _x);
     for (x=0; x<_x; x++)
     { r[o][x] = (uint64_t**) malloc(sizeof(uint64_t*)*_y);
       for (y=0; y<_y; y++)
       { r[o][x][y] = (uint64_t*) malloc(sizeof(uint64_t)*RUNS); }
     }
   }
 }

 static void st_d_alloc_3(double** r[OP3], size_t _x, size_t _y)
 {
   size_t o, x;
   for (o=0; o<OP3; o++)
   { r[o] = (double**) malloc(sizeof(double*) * _x);
     for (x=0; x<_x; x++)
     { r[o][x] = (double*) malloc(sizeof(double)*_y); }
   }
 }

 static void st_free_3(uint64_t*** r[OP3], size_t _x, size_t _y)
 {
   size_t o, x, y;
   for (o=0; o<OP3; o++)
   { for (x=0; x<_x; x++)
     { for (y=0; y<_y; y++)
       { free(r[o][x][y]); }
       free(r[o][x]);
     }
     free(r[o]);
   }
 }

 static void st_d_free_3(double** r[OP3], size_t _x)
 {
   size_t o, x;
   for (o=0; o<OP3; o++)
   { for (x=0; x<_x; x++)
     { free(r[o][x]); }
     free(r[o]);
   }
 }

 static void st_store_3(uint64_t*** median_runs[OP3], int run, uint64_t** median_loops[OP3][LOOPS])
 {
   size_t op, outlen, r0, inlen, r1;

   min_3(median_loops);

   for (op = 0; op < OP3; op++)
   { for (outlen = MINOUTBYTES, r0 = 0; outlen <= MAXOUTBYTES; outlen = inc_out(outlen), r0 += 1)
     { for (inlen = MININBYTES, r1=0; inlen <= MAXINBYTES; inlen = inc_in(inlen), r1 +=1)
       { median_runs[op][r0][r1][run] = median_loops[op][0][r0][r1]; }
     }
   }
 }

 static int st_check_3(double** sd_runs[OP3], double** mean_runs[OP3], uint64_t*** median_runs[OP3])
 {
   size_t op, outlen, r0, inlen, r1;
   double mean, sd;
   int ok = 1;
 
   for (op = 0; op < OP3; op++)
   { for (outlen = MINOUTBYTES, r0 = 0; outlen <= MAXOUTBYTES; outlen = inc_out(outlen), r0 += 1)
     { for (inlen = MININBYTES, r1=0; inlen <= MAXINBYTES; inlen = inc_in(inlen), r1 +=1)
       {
         qsort(&(median_runs[op][r0][r1][0]), RUNS, sizeof(uint64_t), cmp_uint64);
 
         mean = gsl_stats_ulong_mean(&(median_runs[op][r0][r1][0]), 1, RUNS);
         sd   = gsl_stats_ulong_sd(&(median_runs[op][r0][r1][0]), 1, RUNS);
   
         mean_runs[op][r0][r1] = mean;
         sd_runs[op][r0][r1]   = sd;

         // TODO fine-tune this // isolate
         if(sd > (mean * ST_CHK))
         { ok = 0; }
       }
     }
   }
 
   return ok;
 }

 static void st_print_3(int argc, int _st_it, int _st_ok, double** sd_runs[OP3], double** mean_runs[OP3], uint64_t*** median_runs[OP3], char *op_str[])
 {
   size_t op,outlen, r0, inlen, r1, run;
   FILE *f;

   // print to file or stdout: number_of_iterations, check_is_ok, sdev, mean, median, list_of_results 
   f = stdout;
   for (op = 0; op < OP3; op++)
   { if(argc == 1) { f = fopen(op_str[op], "a"); }
     for (outlen = MINOUTBYTES, r0 = 0; outlen <= MAXOUTBYTES; outlen = inc_out(outlen), r0 += 1)
     { for (inlen = MININBYTES, r1=0; inlen <= MAXINBYTES; inlen = inc_in(inlen), r1 +=1)
       {
         fprintf(f, "%" PRIu64 ", %" PRIu64 "", outlen, inlen);
         fprintf(f, ", %d, %d", (ST_MAX-_st_it), _st_ok);
         fprintf(f, ", %.2lf, %.2lf, %" PRIu64 "", sd_runs[op][r0][r1], mean_runs[op][r0][r1], st_median(&(median_runs[op][r0][r1][0]), RUNS));

         for(run = 0; run < RUNS-1; run++)
         { fprintf(f, ", %" PRIu64 "", median_runs[op][r0][r1][run]); }
         fprintf(f, ", %" PRIu64 "\n", median_runs[op][r0][r1][RUNS-1]);
       }
     }
     if(argc == 1) { fclose(f); }
   }
 }
#endif

// ////////////////////////////////////////////////////////////////////////////

#else // defined(ST_ON)

 #define _st_while_b
 #define _st_while_e
 #define _st_reset_notrandombytes
 #define _st_ifnotst(a) a;

 #define _st_store_1(median_r, run, median_loops)
 #define _st_check_1(sd_r, mean_r, median_r)
 #define _st_print_1(argc, sd_r, mean_r, median_r, op1_str)

 #define _st_alloc_2(r,x)
 #define _st_d_alloc_2(r,x)
 #define _st_free_2(r,x)
 #define _st_d_free_2(r)
 #define _st_store_2(median_r, run, median_l)
 #define _st_check_2(sd_r, mean_r, median_r)
 #define _st_print_2(argc, sd_r, mean_r, median_r, op2_str)

 #define _st_check_1_2(sd_r1, mean_r1, median_r1, sd_r2, mean_r2, median_r2)

 #define _st_alloc_3(r,x,y)
 #define _st_d_alloc_3(r,x,y)
 #define _st_free_3(r,x,y)
 #define _st_d_free_3(r,x)
 #define _st_store_3(median_r, run, median_l)
 #define _st_check_3(sd_r, mean_r, median_r)
 #define _st_print_3(argc, sd_r, mean_r, median_r, op3_str)


#endif

#endif // STABILITY_C
