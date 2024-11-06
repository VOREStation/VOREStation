// Glass shards

/obj/item/material/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
	icon_state = "large"
	randpixel = 8
	sharp = TRUE
	edge = TRUE
	w_class = ITEMSIZE_SMALL
	force_divisor = 0.25 // 7.5 with hardness 30 (glass)
	thrown_force_divisor = 0.5
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	default_material = "glass"
	unbreakable = 1 //It's already broken.
	drops_debris = 0

/obj/item/material/shard/set_material(var/new_material)
	..(new_material)
	if(!istype(material))
		return

	icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
	randpixel_xy()
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

/obj/item/material/shard/update_icon()
	if(material)
		color = material.icon_colour
		// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
		alpha = 255 * (1 - (1 - material.opacity)*(1 - material.opacity))
	else
		color = "#ffffff"
		alpha = 255

/obj/item/material/shard/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WELDER) && material.shard_can_repair)
		var/obj/item/weldingtool/WT = W.get_welder()
		if(WT.remove_fuel(0, user))
			material.place_sheet(loc, 1)
			qdel(src)
			return
	return ..()

/obj/item/material/shard/afterattack(var/atom/target, mob/living/carbon/human/user as mob, proximity)
	if(!proximity)
		return
	var/active_hand //hand the shard is in
	var/will_break = FALSE
	var/protected_hands = FALSE //this is a fucking mess
	var/break_damage = 4
	var/light_glove_d = rand(2, 4)
	var/no_glove_d = rand(4, 6)
	var/list/forbidden_gloves = list(
			/obj/item/clothing/gloves/sterile,
			/obj/item/clothing/gloves/knuckledusters
		)

	if(src == user.l_hand)
		active_hand = BP_L_HAND
	else if(src == user.r_hand)
		active_hand = BP_R_HAND
	else
		return // If it's not actually in our hands anymore, we were probably gentle with it

	active_hand = (src == user.l_hand) ? BP_L_HAND : BP_R_HAND // May not actually be faster than an if-else block, but a little bit cleaner -Ater

	if(prob(75))
		will_break = TRUE

	if(user.gloves && (user.gloves.body_parts_covered & HANDS) && istype(user.gloves, /obj/item/clothing/gloves)) // Not-gloves aren't gloves, and therefore don't protect us
		protected_hands = TRUE // If we're wearing gloves we can probably handle it just fine
		for(var/I in forbidden_gloves)
			if(istype(user.gloves, I)) // forbidden_gloves is a blacklist, so if we match anything in there, our hands are not protected
				protected_hands = FALSE
				break

	if(user.gloves && !protected_hands)
		to_chat(user, span_warning("\The [src] partially cuts into your hand through your gloves as you hit \the [target]!"))
		user.apply_damage(light_glove_d + will_break ? break_damage : 0, BRUTE, active_hand, 0, 0, src, src.sharp, src.edge) // Ternary to include break damage

	else if(!user.gloves)
		to_chat(user, span_warning("\The [src] cuts into your hand as you hit \the [target]!"))
		user.apply_damage(no_glove_d + will_break ? break_damage : 0, BRUTE, active_hand, 0, 0, src, src.sharp, src.edge)

	if(will_break && src.loc == user) // If it's not in our hand anymore
		user.visible_message(span_danger("[user] hit \the [target] with \the [src], shattering it!"), span_warning("You shatter \the [src] in your hand!"))
		playsound(src, pick('sound/effects/Glassbr1.ogg', 'sound/effects/Glassbr2.ogg', 'sound/effects/Glassbr3.ogg'), 30, 1)
		qdel(src)
	return

/obj/item/material/shard/Crossed(atom/movable/AM as mob|obj)
	..()
	if(AM.is_incorporeal())
		return
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(src, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5) //Thick skin.
				return

			if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
				return

			if(H.species.flags & NO_MINOR_CUT)
				return

			to_chat(H, span_danger("You step on \the [src]!"))

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
/obj/item/material/shard/shrapnel/New(loc)
	..(loc, "steel")

/obj/item/material/shard/phoron/New(loc)
	..(loc, "borosilicate glass")
