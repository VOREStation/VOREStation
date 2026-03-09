/// Object has been affected by a cryptographic sequencer (EMAG) disabling it or causing other malicious effects
#define EMAGGED (1<<0)
/// Can this be bludgeoned by items
#define CAN_BE_HIT (1<<1)
/// Admin possession yes/no
#define DANGEROUS_POSSESSION (1<<2)
/// Can you customize the description/name of the thing
#define UNIQUE_RENAME (1<<3)
/// If it can be renamed, is its description excluded
#define RENAME_NO_DESC (1<<4)
/// Should this object block z falling from loc
#define BLOCK_Z_OUT_DOWN (1<<5)
/// Should this object block z uprise from loc
#define BLOCK_Z_OUT_UP (1<<6)
/// Should this object block z falling from above
#define BLOCK_Z_IN_DOWN (1<<7)
/// Should this object block z uprise from below
#define BLOCK_Z_IN_UP (1<<8)
/// Does this object prevent things from being built on it
#define BLOCKS_CONSTRUCTION (1<<9)
/// Does this object prevent same-direction things from being built on it
#define BLOCKS_CONSTRUCTION_DIR (1<<10)
/// Can we ignore density when building on this object (for example, directional windows and grilles)
#define IGNORE_DENSITY (1<<11)
/// Can this object conduct electricity
#define CONDUCTS_ELECTRICITY (1<<12)
/// Atoms don't spawn anything when deconstructed (they just vanish)
#define NO_DEBRIS_AFTER_DECONSTRUCTION (1<<13)
/// Flag which tells an object to hang onto an support atom on late initialize. Usefull only during mapload and supported by some atoms only
#define MOUNT_ON_LATE_INITIALIZE (1<<14)
