/obj/structure/ghost_pod/Destroy()
	if(src in active_ghost_pods)
		active_ghost_pods -= src
	..()

/obj/structure/ghost_pod
	var/spawn_active = FALSE

/obj/structure/ghost_pod/manual
	var/remains_active = FALSE
	var/activated = FALSE

/obj/structure/ghost_pod/manual/attack_ghost(var/mob/observer/dead/user)
	if(!remains_active || busy)
		return

	if(!activated)
		to_chat(user, "<span class='warning'>\the [src] has not yet been activated.  Sorry.</span>")
		return

	if(used)
		to_chat(user, "<span class='warning'>Another spirit appears to have gotten to \the [src] before you.  Sorry.</span>")
		return

	busy = TRUE
	var/choice = input(user, "Are you certain you wish to activate this pod?", "Control Pod") as null|anything in list("Yes", "No")

	if(!choice || choice == "No")
		busy = FALSE
		return

	else if(used)
		to_chat(user, "<span class='warning'>Another spirit appears to have gotten to \the [src] before you.  Sorry.</span>")
		busy = FALSE
		return

	busy = FALSE

	create_occupant(user)

/obj/structure/ghost_pod/proc/ghostpod_startup(var/notify = FALSE)
	if(!(src in active_ghost_pods))
		active_ghost_pods += src
	if(notify)
		trigger()

/obj/structure/ghost_pod/ghost_activated/Initialize()
	. = ..()
	ghostpod_startup(spawn_active)