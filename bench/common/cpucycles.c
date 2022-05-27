#ifndef CPUCYCLES_H
#define CPUCYCLES_H

static inline uint64_t cpucycles(void) {
  uint64_t result;

  __asm__ volatile ("rdtsc; shlq $32,%%rdx; orq %%rdx,%%rax"
    : "=a" (result) : : "%rdx");

  return result;
}

static int cmp_uint64(const void *a, const void *b)
{
  if(*(uint64_t *)a < *(uint64_t *)b){ return -1; }
  if(*(uint64_t *)a > *(uint64_t *)b){ return 1; }
  return 0;
}

static uint64_t median(uint64_t *l, size_t llen)
{
  qsort(l,llen,sizeof(uint64_t),cmp_uint64);

  if(llen%2) return l[llen/2];
  else return (l[llen/2-1]+l[llen/2])/2;
}

static uint64_t cpucycles_median(uint64_t *cycles, size_t timings)
{
  size_t i;
  for (i = 0; i < timings-1; i++)
  { cycles[i] = cycles[i+1] - cycles[i]; }

  return median(cycles, timings-1);
}


#endif
