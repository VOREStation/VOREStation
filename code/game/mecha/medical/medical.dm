/obj/mecha/medical
	max_hull_equip = 1
	max_weapon_equip = 0
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

	melee_sound = 'sound/weapons/resonator_blast.ogg'
	stomp_sound = 'sound/mecha/mechmove01.ogg'

	cargo_capacity = 1

	starting_components = list(
		/obj/item/mecha_parts/component/hull,
		/obj/item/mecha_parts/component/actuator,
		/obj/item/mecha_parts/component/armor/lightweight,
		/obj/item/mecha_parts/component/gas,
		/obj/item/mecha_parts/component/electrical
		)

	var/obj/item/clothing/glasses/hud/health/mech/hud

/obj/mecha/medical/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	if(isPlayerLevel(T.z))
		new /obj/item/mecha_parts/mecha_tracking(src)

	hud = new /obj/item/clothing/glasses/hud/health/mech(src)
	return

/obj/mecha/medical/moved_inside(var/mob/living/carbon/human/H as mob)
	. = ..()
	if(istype(H))
		if(H.glasses)
			occupant_message("<font color='red'>[H.glasses] prevent you from using [src] [hud]</font>")
		else
			H.glasses = hud
			H.recalculate_vis()

/obj/mecha/medical/odysseus/go_out()
	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		if(H.glasses == hud)
			H.glasses = null
			H.recalculate_vis()
	return ..()

/*	// One horrific bastardization of glorious inheritence dead. A billion to go. ~Mech
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
*/
