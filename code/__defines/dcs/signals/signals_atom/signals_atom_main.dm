// Main atom signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

///when an atom starts playing a song datum (datum/song)
#define COMSIG_ATOM_STARTING_INSTRUMENT "atom_starting_instrument"

///When the transform or an atom is varedited through vv topic.
#define COMSIG_ATOM_VV_MODIFY_TRANSFORM "atom_vv_modify_transform"

/// from base of [/atom/proc/extinguish]
#define COMSIG_ATOM_EXTINGUISH "atom_extinguish"

/// From base atom/hitby(atom/movable/AM)
#define COMSIG_ATOM_HITBY "atom_hitby"
