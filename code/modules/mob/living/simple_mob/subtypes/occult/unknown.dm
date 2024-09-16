#define GA_ADS 0
#define GA_CALLDOWN 1
#define GA_SPEEDUP 2
#define GA_ILLUSION 3
#define GA_BULLETHELL 4
#define GA_LINES 5
#define GA_CONFUSION 6

/mob/living/simple_mob/glitch_boss
	name = "CLICK ME!!!"
	desc = "WELCOME TO %location_data% THIS IS YOUR HOME NOW PLEASE INPUT CREDIT CARD CREDENTIALS BELOW"
	tt_desc = "BEST TOOLBAR PROVIDER SINCE 2098"
	icon = 'icons/mob/unknown_boss.dmi'
	icon_state = "glitch_boss"
	icon_living = "glitch_boss"
	icon_dead = "glitch_boss_dead"

	faction = FACTION_MATH

	maxHealth = 2000
	health = 2000
	evasion = -75		// Its hitbox is broken ;_;

	melee_damage_lower = 20
	melee_damage_upper = 40
	attack_armor_pen = 20

	base_attack_cooldown = 2.5 SECONDS

	projectiletype = /obj/item/projectile/energy/slow_orb
	projectilesound = 'sound/effects/uncloak.ogg'

	special_attack_min_range = 0
	special_attack_max_range = 10
	special_attack_cooldown = 20 SECONDS
	ai_holder_type = /datum/ai_holder/simple_mob/ranged/aggressive/bossmob_glitch

	var/next_special_attack = GA_ADS
	var/recently_used_attack = GA_SPEEDUP
	var/all_special_attacks = list(GA_ADS, GA_CALLDOWN, GA_LINES, GA_BULLETHELL, GA_ILLUSION, GA_CONFUSION, GA_SPEEDUP)

	loot_list = list(/obj/item/device/nif/glitch = 100)

/obj/item/projectile/energy/slow_orb
	name = "TROJAN"
	icon_state = "glitch"
	damage = 50
	speed = 6
	damage_type = ELECTROCUTE
	agony = 15
	check_armour = "energy"
	armor_penetration = 40

	fire_sound = 'sound/effects/uncloak.ogg'
	combustion = TRUE

/mob/living/simple_mob/glitch_boss/death(gibbed, deathmessage="suddenly %runtime error in unknown.dm, line 56%")
	. = ..()
	new /obj/effect/temp_visual/glitch(get_turf(src))
	qdel(src)

/mob/living/simple_mob/glitch_boss/updatehealth()
	. = ..()

	if(health < maxHealth*0.25)
		special_attack_cooldown = 5 SECONDS
		icon_state = "glitch_boss_25"
		icon_living = "glitch_boss_25"
	else if(health < maxHealth*0.5)
		special_attack_cooldown = 10 SECONDS
		icon_state = "glitch_boss_50"
		icon_living = "glitch_boss_50"
	else if (health < maxHealth*0.75)
		special_attack_cooldown = 15 SECONDS
		icon_state = "glitch_boss_75"
		icon_living = "glitch_boss_75"

/mob/living/simple_mob/glitch_boss/proc/create_illusions(atom/A)
	var/list/possible_turfs = list()
	for(var/turf/T in view(4, src))
		if(T.density || T == get_turf(src))		// Our turf is always eligible
			continue
		var/blocked = FALSE
		for(var/atom/movable/AM in T)
			if(AM.density)
				blocked = TRUE
				break
		if(!blocked)
			possible_turfs += T

	if(possible_turfs.len <= 1)
		return

	var/illusion_amount = min(possible_turfs.len, 4)	// Not including our spot
	var/list/actual_turfs = list()
	actual_turfs += get_turf(src)
	for(var/i = 0, i < illusion_amount, i++)
		var/turf_to_add = pick(possible_turfs)
		actual_turfs += turf_to_add
		possible_turfs -= turf_to_add

	for(var/i = 0, i < illusion_amount, i++)
		var/chosen_turf = pick(actual_turfs)
		var/type_to_spawn = prob(15) ? /mob/living/simple_mob/glitch_boss_fake/strong : /mob/living/simple_mob/glitch_boss_fake
		var/mob/living/simple_mob/newmob = new type_to_spawn(chosen_turf)
		newmob.icon_living = src.icon_living
		newmob.icon_state = src.icon_state
		new /obj/effect/temp_visual/glitch(chosen_turf)
		actual_turfs -= chosen_turf

	var/move_turf = pick(actual_turfs)
	src.forceMove(move_turf)
	new /obj/effect/temp_visual/glitch(move_turf)

/mob/living/simple_mob/glitch_boss/proc/make_ads(atom/A)
	var/list/potential_targets = list()
	for(var/mob/living/mob in view(7, src))
		if(mob.client && mob.faction != faction)
			potential_targets += mob
	if(potential_targets.len)
		var/iteration = clamp(potential_targets.len, 1, 4)
		for(var/i = 0, i < iteration, i++)
			if(!(potential_targets.len))
				break
			var/mob/target = pick(potential_targets)
			potential_targets -= target
			if(target.client)
				target.client.create_fake_ad_popup_multiple(/obj/screen/popup/default, 5)

/mob/living/simple_mob/glitch_boss/proc/bombardment(atom/A)
	var/list/potential_targets = ai_holder.list_targets()
	for(var/atom/entry in potential_targets)
		if(istype(entry, /mob/living/simple_mob/glitch_boss_fake))
			potential_targets -= entry
	if(potential_targets.len)
		var/iteration = clamp(potential_targets.len, 1, 3)
		for(var/i = 0, i < iteration, i++)
			if(!(potential_targets.len))
				break
			var/mob/target = pick(potential_targets)
			potential_targets -= target
			spawn_bombardments(target)

/mob/living/simple_mob/glitch_boss/proc/spawn_bombardments(atom/target)
	var/list/bomb_range = block(locate(target.x-1, target.y-1, target.z), locate(target.x+1, target.y+1, target.z))
	new /obj/effect/calldown_attack(get_turf(target))
	bomb_range -= get_turf(target)
	for(var/i = 0, i < 4, i++)
		var/turf/T = pick(bomb_range)
		new /obj/effect/calldown_attack(T)
		bomb_range -= T

/mob/living/simple_mob/glitch_boss/proc/bomb_lines(atom/A)
	var/list/potential_targets = ai_holder.list_targets()
	for(var/atom/entry in potential_targets)
		if(istype(entry, /mob/living/simple_mob/glitch_boss_fake))
			potential_targets -= entry
	if(potential_targets.len)
		var/iteration = clamp(potential_targets.len, 1, 3)
		for(var/i = 0, i < iteration, i++)
			if(!(potential_targets.len))
				break
			var/mob/target = pick(potential_targets)
			potential_targets -= target
			spawn_lines(target)

/mob/living/simple_mob/glitch_boss/proc/spawn_lines(atom/target)
	var/alignment = rand(1,2)	// 1 for vertical, 2 for horizontal
	var/list/line_range = list()
	var/turf/T = get_turf(target)
	line_range += T
	for(var/i = 1, i <= 7, i++)
		switch(alignment)
			if(1)
				if(T.x-i > 0)
					line_range += locate(T.x-i, T.y, T.z)
				if(T.x+i <= world.maxx)
					line_range += locate(T.x+i, T.y, T.z)
			if(2)
				if(T.y-i > 0)
					line_range += locate(T.x, T.y-i, T.z)
				if(T.y+i <= world.maxy)
					line_range += locate(T.x, T.y+i, T.z)
	for(var/turf/dropspot in line_range)
		new /obj/effect/calldown_attack(dropspot)

/mob/living/simple_mob/glitch_boss/proc/confuse_inflict(atom/A)
	var/list/potential_targets = ai_holder.list_targets()
	for(var/atom/entry in potential_targets)
		if(istype(entry, /mob/living/simple_mob/glitch_boss_fake))
			potential_targets -= entry
	if(potential_targets.len < 2)
		return
	potential_targets -= A
	var/mob/living/target
	while(!target && potential_targets.len)
		var/candidate = pick(potential_targets)
		if(isliving(candidate))
			target = candidate
			break
		else
			potential_targets -= candidate

	if(target && istype(target))
		if(target.client)
			to_chat(target, "<span class='critical'>You feel as though you are losing your sense of direction! Brace yourself!</span>")
		new /obj/effect/temp_visual/pre_confuse(get_turf(target))
		spawn(5 SECONDS)
			if(target)
				target.Confuse(3)
				if(target.client)
					to_chat(target, "<span class='critical'>You feel confused!</span>")
				new /obj/effect/temp_visual/confuse(get_turf(target))

/mob/living/simple_mob/glitch_boss/proc/bullethell(atom/A)
	set waitfor = FALSE

	var/sd = dir2angle(dir)
	var/list/offsets = list(45, 45, 20, 10)

	for(var/i = 0, i<4, i++)
		for(var/j = 0, j <4, j++)
			var/obj/item/projectile/energy/slow_orb/shot = new(get_turf(src))
			shot.firer = src
			shot.fire(sd)
			sd += 90
		sd += pick(offsets)
		sleep(20)

/mob/living/simple_mob/glitch_boss/proc/speed_up_boost(atom/A)
	if(base_attack_cooldown == initial(base_attack_cooldown))
		base_attack_cooldown = 1 SECOND
		var/duration = (special_attack_cooldown == 5 SECONDS) ? 5 SECONDS : 10 SECONDS
		spawn(duration)
			base_attack_cooldown = initial(base_attack_cooldown)

/mob/living/simple_mob/glitch_boss/do_special_attack(atom/A)
	. = TRUE
	recently_used_attack = next_special_attack
	switch(next_special_attack)
		if(GA_ADS)
			make_ads(A)
		if(GA_CALLDOWN)
			bombardment(A)
		if(GA_LINES)
			bomb_lines(A)
		if(GA_BULLETHELL)
			bullethell(A)
		if(GA_ILLUSION)
			create_illusions(A)
		if(GA_CONFUSION)
			confuse_inflict(A)
		if(GA_SPEEDUP)
			speed_up_boost(A)

/datum/ai_holder/simple_mob/ranged/aggressive/bossmob_glitch
	wander = TRUE
	pointblank = TRUE
	intelligence_level = AI_SMART
	vision_range = 10
	closest_distance = 4

/datum/ai_holder/simple_mob/ranged/aggressive/bossmob_glitch/pre_special_attack(atom/A)
	var/mob/living/simple_mob/glitch_boss/GB
	if(istype(holder, /mob/living/simple_mob/glitch_boss))
		GB = holder
	if(GB)
		if(isliving(A) || ismecha(A))
			var/list/possible_attacks = list()
			possible_attacks += GB.all_special_attacks - GB.recently_used_attack
			var/illusion_count = 0
			var/list/potential_targets = list_targets()
			for(var/atom/illusion_maybe in potential_targets)
				if(istype(illusion_maybe, /mob/living/simple_mob/glitch_boss_fake))
					illusion_count++
					potential_targets -= illusion_maybe
			if(potential_targets.len < 2)
				possible_attacks -= GA_CONFUSION
				possible_attacks += GA_SPEEDUP			// Double chance when fighting single target
			if(illusion_count > 4)
				possible_attacks -= GA_ILLUSION
			if(!(possible_attacks.len))
				GB.next_special_attack = GA_BULLETHELL
			else
				GB.next_special_attack = pick(possible_attacks)
		else
			GB.next_special_attack = GA_BULLETHELL



/mob/living/simple_mob/glitch_boss_fake
	name = "CLICK ME!!!"
	desc = "WELCOME TO %location_data% THIS IS YOUR HOME NOW PLEASE INPUT CREDIT CARD CREDENTIALS BELOW"
	tt_desc = "BEST TOOLBAR PROVIDER SINCE 2098"
	icon = 'icons/mob/unknown_boss.dmi'
	icon_state = "glitch_boss"
	icon_living = "glitch_boss"
	icon_dead = "glitch_boss_dead"
	faction = FACTION_MATH

	maxHealth = 20
	health = 20
	evasion = -75

	melee_damage_lower = 0
	melee_damage_upper = 0
	attack_armor_pen = 0

	base_attack_cooldown = 2.5 SECONDS

	projectiletype = /obj/item/projectile/energy/slow_orb_fake
	projectilesound = 'sound/effects/uncloak.ogg'

	var/prob_respawn = 15

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/aggressive/bossmob_glitch_fake

/mob/living/simple_mob/glitch_boss_fake/strong
	maxHealth = 100
	health = 100
	prob_respawn = 60

/mob/living/simple_mob/glitch_boss_fake/death(gibbed, deathmessage="disappears in cloud of static.")
	new /obj/effect/temp_visual/glitch(get_turf(src))
	if(prob(prob_respawn))
		new /mob/living/simple_mob/glitch_boss_fake(get_turf(src))
	qdel(src)

/obj/item/projectile/energy/slow_orb_fake
	name = "TROJAN"
	icon_state = "glitch"
	damage = 0
	speed = 6
	damage_type = ELECTROCUTE
	agony = 0
	check_armour = "energy"
	armor_penetration = 0

	fire_sound = 'sound/effects/uncloak.ogg'
	combustion = TRUE

/datum/ai_holder/simple_mob/ranged/aggressive/bossmob_glitch_fake		//Same AI, but without special attack calculation stuff
	wander = TRUE
	pointblank = TRUE
	intelligence_level = AI_SMART
	vision_range = 9
	closest_distance = 4

#undef GA_ADS
#undef GA_CALLDOWN
#undef GA_SPEEDUP
#undef GA_ILLUSION
#undef GA_BULLETHELL
#undef GA_LINES
#undef GA_CONFUSION
