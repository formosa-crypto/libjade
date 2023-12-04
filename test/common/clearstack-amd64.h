#ifndef TEST_COMMON_CLEARSTACK_AMD64_H
#define TEST_COMMON_CLEARSTACK_AMD64_H

#include <assert.h>
#include <stddef.h>
#include <stdint.h>

// TODO: "dynamic" OFFSET
#define OFFSET 8
#define CANARY_LENGTH 128

//

#define cs_recover_stack_debug(stack_pointer, recover_array, max_size) \
  { for(size_t __i=0; __i<(max_size+CANARY_LENGTH); __i++) { recover_array[__i] = stack_pointer[__i]; } \
    printf("stack_pointer: %p\n", stack_pointer); \
  }

#define cs_check_stack_zeros_debug(recovered_array, canary_array, max_size) \
  { printf("stack_max_size: %d\n", max_size); \
    size_t __i, __j, __dirty = 0; \
    for(__i=0, __j=0; __i< max_size; __i++) \
    { if( (recovered_array[__i + CANARY_LENGTH] != 0) ) \
      { __dirty = 1; \
        if(__i != 0 && __j != __i) { printf("(%zu..%zu)@0, ", __j, __i-1); } \
        printf("(%zu)@%x, ", __i, recovered_array[__i + CANARY_LENGTH]); \
        __j = __i+1; \
      } \
    } \
    if(__j != __i) { printf("(%zu..%zu)@0", __j, __i-1); } \
    printf("\n\n"); \
    assert(__dirty == 0); \
  }

//

#define cs_init_randombytes_for_canary(position) initrandombytes2(position);

//

#define cs_declare(stack_pointer, canary_array, recover_array, max_size) \
  uint8_t *stack_pointer; \
  uint8_t  canary_array[CANARY_LENGTH + max_size]; \
  uint8_t  recover_array[CANARY_LENGTH + max_size];

//

#define cs_init_stack_pointer(stack_pointer, max_size, alignment) \
  __asm__( "movq %%rsp, %%rax" : "=a"(stack_pointer)); \
  stack_pointer -= (OFFSET + max_size + CANARY_LENGTH); \
  stack_pointer = (uint8_t*) ( ((uint64_t) stack_pointer) & (-(((uint64_t)alignment)>>3)) );

#define cs_init_canary(canary_array, max_size) \
  { randombytes2(canary_array, max_size+CANARY_LENGTH); }

#define cs_init_stack(stack_pointer, canary_array, max_size) \
  { for(size_t __i=0; __i<(max_size+CANARY_LENGTH); __i++) { stack_pointer[__i] = canary_array[__i]; } }

#define cs_init(stack_pointer, max_size, alignment, canary_array) \
  cs_init_stack_pointer(stack_pointer, max_size, alignment) \
  cs_init_canary(canary_array, max_size) \
  cs_init_stack(stack_pointer, canary_array, max_size)

//

#define cs_recover_stack(stack_pointer, recover_array, max_size) \
  { for(size_t __i=0; __i<(max_size+CANARY_LENGTH); __i++) { recover_array[__i] = stack_pointer[__i]; } }

#define cs_check_stack_canary(recovered_array, canary_array) \
  { for(size_t __i=0; __i<(CANARY_LENGTH); __i++) { assert(recovered_array[__i] == canary_array[__i]); } }

#define cs_check_stack_zeros_or_canary(recovered_array, canary_array, max_size) \
  { for(size_t __i=0; __i< max_size; __i++) \
    { assert( (recovered_array[__i + CANARY_LENGTH] == 0) || (recovered_array[__i + CANARY_LENGTH] == canary_array[__i + CANARY_LENGTH]) ); } \
  }

#define cs_recover_and_check(stack_pointer, recover_array, canary_array, max_size) \
  cs_recover_stack(stack_pointer, recover_array, max_size) \
  cs_check_stack_zeros_or_canary(recover_array, canary_array, max_size)

#define cs_recover_and_check_debug(stack_pointer, recover_array, canary_array, max_size) \
  cs_recover_stack_debug(stack_pointer, recover_array, max_size) \
  cs_check_stack_zeros_debug(recover_array, canary_array, max_size)

#endif

