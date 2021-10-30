/atom/movable/proc/Bump_vr(var/atom/A, yes)
	return

/atom/movable/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("move_atom", "Move To Coordinate")

/atom/vv_do_topic(list/href_list)
	. = ..()
	IF_VV_OPTION("move_atom")
		usr.client.cmd_admin_move_atom(src)
		href_list["datumrefresh"] = "\ref[src]"
