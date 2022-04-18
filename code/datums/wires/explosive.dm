/datum/wires/explosive
	wire_count = 1
	proper_name = "Explosive wires"

/datum/wires/explosive/New(atom/_holder)
	wires = list(WIRE_EXPLODE)
	return ..()

/datum/wires/explosive/proc/explode()
	return

/datum/wires/explosive/on_pulse(wire)
	switch(wire)
		if(WIRE_EXPLODE)
			explode()

/datum/wires/explosive/on_cut(wire, mend)
	switch(wire)
		if(WIRE_EXPLODE)
			if(!mend)
				explode()

/datum/wires/explosive/c4
	holder_type = /obj/item/plastique

/datum/wires/explosive/c4/interactable(mob/user)
	var/obj/item/plastique/P = holder
	if(P.open_panel)
		return TRUE
	return FALSE

/datum/wires/explosive/c4/explode()
<<<<<<< HEAD
	var/obj/item/weapon/plastique/P = holder
	P.explode(get_turf(P))
=======
	var/obj/item/plastique/P = holder
	P.set_target(get_turf(P))
	P.detonate()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
