/// 33554431 (2^24 - 1) is the maximum value our bitflags can reach.
#define MAX_BITFLAG_DIGITS 8

//Fire and Acid stuff, for resistance_flags
#define LAVA_PROOF (1<<0)
/// 100% immune to fire damage (but not necessarily to lava or heat)
#define FIRE_PROOF (1<<1)
/// atom is flammable and can have the burning component
#define FLAMMABLE (1<<2)
/// currently burning
#define ON_FIRE (1<<3)
/// acid can't even appear on it, let alone melt it.
#define UNACIDABLE (1<<4)
/// acid stuck on it doesn't melt it.
#define ACID_PROOF (1<<5)
/// doesn't take damage
#define INDESTRUCTIBLE (1<<6)
/// can't be frozen
#define FREEZE_PROOF (1<<7)
/// can't be shuttle crushed.
#define SHUTTLE_CRUSH_PROOF (1<<8)
/// can't be destroyed by bombs
#define BOMB_PROOF (1<<9)
///Object will protect itself.
#define EMP_PROTECT_SELF (1<<0)
///Object will protect its contents from being EMPed.
#define EMP_PROTECT_CONTENTS (1<<1)
///Object will protect its wiring from being EMPed.
#define EMP_PROTECT_WIRES (1<<2)

///Protects against all EMP types.
#define EMP_PROTECT_ALL (EMP_PROTECT_SELF | EMP_PROTECT_CONTENTS | EMP_PROTECT_WIRES)
