//Interactions
/turf/simulated/wall/proc/toggle_open(var/mob/user)

	if(can_open == WALL_OPENING)
		return

	SSradiation.resistance_cache.Remove(src)

	if(density)
		can_open = WALL_OPENING
		//flick("[material.icon_base]fwall_opening", src)
		density = FALSE
		blocks_air = ZONE_BLOCKED
		update_icon()
		update_air()
		set_light(0)
		src.blocks_air = 0
		set_opacity(0)
		for(var/turf/simulated/turf in loc)
			air_master.mark_for_update(turf)
	else
		can_open = WALL_OPENING
		//flick("[material.icon_base]fwall_closing", src)
		density = TRUE
		blocks_air = AIR_BLOCKED
		update_icon()
		update_air()
		set_light(1)
		src.blocks_air = 1
		set_opacity(1)
		for(var/turf/simulated/turf in loc)
			air_master.mark_for_update(turf)

	can_open = WALL_CAN_OPEN
	update_icon()

/turf/simulated/wall/proc/update_air()
	if(!air_master)
		return

	for(var/turf/simulated/turf in loc)
		update_thermal(turf)
		air_master.mark_for_update(turf)


/turf/simulated/wall/proc/update_thermal(var/turf/simulated/source)
	if(istype(source))
		if(density && opacity)
			source.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/turf/simulated/wall/proc/fail_smash(var/mob/user)
	var/damage_lower = 25
	var/damage_upper = 75
	if(isanimal(user))
		var/mob/living/simple_mob/S = user
		playsound(src, S.attack_sound, 75, 1)
		if(!(S.melee_damage_upper >= STRUCTURE_MIN_DAMAGE_THRESHOLD * 2))
			to_chat(user, "<span class='notice'>You bounce against the wall.</span>")
			return FALSE
		damage_lower = S.melee_damage_lower
		damage_upper = S.melee_damage_upper
	to_chat(user, "<span class='danger'>You smash against the wall!</span>")
	user.do_attack_animation(src)
	take_damage(rand(damage_lower,damage_upper))

/turf/simulated/wall/proc/success_smash(var/mob/user)
	to_chat(user, "<span class='danger'>You smash through the wall!</span>")
	user.do_attack_animation(src)
	if(isanimal(user))
		var/mob/living/simple_mob/S = user
		playsound(src, S.attack_sound, 75, 1)
	spawn(1)
		dismantle_wall(1)

/turf/simulated/wall/proc/try_touch(var/mob/user, var/rotting)

	if(rotting)
		if(reinf_material)
			to_chat(user, "<span class='danger'>\The [reinf_material.display_name] feels porous and crumbly.</span>")
		else
			to_chat(user, "<span class='danger'>\The [material.display_name] crumbles under your touch!</span>")
			dismantle_wall()
			return 1

	if(!can_open)
		if(!material.wall_touch_special(src, user))
			to_chat(user, "<span class='notice'>You push the wall, but nothing happens.</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
	else
		toggle_open(user)
	return 0


/turf/simulated/wall/attack_hand(var/mob/user)

	radiate()
	add_fingerprint(user)
	user.setClickCooldown(user.get_attack_speed())
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if (HULK in user.mutations)
		if (rotting || !prob(material.hardness))
			success_smash(user)
		else
			fail_smash(user)
			return 1

	try_touch(user, rotting)

/turf/simulated/wall/attack_generic(var/mob/user, var/damage, var/attack_message)

	radiate()
	user.setClickCooldown(user.get_attack_speed())
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if(damage < STRUCTURE_MIN_DAMAGE_THRESHOLD * 2)
		try_touch(user, rotting)
		return

	if(rotting)
		return success_smash(user)

	if(reinf_material)
		if(damage >= max(material.hardness, reinf_material.hardness) )
			return success_smash(user)
	else if(damage >= material.hardness)
		return success_smash(user)
	return fail_smash(user)

/turf/simulated/wall/attackby(var/obj/item/W, var/mob/user)

	user.setClickCooldown(user.get_attack_speed(W))

/*
//As with the floors, only this time it works AND tries pushing the wall after it's done.
	if(!construction_stage && user.a_intent == I_HELP)
		if(try_graffiti(user,W))
			return
*/

	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	//get the user's location
	if(!istype(user.loc, /turf))
		return	//can't do this stuff whilst inside objects and such

	if(W)
		radiate()
		if(is_hot(W))
			burn(is_hot(W))

	if(istype(W, /obj/item/electronic_assembly/wallmount))
		var/obj/item/electronic_assembly/wallmount/IC = W
		IC.mount_assembly(src, user)
		return

	if(istype(W, /obj/item/stack/tile/roofing))
		var/expended_tile = FALSE // To track the case. If a ceiling is built in a multiz zlevel, it also necessarily roofs it against weather
		var/turf/T = GetAbove(src)
		var/obj/item/stack/tile/roofing/R = W

		// Place plating over a wall
		if(T)
			if(istype(T, /turf/simulated/open) || istype(T, /turf/space))
				if(R.use(1)) // Cost of roofing tiles is 1:1 with cost to place lattice and plating
					T.ReplaceWithLattice()
					T.ChangeTurf(/turf/simulated/floor, preserve_outdoors = TRUE)
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
					user.visible_message("<span class='notice'>[user] patches a hole in the ceiling.</span>", "<span class='notice'>You patch a hole in the ceiling.</span>")
					expended_tile = TRUE
			else
				to_chat(user, "<span class='warning'>There aren't any holes in the ceiling to patch here.</span>")
				return

		// Create a ceiling to shield from the weather
		if(is_outdoors())
			if(expended_tile || R.use(1)) // Don't need to check adjacent turfs for a wall, we're building on one
				make_indoors()
				if(!expended_tile) // Would've already played a sound
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				user.visible_message("<span class='notice'>[user] roofs \the [src], shielding it from the elements.</span>", "<span class='notice'>You roof \the [src] tile, shielding it from the elements.</span>")
		return


	if(locate(/obj/effect/overlay/wallrot) in src)
		if(istype(W, /obj/item/weldingtool) )
			var/obj/item/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				to_chat(user, "<span class='notice'>You burn away the fungi with \the [WT].</span>")
				playsound(src, WT.usesound, 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, "<span class='notice'>\The [src] crumbles away under the force of your [W.name].</span>")
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if( istype(W, /obj/item/weldingtool) )
			var/obj/item/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				thermitemelt(user)
				return

		else if(istype(W, /obj/item/pickaxe/plasmacutter))
			thermitemelt(user)
			return

		else if( istype(W, /obj/item/melee/energy/blade) )
			var/obj/item/melee/energy/blade/EB = W

			EB.spark_system.start()
			to_chat(user, "<span class='notice'>You slash \the [src] with \the [EB]; the thermite ignites!</span>")
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)

			thermitemelt(user)
			return

	var/turf/T = user.loc	//get user's location for delay checks

	if(damage && istype(W, /obj/item/weldingtool))

		var/obj/item/weldingtool/WT = W

		if(!WT.isOn())
			return

		if(WT.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You start repairing the damage to [src].</span>")
			playsound(src, WT.usesound, 100, 1)
			if(do_after(user, max(5, damage / 5) * WT.toolspeed) && WT && WT.isOn())
				to_chat(user, "<span class='notice'>You finish repairing the damage to [src].</span>")
				take_damage(-damage)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return
		user.update_examine_panel(src)
		return

	// Basic dismantling.
	//var/dismantle_toolspeed = 0
	if(isnull(construction_stage) || !reinf_material)

		var/cut_delay = 60 - material.cut_delay
		var/dismantle_verb
		var/dismantle_sound

		if(istype(W,/obj/item/weldingtool))
			var/obj/item/weldingtool/WT = W
			if(!WT.isOn())
				return
			if(!WT.remove_fuel(0,user))
				to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
				return
			dismantle_verb = "cutting"
			dismantle_sound = W.usesound
		//	cut_delay *= 0.7 // Tools themselves now can shorten the time it takes.
		else if(istype(W,/obj/item/melee/energy/blade))
			dismantle_sound = "sparks"
			dismantle_verb = "slicing"
			//dismantle_toolspeed = 1
			cut_delay *= 0.5
		else if(istype(W,/obj/item/pickaxe))
			var/obj/item/pickaxe/P = W
			dismantle_verb = P.drill_verb
			dismantle_sound = P.drill_sound
			cut_delay -= P.digspeed

		if(dismantle_verb)

			to_chat(user, "<span class='notice'>You begin [dismantle_verb] through the outer plating.</span>")
			if(dismantle_sound)
				playsound(src, dismantle_sound, 100, 1)

			if(cut_delay < 0)
				cut_delay = 0

			if(!do_after(user,cut_delay * W.toolspeed))
				return

			to_chat(user, "<span class='notice'>You remove the outer plating.</span>")
			dismantle_wall()
			user.visible_message("<span class='warning'>The wall was torn open by [user]!</span>")
			return

	//Reinforced dismantling.
	else
		switch(construction_stage)
			if(6)
				if (W.is_wirecutter())
					playsound(src, W.usesound, 100, 1)
					construction_stage = 5
					user.update_examine_panel(src)
					to_chat(user, "<span class='notice'>You cut through the outer grille.</span>")
					update_icon()
					return
			if(5)
				if (W.is_screwdriver())
					to_chat(user, "<span class='notice'>You begin removing the support lines.</span>")
					playsound(src, W.usesound, 100, 1)
					if(!do_after(user,40 * W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 5)
						return
					construction_stage = 4
					user.update_examine_panel(src)
					update_icon()
					to_chat(user, "<span class='notice'>You unscrew the support lines.</span>")
					return
				else if (W.is_wirecutter())
					construction_stage = 6
					user.update_examine_panel(src)
					to_chat(user, "<span class='notice'>You mend the outer grille.</span>")
					playsound(src, W.usesound, 100, 1)
					update_icon()
					return
			if(4)
				var/cut_cover
				if(istype(W,/obj/item/weldingtool))
					var/obj/item/weldingtool/WT = W
					if(!WT.isOn())
						return
					if(WT.remove_fuel(0,user))
						cut_cover=1
					else
						to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
						return
				else if (istype(W, /obj/item/pickaxe/plasmacutter))
					cut_cover = 1
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the metal cover.</span>")
					playsound(src, W.usesound, 100, 1)
					if(!do_after(user, 60 * W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 4)
						return
					construction_stage = 3
					user.update_examine_panel(src)
					update_icon()
					to_chat(user, "<span class='notice'>You press firmly on the cover, dislodging it.</span>")
					return
				else if (W.is_screwdriver())
					to_chat(user, "<span class='notice'>You begin screwing down the support lines.</span>")
					playsound(src, W.usesound, 100, 1)
					if(!do_after(user,40 * W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 4)
						return
					construction_stage = 5
					user.update_examine_panel(src)
					update_icon()
					to_chat(user, "<span class='notice'>You screw down the support lines.</span>")
					return
			if(3)
				if (W.is_crowbar())
					to_chat(user, "<span class='notice'>You struggle to pry off the cover.</span>")
					playsound(src, W.usesound, 100, 1)
					if(!do_after(user,100 * W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 3)
						return
					construction_stage = 2
					user.update_examine_panel(src)
					update_icon()
					to_chat(user, "<span class='notice'>You pry off the cover.</span>")
					return
			if(2)
				if (W.is_wrench())
					to_chat(user, "<span class='notice'>You start loosening the anchoring bolts which secure the support rods to their frame.</span>")
					playsound(src, W.usesound, 100, 1)
					if(!do_after(user,40 * W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 2)
						return
					construction_stage = 1
					user.update_examine_panel(src)
					update_icon()
					to_chat(user, "<span class='notice'>You remove the bolts anchoring the support rods.</span>")
					return
			if(1)
				var/cut_cover
				if(istype(W, /obj/item/weldingtool))
					var/obj/item/weldingtool/WT = W
					if( WT.remove_fuel(0,user) )
						cut_cover=1
					else
						to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
						return
				else if(istype(W, /obj/item/pickaxe/plasmacutter))
					cut_cover = 1
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the support rods.</span>")
					playsound(src, W.usesound, 100, 1)
					if(!do_after(user,70 * W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 1)
						return
					construction_stage = 0
					user.update_examine_panel(src)
					update_icon()
					to_chat(user, "<span class='notice'>You slice through the support rods.</span>")
					return
			if(0)
				if(W.is_crowbar())
					to_chat(user, "<span class='notice'>You struggle to pry off the outer sheath.</span>")
					playsound(src, W.usesound, 100, 1)
					if(!do_after(user,100 * W.toolspeed) || !istype(src, /turf/simulated/wall) || !user || !W || !T )
						return
					if(user.loc == T && user.get_active_hand() == W )
						to_chat(user, "<span class='notice'>You pry off the outer sheath.</span>")
						dismantle_wall()
					return

	if(istype(W,/obj/item/frame))
		var/obj/item/frame/F = W
		F.try_build(src, user)
		return

	else if(!istype(W,/obj/item/rcd) && !istype(W, /obj/item/reagent_containers))
		return attack_hand(user)
