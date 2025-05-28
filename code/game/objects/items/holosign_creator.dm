/obj/item/holosign_creator
	name = "holographic sign projector"
	desc = "A handy-dandy holographic projector that displays a janitorial sign."
	icon = 'icons/obj/device.dmi'
	icon_state = "signmaker"
	item_state = "electronic"
	force = 0
	w_class = 2
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	var/list/signs = list()
	var/max_signs = 10
	var/creation_time = 0 //time to create a holosign in deciseconds.
	var/holosign_type = /obj/structure/holosign/wetsign
	var/holocreator_busy = FALSE //to prevent placing multiple holo barriers at once

/obj/item/holosign_creator/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	. = ..()
	if(!check_allowed_items(target, 1))
		return
	var/turf/T = get_turf(target)
	var/obj/structure/holosign/H = locate(holosign_type) in T
	if(H)
		to_chat(user, span_notice("You use [src] to deactivate [H]."))
		qdel(H)
	else
		if(holocreator_busy)
			to_chat(user, span_notice("[src] is busy creating a hologram."))
			return
		if(signs.len < max_signs)
			playsound(src.loc, 'sound/machines/click.ogg', 20, 1)
			if(creation_time)
				holocreator_busy = TRUE
				if(!do_after(user, creation_time, target = target))
					holocreator_busy = FALSE
					return
				holocreator_busy = FALSE
				if(signs.len >= max_signs)
					return
				if(is_blocked_turf(T, TRUE)) //don't try to sneak dense stuff on our tile during the wait.
					return
			H = new holosign_type(get_turf(target), src)
			to_chat(user, span_notice("You create \a [H] with [src]."))
		else
			to_chat(user, span_notice("[src] is projecting at max capacity!"))

/obj/item/holosign_creator/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(signs.len)
		for(var/H in signs)
			qdel(H)
		to_chat(user, span_notice("You clear all active holograms."))

/obj/item/holosign_creator/combifan
	name = "ATMOS holo-combifan projector"
	desc = "A holographic projector that creates holographic combi-fans that prevent changes in atmosphere and temperature conditions. Somehow."
	icon_state = "signmaker_engi"
	holosign_type = /obj/structure/holosign/barrier/combifan
	creation_time = 0
	max_signs = 3

/obj/item/holosign_creator/medical
	name = "Vey-Med barrier projector"
	desc = "A holographic projector that creates Vey-Medical holobarriers. Useful during quarantines since they halt those with malicious diseases."
	icon = 'icons/obj/device.dmi'
	icon_state = "signmaker_med"
	holosign_type = /obj/structure/holosign/barrier/medical
	creation_time = 0
	max_signs = 6
