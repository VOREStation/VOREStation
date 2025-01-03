/obj/item/material/harpoon
	name = "harpoon"
	sharp = TRUE
	edge = FALSE
	desc = "Tharr she blows!"
	icon_state = "harpoon"
	item_state = "harpoon"
	force_divisor = 0.3 // 18 with hardness 60 (steel)
	attack_verb = list("jabbed","stabbed","ripped")

/obj/item/material/knife/machete/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hatchet"
	force_divisor = 0.2 // 12 with hardness 60 (steel)
	thrown_force_divisor = 0.75 // 15 with weight 20 (steel)
	w_class = ITEMSIZE_SMALL
	sharp = TRUE
	edge = TRUE
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	attack_verb = list("chopped", "torn", "cut")
	applies_material_colour = 0
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'
/* VOREStation Removal - We have one already
/obj/item/material/knife/machete/hatchet/stone
	name = "sharp rock"
	desc = "The secret is to bang the rocks together, guys."
	force_divisor = 0.2
	icon_state = "rock"
	item_state = "rock"
	attack_verb = list("chopped", "torn", "cut")

/obj/item/material/knife/machete/hatchet/stone/set_material(var/new_material)
	var/old_name = name
	. = ..()
	name = old_name
*/
/obj/item/material/knife/machete/hatchet/unathiknife
	name = "duelling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "unathiknife"
	attack_verb = list("ripped", "torn", "cut")
	can_cleave = FALSE
	var/hits = 0

/obj/item/material/knife/machete/hatchet/unathiknife/attack(mob/M as mob, mob/user as mob)
	if(hits > 0)
		return
	var/obj/item/I = user.get_inactive_hand()
	if(istype(I, /obj/item/material/knife/machete/hatchet/unathiknife))
		hits ++
		var/obj/item/W = I
		W.attack(M, user)
		W.afterattack(M, user)
	..()

/obj/item/material/knife/machete/hatchet/unathiknife/afterattack(mob/M as mob, mob/user as mob)
	hits = initial(hits)
	..()

/obj/item/material/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hoe"
	force_divisor = 0.25 // 5 with weight 20 (steel)
	thrown_force_divisor = 0.25 // as above
	dulled_divisor = 0.75	//Still metal on a long pole
	w_class = ITEMSIZE_SMALL
	attack_verb = list("slashed", "sliced", "cut", "clawed")

/obj/item/material/snow/snowball
	name = "loose packed snowball"
	desc = "A fun snowball. Throw it at your friends!"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "snowball"
	default_material = MAT_SNOW
	health = 1
	fragile = 1
	force_divisor = 0.01
	thrown_force_divisor = 0.10
	w_class = ITEMSIZE_SMALL
	attack_verb = list("mushed", "splatted", "splooshed", "splushed") // Words that totally exist.

/obj/item/material/snow/snowball/attack_self(mob/user as mob)
	if(user.a_intent == I_HURT)
		to_chat(user, span_notice("You smash the snowball in your hand."))
		var/atom/S = new /obj/item/stack/material/snow(user.loc)
		qdel(src)
		user.put_in_hands(S)
	else
		to_chat(user, span_notice("You start compacting the snowball."))
		if(do_after(user, 2 SECONDS))
			var/atom/S = new /obj/item/material/snow/snowball/reinforced(user.loc)
			qdel(src)
			user.put_in_hands(S)

/obj/item/material/snow/snowball/reinforced
	name = "snowball"
	desc = "A well-formed and fun snowball. It looks kind of dangerous."
	//icon_state = "reinf-snowball"
	force_divisor = 0.20
	thrown_force_divisor = 0.25

/obj/item/material/whip
	name = "whip"
	desc = "A tool used to discipline animals, or look cool. Mostly the latter."
	description_info = "Help - Standard attack, no modifiers.<br>\
	Disarm - Disarming strike. Attempts to disarm the target at range, similar to an unarmed disarm. Additionally, will force the target (if possible) to move away from you.<br>\
	Grab - Grappling strike. Attempts to pull the target toward you. This can also move objects.<br>\
	Harm - A standard strike with a small chance to disarm."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "whip"
	item_state = "chain"
	default_material = MAT_LEATHER
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 2)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	force_divisor = 0.15
	thrown_force_divisor = 0.25
	reach = 2

	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',
			)

/obj/item/material/whip/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	..()

	if(!proximity)
		return

	if(istype(A, /atom/movable))
		var/atom/movable/AM = A
		if(AM.anchored)
			to_chat(user, span_notice("\The [AM] won't budge."))
			return

		else
			if(!istype(AM, /obj/item))
				user.visible_message(span_warning("\The [AM] is pulled along by \the [src]!"))
				AM.Move(get_step(AM, get_dir(AM, src)))
				return

			else
				user.visible_message(span_warning("\The [AM] is snatched by \the [src]!"))
				AM.throw_at(user, reach, 0.1, user)

/obj/item/material/whip/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(user.a_intent)
		switch(user.a_intent)
			if(I_HURT)
				if(prob(10) && ishuman(target) && (user.zone_sel in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND)))
					to_chat(target, span_warning("\The [src] rips at your hands!"))
					ranged_disarm(target)
			if(I_DISARM)
				if(prob(min(90, force * 3)) && ishuman(target) && (user.zone_sel in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND)))
					ranged_disarm(target)
				else
					target.visible_message(span_danger("\The [src] sends \the [target] stumbling away."))
					target.Move(get_step(target,get_dir(user,target)))
			if(I_GRAB)
				var/turf/STurf = get_turf(target)
				spawn(2)
					playsound(STurf, 'sound/effects/snap.ogg', 60, 1)
				target.visible_message(span_critical("\The [src] yanks \the [target] towards \the [user]!"))
				target.throw_at(get_turf(get_step(user,get_dir(user,target))), 2, 1, src)

	..()

/obj/item/material/whip/proc/ranged_disarm(var/mob/living/carbon/human/H, var/mob/living/user)
	if(istype(H))
		var/list/holding = list(H.get_active_hand() = 40, H.get_inactive_hand() = 20)

		if(user.zone_sel in list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND))
			for(var/obj/item/gun/W in holding)
				if(W && prob(holding[W]))
					var/list/turfs = list()
					for(var/turf/T in view())
						turfs += T
					if(turfs.len)
						var/turf/target = pick(turfs)
						visible_message(span_danger("[H]'s [W] goes off due to \the [src]!"))
						return W.afterattack(target,H)

		if(!(H.species.flags & NO_SLIP) && prob(10) && (user.zone_sel in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)))
			var/armor_check = H.run_armor_check(user.zone_sel, "melee")
			H.apply_effect(3, WEAKEN, armor_check)
			playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			if(armor_check < 60)
				visible_message(span_danger("\The [src] has tripped [H]!"))
			else
				visible_message(span_warning("\The [src] attempted to trip [H]!"))
			return

		else
			if(H.break_all_grabs(user))
				playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				return

			if(user.zone_sel in list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND))
				for(var/obj/item/I in holding)
					if(I && prob(holding[I]))
						H.drop_from_inventory(I)
						visible_message(span_danger("\The [src] has disarmed [H]!"))
						playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
						return

/obj/item/material/whip/attack_self(mob/user)
	user.visible_message(span_warning("\The [user] cracks \the [src]!"))
	playsound(src, 'sound/effects/snap.ogg', 50, 1)

/obj/item/material/knife/machete/hatchet/stone
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "stone_wood_axe"
	default_material = MAT_FLINT
	origin_tech = list()
	applies_material_colour = FALSE

/obj/item/material/knife/machete/hatchet/stone/bone
	icon_state = "stone_bone_axe"
