/datum/technomancer/spell/mend_metal
	name = "Mend Metal"
	desc = "Restores integrity to external robotic components."
	spell_power_desc = "Healing amount increased."
	cost = 50
	obj_path = /obj/item/spell/insert/mend_metal
	ability_icon_state = "tech_mendwounds"
	category = SUPPORT_SPELLS

/obj/item/spell/insert/mend_metal
	name = "mend metal"
	desc = "A roboticist is now obsolete."
	icon_state = "mend_wounds"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	inserting = /obj/item/inserted_spell/mend_metal

/obj/item/inserted_spell/mend_metal/on_insert()
	if(ishuman(host))
		var/mob/living/carbon/human/H = host
		var/heal_power = host == origin ? 10 : 30
		heal_power = round(heal_power * spell_power_at_creation, 1)
		origin.adjust_instability(10)
		looped_insert(5, H)


/obj/item/inserted_spell/mend_metal/looped_insert(remaining_callbacks, mob/living/carbon/human/H)
	if(H)
		remaining_callbacks --
		for(var/obj/item/organ/external/O in H.organs)
			if(O.robotic < ORGAN_ROBOT) // Robot parts only.
				continue
			O.heal_damage(heal_power / 5, 0, internal = 1, robo_repair = 1)

		if(remaining_callbacks > 0)
			addtimer(CALLBACK(src, PROC_REF(looped_insert), remaining_callbacks, H), 1 SECOND, TIMER_DELETE_ME)
			return

	on_expire()
