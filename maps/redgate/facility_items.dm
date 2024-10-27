/obj/item/card/id/keycard
	name = "keycard"
	desc = "Allows access to certain doors."
	icon_state = "keycard-red"
	initial_sprite_stack = list()
	light_color = "#0099ff"
	access = list(801)

/obj/item/card/id/keycard/update_icon()
	return

/obj/item/card/id/keycard/read()
	to_chat(usr, span_notice("It is a red keycard, it must unlock something."))

/obj/item/card/id/keycard/attack_self(mob/living/user as mob)
	return

/obj/item/card/id/keycard/blue
	icon_state = "keycard-blue"
	access = list(802)

/obj/item/card/id/keycard/green
	icon_state = "keycard-green"
	access = list(803)

/obj/item/glamourcrystal
	name = "white crytal"
	desc = "A large white, highly reflective crystal with a slight glow to it."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "glamourcrystal"

/obj/structure/crystalholder
	name = "material cart"
	desc = "A cart designed to fit and carry one large carefully cut crystal."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "crystalholder"
	var/crystal = 0
	density = 1
	anchored = 0

/obj/structure/crystalholder/attackby(obj/item/W as obj, mob/living/user as mob)
	if(istype(W,/obj/item/glamourcrystal) && !crystal)
		icon_state = "crystalholder_full"
		update_icon()
		crystal = 1
		user.drop_item()
		qdel(W)
		to_chat(usr, span_notice("You insert the crystal into the receptacle."))
	else
		to_chat(usr, span_notice("There isn't a slot for that."))

/obj/machinery/crystalexperimenter
	name = "crystal experimenter"
	desc = "A cart designed to fit and carry one large carefully cut crystal."
	icon = 'icons/obj/32x64.dmi'
	icon_state = "crystalexperimenter"
	var/used_up = 0
	density = 0
	anchored = 1
	layer = 5
	var/id = "glamour"

/obj/machinery/crystalexperimenter/proc/experiment()
	if(used_up)
		return
	var/crystal_found = 0
	for(var/obj/structure/crystalholder/C in get_turf(src))
		if(C.crystal)
			used_up = 1
			crystal_found = 1
			continue

	if(!crystal_found)
		return

	for(var/obj/machinery/light/L in machines)
		if(L.z != src.z || get_dist(src,L) > 10)
			continue
		else
			L.flicker(10)

	for(var/obj/machinery/door/blast/M in machines)
		if(M.id == id)
			if(M.density)
				spawn(0)
					M.open()
					return
			else
				spawn(0)
					M.close()
					return


/obj/machinery/button/remote/experimenter
	name = "experimentation switch"
	desc = "A switch tied to nearby machinery."

/obj/machinery/button/remote/experimenter/trigger()
	for(var/obj/machinery/crystalexperimenter/E in machines)
		E.experiment()

/turf/unsimulated/wall/glamour
	name = "glamour"
	desc = "A blindingly white light that appears to cast your reflection."
	icon = 'icons/turf/flooring/glamour.dmi'
	icon_state = "glamour"

/turf/simulated/floor/glamour
	name = "glamour"
	desc = "A blindingly white light that appears to cast your reflection."
	icon = 'icons/turf/flooring/glamour.dmi'
	icon_state = "glamour"
	light_range = 7
	light_power = 1
	light_color = "#ffffff"
	light_on = TRUE
