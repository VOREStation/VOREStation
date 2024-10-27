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
	var/skill = user.skills["combat"]
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/datum/gender/T = gender_datums[user.get_visible_gender()]
	var/datum/gender/TT = gender_datums[target.get_visible_gender()]
	if(!skill)	skill = 1
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
