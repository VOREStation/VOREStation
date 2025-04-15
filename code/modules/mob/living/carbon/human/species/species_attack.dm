/datum/unarmed_attack/bite/sharp //eye teeth
	attack_name = "sharp bite"
	attack_verb = list("bit", "chomped on")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	sharp = TRUE
	edge = TRUE

/datum/unarmed_attack/diona
	attack_name = "tendrils"
	attack_verb = list("lashed", "bludgeoned")
	attack_noun = list("tendril")
	eye_attack_text = "a tendril"
	eye_attack_text_victim = "a tendril"
	is_punch = TRUE

/datum/unarmed_attack/claws
	attack_name = "claws"
	attack_verb = list("scratched", "clawed", "slashed")
	attack_noun = list("claws")
	eye_attack_text = "claws"
	eye_attack_text_victim = "sharp claws"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	sharp = TRUE
	edge = TRUE

/datum/unarmed_attack/claws/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/datum/gender/T = GLOB.gender_datums[user.get_visible_gender()]
	var/datum/gender/TT = GLOB.gender_datums[target.get_visible_gender()]
	attack_damage = CLAMP(attack_damage, 1, 5)

	if(target == user)
		user.visible_message(span_danger("[user] [pick(attack_verb)] [T.himself] in the [affecting.name]!"))
		return 0

	switch(zone)
		if(BP_HEAD, O_MOUTH, O_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message(span_danger("[user] scratched [target] across [TT.his] cheek!"))
				if(3 to 4)
					user.visible_message(span_danger("[user] [pick(attack_verb)] [target]'s [pick("head", "neck")]!")) //'with spread claws' sounds a little bit odd, just enough that conciseness is better here I think
				if(5)
					user.visible_message(pick(
						span_danger("[user] rakes [T.his] [pick(attack_noun)] across [target]'s face!"),
						span_danger("[user] tears [T.his] [pick(attack_noun)] into [target]'s face!"),
						))
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)	user.visible_message(span_danger("[user] scratched [target]'s [affecting.name]!"))
				if(3 to 4)	user.visible_message(span_danger("[user] [pick(attack_verb)] [pick("", "", "the side of")] [target]'s [affecting.name]!"))
				if(5)		user.visible_message(span_danger("[user] tears [T.his] [pick(attack_noun)] [pick("deep into", "into", "across")] [target]'s [affecting.name]!"))

/datum/unarmed_attack/claws/strong
	attack_name = "strong claws"
	attack_verb = list("slashed")
	damage = 5
	shredding = 1

/datum/unarmed_attack/claws/strong/xeno
	attack_verb = list("slashed", "gouged", "stabbed")
	damage = 15

/datum/unarmed_attack/claws/strong/xeno/queen
	attack_verb = list("slashed", "gouged", "stabbed", "gored")
	damage = 20

/datum/unarmed_attack/bite/strong
	attack_name = "strong bite"
	attack_verb = list("mauled")
	damage = 8
	shredding = 1

/datum/unarmed_attack/bite/strong/xeno
	damage = 15

/datum/unarmed_attack/slime_glomp
	attack_name = "glomp"
	attack_verb = list("glomped")
	attack_noun = list("body")
	damage = 2

/datum/unarmed_attack/slime_glomp/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)
	..()
	user.apply_stored_shock_to(target)

/datum/unarmed_attack/stomp/weak
	attack_name = "weak stomp"
	attack_verb = list("jumped on")

/datum/unarmed_attack/stomp/weak/get_unarmed_damage()
	return damage

/datum/unarmed_attack/stomp/weak/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	user.visible_message(span_warning("[user] jumped up and down on \the [target]'s [affecting.name]!"))
	playsound(user, attack_sound, 25, 1, -1)

/datum/unarmed_attack/bite/sharp/numbing //Is using this against someone you are truly trying to fight a bad idea? Yes. Yes it is.
	attack_name = "numbing bite"
	attack_verb = list("bit")
	attack_noun = list("fangs")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	sharp = TRUE
	edge = TRUE

/datum/unarmed_attack/bite/sharp/numbing/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)

	attack_damage = CLAMP(attack_damage, 1, 5)
	if(target == user)
		user.visible_message(span_danger("[user] [pick(attack_verb)] \himself in the [affecting.name]!"))
		return 0 //No venom for you.
	switch(zone)
		if(BP_HEAD, O_MOUTH, O_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message(span_danger("[user]'s fangs scrape across [target]'s cheek!"))
					to_chat(target, span_danger("Your face feels tingly!"))
					target.bloodstr.add_reagent(REAGENT_ID_NUMBENZYME,attack_damage) //Have to add this here, otherwise the swtich fails.
				if(3 to 4)
					user.visible_message(span_danger("[user]'s fangs pierce into [target]'s neck at an odd, awkward angle!"))
					to_chat(target, span_danger("Your neck feels like it's on fire before going numb!"))
					target.bloodstr.add_reagent(REAGENT_ID_NUMBENZYME,attack_damage)
				if(5)
					user.visible_message(span_danger("[user] sinks \his [pick(attack_noun)] <b><i>deep</i></b> into [target]'s neck, causing the vein to bulge outwards at some type of chemical is pumped into it!"))
					to_chat(target, span_danger("Your neck feels like it's going to burst! Moments later, you simply can't feel your neck any longer, the numbness beginning to spread throughout your body!"))
					target.bloodstr.add_reagent(REAGENT_ID_NUMBENZYME,attack_damage)
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message(span_danger("[user]'s fangs scrape across [target]'s [affecting.name]!"))
					to_chat(target, span_danger("Your [affecting.name] feels tingly!"))
					target.bloodstr.add_reagent(REAGENT_ID_NUMBENZYME,attack_damage)
				if(3 to 4)
					user.visible_message(span_danger("[user]'s fangs pierce [pick("", "", "the side of")] [target]'s [affecting.name]!"))
					to_chat(target, span_danger("Your [affecting.name] feels like it's on fire before going numb!"))
					target.bloodstr.add_reagent(REAGENT_ID_NUMBENZYME,attack_damage)
				if(5)
					user.visible_message(span_danger("[user]'s fangs sink deep into [target]'s [affecting.name], one of their veins bulging outwards from the sudden fluid pumped into it!"))
					to_chat(target, span_danger("Your [affecting.name] feels like it's going to burst! Moments later, you simply can't feel your [affecting.name] any longer, the numbness slowly spreading throughout your body!"))
					target.bloodstr.add_reagent(REAGENT_ID_NUMBENZYME,attack_damage)

/datum/unarmed_attack/claws/shadekin

/datum/unarmed_attack/claws/shadekin/apply_effects(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	..()
	if(!(target == user))
		user.shadekin_adjust_energy(attack_damage)

/datum/unarmed_attack/bite/sharp/shadekin

/datum/unarmed_attack/bite/sharp/shadekin/apply_effects(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	..()
	if(!(target == user))
		user.shadekin_adjust_energy(attack_damage)

/datum/unarmed_attack/claws/chimera //special feral attack that gets stronger as they get angrier

/datum/unarmed_attack/claws/chimera/get_unarmed_damage(var/mob/living/carbon/human/user)
	return user.feral/5

/datum/unarmed_attack/claws/chimera/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)
	..()
	if(user.feral && !(target == user))
		var/selfdamage = ((user.feral/10)-7.5)
		if(selfdamage > 0)
			var/selfdamagezone = null
			if (user.hand)
				selfdamagezone=pick(BP_L_ARM, BP_L_HAND)
			else
				selfdamagezone=pick(BP_R_ARM, BP_R_HAND)
			user.apply_damage(selfdamage, BRUTE, selfdamagezone, 0, 0, sharp=FALSE, edge=FALSE)
