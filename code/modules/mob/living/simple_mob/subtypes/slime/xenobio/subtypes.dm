// Here are where all the other colors of slime live.
// They will generally fight each other if not Unified, meaning the xenobiologist has to seperate them.

// Tier 1.

/mob/living/simple_mob/slime/xenobio/purple
	desc = "This slime is rather toxic to handle, as it is poisonous."
	color = "#CC23FF"
	slime_color = "purple"
	coretype = /obj/item/slime_extract/purple
	reagent_injected = "toxin"

	description_info = "This slime spreads a toxin when it attacks.  A biosuit or other thick armor can protect from the toxic attack."
	player_msg = "You <b>inject a harmful toxin</b> when attacking."

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/dark_purple,
			/mob/living/simple_mob/slime/xenobio/dark_blue,
			/mob/living/simple_mob/slime/xenobio/green,
			/mob/living/simple_mob/slime/xenobio
		)

/mob/living/simple_mob/slime/xenobio/orange
	desc = "This slime is known to be flammable and can ignite enemies."
	color = "#FFA723"
	slime_color = "orange"
	coretype = /obj/item/slime_extract/orange
	melee_damage_lower = 5
	melee_damage_upper = 5
	heat_resist = 1

	description_info = "The slime is immune to burning attacks, and attacks from this slime will burn you, and can ignite you. \
	A firesuit can protect from the burning attacks of this slime."
	player_msg = "You <b>inflict burning attacks</b>, which causes additional damage, makes the target more flammable, and has a chance to ignite them.<br>\
	You are also immune to burning attacks."

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/dark_purple,
			/mob/living/simple_mob/slime/xenobio/yellow,
			/mob/living/simple_mob/slime/xenobio/red,
			/mob/living/simple_mob/slime/xenobio
		)

/mob/living/simple_mob/slime/xenobio/orange/apply_melee_effects(atom/A)
	..()
	if(isliving(A))
		var/mob/living/L = A
		L.inflict_heat_damage(is_adult ? 10 : 5)
		to_chat(src, span("span", "You burn \the [L]."))
		to_chat(L, span("danger", "You've been burned by \the [src]!"))
		L.adjust_fire_stacks(1)
		if(prob(12))
			L.IgniteMob()

/mob/living/simple_mob/slime/xenobio/blue
	desc = "This slime produces 'cryotoxin' and uses it against their foes.  Very deadly to other slimes."
	color = "#19FFFF"
	slime_color = "blue"
	coretype = /obj/item/slime_extract/blue
	reagent_injected = "cryotoxin"
	cold_resist = 0.50 // Not as strong as dark blue, which has immunity.

	description_info = "The slime is resistant to the cold, and attacks from this slime can inject cryotoxin into you. \
	A biosuit or other thick armor can protect from the injection."
	player_msg = "You <b>inject cryotoxin on attack</b>, which causes them to get very cold, slowing them down and harming them over time.<br>\
	You are also resistant to cold attacks."

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/dark_blue,
			/mob/living/simple_mob/slime/xenobio/silver,
			/mob/living/simple_mob/slime/xenobio/pink,
			/mob/living/simple_mob/slime/xenobio
		)


/mob/living/simple_mob/slime/xenobio/metal
	desc = "This slime is a lot more resilient than the others, due to having a metamorphic metallic and sloped surface."
	color = "#5F5F5F"
	slime_color = "metal"
	shiny = TRUE
	coretype = /obj/item/slime_extract/metal

	description_info = "This slime is a lot more durable and tough to damage than the others. It also seems to provoke others to attack it over others."
	player_msg = "You are <b>more resilient and armored</b> than more slimes. Your attacks will also encourage less intelligent enemies to focus on you."

	maxHealth = 250
	maxHealth_adult = 350

	// The sloped armor.
	// It's resistant to most weapons (but a spraybottle still kills it rather fast).
	armor = list(
				"melee" = 25,
				"bullet" = 25,
				"laser" = 25,
				"energy" = 50,
				"bomb" = 80,
				"bio" = 100,
				"rad" = 100
				)

	armor_soak = list(
				"melee" = 5,
				"bullet" = 5,
				"laser" = 5,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/silver,
			/mob/living/simple_mob/slime/xenobio/yellow,
			/mob/living/simple_mob/slime/xenobio/gold,
			/mob/living/simple_mob/slime/xenobio
		)

/mob/living/simple_mob/slime/xenobio/metal/apply_melee_effects(atom/A)
	..()
	if(isliving(A))
		var/mob/living/L = A
		L.taunt(src, TRUE) // We're the party tank now.

// Tier 2

/mob/living/simple_mob/slime/xenobio/yellow
	desc = "This slime is very conductive, and is known to use electricity as a means of defense moreso than usual for slimes."
	color = "#FFF423"
	slime_color = "yellow"
	coretype = /obj/item/slime_extract/yellow
	melee_damage_lower = 5
	melee_damage_upper = 5
	shock_resist = 1

	projectiletype = /obj/item/projectile/beam/lightning/slime
	projectilesound = 'sound/effects/lightningbolt.ogg'
	glow_toggle = TRUE

	description_info = "In addition to being immune to electrical shocks, this slime will fire ranged lightning attacks at \
	enemies if they are at range, inflict shocks upon entities they attack, and generate electricity for their stun \
	attack faster than usual.  Insulative or reflective armor can protect from these attacks."
	player_msg = "You have a <b>ranged electric attack</b>. You also <b>shock enemies you attack</b>, and your electric stun attack charges passively.<br>\
	You are also immune to shocking attacks."

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/bluespace,
			/mob/living/simple_mob/slime/xenobio/bluespace,
			/mob/living/simple_mob/slime/xenobio/metal,
			/mob/living/simple_mob/slime/xenobio/orange
		)

/mob/living/simple_mob/slime/xenobio/yellow/apply_melee_effects(atom/A)
	..()
	if(isliving(A))
		var/mob/living/L = A
		L.inflict_shock_damage(is_adult ? 10 : 5)
		to_chat(src, span("span", "You shock \the [L]."))
		to_chat(L, span("danger", "You've been shocked by \the [src]!"))

/mob/living/simple_mob/slime/xenobio/yellow/handle_special()
	if(stat == CONSCIOUS)
		if(prob(25))
			power_charge = between(0, power_charge + 1, 10)
	..()

/obj/item/projectile/beam/lightning/slime
	power = 10
	fire_sound = 'sound/effects/lightningbolt.ogg'


/mob/living/simple_mob/slime/xenobio/dark_purple
	desc = "This slime produces ever-coveted phoron.  Risky to handle but very much worth it."
	color = "#660088"
	slime_color = "dark purple"
	coretype = /obj/item/slime_extract/dark_purple
	reagent_injected = "phoron"

	description_info = "This slime applies phoron to enemies it attacks.  A biosuit or other thick armor can protect from the toxic attack.  \
	If hit with a burning attack, it will erupt in flames."
	player_msg = "You <b>inject phoron</b> into enemies you attack.<br>\
	<b>You will erupt into flames if harmed by fire!</b>"

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/purple,
			/mob/living/simple_mob/slime/xenobio/orange,
			/mob/living/simple_mob/slime/xenobio/ruby,
			/mob/living/simple_mob/slime/xenobio/ruby
		)

/mob/living/simple_mob/slime/xenobio/dark_purple/proc/ignite()
	visible_message(span("critical", "\The [src] erupts in an inferno!"))
	for(var/turf/simulated/target_turf in view(2, src))
		target_turf.assume_gas("phoron", 30, 1500+T0C)
		spawn(0)
			target_turf.hotspot_expose(1500+T0C, 400)
	qdel(src)

/mob/living/simple_mob/slime/xenobio/dark_purple/ex_act(severity)
	log_and_message_admins("[src] ignited due to a chain reaction with an explosion.")
	ignite()

/mob/living/simple_mob/slime/xenobio/dark_purple/fire_act(datum/gas_mixture/air, temperature, volume)
	log_and_message_admins("[src] ignited due to exposure to fire.")
	ignite()

/mob/living/simple_mob/slime/xenobio/dark_purple/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(P.damage_type && P.damage_type == BURN && P.damage) // Most bullets won't trigger the explosion, as a mercy towards Security.
		log_and_message_admins("[src] ignited due to bring hit by a burning projectile[P.firer ? " by [key_name(P.firer)]" : ""].")
		ignite()
	else
		..()

/mob/living/simple_mob/slime/xenobio/dark_purple/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W) && W.force && W.damtype == BURN)
		log_and_message_admins("[src] ignited due to being hit with a burning weapon ([W]) by [key_name(user)].")
		ignite()
	else
		..()



/mob/living/simple_mob/slime/xenobio/dark_blue
	desc = "This slime makes other entities near it feel much colder, and is more resilient to the cold.  It tends to kill other slimes rather quickly."
	color = "#2398FF"
	glow_toggle = TRUE
	slime_color = "dark blue"
	coretype = /obj/item/slime_extract/dark_blue
	melee_damage_lower = 5
	melee_damage_upper = 5
	cold_resist = 1

	description_info = "This slime is immune to the cold, however water will still kill it. Its presense, as well as its attacks, will \
	also cause you additional harm from the cold. A winter coat or other cold-resistant clothing can protect from this."
	player_msg = "You are <b>immune to the cold</b>, inflict additional cold damage on attack, and cause nearby entities to suffer from coldness."

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/purple,
			/mob/living/simple_mob/slime/xenobio/blue,
			/mob/living/simple_mob/slime/xenobio/cerulean,
			/mob/living/simple_mob/slime/xenobio/cerulean
		)

	minbodytemp = 0
	cold_damage_per_tick = 0

/mob/living/simple_mob/slime/xenobio/dark_blue/handle_special()
	if(stat != DEAD)
		cold_aura()
	..()

/mob/living/simple_mob/slime/xenobio/dark_blue/proc/cold_aura()
	for(var/mob/living/L in view(2, src))
		if(L == src)
			continue
		chill(L)

	var/turf/T = get_turf(src)
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		env.add_thermal_energy(-10 * 1000)

/mob/living/simple_mob/slime/xenobio/dark_blue/apply_melee_effects(atom/A)
	..()
	if(isliving(A))
		var/mob/living/L = A
		chill(L)
		to_chat(src, span("span", "You chill \the [L]."))
		to_chat(L, span("danger", "You've been chilled by \the [src]!"))


/mob/living/simple_mob/slime/xenobio/dark_blue/proc/chill(mob/living/L)
	L.inflict_cold_damage(is_adult ? 10 : 5)
	if(L.get_cold_protection() < 1 && L.has_AI()) // Harmful auras will make the AI react to its bearer.
		L.ai_holder.react_to_attack(src)


/mob/living/simple_mob/slime/xenobio/silver
	desc = "This slime is shiny, and can deflect lasers or other energy weapons directed at it."
	color = "#AAAAAA"
	slime_color = "silver"
	coretype = /obj/item/slime_extract/silver
	shiny = TRUE

	description_info = "Tasers, including the slime version, are ineffective against this slime.  The slimebation still works."
	player_msg = "You <b>automatically reflect</b> lasers, beams, and tasers that hit you."

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/metal,
			/mob/living/simple_mob/slime/xenobio/blue,
			/mob/living/simple_mob/slime/xenobio/amber,
			/mob/living/simple_mob/slime/xenobio/amber
		)

/mob/living/simple_mob/slime/xenobio/silver/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(istype(P,/obj/item/projectile/beam) || istype(P, /obj/item/projectile/energy))
		visible_message(span("danger", "\The [src] reflects \the [P]!"))

		// Find a turf near or on the original location to bounce to
		var/new_x = P.starting.x + pick(0, 0, 0, -1, 1, -2, 2)
		var/new_y = P.starting.y + pick(0, 0, 0, -1, 1, -2, 2)
		var/turf/curloc = get_turf(src)

		// redirect the projectile
		P.redirect(new_x, new_y, curloc, src)
		P.reflected = TRUE
		return PROJECTILE_CONTINUE // complete projectile permutation
	else
		..()


// Tier 3

/mob/living/simple_mob/slime/xenobio/bluespace
	desc = "Trapping this slime in a cell is generally futile, as it can teleport at will."
	color = null
	slime_color = "bluespace"
	icon_state_override = "bluespace"
	coretype = /obj/item/slime_extract/bluespace

	description_info = "This slime will teleport to attack something if it is within a range of seven tiles.  The teleport has a cooldown of five seconds."
	player_msg = "You can <b>teleport at will</b> to a specific tile by clicking on it at range. This has a five second cooldown."

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/bluespace,
			/mob/living/simple_mob/slime/xenobio/bluespace,
			/mob/living/simple_mob/slime/xenobio/yellow,
			/mob/living/simple_mob/slime/xenobio/yellow
		)

	special_attack_min_range = 3
	special_attack_max_range = 7
	special_attack_cooldown = 5 SECONDS

/mob/living/simple_mob/slime/xenobio/bluespace/do_special_attack(atom/A)
	// Teleport attack.
	if(!A)
		to_chat(src, span("warning", "There's nothing to teleport to."))
		return FALSE

	var/list/nearby_things = range(1, A)
	var/list/valid_turfs = list()

	// All this work to just go to a non-dense tile.
	for(var/turf/potential_turf in nearby_things)
		var/valid_turf = TRUE
		if(potential_turf.density)
			continue
		for(var/atom/movable/AM in potential_turf)
			if(AM.density)
				valid_turf = FALSE
		if(valid_turf)
			valid_turfs.Add(potential_turf)

	var/turf/T = get_turf(src)
	var/turf/target_turf = pick(valid_turfs)

	if(!target_turf)
		to_chat(src, span("warning", "There wasn't an unoccupied spot to teleport to."))
		return FALSE

	var/datum/effect/effect/system/spark_spread/s1 = new /datum/effect/effect/system/spark_spread
	s1.set_up(5, 1, T)
	var/datum/effect/effect/system/spark_spread/s2 = new /datum/effect/effect/system/spark_spread
	s2.set_up(5, 1, target_turf)


	T.visible_message(span("notice", "\The [src] vanishes!"))
	s1.start()

	forceMove(target_turf)
	playsound(target_turf, 'sound/effects/phasein.ogg', 50, 1)
	to_chat(src, span("notice", "You teleport to \the [target_turf]."))

	target_turf.visible_message(span("warning", "\The [src] appears!"))
	s2.start()

	if(Adjacent(A))
		attack_target(A)


/mob/living/simple_mob/slime/xenobio/ruby
	desc = "This slime has great physical strength."
	color = "#FF3333"
	slime_color = "ruby"
	shiny = TRUE
	glow_toggle = TRUE
	coretype = /obj/item/slime_extract/ruby

	description_info = "This slime is unnaturally stronger, allowing it to hit much harder, take less damage, and be stunned for less time.  \
	Their glomp attacks also send the victim flying."
	player_msg = "Your <b>attacks knock back the target</b> a fair distance.<br>\
	You also hit harder, take less damage, and stuns affect you for less time."

	melee_attack_delay = 1 SECOND

	slime_mutation = list(
		/mob/living/simple_mob/slime/xenobio/dark_purple,
		/mob/living/simple_mob/slime/xenobio/dark_purple,
		/mob/living/simple_mob/slime/xenobio/ruby,
		/mob/living/simple_mob/slime/xenobio/ruby
	)

/mob/living/simple_mob/slime/xenobio/ruby/Initialize()
	add_modifier(/datum/modifier/slime_strength, null, src) // Slime is always swole.
	return ..()

/mob/living/simple_mob/slime/xenobio/ruby/apply_melee_effects(atom/A)
	..()

	if(isliving(A) && a_intent == I_HURT)
		var/mob/living/L = A
		if(L.mob_size <= MOB_MEDIUM)
			visible_message(span("danger", "\The [src] sends \the [L] flying with the impact!"))
			playsound(src, "punch", 50, 1)
			L.Weaken(1)
			var/throwdir = get_dir(src, L)
			L.throw_at(get_edge_target_turf(L, throwdir), 3, 1, src)
		else
			to_chat(L, span("warning", "\The [src] hits you with incredible force, but you remain in place."))


/mob/living/simple_mob/slime/xenobio/amber
	desc = "This slime seems to be an expert in the culinary arts, as they create their own food to share with others.  \
	They would probably be very important to other slimes, if the other colors didn't try to kill them."
	color = "#FFBB00"
	slime_color = "amber"
	shiny = TRUE
	glow_toggle = TRUE
	coretype = /obj/item/slime_extract/amber

	description_info = "This slime feeds nearby entities passively while it is alive.  This can cause uncontrollable \
	slime growth and reproduction if not kept in check.  The amber slime cannot feed itself, but can be fed by other amber slimes."
	player_msg = "You <b>passively provide nutrition</b> to nearby entities."

	slime_mutation = list(
		/mob/living/simple_mob/slime/xenobio/silver,
		/mob/living/simple_mob/slime/xenobio/silver,
		/mob/living/simple_mob/slime/xenobio/amber,
		/mob/living/simple_mob/slime/xenobio/amber
	)

/mob/living/simple_mob/slime/xenobio/amber/handle_special()
	if(stat != DEAD)
		feed_aura()
	..()

/mob/living/simple_mob/slime/xenobio/amber/proc/feed_aura()
	for(var/mob/living/L in view(1, src))
		if(L.stat == DEAD || !IIsAlly(L))
			continue
		if(L == src || istype(L, /mob/living/simple_mob/slime/xenobio/amber)) // Don't feed themselves, or it is impossible to stop infinite slimes without killing all of the ambers.
			continue
		if(istype(L, /mob/living/simple_mob/slime/xenobio))
			var/mob/living/simple_mob/slime/xenobio/X = L
			X.adjust_nutrition(rand(15, 25), 0)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.isSynthetic())
				continue
			H.nutrition = between(0, H.nutrition + rand(15, 25), 800)

/mob/living/simple_mob/slime/xenobio/cerulean
	desc = "This slime is generally superior in a wide range of attributes, compared to the common slime.  The jack of all trades, but master of none."
	color = "#4F7EAA"
	slime_color = "cerulean"
	coretype = /obj/item/slime_extract/cerulean

	// Less than the specialized slimes, but higher than the rest.
	maxHealth = 200
	maxHealth_adult = 250

	melee_damage_lower = 10
	melee_damage_upper = 30

	movement_cooldown = 0 // This actually isn't any faster due to AI limitations that hopefully the timer subsystem can fix in the future.

	slime_mutation = list(
		/mob/living/simple_mob/slime/xenobio/dark_blue,
		/mob/living/simple_mob/slime/xenobio/dark_blue,
		/mob/living/simple_mob/slime/xenobio/cerulean,
		/mob/living/simple_mob/slime/xenobio/cerulean
	)

// Tier 4

/mob/living/simple_mob/slime/xenobio/red
	desc = "This slime is full of energy, and very aggressive.  'The red ones go faster.' seems to apply here."
	color = "#FF3333"
	slime_color = "red"
	coretype = /obj/item/slime_extract/red
	movement_cooldown = 0 // See above.
	untamable = TRUE // Will enrage if disciplined.

	description_info = "This slime is faster than the others.  Attempting to discipline this slime will always cause it to go rabid and berserk."

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/red,
			/mob/living/simple_mob/slime/xenobio/oil,
			/mob/living/simple_mob/slime/xenobio/oil,
			/mob/living/simple_mob/slime/xenobio/orange
		)

	ai_holder_type = /datum/ai_holder/simple_mob/xenobio_slime


/mob/living/simple_mob/slime/xenobio/green
	desc = "This slime is radioactive."
	color = "#14FF20"
	slime_color = "green"
	coretype = /obj/item/slime_extract/green
	glow_toggle = TRUE
	reagent_injected = "radium"
	var/rads = 25

	description_info = "This slime will irradiate anything nearby passively, and will inject radium on attack.  \
	A radsuit or other thick and radiation-hardened armor can protect from this.  It will only radiate while alive."
	player_msg = "You <b>passively irradiate your surroundings</b>.<br>\
	You also inject radium on attack."

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/purple,
			/mob/living/simple_mob/slime/xenobio/green,
			/mob/living/simple_mob/slime/xenobio/emerald,
			/mob/living/simple_mob/slime/xenobio/emerald
		)

/mob/living/simple_mob/slime/xenobio/green/handle_special()
	if(stat != DEAD)
		irradiate()
	..()

/mob/living/simple_mob/slime/xenobio/green/proc/irradiate()
	SSradiation.radiate(src, rads)



/mob/living/simple_mob/slime/xenobio/pink
	desc = "This slime has regenerative properties."
	color = "#FF0080"
	slime_color = "pink"
	coretype = /obj/item/slime_extract/pink
	glow_toggle = TRUE

	description_info = "This slime will passively heal nearby entities within two tiles, including itself.  It will only do this while alive."
	player_msg = "You <b>passively heal yourself and nearby allies</b>."

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/blue,
			/mob/living/simple_mob/slime/xenobio/light_pink,
			/mob/living/simple_mob/slime/xenobio/light_pink,
			/mob/living/simple_mob/slime/xenobio/pink
		)

/mob/living/simple_mob/slime/xenobio/pink/handle_special()
	if(stat != DEAD)
		heal_aura()
	..()

/mob/living/simple_mob/slime/xenobio/pink/proc/heal_aura()
	for(var/mob/living/L in view(src, 2))
		if(L.stat == DEAD || !IIsAlly(L))
			continue
		L.add_modifier(/datum/modifier/aura/slime_heal, null, src)

/datum/modifier/aura/slime_heal
	name = "slime mending"
	desc = "You feel somewhat gooey."
	mob_overlay_state = "pink_sparkles"
	stacks = MODIFIER_STACK_FORBID
	aura_max_distance = 2

	on_created_text = "<span class='warning'>Twinkling spores of goo surround you.  It makes you feel healthier.</span>"
	on_expired_text = "<span class='notice'>The spores of goo have faded, although you feel much healthier than before.</span>"

/datum/modifier/aura/slime_heal/tick()
	if(holder.stat == DEAD)
		expire()

	if(ishuman(holder)) // Robolimbs need this code sadly.
		var/mob/living/carbon/human/H = holder
		for(var/obj/item/organ/external/E in H.organs)
			var/obj/item/organ/external/O = E
			O.heal_damage(2, 2, 0, 1)
	else
		holder.adjustBruteLoss(-2)
		holder.adjustFireLoss(-2)

	holder.adjustToxLoss(-2)
	holder.adjustOxyLoss(-2)
	holder.adjustCloneLoss(-1)


/mob/living/simple_mob/slime/xenobio/gold
	desc = "This slime absorbs energy, and cannot be stunned by normal means."
	color = "#EEAA00"
	shiny = TRUE
	slime_color = "gold"
	coretype = /obj/item/slime_extract/gold
	description_info = "This slime is immune to the slimebaton and taser, and will actually charge the slime, however it will still discipline the slime."

	slime_mutation = list(
			/mob/living/simple_mob/slime/xenobio/metal,
			/mob/living/simple_mob/slime/xenobio/gold,
			/mob/living/simple_mob/slime/xenobio/sapphire,
			/mob/living/simple_mob/slime/xenobio/sapphire
		)

/mob/living/simple_mob/slime/xenobio/gold/slimebatoned(mob/living/user, amount)
	adjust_discipline(round(amount/2))
	power_charge = between(0, power_charge + amount, 10)

/mob/living/simple_mob/slime/xenobio/gold/get_description_interaction() // So it doesn't say to use a baton on them.
	return list()


// Tier 5

/mob/living/simple_mob/slime/xenobio/oil
	desc = "This slime is explosive and volatile.  Smoking near it is probably a bad idea."
	color = "#333333"
	slime_color = "oil"
	shiny = TRUE
	coretype = /obj/item/slime_extract/oil

	description_info = "If this slime suffers damage from a fire or heat based source, or if it is caught inside \
	an explosion, it will explode.  Oil slimes will also suicide-bomb themselves when fighting something that is not a monkey or slime."
	player_msg = "You <b>will explode if struck by a burning attack</b>, or if you hit an enemy with a melee attack that is not a monkey or another slime."

	slime_mutation = list(
		/mob/living/simple_mob/slime/xenobio/oil,
		/mob/living/simple_mob/slime/xenobio/oil,
		/mob/living/simple_mob/slime/xenobio/red,
		/mob/living/simple_mob/slime/xenobio/red
	)

/mob/living/simple_mob/slime/xenobio/oil/proc/explode()
	if(stat != DEAD)
		explosion(src.loc, 0, 2, 4) // A bit weaker since the suicide charger tended to gib the poor sod being targeted.
		if(src) // Delete ourselves if the explosion didn't do it.
			qdel(src)

/mob/living/simple_mob/slime/xenobio/oil/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(ishuman(L))
			var/mob/living/carbon/human/H = A
			if(istype(H.species, /datum/species/monkey))
				return ..()// Don't blow up when just eatting monkeys.

		else if(isslime(L))
			return ..()

		// Otherwise blow ourselves up.
		say(pick("Sacrifice...!", "Sssss...", "Boom...!"))
		set_AI_busy(TRUE)
		sleep(2 SECONDS)
		log_and_message_admins("[src] has suicide-bombed themselves while trying to kill \the [L].")
		explode()

	return ..()

/mob/living/simple_mob/slime/xenobio/oil/ex_act(severity)
	log_and_message_admins("[src] exploded due to a chain reaction with another explosion.")
	explode()

/mob/living/simple_mob/slime/xenobio/oil/fire_act(datum/gas_mixture/air, temperature, volume)
	log_and_message_admins("[src] exploded due to exposure to fire.")
	explode()

/mob/living/simple_mob/slime/xenobio/oil/bullet_act(obj/item/projectile/P, def_zone)
	if(P.damage_type && P.damage_type == BURN && P.damage) // Most bullets won't trigger the explosion, as a mercy towards Security.
		log_and_message_admins("[src] exploded due to bring hit by a burning projectile[P.firer ? " by [key_name(P.firer)]" : ""].")
		explode()
	else
		..()

/mob/living/simple_mob/slime/xenobio/oil/attackby(obj/item/weapon/W, mob/living/user)
	if(istype(W) && W.force && W.damtype == BURN)
		log_and_message_admins("[src] exploded due to being hit with a burning weapon ([W]) by [key_name(user)].")
		explode()
	else
		..()


/mob/living/simple_mob/slime/xenobio/sapphire
	desc = "This slime seems a bit brighter than the rest, both figuratively and literally."
	color = "#2398FF"
	slime_color = "sapphire"
	shiny = TRUE
	glow_toggle = TRUE
	coretype = /obj/item/slime_extract/sapphire
	ai_holder_type = /datum/ai_holder/simple_mob/xenobio_slime/sapphire

	description_info = "This slime uses more robust tactics when fighting and won't hold back, so it is dangerous to be alone \
	with one if hostile, and especially dangerous if they outnumber you."

	slime_mutation = list(
		/mob/living/simple_mob/slime/xenobio/sapphire,
		/mob/living/simple_mob/slime/xenobio/sapphire,
		/mob/living/simple_mob/slime/xenobio/gold,
		/mob/living/simple_mob/slime/xenobio/gold
	)


/mob/living/simple_mob/slime/xenobio/emerald
	desc = "This slime is faster than usual, even more so than the red slimes."
	color = "#22FF22"
	shiny = TRUE
	glow_toggle = TRUE
	slime_color = "emerald"
	coretype = /obj/item/slime_extract/emerald

	description_info = "This slime will make everything around it, and itself, faster for a few seconds, if close by."

	slime_mutation = list(
		/mob/living/simple_mob/slime/xenobio/green,
		/mob/living/simple_mob/slime/xenobio/green,
		/mob/living/simple_mob/slime/xenobio/emerald,
		/mob/living/simple_mob/slime/xenobio/emerald
	)

/mob/living/simple_mob/slime/xenobio/emerald/handle_special()
	if(stat != DEAD)
		zoom_aura()
	..()

/mob/living/simple_mob/slime/xenobio/emerald/proc/zoom_aura()
	for(var/mob/living/L in view(src, 2))
		if(L.stat == DEAD || !IIsAlly(L))
			continue
		L.add_modifier(/datum/modifier/technomancer/haste, 5 SECONDS, src)


/mob/living/simple_mob/slime/xenobio/light_pink
	desc = "This slime seems a lot more peaceful than the others."
	color = "#FF8888"
	slime_color = "light pink"
	coretype = /obj/item/slime_extract/light_pink

	description_info = "This slime is effectively always disciplined initially."

	slime_mutation = list(
		/mob/living/simple_mob/slime/xenobio/pink,
		/mob/living/simple_mob/slime/xenobio/pink,
		/mob/living/simple_mob/slime/xenobio/light_pink,
		/mob/living/simple_mob/slime/xenobio/light_pink
	)

	ai_holder_type = /datum/ai_holder/simple_mob/xenobio_slime/light_pink

// Special
/mob/living/simple_mob/slime/xenobio/rainbow
	desc = "This slime changes colors constantly."
	color = null // Uses a special icon_state.
	slime_color = "rainbow"
	coretype = /obj/item/slime_extract/rainbow
	icon_state_override = "rainbow"
	unity = TRUE

	description_info = "This slime is considered to be the same color as all other slime colors at the same time for the purposes of \
	other slimes being friendly to them, and therefore will never be harmed by another slime.  \
	Attacking this slime will provoke the wrath of all slimes within range."
	player_msg = "You are <b>considered to be the same color as every slime</b>, \
	meaning that you are considered an ally to all slimes."

	slime_mutation = list(
		/mob/living/simple_mob/slime/xenobio/rainbow,
		/mob/living/simple_mob/slime/xenobio/rainbow,
		/mob/living/simple_mob/slime/xenobio/rainbow,
		/mob/living/simple_mob/slime/xenobio/rainbow
	)

/mob/living/simple_mob/slime/xenobio/rainbow/Initialize()
	unify()
	return ..()

// The RD's pet slime.
/mob/living/simple_mob/slime/xenobio/rainbow/kendrick
	name = "Kendrick"
	desc = "The Research Director's pet slime.  It shifts colors constantly."
	rainbow_core_candidate = FALSE
	// Doing pacify() in initialize() won't actually pacify the AI due to the ai_holder not existing due to parent initialize() not being called yet.
	// Instead lets just give them an ai_holder that does that for us.
	ai_holder_type = /datum/ai_holder/simple_mob/xenobio_slime/passive

/mob/living/simple_mob/slime/xenobio/rainbow/kendrick/Initialize()
	pacify() // So the physical mob also gets made harmless.
	return ..()
