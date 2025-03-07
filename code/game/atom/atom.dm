/**
 * Hook for running code when a dir change occurs
 *
 * Not recommended to use, listen for the [COMSIG_ATOM_DIR_CHANGE] signal instead (sent by this proc)
 */
/atom/proc/setDir(newdir)
	SHOULD_CALL_PARENT(TRUE)
	if (SEND_SIGNAL(src, COMSIG_ATOM_PRE_DIR_CHANGE, dir, newdir) & COMPONENT_ATOM_BLOCK_DIR_CHANGE)
		newdir = dir
		return
	SEND_SIGNAL(src, COMSIG_ATOM_DIR_CHANGE, dir, newdir)
	var/oldDir = dir
	dir = newdir
	SEND_SIGNAL(src, COMSIG_ATOM_POST_DIR_CHANGE, oldDir, newdir)
	//if(smoothing_flags & SMOOTH_BORDER_OBJECT)
		//QUEUE_SMOOTH_NEIGHBORS(src)
