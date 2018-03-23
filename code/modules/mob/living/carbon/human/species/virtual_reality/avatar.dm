// ### Wooo, inheritance. Basically copying everything I don't need to edit from prometheans, because they mostly work already.
// ### Any and all of this is open to change for balance or whatever.
// ###
// ###
// Species definition follows.
/datum/species/shapeshifter/promethean/avatar

	name =             SPECIES_VR
	name_plural =      "Virtual Reality Avatars"
	blurb =            "A 3-dimensional representation of some sort of animate object used to display the presence and actions of some-one or -thing using a virtual reality program."
	show_ssd =         "eerily still"
	death_message =    "flickers briefly, their gear falling in a heap on the floor around their motionless body."
	knockout_message = "has been knocked unconscious!"

	spawn_flags =		SPECIES_IS_RESTRICTED

	speech_bubble_appearance = "cyber"

	male_cough_sounds = list('sound/effects/mob_effects/m_cougha.ogg','sound/effects/mob_effects/m_coughb.ogg', 'sound/effects/mob_effects/m_coughc.ogg')
	female_cough_sounds = list('sound/effects/mob_effects/f_cougha.ogg','sound/effects/mob_effects/f_coughb.ogg')
	male_sneeze_sound = 'sound/effects/mob_effects/sneeze.ogg'
	female_sneeze_sound = 'sound/effects/mob_effects/f_sneeze.ogg'

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	has_organ =     list(O_BRAIN = /obj/item/organ/internal/brain/slime, O_EYES = /obj/item/organ/internal/eyes) // Slime core.
	heal_rate = 0		// Avatars don't naturally heal like prometheans, at least not for now
	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/regenerate,
		/mob/living/carbon/human/proc/shapeshifter_change_opacity,
		/mob/living/carbon/human/proc/exit_vr
		)


/datum/species/shapeshifter/promethean/avatar/handle_death(var/mob/living/carbon/human/H)
	return

/datum/species/shapeshifter/promethean/avatar/handle_environment_special(var/mob/living/carbon/human/H)
	return

/mob/living/carbon/human/proc/shapeshifter_change_opacity()

	set name = "Toggle Opacity"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10

	if(src.icon_state == "promethean")
		icon_state = lowertext(src.species.get_bodytype(src))
		shapeshifter_change_species("Virtual Reality [src.species.get_bodytype(src)]")
	else
		icon_state = "promethean"
		shapeshifter_change_species(SPECIES_VR)


// enter_vr is called on the original mob, and puts the mind into the supplied vr mob
/mob/living/carbon/human/proc/enter_vr(var/mob/living/carbon/human/avatar) // Avatar is currently a human, because we have preexisting setup code for appearance manipulation, etc.
	if(!istype(avatar))
		return

	// Link the two mobs for client transfer
	avatar.vr_holder = src
	src.teleop = avatar
	src.vr_link = avatar // Can't reuse vr_holder so that death can automatically eject users from VR

	// Move the mind
	avatar.Sleeping(1)
	src.mind.transfer_to(avatar)
	to_chat(avatar, "<b>You have enterred Virtual Reality!\nAll normal gameplay rules still apply.\nWounds you suffer here won't persist when you leave VR, but some of the pain will.\nYou can leave VR at any time by using the \"Exit Virtual Reality\" verb in the Abilities tab, or by ghosting.\nYou can modify your appearance by using various \"Change \[X\]\" verbs in the Abilities tab.</b>")
	to_chat(avatar, "<span class='notice'> You black out for a moment, and wake to find yourself in a new body in virtual reality.</span>") // So this is what VR feels like?

// exit_vr is called on the vr mob, and puts the mind back into the original mob
/mob/living/carbon/human/proc/exit_vr()
	set name = "Exit Virtual Reality"
	set category = "Abilities"

	if(!vr_holder)
		return
	if(!mind)
		return

	var/total_damage
	// Tally human damage
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		total_damage = H.getBruteLoss() + H.getFireLoss() + H.getOxyLoss() + H.getToxLoss()

	// Move the mind back to the original mob
//	vr_holder.Sleeping(1)
	src.mind.transfer_to(vr_holder)
	to_chat(vr_holder, "<span class='notice'>You black out for a moment, and wake to find yourself back in your own body.</span>")
	// Two-thirds damage is transferred as agony for /humans
	// Getting hurt in VR doesn't damage the physical body, but you still got hurt.
	if(ishuman(vr_holder) && total_damage)
		var/mob/living/carbon/human/V = vr_holder
		V.stun_effect_act(0, total_damage*2/3, null)												// 200 damage leaves the user in paincrit for several seconds, agony reaches 0 after around 2m.
		to_chat(vr_holder, "<span class='warning'>Pain from your time in VR lingers.</span>")		// 250 damage leaves the user unconscious for several seconds in addition to paincrit

	// Maintain a link with the mob, but don't use teleop
	vr_holder.vr_link = src
	vr_holder.teleop = null

	if(istype(vr_holder.loc, /obj/machinery/vr_sleeper))
		var/obj/machinery/vr_sleeper/V = vr_holder.loc
		V.go_out()