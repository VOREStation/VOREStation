/obj/mecha/medical/odysseus
	desc = "These exosuits are developed and produced by Vey-Med. (&copy; All rights reserved)."
	name = "Odysseus"
	catalogue_data = list(
		/datum/category_item/catalogue/technology/odysseus,
		/datum/category_item/catalogue/information/organization/vey_med
		)
	icon_state = "odysseus"
	initial_icon = "odysseus"
	step_in = 2
	max_temperature = 15000
	health = 70
	maxhealth = 70
	wreckage = /obj/effect/decal/mecha_wreckage/odysseus
	internal_damage_threshold = 35
	deflect_chance = 15
	step_energy_drain = 6
	var/obj/item/clothing/glasses/hud/health/mech/hud

	icon_scale_x = 1.2
	icon_scale_y = 1.2

/obj/mecha/medical/odysseus/New()
	..()
	hud = new /obj/item/clothing/glasses/hud/health/mech(src)
	return

/obj/mecha/medical/odysseus/moved_inside(var/mob/living/human/H as mob)
	if(..())
		if(H.glasses)
			occupant_message("<font color='red'>[H.glasses] prevent you from using [src] [hud]</font>")
		else
			H.glasses = hud
			H.recalculate_vis()
		return 1
	else
		return 0

/obj/mecha/medical/odysseus/go_out()
	if(ishuman(occupant))
		var/mob/living/human/H = occupant
		if(H.glasses == hud)
			H.glasses = null
			H.recalculate_vis()
	..()
	return
/*
	verb/set_perspective()
		set name = "Set client perspective."
		set category = "Exosuit Interface"
		set src = usr.loc
		var/perspective = input(usr, "Select a perspective type.",
                      "Client perspective",
                      occupant.client.perspective) in list(MOB_PERSPECTIVE,EYE_PERSPECTIVE)
		to_world("[perspective]")
		occupant.client.perspective = perspective
		return

	verb/toggle_eye()
		set name = "Toggle eye."
		set category = "Exosuit Interface"
		set src = usr.loc
		if(occupant.client.eye == occupant)
			occupant.client.eye = src
		else
			occupant.client.eye = occupant
		to_world("[occupant.client.eye]")
		return
*/

//TODO - Check documentation for client.eye and client.perspective...
/obj/item/clothing/glasses/hud/health/mech
	name = "Integrated Medical Hud"


//	process_hud(var/mob/M) //TODO VIS
/*
		to_world("view(M)")
		for(var/mob/mob in view(M))
			to_world("[mob]")
		to_world("view(M.client)")
		for(var/mob/mob in view(M.client))
			to_world("[mob]")
		to_world("view(M.loc)")
		for(var/mob/mob in view(M.loc))
			to_world("[mob]")


		if(!M || M.stat || !(M in view(M)))	return
		if(!M.client)	return
		var/client/C = M.client
		var/image/holder
		for(var/mob/living/human/patient in view(M.loc))
			if(M.see_invisible < patient.invisibility)
				continue
			var/foundVirus = 0

			for (var/ID in patient.virus2)
				if (ID in virusDB)
					foundVirus = 1
					break

			holder = patient.hud_list[HEALTH_HUD]
			if(patient.stat == DEAD)
				holder.icon_state = "hudhealth-100"
				C.images += holder
			else
				holder.icon_state = RoundHealth((patient.health-config.health_threshold_crit)/(patient.getMaxHealth()-config.health_threshold_crit)*100)
				C.images += holder

			holder = patient.hud_list[STATUS_HUD]
			if(patient.isSynthetic())
				holder.icon_state = "hudrobo"
			else if(patient.stat == DEAD)
				holder.icon_state = "huddead"
			else if(foundVirus)
				holder.icon_state = "hudill"
			else if(patient.has_brain_worms())
				var/mob/living/simple_mob/animal/borer/B = patient.has_brain_worms()
				if(B.controlling)
					holder.icon_state = "hudbrainworm"
				else
					holder.icon_state = "hudhealthy"
			else
				holder.icon_state = "hudhealthy"

			C.images += holder
*/
/obj/mecha/medical/odysseus/loaded/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/tool/sleeper
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/sleeper
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	ME.attach(src)

//Meant for random spawns.
/obj/mecha/medical/odysseus/old
	desc = "An aging combat exosuit utilized by many corporations. Originally developed to combat hostile alien lifeforms. This one is particularly worn looking and likely isn't as sturdy."

/obj/mecha/medical/odysseus/old/New()
	..()
	health = 25
	maxhealth = 50	//Just slightly worse.
	cell.charge = rand(0, (cell.charge/2))