/// Flags for specifically what kind of items to get in get_equipped_items
#define INCLUDE_POCKETS (1<<0)
#define INCLUDE_ACCESSORIES (1<<1)
#define INCLUDE_HELD (1<<2)
/// Include prosthetic item limbs (which are not flavoured as being equipped items)
#define INCLUDE_PROSTHETICS (1<<3)
/// Include items that are not "real" items, such as hand items
#define INCLUDE_ABSTRACT (1<<4)
