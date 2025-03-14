/datum/technomancer/spell/mend_burns
	name = "Mend Burns"
	desc = "Heals minor burns, such as from exposure to flame, electric shock, or lasers."
	spell_power_desc = "Healing amount increased."
	cost = 50
	obj_path = /obj/item/spell/insert/mend_burns
	ability_icon_state = "tech_mendburns"
	category = SUPPORT_SPELLS

/obj/item/spell/insert/mend_burns
	name = "mend burns"
	desc = "Ointment is a thing of the past."
	icon_state = "mend_burns"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	inserting = /obj/item/inserted_spell/mend_burns

/obj/item/inserted_spell/mend_burns/on_insert()
	if(ishuman(host))
		var/mob/living/carbon/human/H = host
		var/heal_power = host == origin ? 10 : 30
		heal_power = round(heal_power * spell_power_at_creation, 1)
		origin.adjust_instability(10)
		looped_insert(5, H)


/obj/item/inserted_spell/mend_wires/looped_insert(remaining_callbacks, mob/living/carbon/human/H)
	if(H)
		remaining_callbacks --
		H.adjustFireLoss(-heal_power / 5)

		if(remaining_callbacks > 0)
			addtimer(CALLBACK(src, PROC_REF(looped_insert), remaining_callbacks, H), 1 SECOND, TIMER_DELETE_ME)
			return

	on_expire()
