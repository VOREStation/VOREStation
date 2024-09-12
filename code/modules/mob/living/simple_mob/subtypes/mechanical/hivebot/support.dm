// These hivebots help their team in various ways, and can be very powerful with allies, but are otherwise very weak when alone.

/mob/living/simple_mob/mechanical/hivebot/support
	icon_state = "white"
	icon_living = "white"
	attacktext = list("prodded")
	movement_cooldown = 1.5
	melee_damage_lower = 2
	melee_damage_upper = 2

	organ_names = /decl/mob_organ_names/hivebotsupport

// This hivebot supplies a general buff to nearby hivebots that improve their performance.
// Note that the commander itself does not receive the buff.
/mob/living/simple_mob/mechanical/hivebot/support/commander
	name = "commander hivebot"
	desc = "A robot that appears to be directing the others."
	maxHealth = 5 LASERS_TO_KILL // 150 health
	health = 5 LASERS_TO_KILL
	player_msg = "You <b>increase the performance of other hivebots near you</b> passively.<br>\
	You are otherwise very weak offensively."

/mob/living/simple_mob/mechanical/hivebot/support/commander/handle_special()
	for(var/mob/living/L in range(4, src))
		if(L == src)
			continue // Don't buff ourselves.
		if(IIsAlly(L) && L.isSynthetic()) // Don't buff enemies.
			L.add_modifier(/datum/modifier/aura/hivebot_commander_buff, null, src)

// Modifier added to friendly hivebots nearby.
// Boosts most stats by 30%.
// The boost is lost if the commander is too far away or dies.
/datum/modifier/aura/hivebot_commander_buff
	name = "Strategicals"
	on_created_text = "<span class='notice'>Signal established with commander. Optimizating combat performance...</span>"
	on_expired_text = "<span class='warning'>Lost signal to commander. Optimization halting.</span>"
	stacks = MODIFIER_STACK_FORBID
	aura_max_distance = 4
	mob_overlay_state = "signal_blue"

	disable_duration_percent = 0.7
	outgoing_melee_damage_percent = 1.3
	attack_speed_percent = 1.3
	accuracy = 30
	slowdown = -1
	evasion = 30

// Variant that automatically commands nearby allies to follow it when created.
// Useful to avoid having to manually set follow to a lot of hivebots that are gonna die in the next minute anyways.
/mob/living/simple_mob/mechanical/hivebot/support/commander/autofollow/Initialize()
	for(var/mob/living/L in hearers(7, src))
		if(!L.ai_holder)
			continue
		if(L.faction != src.faction)
			continue
		var/datum/ai_holder/AI = L.ai_holder
		AI.set_follow(src)
	return ..()


// This hivebot adds charges to nearby allied hivebots that use the charge system for their special attacks.
// A charge is given to a nearby ally every so often.
// Charges cannot exceed the initial starting amount.
/mob/living/simple_mob/mechanical/hivebot/support/logistics
	name = "logistics hivebot"
	desc = "A robot that resupplies their allies."
	maxHealth = 3 LASERS_TO_KILL // 90 health
	health = 3 LASERS_TO_KILL
	player_msg = "You <b>passively restore 'charges' to allies with special abilities</b> who are \
	limited to using them a specific number of times."
	var/resupply_range = 5
	var/resupply_cooldown = 4 SECONDS
	var/last_resupply = null

/mob/living/simple_mob/mechanical/hivebot/support/logistics/handle_special()
	if(last_resupply + resupply_cooldown > world.time)
		return // On cooldown.

	for(var/mob/living/simple_mob/SM in hearers(resupply_range, src))
		if(SM == src)
			continue // We don't use charges buuuuut in case that changes in the future...
		if(IIsAlly(SM)) // Don't resupply enemies.
			if(!isnull(SM.special_attack_charges) && SM.special_attack_charges < initial(SM.special_attack_charges))
				SM.special_attack_charges += 1
				to_chat(SM, span("notice", "\The [src] has resupplied you, and you can use your special ability one additional time."))
				to_chat(src, span("notice", "You have resupplied \the [SM]."))
				last_resupply = world.time
				break // Only one resupply per pulse.

/decl/mob_organ_names/hivebotsupport
	hit_zones = list("central chassis", "positioning servo", "head", "sensor suite", "manipulator arm", "battle analytics mount", "weapons array", "front right leg", "front left leg", "rear left leg", "rear right leg")

/mob/living/simple_mob/mechanical/hivebot/support/harry
	name = "Harry the hivelessbot"
	desc = "A severely corroded hivebot, covered in barnacles and seaweed."
	maxHealth = 5 // 1 health
	health = 5
	ai_holder_type = /datum/ai_holder/simple_mob/passive/speedy
	say_list_type = /datum/say_list/hivebot/harry
	melee_damage_lower = 0
	melee_damage_upper = 0
	faction = FACTION_STATION
	water_resist = 1 //Harry lives under the sea!

/mob/living/simple_mob/mechanical/hivebot/support/harry/death()
	..()
	visible_message(span("Connection... terminated... Sweet Release... obtained.","\The [src] blows apart!"))
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
