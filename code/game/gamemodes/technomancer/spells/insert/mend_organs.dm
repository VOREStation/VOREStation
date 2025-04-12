/datum/technomancer/spell/mend_organs
	name = "Great Mend Wounds"
	desc = "Greatly heals the target's wounds, both external and internal.  Restores internal organs to functioning states, even if \
	robotic, reforms bones, patches internal bleeding, and restores missing blood."
	spell_power_desc = "Healing amount increased."
	cost = 100
	obj_path = /obj/item/spell/insert/mend_organs
	ability_icon_state = "tech_mendwounds"
	category = SUPPORT_SPELLS

/obj/item/spell/insert/mend_organs
	name = "great mend wounds"
	desc = "A walking medbay is now you!"
	icon_state = "mend_wounds"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	inserting = /obj/item/inserted_spell/mend_organs

/obj/item/inserted_spell/mend_organs/on_insert()
	if(ishuman(host))
		var/mob/living/carbon/human/H = host
		var/heal_power = host == origin ? 2 : 5
		heal_power = round(heal_power * spell_power_at_creation, 1)
		origin.adjust_instability(15)

		looped_insert(5, H)


/obj/item/inserted_spell/mend_wires/looped_insert(remaining_callbacks, mob/living/carbon/human/H)
	if(H)
		remaining_callbacks --
		for(var/obj/item/organ/O in H.internal_organs)
			if(O.damage > 0) // Fix internal damage
				O.damage = max(O.damage - (heal_power / 5), 0)
			if(O.damage <= 5 && O.organ_tag == O_EYES) // Fix eyes
				H.sdisabilities &= ~BLIND

		for(var/obj/item/organ/external/O in H.organs) // Fix limbs
			if(!O.robotic < ORGAN_ROBOT) // No robot parts for this.
				continue
			O.heal_damage(0, heal_power / 5, internal = 1, robo_repair = 0)

		for(var/obj/item/organ/E in H.bad_external_organs) // Fix bones
			var/obj/item/organ/external/affected = E
			if((affected.damage < affected.min_broken_damage *  CONFIG_GET(number/organ_health_multiplier)) && (affected.status & ORGAN_BROKEN))
				affected.status &= ~ORGAN_BROKEN

			for(var/datum/wound/W in affected.wounds) // Fix IB
				if(istype(W, /datum/wound/internal_bleeding))
					affected.wounds -= W
					affected.update_damages()

		H.restore_blood() // Fix bloodloss

		H.adjustBruteLoss(-heal_power)

		if(remaining_callbacks > 0)
			addtimer(CALLBACK(src, PROC_REF(looped_insert), remaining_callbacks, H), 1 SECOND, TIMER_DELETE_ME)
			return

	on_expire()
