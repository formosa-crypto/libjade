#include "printbench.h"

#include <stdio.h>

static int cmp_uint64(const void *a, const void *b) {
  if(*(uint64_t *)a < *(uint64_t *)b) return -1;
  if(*(uint64_t *)a > *(uint64_t *)b) return 1;
  return 0;
}

static uint64_t median(uint64_t *l, size_t llen) {
  qsort(l,llen,sizeof(uint64_t),cmp_uint64);

  if(llen%2) return l[llen/2];
  else return (l[llen/2-1]+l[llen/2])/2;
}

void printbench(const char *algname, const char *op, uint64_t *t, size_t nruns)
{
  uint64_t i;
  for(i=0;i<nruns-1;i++)
    t[i] = t[i+1] - t[i];

  printf("%s ", algname);
  printf("%s ", op);
  printf("%" PRIu64 "\n", median(t, nruns-1));
}

