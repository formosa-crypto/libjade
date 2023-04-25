#ifndef TEST_COMMON_FILES_C
#define TEST_COMMON_FILES_C

#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include <stdarg.h>

static void f_map_fopen(FILE **files, char **filenames, size_t length, char *mode)
{
  size_t i;
  for(i=0; i<length; i++)
  { files[i] = fopen(filenames[i], mode);
    assert(files[i] != NULL);
  }
}

static void f_map_fclose(FILE **files, size_t length)
{
  int r;
  size_t i;
  for(i=0; i<length; i++)
  { r = fclose(files[i]);
    assert(r == 0);
  }
}

static void f_map_fopen_write(FILE **files, char **filenames, size_t length)
{
  f_map_fopen(files, filenames, length, "w");
}

static void f_fprintf2(FILE *stream1, FILE *stream2, const char *format, ...)
{
  va_list arguments;

  va_start(arguments, format);
    vfprintf(stream1, format, arguments);
  va_end(arguments);

  va_start(arguments, format);
    vfprintf(stream2, format, arguments);
  va_end(arguments);
}

#endif
