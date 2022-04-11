#define MAX_PROGRESS 100

/obj/structure/alien/egg //Gurg Addition, working alien egg structure.
	desc = "It looks like a weird egg."
	name = "egg"
	icon_state = "egg_growing"
	density = FALSE
	var/progress = 0

/obj/structure/alien/egg/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/alien/egg/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/alien/egg/CanUseTopic(var/mob/user)
	return isobserver(user) ? STATUS_INTERACTIVE : STATUS_CLOSE

/obj/structure/alien/egg/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["spawn"])
		attack_ghost(usr)

/obj/structure/alien/egg/process()
	progress++
	if(progress >= MAX_PROGRESS)
		for(var/mob/observer/dead/O in observer_mob_list)
			if(O.client)
				to_chat(O, "<span class='notice'>An alien is ready to hatch at [get_area(src.loc)]! (<a href='byond://?src=\ref[src];spawn=1'>spawn</a>)</span>")
		STOP_PROCESSING(SSobj, src)
		update_icon()

/obj/structure/alien/egg/update_icon()
	if(progress == -1)
		icon_state = "egg_opened"
	else if(progress < MAX_PROGRESS)
		icon_state = "egg_growing"
	else
		icon_state = "egg"

	// Ghostjoinable icon
	var/static/image/I
	if(!I)
		I = image('icons/mob/hud_vr.dmi', "ghostjoin")
		I.invisibility = INVISIBILITY_OBSERVER
		I.plane = PLANE_GHOSTS
		I.appearance_flags = KEEP_APART|RESET_TRANSFORM
	
	if(progress >= MAX_PROGRESS)
		add_overlay(I)
	else
		cut_overlay(I)


/obj/structure/alien/egg/attack_ghost(var/mob/observer/dead/user)
	// Still a ghost?
	if(!istype(user))
		tgui_alert_async(user, "You have to be an observer to join as this Xenomorph larva.")
		return
	
	// Check for bans properly.
	if(jobban_isbanned(user, "Xenomorph"))
		tgui_alert_async(user, "You are banned from playing a Xenomorph, so you can't join as this Xenomorph larva.")
		return
		
	// Check for respawn
	if(!user.MayRespawn(1))
		tgui_alert_async(user, "You aren't allowed to respawn, so you can't join as this Xenomorph larva.")
		return
	
	if(progress == -1)
		tgui_alert_async(user, "That egg has already hatched.")
	else if(progress >= MAX_PROGRESS)
		tgui_alert_async(user, "Are you sure you want to join as a Xenomorph larva?", "Become Larva", list("Yes","No"), CALLBACK(src, .proc/ghost_dunk), 20 SECONDS)
	else
		tgui_alert_async(user, "\The [src] has not yet matured.")

/obj/structure/alien/egg/proc/ghost_dunk(choice)
	if(choice != "Yes")
		return
	var/mob/observer/dead/user = usr
	if(progress < MAX_PROGRESS || !istype(user))
		return

	progress = -1 // No harvesting pls.
	flick("egg_opening",src)
	sleep(5) //5ds animation

	if(!src || !istype(user))
		visible_message("<span class='alium'>\The [src] writhes with internal motion, but nothing comes out.</span>")
		progress = MAX_PROGRESS // Someone else can have a go.
		return // What a pain.

	// Create the mob, transfer over key.
	var/mob/living/carbon/alien/larva/larva = new(get_turf(src))
	
	// Move the ghost in
	if(user.mind)
		user.mind.active = TRUE
		user.mind.transfer_to(larva)
	else
		larva.ckey = user.ckey
	qdel(user)
	
	visible_message("<span class='alium'>\The [src] splits open with a wet slithering noise, and \the [larva] writhes free!</span>")

	// Turn us into a hatched egg.
	name = "hatched alien egg"
	desc += " This one has hatched."
	update_icon()

#undef MAX_PROGRESS
