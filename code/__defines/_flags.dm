/// 33554431 (2^24 - 1) is the maximum value our bitflags can reach.
#define MAX_BITFLAG_DIGITS 8

//Movement Types
#define GROUND (1<<0)
#define FLYING (1<<1)
#define VENTCRAWLING (1<<2)
#define FLOATING (1<<3)
/// When moving, will Cross() everything, but won't stop or Bump() anything.
#define PHASING (1<<4)
/// The mob is walking on the ceiling. Or is generally just, upside down.
#define UPSIDE_DOWN (1<<5)
/// Combination flag for movetypes which, for all intents and purposes, mean the mob is not touching the ground
#define MOVETYPES_NOT_TOUCHING_GROUND (FLYING|FLOATING|UPSIDE_DOWN)
/// Trait source for stuff movetypes applies
#define SOURCE_MOVETYPES "movetypes"
