// extern_impl.cpp - always compiled /fp:precise; target of LTCG cross-module inlining.
#include "sin13.h"
float  sin_extern(float x)  { return sin_plain(x); }
double sin_extern(double x) { return sin_plain(x); }
