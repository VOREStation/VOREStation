#define PERSIST_SPAWN		0x01	// Persist spawnpoint based on location of despawn/logout.
#define PERSIST_WEIGHT		0x02	// Persist mob weight
#define PERSIST_ORGANS		0x04	// Persist the status (normal/amputated/robotic/etc) and model (for robotic) status of organs
#define PERSIST_MARKINGS	0x08	// Persist markings
#define PERSIST_SIZE		0x10	// Persist size
#define PERSIST_COUNT		5		// Number of valid bits in this bitflag.  Keep this updated!
#define PERSIST_DEFAULT		PERSIST_SPAWN|PERSIST_ORGANS|PERSIST_MARKINGS|PERSIST_SIZE // Default setting for new folks
