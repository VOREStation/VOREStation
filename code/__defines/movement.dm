/// Classic bluespace teleportation, requires a sender but no receiver
#define TELEPORT_CHANNEL_BLUESPACE "bluespace"
/// Quantum-based teleportation, requires both sender and receiver, but is free from normal disruption
#define TELEPORT_CHANNEL_QUANTUM "quantum"

// Container flags for get_teleportable_container
/// Count mob inventory as a valid container
#define TELEPORT_CONTAINER_INCLUDE_INVENTORY (1<<0)
/// Count modsuits with at least one sealed part as valid containers, even if mob inventory is not a valid container
#define TELEPORT_CONTAINER_INCLUDE_SEALED_RIGSUIT (1<<1)
/// Count atom storage as a valid container
#define TELEPORT_CONTAINER_INCLUDE_STORAGE (1<<2)
/// Count closets as a valid container
#define TELEPORT_CONTAINER_INCLUDE_CLOSET (1<<3)
/// Count vehicles as a valid container
#define TELEPORT_CONTAINER_INCLUDE_VEHICLE (1<<4)
/// Count mech equipment (particularly cargo holds and sleepers) as a valid container
#define TELEPORT_CONTAINER_INCLUDE_MECH_EQUIPMENT (1<<5)
/// Count stomachs as a valid container
#define TELEPORT_CONTAINER_INCLUDE_STOMACH (1<<6)
