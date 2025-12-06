///called when a disposal connected object flushes its contents into the disposal pipe network
#define COMSIG_DISPOSAL_FLUSH "disposal_system_flushing"

///called when a disposal connected object gets a packet from the disposal pipe network
#define COMSIG_DISPOSAL_RECEIVING "disposal_system_receiving"

///called when the movable is added to a disposal holder object for disposal movement: (obj/structure/disposalholder/holder, obj/machinery/disposal/source)
//#define COMSIG_MOVABLE_DISPOSING "movable_disposing" //This is in signals_atom_movable.dm but kept here for housekeeping.

///Called right after the atom is flushed into a disposal holder and sent through the disposal network: (/obj/structure/disposalholder)
#define COMSIG_ATOM_DISPOSAL_FLUSHED "atom_disposal_flushed"
