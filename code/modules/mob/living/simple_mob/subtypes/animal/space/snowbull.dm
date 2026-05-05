/mob/living/simple_mob/animal/passive/snowbull
	name = "Snowbull"
	desc = "Some white furred bull with a single curved horn."
	tt_desc = "legionis gayus"
	icon = 'icons/mob/cryogaia64x64.dmi'
	icon_state = "snowbull"
	icon_living = "snowbull"
	icon_dead = "snowbull-dead"
	maxHealth = 300
	health = 300
	faction = "snowbull"
	pixel_x = -16
	special_attack_min_range = 3
	special_attack_max_range = 8
	special_attack_cooldown = 10 SECONDS
	var/charging = 0
	var/charging_warning = 1 SECONDS
	minbodytemp = 0
	maxbodytemp = 1000
	min_oxy = 0				// Oxygen in moles, minimum, 0 is 'no minimum'
	max_oxy = 0					// Oxygen in moles, maximum, 0 is 'no maximum'
	min_tox = 0					// Phoron min
	max_tox = 0					// Phoron max
	min_co2 = 0					// CO2 min
	max_co2 = 0					// CO2 max
	min_n2 = 0					// N2 min
	max_n2 = 0					// N2 max
	attack_sharp = 1
	melee_damage_lower = 15
	melee_damage_upper = 20
	butchery_loot = list(/obj/item/stack/animalhide = 6)

	ai_holder_type = /datum/ai_holder/simple_mob/snowbull

/mob/living/simple_mob/animal/passive/snowbull/update_icon()
	if(charging)
		icon_state = "[icon_living]-charge"
	..()


/mob/living/simple_mob/animal/passive/snowbull/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)
	charging = 1
	movement_shake_radius = 3
	movement_sound = 'sound/effects/mob_effects/snowbull_charge.ogg'
	visible_message(span_warning("\The [src] prepares to charge at \the [A]!"))
	update_icon()
	sleep(charging_warning)
	var/chargeturf = get_turf(A)
	if(!chargeturf)
		return
	var/chargedir = get_dir(src, chargeturf)
	set_dir(chargedir)
	var/turf/T = get_ranged_target_turf(chargeturf, chargedir, isDiagonal(chargedir) ? 1 : 2)
	if(!T)
		charging = 0
		movement_shake_radius = null
		movement_sound = null
		update_icon()
		visible_message(span_warning("\The [src] desists from charging at \the [A]"))
		return
	for(var/distance = get_dist(src.loc, T), src.loc!=T && distance>0, distance--)
		var/movedir = get_dir(src.loc, T)
		var/moveturf = get_step(src.loc, movedir)
		SelfMove(moveturf, movedir, 2)
		sleep(2 * world.tick_lag) //Speed it will move, default is two server ticks
	sleep((get_dist(src, T) * 2.2))
	charging = 0
	update_icon()
	movement_shake_radius = 0
	movement_sound = null
	set_AI_busy(FALSE)

/mob/living/simple_mob/animal/passive/snowbull/Bump(atom/movable/AM)
	if(charging)
		if(istype(AM, /mob/living))
			var/mob/living/M = AM
			visible_message(span_warning("[src] rams [AM]!"))
			M.Stun(5)
			M.Weaken(3)
			var/throwdir = pick(turn(dir, 45), turn(dir, -45))
			M.throw_at(get_step(src.loc, throwdir), 1, 1, src)
			runOver(M) // Actually should not use this, placeholder
		if(istype(AM, /obj/structure))
			if(istype(AM, /obj/structure/window))
				var/obj/structure/window/window = AM
				window.hit(80) //Shatters reinforced windows
			else if(istype(AM, /obj/structure/table))
				var/obj/structure/table/table = AM
				var/tableflipdir = pick(turn(dir, 90), turn(dir, -90))
				if(!table.flip(tableflipdir)) //If table don't gets flipped just generic attack it
					AM.attack_generic(src, 20, "rams")
			else if(istype(AM, /obj/structure/closet))
				var/obj/structure/closet/closet = AM
				closet.throw_at_random(0, 2, 2)
				closet.break_open() //Lets not destroy closets that easily, instead just open it
			else
				AM.attack_generic(src, 20, "rams") // Otherwise just attack_generic that structure
		if(istype(AM, /turf/simulated/wall))
			var/turf/simulated/wall/wall = AM
			wall.take_damage(20)
		if(istype(AM, /obj/machinery))
			var/obj/machinery/machinery = AM
			machinery.attack_generic(src, 20)
	..()

/mob/living/simple_mob/animal/passive/snowbull/proc/runOver(mob/living/M)
	if(istype(M))
		visible_message(span_warning("[src] rams [M] over!"))
		playsound(src, 'sound/effects/splat.ogg', 50, 1)
		var/damage = rand(3,4)
		M.apply_damage(2 * damage, BRUTE, BP_HEAD)
		M.apply_damage(2 * damage, BRUTE, BP_TORSO)
		M.apply_damage(0.5 * damage, BRUTE, BP_L_LEG)
		M.apply_damage(0.5 * damage, BRUTE, BP_R_LEG)
		M.apply_damage(0.5 * damage, BRUTE, BP_L_ARM)
		M.apply_damage(0.5 * damage, BRUTE, BP_R_ARM)
		blood_splatter(src, M, 1)

/mob/living/simple_mob/animal/passive/snowbull/handle_special()
	if(ai_holder)
		if(istype(ai_holder, /datum/ai_holder/simple_mob/snowbull))
			var/datum/ai_holder/simple_mob/snowbull/changedAI = ai_holder
			var/mobtension = 0
			mobtension = get_tension() //Check for their tension, based on dangerous mobs and allies nearby
			if(mobtension > 170)
				changedAI.untrusting = TRUE
			if(mobtension > 270)
				changedAI.untrusting = 2
			if(mobtension < 170)
				changedAI.untrusting = FALSE
	var/beforehealth = icon_living
	var/healthpercent = health/maxHealth
	switch(healthpercent)
		if(0 to 0.25)
			icon_living = "snowbull-25"
		if(0.26 to 0.50)
			icon_living = "snowbull-50"
		if(0.51 to 0.75)
			icon_living = "snowbull-75"
		if(0.76 to INFINITY)
			icon_living = "snowbull-100"
	if(beforehealth != icon_living)
		update_icon()

/datum/ai_holder/simple_mob/snowbull
	hostile = TRUE //Not actually hostile but neede for a check otherwise it won't work
	retaliate = TRUE
	cooperative = TRUE
	wander_delay = 12
	can_breakthrough = TRUE
	violent_breakthrough = TRUE
	lose_target_timeout = 40 SECONDS //How much time till they forget who attacked them.
	var/untrusting = FALSE //This will make the mob check other mobs if they're very dangerous or has intent to harm them.
	threaten = TRUE //Threaten to attack the enemy.
	threaten_delay = 7 SECONDS
	threaten_timeout = 0 SECONDS //we don't want to attack immediately when they get back, only if they don't behave after we warn
	can_flee = FALSE //No, we don't flee, we attack back.

/datum/ai_holder/simple_mob/snowbull/find_target(list/possible_targets, has_targets_list)
	ai_log("find_target() : Entered.", AI_LOG_TRACE)
	. = list()
	if(!has_targets_list)
		possible_targets = list_targets()
	for(var/possible_target in possible_targets)
		var/target_threatlevel
		if(istype(possible_target, /atom/movable)) //Test
			var/atom/movable/threatener = possible_target
			target_threatlevel = threatener.get_threat(holder)
		if(checkthreatened(possible_target, target_threatlevel)) //won't attack anything that ain't a big threat
			if(can_attack(possible_target)) // Can we attack it?
				. += possible_target
	var/new_target = pick_target(.)
	give_target(new_target)
	return new_target

/datum/ai_holder/simple_mob/snowbull/proc/checkthreatened(var/possible_target, target_threatlevel = 0)
	if(check_attacker(possible_target))
		return TRUE
	if(untrusting == 1 && target_threatlevel > 130 && (possible_target in range(5)))
		return TRUE
	if(untrusting > 1 && target_threatlevel > 100)
		return TRUE
	else
		return FALSE

/datum/ai_holder/simple_mob/snowbull/threaten_target()
	holder.face_atom(target) // Constantly face the target.

	if(!threatening) // First tick.
		threatening = TRUE
		last_threaten_time = world.time
		holder.visible_emote(span_warning("Huffs, reacting to the threat of [target]!"))
	else // Otherwise we are waiting for them to go away or to wait long enough for escalate.
		var/threatlevel = target.get_threat(holder)
		if((target in list_targets()) && checkthreatened(target, threatlevel)) // Are they still visible and threatening ?
			var/should_escalate = FALSE

			if(threaten_delay && last_threaten_time + threaten_delay < world.time) // Waited too long.
				should_escalate = TRUE

			if(should_escalate)
				threatening = FALSE
				set_stance(STANCE_APPROACH)
				if(holder.say_list)
					holder.visible_emote(span_notice("Gets irritated, going after [target]!"))
			else
				return // Wait a bit.

		else // They left, or so we think.
			if(last_threaten_time + threaten_timeout < world.time)	// They've been gone long enough, probably safe to stand down
				threatening = FALSE
			set_stance(STANCE_IDLE)
			holder.visible_emote(span_notice("calms down, lowering down their horns"))
			if(holder.say_list)
				holder.ISay(safepick(holder.say_list.say_stand_down))
				playsound(target, holder.say_list.stand_down_sound, 50, 1) // Actual aim-mode also does that so at least it's consistant.
