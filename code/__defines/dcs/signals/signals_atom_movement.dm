// Atom movement signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

/// From base of atom/setDir(): (old_dir, new_dir). Called before the direction changes
#define COMSIG_ATOM_PRE_DIR_CHANGE "atom_pre_face_atom"
	#define COMPONENT_ATOM_BLOCK_DIR_CHANGE (1<<0)
///from base of atom/setDir(): (old_dir, new_dir). Called before the direction changes.
#define COMSIG_ATOM_DIR_CHANGE "atom_dir_change"
///from base of atom/setDir(): (old_dir, new_dir). Called after the direction changes.
#define COMSIG_ATOM_POST_DIR_CHANGE "atom_post_dir_change"
