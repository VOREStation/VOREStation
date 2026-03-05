//Vac attachment
/obj/item/vac_attachment
	name = "\improper Vac-Pack attachment"
	desc = "Useful for slurping mess off the floors. Even things and stuff depending on settings. Can be connected to a trash bag or vore belly. On-mob sprites can be toggled via verb in Objects tab."
	icon = 'icons/mob/vacpack.dmi'
	icon_override = 'icons/mob/vacpack.dmi'
	icon_state = "sucker_drop"
	item_state = "sucker"
	slot_flags = SLOT_BELT | SLOT_BACK
	var/vac_power = 0
	var/output_dest = null
	var/list/vac_settings = list(
			"power off" = 0,
			"dust and grime" = 1,
			"tiny objects" = 2,
			"pests and small objects" = 3,
			"medium objects" = 4,
			"large objects" = 5,
			"large pests" = 6,
			"auto-level" = 7,
			"DANGEROUS" = 8,
			"output destination" = 9
			)
	var/vac_owner = null
	var/sucksound = 'sound/machines/kitchen/candymaker/candymaker-mid1.ogg'
	var/suckverb = "vacuum"
	var/suckanim = TRUE
	var/pull_range = 1
	var/max_items = 20
	flags = NOBLUDGEON

/obj/item/vac_attachment/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	var/set_input = null
	if(!output_dest)
		set_input = "output destination"
	if(!set_input)
		set_input = tgui_input_list(user, "Set your [suckverb] attachment's power level or output mode.", "Vac Settings", vac_settings)
	if(set_input)
		if(set_input == "output destination")
			if(vac_owner && user != vac_owner)
				to_chat(user, span_warning("Only designated owner can change this setting."))
				return
			var/vac_options = list("Vore Belly", "Trash Bag") //Dont show option for borg belly if the user isnt even a borg. QOL!
			if(isrobot(user))
				vac_options = list("Vore Belly", "Borg Belly", "Trash Bag")
			var/set_output = tgui_input_list(user, "Set your [suckverb] attachment's connection port", "Vac Settings", vac_options)
			switch(set_output)
				if("Borg Belly")
					if(isrobot(user))
						var/mob/living/silicon/robot/R = user
						var/obj/item/robot_module/M = R.module
						for(var/obj/item/dogborg/sleeper/S in M.modules)
							if(istype(S))
								output_dest = S
								return
					to_chat(user, span_warning("Borg belly not found."))
				if("Trash Bag")
					if(isrobot(user))
						var/mob/living/silicon/robot/R = user
						var/obj/item/robot_module/M = R.module
						for(var/obj/item/storage/bag/trash/T in M.modules)
							if(istype(T))
								output_dest = T
								return
					for(var/obj/item/storage/bag/trash/T in user.contents)
						if(istype(T))
							output_dest = T
							return
					to_chat(user, span_warning("Trash bag not found."))
				if("Vore Belly")
					if(user.vore_selected)
						output_dest = user.vore_selected
			return
		else
			vac_power = vac_settings[set_input]
			icon_state = "sucker-[vac_power]"

/obj/item/vac_attachment/afterattack(atom/target, mob/living/user, proximity)
	if(vac_power < 1)
		return
	if(!proximity)
		return
	if(!output_dest)
		return
	if(istype(output_dest,/obj/item/storage/bag/trash))
		if(get_turf(output_dest) != get_turf(user))
			vac_power = 0
			icon_state = "sucker-0"
			output_dest = null
			to_chat(user, span_warning("Trash bag not found. Shutting down."))
			return
		var/obj/item/storage/bag/trash/B = output_dest
		var/total_storage_space = 0
		for(var/obj/item/thing in B.contents)//no more leniency on this one. We check it all. B
			total_storage_space += thing.get_storage_cost()
			if(total_storage_space >= B.max_storage_space)
				to_chat(user, span_warning("Trash bag full. Empty trash bag contents to continue."))
				return
	if(istype(output_dest,/obj/item/dogborg/sleeper))
		var/obj/item/dogborg/sleeper/B = output_dest
		if(LAZYLEN(B.contents) >= B.max_item_count)
			to_chat(user, span_warning("[B.name] full. Empty or process contents to continue."))
			return
		if(B.ore_storage)
			if(B.current_capacity >= B.max_ore_storage)
				to_chat(user, span_warning("Ore storage full. Deposit ore contents to a box continue."))
				return
	if(isbelly(output_dest))
		var/turf/T = get_turf(output_dest)
		if(!T.Adjacent(user)) //Can still be used as a feeding tube by another adjacent player.
			if(vac_owner && user != vac_owner)
				return
			vac_power = 0
			icon_state = "sucker-0"
			output_dest = null
			to_chat(user, span_warning("Target destination not found. Shutting down."))
			return
	if(istype(target,/obj/structure/window) || istype(target,/obj/structure/grille))
		target = get_turf(target) // Windows can be clicked to clean their turf
	if(issilicon(user))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.5)//this is a mop, cart, and trash bag in one. Halving its speed should keep it somewhat more in-line with other cleaning equipment.
	var/auto_setting = 1
	if(isturf(target))
		user.visible_message(span_filter_notice("[user] begins [suckverb]ing the mess off \the [target.name]..."), span_notice("You begin [suckverb]ing the mess off \the [target.name]..."))
		var/list/suckables = list()
		if(vac_power == 8)
			playsound(src, 'sound/machines/hiss.ogg', 100, 1, -1)
			for(var/obj/item/I in oview(pull_range, target))
				if(I.anchored || !is_allowed_suck(I, user))
					continue
				I.singularity_pull(target, STAGE_THREE)
				suckables += I
			for(var/mob/living/L in oview(pull_range, target))
				if(L.anchored || !L.devourable || L == user || L.buckled || !L.can_be_drop_prey)
					continue
				L.singularity_pull(target, STAGE_THREE)
				suckables += L
		if(vac_power >= 1)
			for(var/obj/effect/decal/cleanable/C in target)
				suckables += C
		if(vac_power >= 2)
			for(var/obj/item/I in target)
				if(I.anchored || I.w_class > (vac_power - 1) && vac_power < 5 || I.w_class > 5)
					continue
				suckables += I
			for(var/mob/living/L in target)
				if(L.anchored || !L.devourable || L == user || L.buckled || !L.can_be_drop_prey)
					continue
				if(L.size_multiplier < 0.5 || vac_power >= 6)
					suckables += L
					continue
				if(istype(L,/mob/living/simple_mob/animal/passive/mouse) || istype(L,/mob/living/simple_mob/animal/passive/lizard) || istype(L,/mob/living/simple_mob/animal/passive/cockroach))
					suckables += L
		if(LAZYLEN(suckables))
			if(vac_power == 7)
				for(var/atom/movable/F in suckables)
					if(isitem(F))
						auto_setting = max(2, auto_setting)
						var/obj/item/I = F
						if(I.w_class > auto_setting)
							auto_setting = min(I.w_class, 5)
					if(isliving(F))
						var/mob/living/L = F
						if(L.size_multiplier < 0.5 || istype(L,/mob/living/simple_mob/animal/passive/mouse) || istype(L,/mob/living/simple_mob/animal/passive/lizard) || istype(L,/mob/living/simple_mob/animal/passive/cockroach))
							if(auto_setting < 3)
								auto_setting = 3
						else
							auto_setting = 6
							break
			else
				auto_setting = vac_power

			playsound(src, sucksound, auto_setting * 20, 1, -1)
			var/vac_conga = 0
			var/sucklimit = max_items
			for(var/atom/movable/F in suckables)
				if(sucklimit <= 0)
					continue
				if(is_type_in_list(F, GLOB.item_vore_blacklist))
					continue
				if(istype(F,/obj/effect/decal/cleanable))
					if(isbelly(output_dest))
						var/obj/belly/B = output_dest
						B.owner_adjust_nutrition(1)
					qdel(F)
					continue
				if(istype(output_dest,/obj/item/storage/bag/trash))
					var/obj/item/storage/bag/trash/B = output_dest
					if(LAZYLEN(B.contents) >= B.max_storage_space)
						to_chat(user, span_warning("Trash bag full. Empty trash bag contents to continue."))
						break
				sucklimit -= 1
				if(suckanim)
					if(vac_conga < 100)
						vac_conga += 3
					addtimer(CALLBACK(src, PROC_REF(prepare_sucking), F, user, auto_setting, target), 0.3 SECONDS + vac_conga)
				else if(is_allowed_suck(target, user))
					handle_consumption(F, user, auto_setting)
			if(vac_conga > 0)
				var/obj/effect/vac_visual/V = new(target)
				V.ready(0.5 SECONDS + vac_conga)
			if(istype(target, /turf/simulated))
				var/turf/simulated/T = target
				if(isbelly(output_dest) && T.dirt > 50)
					var/obj/belly/B = output_dest
					B.owner_adjust_nutrition((T.dirt - 50) / 10) //Max tile dirt is 101. so about 5 nutrition from a disgusting floor, I think that's okay.
				T.dirt = 0
				T.wash(CLEAN_WASH)
		return

	if(!isturf(target.loc))
		return

	if(isitem(target))
		var/obj/item/I = target
		if(is_type_in_list(I, GLOB.item_vore_blacklist) || I.w_class >= ITEMSIZE_HUGE)
			return
		if(!is_allowed_suck(target, user)) //cancel if you're not allowed
			return
		if(vac_power > I.w_class)
			if(vac_power == 7)
				auto_setting = min(I.w_class, 5)
			else
				auto_setting = vac_power
			playsound(src, sucksound, auto_setting * 20, 1, -1)
			user.visible_message(span_filter_notice("[user] [suckverb]s up \the [target.name]."), span_notice("You [suckverb] up \the [target.name]..."))
			if(suckanim)
				I.SpinAnimation(5,1)
			addtimer(CALLBACK(src, PROC_REF(handle_consumption), I, user, auto_setting), 0.5 SECONDS)
			return

	if(istype(target,/obj/effect/decal/cleanable))
		playsound(src, sucksound, auto_setting * 20, 1, -1)
		user.visible_message(span_filter_notice("[user] [suckverb]s up \the [target.name]."), span_notice("You [suckverb] up \the [target.name]..."))
		qdel(target)
		return

	if(isliving(target))
		var/mob/living/L = target
		var/valid_to_suck = FALSE
		if(L.anchored || !L.devourable || L == user || L.buckled || !L.can_be_drop_prey)
			return
		if(vac_power >= 3)
			if(L.size_multiplier > 0.5 || istype(L,/mob/living/simple_mob/animal/passive/mouse) || istype(L,/mob/living/simple_mob/animal/passive/lizard))
				valid_to_suck = TRUE
				auto_setting = 3
		if(vac_power >= 6)
			valid_to_suck = TRUE
			auto_setting = 6
		if(valid_to_suck && is_allowed_suck(target, user))
			playsound(src, sucksound, auto_setting * 20, 1, -1)
			user.visible_message(span_filter_notice("[user] [suckverb]s up \the [target.name]."), span_notice("You [suckverb] up \the [target.name]..."))
			if(suckanim)
				L.SpinAnimation(5,1)
			addtimer(CALLBACK(src, PROC_REF(handle_consumption), L, user, auto_setting), 0.5 SECONDS)

/obj/item/vac_attachment/proc/prepare_sucking(atom/movable/target, mob/user, turf/target_turf)
	if(!target.Adjacent(user) || src.loc != user || vac_power < 2 || !output_dest) //Cancel if moved/unpowered/dropped
		return
	if(!is_allowed_suck(target, user)) //cancel if you're not allowed
		return
	target.SpinAnimation(5,1)
	addtimer(CALLBACK(src, PROC_REF(handle_consumption), target, user, target_turf), 0.5 SECONDS)

/obj/item/vac_attachment/proc/handle_consumption(atom/movable/target, mob/user, auto_setting, turf/target_turf)
	if(target_turf && target.loc != target_turf)
		return
	if(!target.Adjacent(user) || src.loc != user || vac_power < 2 || !output_dest) //Cancel if moved/unpowered/dropped
		return
	if(!is_allowed_suck(target, user)) //Does it obey restrictions on what the target could otherwise consume?
		return
	if(isitem(target))
		var/obj/item/target_item = target
		if(target_item.drop_sound)
			playsound(src, target_item.drop_sound, vac_power * 5, 1, -1)
	playsound(src, 'sound/rakshasa/corrosion3.ogg', auto_setting * 15, 1, -1)
	if(isbelly(output_dest))
		var/obj/belly/output_belly = output_dest
		output_belly.nom_atom(target)
		return
	target.forceMove(output_dest)

/obj/item/vac_attachment/proc/is_allowed_suck(atom/movable/target, mob/user) //a ray of light in this inscrutible file. Check if we *can* fit what we want to fit, where we want to fit it. This does NOT check all the sanity checks n stuff
	if(isitem(target))
		var/obj/item/target_item = target
		if(istype(output_dest, /obj/item/storage))//if it's storage, does it fit?
			var/obj/item/storage/target_storage = output_dest
			if(target_storage.can_be_inserted(target_item, TRUE))
				return TRUE
		else//if it's not a trash bag, it's a vorebelly or borg belly. Check trash eat
			if(is_type_in_list(target_item, GLOB.edible_trash) && target_item.trash_eatable && !is_type_in_list(target_item, GLOB.item_vore_blacklist))
				return TRUE
			if(isliving(user))
				var/mob/living/trashcheck = user
				if(trashcheck.adminbus_trash)
					return TRUE
	if(isliving(target)) //quick prefs test. Better safe than sorry
		var/mob/living/caneat = target
		if(caneat.devourable && caneat.can_be_drop_prey)
			if(istype(output_dest, /obj/item/storage))//check if a mob holder's gonna fit there!
				var/obj/item/storage/target_storage = output_dest
				var/total_storage_space = ITEMSIZE_COST_SMALL
				for(var/obj/item/thing in target_storage.contents)
					total_storage_space += thing.get_storage_cost()
				if(total_storage_space > target_storage.max_storage_space)
					return FALSE
			return TRUE
	return FALSE

/obj/item/vac_attachment/resolve_attackby(atom/A, mob/user, var/attack_modifier = 1, var/click_parameters)
	if(istype(A,/obj/structure) && vac_power > 0)
		afterattack(A.loc, user, click_parameters)
		return TRUE
	return ..()

/obj/item/vac_attachment/pickup(mob/user)
	.=..()
	icon_state = "sucker-[vac_power]"

/obj/item/vac_attachment/equipped()
	.=..()
	icon_state = "sucker-[vac_power]"

/obj/item/vac_attachment/dropped(mob/user as mob)
	.=..()
	icon_state = "sucker_drop"

/obj/item/vac_attachment/verb/hide_pack()
	set name = "Toggle Vac-Pack Sprites"
	set desc = "Toggle Vac-Pack sprite visibility"
	set category = "Object"

	var/choice = tgui_input_list(usr, "Vac-Pack Visibility Options", "Vac-Pack Visibility Options", list("Show Pack", "Show Tube", "Hidden"))
	if(!choice)
		return

	switch(choice)
		if("Show Pack")
			item_state = "sucker"
		if("Show Tube")
			item_state = "sucker_nobag"
		if("Hidden")
			item_state = null
	usr.update_inv_r_hand()
	usr.update_inv_l_hand()

/obj/item/storage/Entered(atom/movable/thing, atom/OldLoc) //Holder the mob so they don't get stuck in trashbags etc.
	. = ..()
	if(isliving(thing))
		var/mob/living/L = thing
		var/mob_holder_type = L.holder_type || /obj/item/holder
		new mob_holder_type(src, L)

/obj/item/vac_attachment/scoop
	name = "\improper Scoop Hopper"
	desc = "Useful for scooping clutter off the floors. Even things and stuff depending on settings. Can be connected to a trash bag or vore belly. On-mob sprites can be toggled via verb in Objects tab."
	sucksound = 'sound/machines/hatchclose.ogg'
	suckverb = "scoop"
	suckanim = FALSE
	vac_settings = list(
			"power off" = 0,
			"dust and grime" = 1,
			"tiny objects" = 2,
			"pests and small objects" = 3,
			"medium objects" = 4,
			"large objects" = 5,
			"large pests" = 6,
			"auto-level" = 7,
			"output destination" = 8
			)

/obj/effect/vac_visual
	icon = 'icons/effects/anomalies.dmi'
	icon_state = "vortex"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = TURF_PLANE
	mouse_opacity = 0
	blend_mode = BLEND_ADD

/obj/effect/vac_visual/proc/ready(effect_time)
	QDEL_IN(src, effect_time)
