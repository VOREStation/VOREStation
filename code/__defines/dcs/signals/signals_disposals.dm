///called when a disposal connected object flushes its contents into the disposal pipe network
#define COMSIG_DISPOSAL_FLUSH "disposal_system_flushing"

///called when a disposal trunk attempts to send a packet, to be recieved by an atom with a disposal network connection component.
#define COMSIG_DISPOSAL_SEND "disposal_system_sending"

///called when a disposal connected object recieves an object from it's connected trunk
#define COMSIG_DISPOSAL_RECEIVE "disposal_system_receiving"

///called when the movable is added to a disposal holder object for disposal movement: (obj/structure/disposalholder/holder, atom/source)
//#define COMSIG_MOVABLE_DISPOSING "movable_disposing" //This is in signals_atom_movable.dm but kept here for housekeeping.

///Called right after the atom is flushed into a disposal holder and sent through the disposal network: (/obj/structure/disposalholder)
#define COMSIG_ATOM_DISPOSAL_FLUSHED "atom_disposal_flushed"

///called when a disposal connected object attempts to link to a trunk: (/obj/structure/disposalpipe/trunk)
#define COMSIG_DISPOSAL_LINK "disposal_system_linkage"

///called when a disposal connected object should unlink from a trunk it's attached to.
#define COMSIG_DISPOSAL_UNLINK "disposal_system_unlink"
