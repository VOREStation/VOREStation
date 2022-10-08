// Bitflags for the move_keys_held bitfield.
#define NORTH_KEY   (1<<0)
#define SOUTH_KEY   (1<<1)
#define EAST_KEY    (1<<2)
#define WEST_KEY    (1<<3)
#define W_KEY       (1<<4)
#define S_KEY       (1<<5)
#define D_KEY       (1<<6)
#define A_KEY       (1<<7)
// Combine the held WASD and arrow keys together (OR) into byond N/S/E/W dir
#define MOVEMENT_KEYS_TO_DIR(MK) ((((MK)>>4)|(MK))&(ALL_CARDINALS))

// Bitflags for pressed modifier keys.
// Values chosen specifically to not conflict with dir bitfield, in case we want to smoosh them together.
#define CTRL_KEY    (1<<8)
#define SHIFT_KEY   (1<<9)
#define ALT_KEY     (1<<10)

// Uncomment to get a lot of debug logging for movement keys.
// #define DEBUG_INPUT(A) to_world_log(A)
<<<<<<< HEAD
#define DEBUG_INPUT(A)
=======
#define DEBUG_INPUT(A)
>>>>>>> c463104999a... Ports Diagonal Movement (#8199)
