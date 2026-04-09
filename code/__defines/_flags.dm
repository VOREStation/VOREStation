/// 33554431 (2^24 - 1) is the maximum value our bitflags can reach.
#define MAX_BITFLAG_DIGITS 8

///Object will protect itself.
#define EMP_PROTECT_SELF (1<<0)
///Object will protect its contents from being EMPed.
#define EMP_PROTECT_CONTENTS (1<<1)

///Protects against all EMP types.
#define EMP_PROTECT_ALL (EMP_PROTECT_SELF | EMP_PROTECT_CONTENTS)
