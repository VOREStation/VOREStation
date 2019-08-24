/obj/item/clothing/gloves/boxing/hologlove/
	special_attack_type = /datum/unarmed_attack/holopugilism

datum/unarmed_attack/holopugilism
	sparring_variant_type = /datum/unarmed_attack/holopugilism

datum/unarmed_attack/holopugilism/unarmed_override(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/zone)
	user.do_attack_animation(src)
	var/damage = rand(0, 9)
	if(!damage)
		playsound(target.loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		target.visible_message("<font color='red'><B>[user] has attempted to punch [target]!</B></font>")
		return 1
	var/obj/item/organ/external/affecting = target.get_organ(ran_zone(user.zone_sel.selecting))
	var/armor_block = target.run_armor_check(affecting, "melee")
	var/armor_soak = target.get_armor_soak(affecting, "melee")

	if(HULK in user.mutations)
		damage += 5

	playsound(target.loc, "punch", 25, 1, -1)

	target.visible_message("<font color='red'><B>[user] has punched [target]!</B></font>")

	if(armor_soak >= damage)
		return

	target.apply_damage(damage, HALLOSS, affecting, armor_block, armor_soak)
	if(damage >= 9)
		target.visible_message("<font color='red'><B>[user] has weakened [target]!</B></font>")
		target.apply_effect(4, WEAKEN, armor_block)

	return 1
