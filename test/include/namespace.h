#define PASTER(x, y) x##_##y
#define EVALUATOR(x, y) PASTER(x, y)
#define NAMESPACE(fun) EVALUATOR(JADE_NAMESPACE, fun)
#define NAMESPACE_LC(fun) EVALUATOR(JADE_NAMESPACE_LC, fun)

#define MY_TRUTHY_VALUE_X 1
#define CAT(x,y) CAT_(x,y)
#define CAT_(x,y) x##y
#define HAS_NAMESPACE(x) CAT(CAT(MY_TRUTHY_VALUE_,CAT(JADE_NAMESPACE,CAT(_,x))),X)

#if !HAS_NAMESPACE(API_H)
#error "namespace not properly defined for header guard"
#endif

#define xstr(s,e) str(s)#e
#define str(s) #s
