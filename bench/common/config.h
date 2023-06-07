#ifndef CONFIG_H
#define CONFIG_H

//

#ifndef RUNS
#define RUNS 1
#endif

#ifndef LOOPS
#define LOOPS 1
#endif

#ifndef TIMINGS
#define TIMINGS 10000
#endif

//

#ifndef MININBYTES
#define MININBYTES 0
#endif

#ifndef MAXINBYTES
#define MAXINBYTES 16384
#endif

#ifndef MINOUTBYTES
#define MINOUTBYTES 32
#endif

#ifndef MAXOUTBYTES
#define MAXOUTBYTES 128
#endif

//

#ifndef INC_INBYTES
#define INC_INBYTES 2
#endif

#ifndef INC_OUTBYTES
#define INC_OUTBYTES 2
#endif

//

#if defined(ST_ON)

 #ifndef ST_MAX
 #define ST_MAX 5
 #endif

 // 0.1 %
 #ifndef ST_PER
 #define ST_PER 0.1
 #endif

 #ifndef ST_CHK
 #define ST_CHK (((double)ST_PER)/((double)100.0))
 #endif

#endif
//

#endif

