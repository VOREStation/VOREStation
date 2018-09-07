/obj/mecha/medical
	max_hull_equip = 1
	max_weapon_equip = 0
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

	cargo_capacity = 1

/obj/mecha/medical/initialize()
	. = ..()
	var/turf/T = get_turf(src)
	if(isPlayerLevel(T.z))
		new /obj/item/mecha_parts/mecha_tracking(src)


/obj/mecha/medical/mechturn(direction)
	set_dir(direction)
	playsound(src,'sound/mecha/mechmove01.ogg',40,1)
	return 1

/obj/mecha/medical/mechstep(direction)
	var/result = step(src,direction)
	if(result)
		playsound(src,'sound/mecha/mechstep.ogg',25,1)
	return result

/obj/mecha/medical/mechsteprand()
	var/result = step_rand(src)
	if(result)
		playsound(src,'sound/mecha/mechstep.ogg',25,1)
	return result