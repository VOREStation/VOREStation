/obj/item/weapon/syndie
	icon = 'icons/obj/syndieweapons.dmi'

/*C-4 explosive charge and etc, replaces the old syndie transfer valve bomb.*/


/*The explosive charge itself.  Flashes for five seconds before exploding.*/

/obj/item/weapon/syndie/c4explosive
	icon_state = "c-4small_0"
	item_state = "radio"
	name = "normal-sized package"
	desc = "A small wrapped package."
	w_class = ITEMSIZE_NORMAL

	var/devastate = 1
	var/heavy_impact = 2
	var/light_impact = 4
	var/flash_range = 5
	var/size = "small"  /*Used for the icon, this one will make c-4small_0 for the off state.*/

/obj/item/weapon/syndie/c4explosive/heavy
	icon_state = "c-4large_0"
	item_state = "radio"
	desc = "A mysterious package, it's quite heavy."
	devastate = 1
	heavy_impact = 3
	light_impact = 5
	flash_range = 7
	size = "large"

/obj/item/weapon/syndie/c4explosive/heavy/super_heavy
	name = "large-sized package"
	desc = "A mysterious package, it's quite exceptionally heavy."
	devastate = 2
	heavy_impact = 5
	light_impact = 7
	flash_range = 7

/obj/item/weapon/syndie/c4explosive/New()
	var/K = rand(1,2000)
	K = md5(num2text(K)+name)
	K = copytext(K,1,7)
	desc += "\n You see [K] engraved on \the [src]."
	var/obj/item/weapon/flame/lighter/zippo/c4detonator/detonator = new(src.loc)
	detonator.desc += " You see [K] engraved on the lighter."
	detonator.bomb = src

/obj/item/weapon/syndie/c4explosive/proc/detonate()
	icon_state = "c-4[size]_1"
	playsound(src, 'sound/weapons/armbomb.ogg', 75, 1)
	for(var/mob/O in hearers(src, null))
		O.show_message("\icon[src][bicon(src)] <span class = 'warning'> The [src.name] beeps! </span>")
	sleep(50)
	explosion(get_turf(src), devastate, heavy_impact, light_impact, flash_range)
	for(var/dirn in cardinal)		//This is to guarantee that C4 at least breaks down all immediately adjacent walls and doors.
		var/turf/simulated/wall/T = get_step(src,dirn)
		if(locate(/obj/machinery/door/airlock) in T)
			var/obj/machinery/door/airlock/D = locate() in T
			if(D.density)
				D.open()
		if(istype(T,/turf/simulated/wall))
			T.dismantle_wall(1)
	qdel(src)

/obj/item/weapon/syndie/c4explosive/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/flame/lighter/zippo/c4detonator))
		var/obj/item/weapon/flame/lighter/zippo/c4detonator/D = W
		D.bomb = src
		return
	..()

/*Detonator, disguised as a lighter*/
/*Click it when closed to open, when open to bring up a prompt asking you if you want to close it or press the button.*/

/obj/item/weapon/flame/lighter/zippo/c4detonator
	var/detonator_mode = 0
	var/obj/item/weapon/syndie/c4explosive/bomb

/obj/item/weapon/flame/lighter/zippo/c4detonator/attack_self(mob/user as mob)
	if(!detonator_mode)
		..()

	else if(!lit)
		base_state = icon_state
		lit = 1
		icon_state = "[base_state]1"
		//item_state = "[base_state]on"
		user.visible_message("<span class='rose'>Without even breaking stride, \the [user] flips open \the [src] in one smooth movement.</span>")

	else if(lit && detonator_mode)
		switch(tgui_alert(user, "What would you like to do?", "Lighter", list("Press the button.", "Close the lighter.")))
			if("Press the button.")
				to_chat(user, "<span class='warning'>You press the button.</span>")
				icon_state = "[base_state]click"
				if(src.bomb)
					src.bomb.detonate()
					log_admin("[key_name(user)] has triggered [src.bomb] with [src].")
					message_admins("<span class='danger'>[key_name_admin(user)] has triggered [src.bomb] with [src].</span>")

			if("Close the lighter.")
				lit = 0
				icon_state = "[base_state]"
				//item_state = "[base_state]"
				user.visible_message("<span class='rose'>You hear a quiet click, as \the [user] shuts off \the [src] without even looking at what they're doing.</span>")


/obj/item/weapon/flame/lighter/zippo/c4detonator/attackby(obj/item/weapon/W, mob/user as mob)
	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		detonator_mode = !detonator_mode
		playsound(src, W.usesound, 50, 1)
		to_chat(user, "<span class='notice'>You unscrew the top panel of \the [src] revealing a button.</span>")
