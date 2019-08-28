// Glass shards

/obj/item/weapon/material/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
	icon_state = "large"
	sharp = 1
	edge = 1
	w_class = ITEMSIZE_SMALL
	force_divisor = 0.25 // 7.5 with hardness 30 (glass)
	thrown_force_divisor = 0.5
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	default_material = "glass"
	unbreakable = 1 //It's already broken.
	drops_debris = 0

/obj/item/weapon/material/shard/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	viewers(user) << pick("<span class='danger'>\The [user] is slitting [TU.his] wrists with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>",
	                      "<span class='danger'>\The [user] is slitting [TU.his] throat with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/weapon/material/shard/set_material(var/new_material)
	..(new_material)
	if(!istype(material))
		return

	icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)
	update_icon()

	if(material.shard_type)
		name = "[material.display_name] [material.shard_type]"
		desc = "A small piece of [material.display_name]. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as ... a throwing weapon?"
		switch(material.shard_type)
			if(SHARD_SPLINTER, SHARD_SHRAPNEL)
				gender = PLURAL
			else
				gender = NEUTER
	else
		qdel(src)

/obj/item/weapon/material/shard/update_icon()
	if(material)
		color = material.icon_colour
		// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
		alpha = 255 * (1 - (1 - material.opacity)*(1 - material.opacity))
	else
		color = "#ffffff"
		alpha = 255

/obj/item/weapon/material/shard/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool) && material.shard_can_repair)
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			material.place_sheet(loc)
			qdel(src)
			return
	return ..()

/obj/item/weapon/material/shard/afterattack(var/atom/target, mob/living/carbon/human/user as mob)
	var/active_hand //hand the shard is in
	var/will_break
	var/gloves_are_heavy = FALSE//this is a fucking mess
	var/break_damage = 4
	var/light_glove_d = rand(2, 4)
	var/no_glove_d = rand(4, 6)
	var/list/h_gloves = list(/obj/item/clothing/gloves/captain, /obj/item/clothing/gloves/cyborg,
							/obj/item/clothing/gloves/swat, /obj/item/clothing/gloves/combat,
							/obj/item/clothing/gloves/botanic_leather, /obj/item/clothing/gloves/duty,
							/obj/item/clothing/gloves/tactical, /obj/item/clothing/gloves/vox,
							/obj/item/clothing/gloves/gauntlets)

	if(istype(user.l_hand, src))
		active_hand = BP_L_HAND
	else
		active_hand = BP_R_HAND

	if(prob(75))
		will_break = TRUE
	else
		will_break = FALSE

	if(user.gloves && (user.gloves.body_parts_covered & HANDS))
		var/obj/item/clothing/gloves/UG = user.gloves.type
		for(var/I in h_gloves)
			if(UG == I)
				gloves_are_heavy = TRUE
				if(will_break)
					user.visible_message("<span class='danger'>[user] hit \the [target] with \the [src], shattering it!</span>", "<span class='warning'>You shatter \the [src] in your hand!</span>")
					playsound(user, pick('sound/effects/Glassbr1.ogg', 'sound/effects/Glassbr2.ogg', 'sound/effects/Glassbr3.ogg'), 30, 1)
					qdel(src)

		if(gloves_are_heavy == FALSE)
			to_chat(user, "<span class='warning'>\The [src] partially cuts into your hand through your gloves as you hit \the [target]!</span>")
			if(will_break)
				user.visible_message("<span class='danger'>[user] hit \the [target] with \the [src], shattering it!</span>", "<span class='warning'>You shatter \the [src] in your hand!</span>")
				user.apply_damage(light_glove_d + break_damage, BRUTE, active_hand, 0 ,0, src, src.sharp, src.edge)
				playsound(user, pick('sound/effects/Glassbr1.ogg', 'sound/effects/Glassbr2.ogg', 'sound/effects/Glassbr3.ogg'), 30, 1)
				qdel(src)
			else
				user.apply_damage(light_glove_d, BRUTE, active_hand, 0 ,0, src, src.sharp, src.edge)
	else
		to_chat(user, "<span class='warning'>\The [src] cuts into your hand as you hit \the [target]!</span>")
		if(will_break)
			user.visible_message("<span class='danger'>[user] hit \the [target] with \the [src], shattering it!</span>", "<span class='warning'>You shatter \the [src] in your hand!</span>")
			user.apply_damage(no_glove_d + break_damage, BRUTE, active_hand, 0 ,0, src, src.sharp, src.edge)
			playsound(user, pick('sound/effects/Glassbr1.ogg', 'sound/effects/Glassbr2.ogg', 'sound/effects/Glassbr3.ogg'), 30, 1)
			qdel(src)
		else
			user.apply_damage(no_glove_d, BRUTE, active_hand, 0 ,0, src, src.sharp, src.edge)

/obj/item/weapon/material/shard/Crossed(AM as mob|obj)
	..()
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5) //Thick skin.
				return

			if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
				return

			if(H.species.flags & NO_MINOR_CUT)
				return

			to_chat(H, "<span class='danger'>You step on \the [src]!</span>")

			var/list/check = list("l_foot", "r_foot")
			while(check.len)
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = H.get_organ(picked)
				if(affecting)
					if(affecting.robotic >= ORGAN_ROBOT)
						return
					if(affecting.take_damage(force, 0))
						H.UpdateDamageIcon()
					H.updatehealth()
					if(affecting.organ_can_feel_pain())
						H.Weaken(3)
					return
				check -= picked
			return

// Preset types - left here for the code that uses them
/obj/item/weapon/material/shard/shrapnel/New(loc)
	..(loc, "steel")

/obj/item/weapon/material/shard/phoron/New(loc)
	..(loc, "phglass")
