//We will round to this value in damage calculations.
#define DAMAGE_PRECISION 0.1

//Damage flag defines //

/// Involves corrosive substances.
#define ACID "acid"
/// Involved in checking whether a disease can infect or spread. Also involved in xeno neurotoxin.
#define BIO "bio"
/// Involves a shockwave, usually from an explosion.
#define BOMB "bomb"
/// Involves a solid projectile.
#define BULLET "bullet"
/// Involves being eaten
#define CONSUME "consume"
/// Involves an EMP or energy-based projectile.
#define ENERGY "energy"
/// Involves fire or temperature extremes.
#define FIRE "fire"
/// Involves a laser.
#define LASER "laser"
/// Involves a melee attack or a thrown object.
#define MELEE "melee"
/// Involved in checking the likelihood of applying a wound to a mob.
#define WOUND "wound"

/// Calculates the new armour value after armour penetration. Can return negative values, and those must be caught.
#define PENETRATE_ARMOUR(armour, penetration) (penetration >= 100 ? 0 : 100 * (armour - penetration) / (100 - penetration))
