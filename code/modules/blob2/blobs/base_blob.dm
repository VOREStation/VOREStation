GLOBAL_LIST_EMPTY(all_blobs)

/obj/structure/blob
	name = "blob"
	icon = 'icons/mob/blob.dmi'
	desc = "A thick wall of writhing tendrils."
	light_range = 2
	density = FALSE // This is false because blob mob AI's walk_to() proc appears to never attempt to move onto dense objects even if allowed by CanPass().
	opacity = FALSE
	anchored = TRUE
	layer = MOB_LAYER + 0.1
	var/integrity = 0
	var/point_return = 0 //How many points the blob gets back when it removes a blob of that type. If less than 0, blob cannot be removed.
	var/max_integrity = 30
	var/health_regen = 2 //how much health this blob regens when pulsed
	var/pulse_timestamp = 0 //we got pulsed when?
	var/heal_timestamp = 0 //we got healed when?
	var/mob/observer/blob/overmind = null
	var/base_name = "blob" // The name that gets appended along with the blob_type's name.
	var/faction = "blob"

/obj/structure/blob/Initialize(newloc, new_overmind)
	if(new_overmind)
		overmind = new_overmind
		faction = overmind.blob_type.faction
	update_icon()
	if(!integrity)
		integrity = max_integrity
	set_dir(pick(cardinal))
	GLOB.all_blobs += src
	consume_tile()
	return ..()


/obj/structure/blob/Destroy()
	playsound(src, 'sound/effects/splat.ogg', 50, 1) //Expand() is no longer broken, no check necessary.
	GLOB.all_blobs -= src
	overmind = null
	return ..()

/obj/structure/blob/update_icon() //Updates color based on overmind color if we have an overmind.
	if(overmind)
		name = "[overmind.blob_type.name] [base_name]" // This is in update_icon() because inert blobs can turn into other blobs with magic if another blob core claims it with pulsing.
		color = overmind.blob_type.color
		set_light(3, 3, color)
	else
		name = "inert [base_name]"
		color = null
		set_light(0)

/obj/structure/blob/update_transform()
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	animate(src, transform = M, time = 10)

// Blob tiles are not actually dense so we need Special Code(tm).
/obj/structure/blob/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSBLOB))
		return TRUE
	else if(istype(mover, /mob/living))
		var/mob/living/L = mover
		if(L.faction == faction)
			return TRUE
	else if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		if(istype(P.firer, /obj/structure/blob))
			return TRUE
		if(istype(P.firer) && P.firer.faction == faction)
			return TRUE
	return FALSE

/obj/structure/blob/examine(mob/user)
	. = ..()
	if(!overmind)
		. += "It seems inert." // Dead blob.
	else
		. += overmind.blob_type.desc

/obj/structure/blob/get_description_info()
	if(overmind)
		return overmind.blob_type.effect_desc
	return ..()

/obj/structure/blob/emp_act(severity)
	if(overmind)
		overmind.blob_type.on_emp(src, severity)

/obj/structure/blob/proc/pulsed()
	if(pulse_timestamp <= world.time)
		consume_tile()
		if(heal_timestamp <= world.time)
			adjust_integrity(health_regen)
			heal_timestamp = world.time + 2 SECONDS
		update_icon()
		pulse_timestamp = world.time + 1 SECOND
		if(overmind)
			faction = overmind.blob_type.faction
			overmind.blob_type.on_pulse(src)
		return TRUE //we did it, we were pulsed!
	return FALSE //oh no we failed

/obj/structure/blob/proc/pulse_area(pulsing_overmind = overmind, claim_range = 10, pulse_range = 3, expand_range = 2)
	src.pulsed()
	var/expanded = FALSE
	if(prob(70) && expand())
		expanded = TRUE

	var/list/blobs_to_affect = list()
	for(var/obj/structure/blob/B in urange(claim_range, src, 1))
		blobs_to_affect += B

	shuffle_inplace(blobs_to_affect)

	for(var/L in blobs_to_affect)
		var/obj/structure/blob/B = L
		if(B.faction != faction)
			continue

		if(!B.overmind && !istype(B, /obj/structure/blob/core) && prob(30))
			B.overmind = pulsing_overmind //reclaim unclaimed, non-core blobs.
			B.update_icon()

		var/distance = get_dist(get_turf(src), get_turf(B))
		var/expand_probablity = max(50 / (max(distance, 1)), 1)
		if(overmind)
			expand_probablity *= overmind.blob_type.spread_modifier
			if(overmind.blob_type.slow_spread_with_size)
				expand_probablity /= (GLOB.all_blobs.len / 10)

		if(distance <= expand_range)
			var/can_expand = TRUE
			if(blobs_to_affect.len >= 120 && B.heal_timestamp > world.time)
				can_expand = FALSE
			if(!expanded && can_expand && B.pulse_timestamp <= world.time && prob(expand_probablity))
				var/obj/structure/blob/newB = B.expand(null, null, !expanded) //expansion falls off with range but is faster near the blob causing the expansion
				if(newB)
					if(expanded)
						qdel(newB)
					expanded = TRUE

		if(distance <= pulse_range)
			B.pulsed()

/obj/structure/blob/proc/expand(turf/T = null, controller = null, expand_reaction = 1)
	if(!T)
		var/list/dirs = cardinal.Copy()
		for(var/i = 1 to 4)
			var/dirn = pick(dirs)
			dirs.Remove(dirn)
			T = get_step(src, dirn)
			var/obj/structure/blob/B = locate(/obj/structure/blob) in T
			if(!B || B.faction != faction)	// Allow opposing blobs to fight.
				break
			else
				T = null
	if(!T)
		return FALSE

	var/make_blob = TRUE //can we make a blob?

	if(istype(T, /turf/space) && !(locate(/obj/structure/lattice) in T) && prob(80))
		make_blob = FALSE
		playsound(src, 'sound/effects/splat.ogg', 50, 1) //Let's give some feedback that we DID try to spawn in space, since players are used to it

	consume_tile() //hit the tile we're in, making sure there are no border objects blocking us

	if(!T.CanPass(src, T)) //is the target turf impassable
		make_blob = FALSE
		T.blob_act(src) //hit the turf if it is

	for(var/atom/A in T)
		if(!A.CanPass(src, T)) //is anything in the turf impassable
			make_blob = FALSE
		A.blob_act(src) //also hit everything in the turf

	if(make_blob) //well, can we?
		var/obj/structure/blob/B = new /obj/structure/blob/normal(src.loc)
		B.faction = faction
		if(controller)
			B.overmind = controller
		else
			B.overmind = overmind
		B.density = TRUE
		if(T.Enter(B,src)) //NOW we can attempt to move into the tile
			sleep(1) // To have the slide animation work.
			B.density = initial(B.density)
			B.forceMove(T)
			B.update_icon()
			if(B.overmind && expand_reaction)
				B.overmind.blob_type.on_expand(src, B, T, B.overmind)
			return B

		else
			blob_attack_animation(T, controller)
			T.blob_act(src) //if we can't move in hit the turf again
			qdel(B) //we should never get to this point, since we checked before moving in. destroy the blob so we don't have two blobs on one tile
			return null
	else
		blob_attack_animation(T, controller) //if we can't, animate that we attacked
	return null

/obj/structure/blob/proc/consume_tile()
	for(var/atom/A in loc)
		A.blob_act(src)
	if(loc && loc.density)
		loc.blob_act(src) //don't ask how a wall got on top of the core, just eat it

/obj/structure/blob/proc/blob_glow_animation()
	flick("[icon_state]_glow", src)

/obj/structure/blob/proc/blob_attack_animation(atom/A = null, controller) //visually attacks an atom
	var/obj/effect/temporary_effect/blob_attack/O = new /obj/effect/temporary_effect/blob_attack(src.loc)
	O.set_dir(dir)
	if(controller)
		var/mob/observer/blob/BO = controller
		O.color = BO.blob_type.color
		O.alpha = 200
	else if(overmind)
		O.color = overmind.blob_type.color
	if(A)
		O.do_attack_animation(A) //visually attack the whatever
	return O //just in case you want to do something to the animation.

/obj/structure/blob/proc/change_to(type, controller)
	if(!ispath(type))
		throw EXCEPTION("change_to(): invalid type for blob")
		return
	var/obj/structure/blob/B = new type(src.loc, controller)
	if(controller)
		B.overmind = controller
	B.update_icon()
	B.set_dir(dir)
	qdel(src)
	return B

/obj/structure/blob/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	playsound(src, 'sound/effects/attackblob.ogg', 100, 1)
	user.do_attack_animation(src)
	if(overmind)
		damage *= overmind.blob_type.brute_multiplier
	else
		damage *= 2

	if(overmind)
		damage = overmind.blob_type.on_received_damage(src, damage, BRUTE, user)

	adjust_integrity(-damage)

	return

/obj/structure/blob/attack_hand(mob/living/M as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.setClickCooldown(H.get_attack_speed())
		var/datum/unarmed_attack/attack = H.get_unarmed_attack(src, BP_TORSO)
		if(!attack)
			return FALSE

		if(attack.unarmed_override(H, src, BP_TORSO))
			return FALSE

		H.do_attack_animation(src)
		H.visible_message("<span class='danger'>[H] strikes \the [src]!</span>")

		var/real_damage = rand(3,6)
		var/hit_dam_type = attack.damage_type
		real_damage += attack.get_unarmed_damage(H)
		if(H.gloves)
			if(istype(H.gloves, /obj/item/clothing/gloves))
				var/obj/item/clothing/gloves/G = H.gloves
				real_damage += G.punch_force
				hit_dam_type = G.punch_damtype
		if(HULK in H.mutations)
			real_damage *= 2 // Hulks do twice the damage

		real_damage = max(1, real_damage)

		var/damage_mult_burn = 1
		var/damage_mult_brute = 1

		if(hit_dam_type == SEARING)
			damage_mult_burn *= 0.3
			damage_mult_brute *= 0.6

		else if(hit_dam_type == BIOACID)
			damage_mult_burn *= 0.6
			damage_mult_brute = 0

		else if(hit_dam_type in list(ELECTROCUTE, BURN))
			damage_mult_brute = 0

		else if(hit_dam_type in list(BRUTE, CLONE))
			damage_mult_burn = 0

		else if(hit_dam_type != HALLOSS) // Tox, Oxy, or something new. Half damage split to the organism.
			damage_mult_burn = 0.25
			damage_mult_brute = 0.25

		else
			damage_mult_brute = 0.25
			damage_mult_burn = 0

		var/burn_dam = real_damage * damage_mult_burn
		var/brute_dam = real_damage * damage_mult_brute

		if(overmind)
			if(brute_dam)
				brute_dam = overmind.blob_type.on_received_damage(src, brute_dam, BRUTE, M)
			if(burn_dam)
				burn_dam = overmind.blob_type.on_received_damage(src, burn_dam, BURN, M)

		real_damage = burn_dam + brute_dam

		adjust_integrity(-real_damage)

	else
		attack_generic(M, rand(1,10), "bashed")

/obj/structure/blob/attackby(var/obj/item/weapon/W, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	playsound(src, 'sound/effects/attackblob.ogg', 50, 1)
	visible_message("<span class='danger'>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]</span>")
	var/damage = W.force
	switch(W.damtype)
		if(BURN, BIOACID, ELECTROCUTE, OXY)
			if(overmind)
				damage *= overmind.blob_type.burn_multiplier
			else
				damage *= 2

			if(damage > 0)
				playsound(src, 'sound/items/welder.ogg', 100, 1)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, 1)
		if(BRUTE, SEARING, TOX, CLONE)
			if(overmind)
				damage *= overmind.blob_type.brute_multiplier
			else
				damage *= 2

			if(damage > 0)
				playsound(src, 'sound/effects/attackblob.ogg', 50, 1)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, 1)
	if(overmind)
		damage = overmind.blob_type.on_received_damage(src, damage, W.damtype, user)
	adjust_integrity(-damage)
	return

/obj/structure/blob/bullet_act(var/obj/item/projectile/P)
	if(!P)
		return

	if(istype(P.firer) && P.firer.faction == faction)
		return

	var/damage = P.get_structure_damage() // So tasers don't hurt the blob.
	if(!damage)
		return

	switch(P.damage_type)
		if(BRUTE)
			if(overmind)
				damage *= overmind.blob_type.brute_multiplier
		if(BURN)
			if(overmind)
				damage *= overmind.blob_type.burn_multiplier

	if(overmind)
		damage = overmind.blob_type.on_received_damage(src, damage, P.damage_type, P.firer)

	adjust_integrity(-damage)

	return ..()

/obj/structure/blob/water_act(amount)
	if(overmind)
		overmind.blob_type.on_water(src, amount)

/obj/structure/blob/blob_act(var/obj/structure/blob/B)
	. = ..()

	if(B)

		if(!B.overmind)
			return

		if(B.faction != faction)
			var/damage = rand(B.overmind.blob_type.damage_lower, B.overmind.blob_type.damage_upper)
			var/inc_damage_type = B.overmind.blob_type.damage_type

			if(overmind)
				damage = overmind.blob_type.on_received_damage(src, damage, inc_damage_type, B)

			else
				faction = B.faction
				overmind = B.overmind
				update_icon()
				return

			adjust_integrity(-1 * damage)

	return

/obj/structure/blob/proc/adjust_integrity(amount)
	integrity = between(0, integrity + amount, max_integrity)
	if(integrity == 0)
		playsound(src, 'sound/effects/splat.ogg', 50, 1)
		if(overmind)
			overmind.blob_type.on_death(src)
		qdel(src)
	else
		update_icon()

/obj/effect/temporary_effect/blob_attack
	name = "blob"
	desc = "The blob lashing out at something."
	icon_state = "blob_attack"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	time_to_die = 6
	alpha = 140
	mouse_opacity = 0

/obj/structure/grille/blob_act()
	qdel(src)

/turf/simulated/wall/blob_act()
	take_damage(100)