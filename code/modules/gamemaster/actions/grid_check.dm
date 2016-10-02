// New grid check event:
// Very similar to the old one, power goes out in most of the colony, however the new feature is the ability for engineering to
// get power back on sooner, if they are able to reach a special machine and initiate a manual reboot.  If no one is able to do so,
// it will reboot itself after a few minutes, just like the old one.

/datum/gm_action/grid_check
	name = "grid check"
	departments = list(ROLE_ENGINEERING, ROLE_EVERYONE)
	chaotic = 20