#include <inttypes.h>
#include <stdio.h>

#include "print.h"

void print_info(const char *algname, const char *arch, const char *impl)
{
  printf("// {\"%s\" : { architecture : \"%s\", implementation : \"%s\"} }",
         algname, arch, impl);
  printf("\n");
}

void print_u8(const uint8_t *a, size_t l)
{
  size_t i;

  if(l == 0)
  { return; }

  printf("{\n  ");
  for(i=0; i<(l-1); i++)
  { printf("0x%02" PRIx8 ", ", a[i]);
    if((i+1)%16 == 0)
    { printf("\n  "); }
  }

  printf("0x%02" PRIx8 "\n};\n", a[i]);
  return;
}

void print_str_u8(const char *str, const uint8_t *a, size_t l)
{
  if( l == 0 )
  { printf("uint8_t *%s = NULL;\n", str);
    return;
  }
  
  printf("uint8_t %s[%zu] = ",str, l);
  print_u8(a, l);
}

void print_str_c_u8(const char *str, uint64_t c, const uint8_t *a, size_t l)
{
  if( l == 0 )
  { printf("uint8_t *%s_%" PRIu64 " = NULL;\n", str, c);
    return;
  }
  
  printf("uint8_t %s_%" PRIu64 "[%zu] = ",str, c, l);
  print_u8(a, l);
}

void print_str_c_c_u8(const char *str, uint64_t c1, uint64_t c2, const uint8_t *a, size_t l)
{
  if( l == 0 )
  { printf("uint8_t *%s_%" PRIu64 "_%" PRIu64 " = NULL;\n", str, c1, c2);
    return;
  }
  
  printf("uint8_t %s_%" PRIu64 "_%" PRIu64 "[%zu] = ",str, c1, c2, l);
  print_u8(a, l);
}

