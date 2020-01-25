// There are different kinds of blobs, with different colors, properties, weaknesses, etc.  This datum tells the blob objects what kind they are, without a million typepaths.
/datum/blob_type
	var/name = "base blob"
	var/desc = "This shouldn't exist."	// Shown on examine.
	var/effect_desc = "This does nothing special."	// For examine panel.
	var/ai_desc = "default" // Shown when examining the overmind.
	var/difficulty = BLOB_DIFFICULTY_EASY // A rough guess on how hard a blob is to kill.
	                                      // When a harder blob spawns by event, the crew is given more information than usual from the announcement.
	var/color = "#FFFFFF"	// The actual blob's color.
	var/complementary_color = "#000000" //a color that's complementary to the normal blob color.  Blob mobs are colored in this.

	var/attack_message = "The blob attacks you" // Base message the mob gets when blob_act() gets called on them by the blob.  An exclaimation point is added to the end.
	var/attack_message_living = null	// Appended to attack_message, if the target fails isSynthetic() check.
	var/attack_message_synth = null		// Ditto, but if they pass isSynthetic().
	var/attack_verb = "attacks"			// Used for the visible_message(), as the above is shown to the mob getting hit directly.
										// Format is '\The [blob name] [attack_verb] [victim]!' E.g. 'The explosive lattice blasts John Doe!'

	var/damage_type = BRUTE				// What kind of damage to do to living mobs via blob_act()
	var/armor_check = "melee"			// What armor to check for when blob_act()-ing living mobs.
	var/armor_pen = 0					// How much armor to penetrate(ignore) when attacking via blob_act().
	var/damage_lower = 30				// Lower bound for amount of damage to do for attacks.
	var/damage_upper = 40				// Upper bound.

	var/brute_multiplier = 0.5			// Adjust to make blobs stonger or weaker against brute damage.
	var/burn_multiplier = 1.0			// Ditto, for burns.
	var/spread_modifier = 0.5			// A multipler on how fast the blob should naturally spread from the core and nodes.
	var/slow_spread_with_size = TRUE	// Blobs that get really huge will slow down in expansion.

	var/ai_aggressiveness = 10			// Probability of the blob AI attempting to attack someone next to the blob, independant of the attacks from node/core pulsing.

	var/can_build_factories = FALSE		// Forbids this blob type from building factories.  Set to true to enable.
	var/can_build_resources = FALSE		// Ditto, for resource blobs.
	var/can_build_nodes = TRUE			// Ditto, for nodes.

	var/spore_type = /mob/living/simple_mob/blob/spore
	var/ranged_spores = FALSE			// For proper spores of the type above.
	var/spore_firesound = 'sound/effects/slime_squish.ogg'
	var/spore_range = 7					// The range the spore can fire.
	var/spore_projectile = /obj/item/projectile/energy/blob

	var/factory_type = /obj/structure/blob/factory
	var/resource_type = /obj/structure/blob/resource
	var/node_type = /obj/structure/blob/node
	var/shield_type = /obj/structure/blob/shield

// Called when a blob receives damage.  This needs to return the final damage or blobs will be immortal.
/datum/blob_type/proc/on_received_damage(var/obj/structure/blob/B, damage, damage_type)
	return damage

// Called when a blob dies due to integrity depletion.  Not called if deleted by other means.
/datum/blob_type/proc/on_death(var/obj/structure/blob/B)
	return

// Called when a blob expands onto another tile.
/datum/blob_type/proc/on_expand(var/obj/structure/blob/B, var/obj/structure/blob/new_B, var/turf/T, var/mob/observer/blob/O)
	return

// Called when blob_act() is called on a living mob.
/datum/blob_type/proc/on_attack(var/obj/structure/blob/B, var/mob/living/victim, var/def_zone)
	return

// Called when the blob is pulsed by a node or the core.
/datum/blob_type/proc/on_pulse(var/obj/structure/blob/B)
	return

// Called when hit by EMP.
/datum/blob_type/proc/on_emp(obj/structure/blob/B, severity)
	return

// Called when hit by water.
/datum/blob_type/proc/on_water(obj/structure/blob/B, amount)
	return

// Spore things
/datum/blob_type/proc/on_spore_death(mob/living/simple_mob/blob/spore/S)
	return


// Subtypes

// Super fast spreading, but weak to EMP.
/datum/blob_type/grey_goo
	name = "grey tide"
	desc = "A swarm of self replicating nanomachines.  Extremely illegal and dangerous, the EIO was meant to prevent this from showing up a second time."
	effect_desc = "Spreads much faster than average, but is harmed greatly by electromagnetic pulses."
	ai_desc = "genocidal"
	difficulty = BLOB_DIFFICULTY_SUPERHARD // Fastest spread of them all and has snowballing capabilities.
	color = "#888888"
	complementary_color = "#CCCCCC"
	spread_modifier = 1.0
	slow_spread_with_size = FALSE
	ai_aggressiveness = 80
	can_build_resources = TRUE
	attack_message = "The tide tries to swallow you"
	attack_message_living = ", and you feel your skin dissolve"
	attack_message_synth = ", and your external plating dissolves"

/datum/blob_type/grey_goo/on_emp(obj/structure/blob/B, severity)
	B.adjust_integrity(-(20 / severity))

// Slow, tanky blobtype which uses not spores, but hivebots, as its soldiers.
/datum/blob_type/fabrication_swarm
	name = "iron tide"
	desc = "A swarm of self replicating construction nanites. Incredibly illegal, but only mildly dangerous."
	effect_desc = "Slow-spreading, but incredibly resiliant. It has a chance to harden itself against attacks automatically for no resource cost, and uses cheaply-constructed hivebots as soldiers."
	ai_desc = "defensive"
	difficulty = BLOB_DIFFICULTY_MEDIUM // Emitters are okay, EMP is great.
	color = "#666666"
	complementary_color = "#B7410E"
	spread_modifier = 0.2
	can_build_factories = TRUE
	can_build_resources = TRUE
	attack_message = "The tide tries to shove you away"
	attack_message_living = ", and your skin itches"
	attack_message_synth = ", and your external plating dulls"
	attack_verb = "shoves"
	armor_pen = 40
	damage_lower = 10
	damage_upper = 25
	brute_multiplier = 0.25
	burn_multiplier = 0.6
	ai_aggressiveness = 50 //Really doesn't like you near it.
	spore_type = /mob/living/simple_mob/mechanical/hivebot/swarm

/datum/blob_type/fabrication_swarm/on_received_damage(var/obj/structure/blob/B, damage, damage_type, mob/living/attacker)
	if(istype(B, /obj/structure/blob/normal))
		if(damage > 0)
			var/reinforce_probability = min(damage, 70)
			if(prob(reinforce_probability))
				B.visible_message("<span class='danger'>The [name] quakes, before rapidly hardening!</span>")
				new/obj/structure/blob/shield(get_turf(B), B.overmind)
				qdel(B)
	return ..()

/datum/blob_type/fabrication_swarm/on_emp(obj/structure/blob/B, severity)
	B.adjust_integrity(-(30 / severity))

// A blob meant to be fought like a fire.
/datum/blob_type/blazing_oil
	name = "blazing oil"
	desc = "A strange, extremely vicious liquid that seems to burn endlessly."
	ai_desc = "aggressive"
	effect_desc = "Cannot be harmed by burning weapons, and ignites entities it attacks.  It will also gradually heat up the area it is in.  Water harms it greatly."
	difficulty = BLOB_DIFFICULTY_MEDIUM // Emitters don't work but extinguishers are fairly common.  Might need fire/atmos suits.
	color = "#B68D00"
	complementary_color = "#BE5532"
	spread_modifier = 0.5
	ai_aggressiveness = 50
	damage_type = BURN
	burn_multiplier = 0 // Fire immunity
	attack_message = "The blazing oil splashes you with its burning oil"
	attack_message_living = ", and you feel your skin char and melt"
	attack_message_synth = ", and your external plating melts"
	attack_verb = "splashes"

/datum/blob_type/blazing_oil/on_attack(obj/structure/blob/B, mob/living/victim)
	victim.fire_act() // Burn them.

/datum/blob_type/blazing_oil/on_water(obj/structure/blob/B, amount)
	spawn(1)
		B.adjust_integrity(-(amount * 5))

/datum/blob_type/blazing_oil/on_pulse(var/obj/structure/blob/B)
	var/turf/T = get_turf(B)
	if(!T)
		return
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		env.add_thermal_energy(10 * 1000)


// Mostly a classic blob.  No nodes, no other blob types.
/datum/blob_type/classic
	name = "lethargic blob"
	desc = "A mass that seems bound to its core."
	ai_desc = "unambitious"
	effect_desc = "Will not create any nodes.  Has average strength and resistances."
	difficulty = BLOB_DIFFICULTY_EASY // Behaves almost like oldblob, and as such is about as easy as oldblob.
	color = "#AAFF00"
	complementary_color = "#57787B"
	can_build_nodes = FALSE
	spread_modifier = 1.0
	ai_aggressiveness = 0


// Makes robots cry.  Really weak to brute damage.
/datum/blob_type/electromagnetic_web
	name = "electromagnetic web"
	desc = "A gooy mesh that generates an electromagnetic field.  Electronics will likely be ruined if nearby."
	ai_desc = "balanced"
	effect_desc = "Causes an EMP on attack, and will EMP upon death.  It is also more fragile than average, especially to brute force."
	difficulty = BLOB_DIFFICULTY_MEDIUM // Rough for robots but otherwise fragile and can be fought at range like most blobs anyways.
	color = "#83ECEC"
	complementary_color = "#EC8383"
	damage_type = BURN
	damage_lower = 10
	damage_upper = 20
	brute_multiplier = 3
	burn_multiplier = 2
	ai_aggressiveness = 60
	attack_message = "The web lashes you"
	attack_message_living = ", and you hear a faint buzzing"
	attack_message_synth = ", and your electronics get badly damaged"
	attack_verb = "lashes"

/datum/blob_type/electromagnetic_web/on_death(obj/structure/blob/B)
	empulse(B.loc, 0, 1, 2)

/datum/blob_type/electromagnetic_web/on_attack(obj/structure/blob/B, mob/living/victim)
	victim.emp_act(2)


// Makes spores that spread the blob and infest dead people.
/datum/blob_type/fungal_bloom
	name = "fungal bloom"
	desc = "A massive network of rapidly expanding mycelium.  Large spore-like particles can be seen spreading from it."
	ai_desc = "swarming"
	effect_desc = "Creates floating spores that attack enemies from specialized blobs, and will spread the blob if killed.  The spores can also \
	infest deceased biological humanoids.  It is vulnerable to fire."
	difficulty = BLOB_DIFFICULTY_MEDIUM // The spores are more of an annoyance but can be difficult to contain.
	color = "#AAAAAA"
	complementary_color = "#FFFFFF"
	damage_type = TOX
	damage_lower = 15
	damage_upper = 25
	spread_modifier = 0.3 // Lower, since spores will do a lot of the spreading.
	burn_multiplier = 3
	ai_aggressiveness = 40
	can_build_factories = TRUE
	spore_type = /mob/living/simple_mob/blob/spore/infesting

/datum/blob_type/fungal_bloom/on_spore_death(mob/living/simple_mob/blob/spore/S)
	if(S.is_infesting)
		return // Don't make blobs if they were on someone's head.
	var/turf/T = get_turf(S)
	var/obj/structure/blob/B = locate(/obj/structure/blob) in T
	if(B) // Is there already a blob here?  If so, just heal it.
		B.adjust_integrity(10)
	else
		B = new /obj/structure/blob/normal(T, S.overmind) // Otherwise spread it.
		B.visible_message("<span class='danger'>\A [B] forms on \the [T] as \the [S] bursts!</span>")

// Makes tons of weak spores whenever it spreads.
/datum/blob_type/fulminant_organism
	name = "fulminant organism"
	desc = "A self expanding mass of living biomaterial, that appears to produce entities to defend it, much like a living organism's immune system."
	ai_desc = "swarming"
	effect_desc = "Creates weak floating spores that attack enemies from specialized blobs, has a chance to also create a spore when \
	it spreads onto a new tile, and has a chance to create a spore when a blob tile is destroyed.  It is more fragile than average to all types of damage."
	difficulty = BLOB_DIFFICULTY_HARD // Loads of spores that can overwhelm, and spreads quickly.
	color = "#FF0000" // Red
	complementary_color = "#FFCC00" // Orange-ish
	damage_type = TOX
	damage_lower = 10
	damage_upper = 20
	spread_modifier = 0.7
	burn_multiplier = 1.5
	brute_multiplier = 1.5
	ai_aggressiveness = 30 // The spores do most of the fighting.
	can_build_factories = TRUE
	spore_type = /mob/living/simple_mob/blob/spore/weak

/datum/blob_type/fulminant_organism/on_expand(var/obj/structure/blob/B, var/obj/structure/blob/new_B, var/turf/T, var/mob/observer/blob/O)
	if(prob(10)) // 10% chance to make a weak spore when expanding.
		var/mob/living/simple_mob/blob/spore/S = new spore_type(T)
		if(istype(S))
			S.overmind = O
			O.blob_mobs.Add(S)
		else
			S.faction = "blob"
		S.update_icons()

/datum/blob_type/fulminant_organism/on_death(obj/structure/blob/B)
	if(prob(33)) // 33% chance to make a spore when dying.
		var/mob/living/simple_mob/blob/spore/S = new spore_type(get_turf(B))
		B.visible_message("<span class='danger'>\The [S] floats free from the [name]!</span>")
		if(istype(S))
			S.overmind = B.overmind
			B.overmind.blob_mobs.Add(S)
		else
			S.faction = "blob"
		S.update_icons()


// Auto-retaliates against melee attacks.  Weak to projectiles.
/datum/blob_type/reactive_spines
	name = "reactive spines"
	desc = "An ever-growing lifeform with a large amount of sharp, powerful looking spines.  They look like they could pierce most armor."
	ai_desc = "defensive"
	effect_desc = "When attacked by a melee weapon, it will automatically retaliate, striking the attacker with an armor piercing attack.  \
	The blob itself is rather weak to all forms of attacks regardless, and lacks automatic realitation from ranged attacks."
	difficulty = BLOB_DIFFICULTY_EASY // Potentially deadly to people not knowing the mechanics, but otherwise fairly tame, due to its slow spread and weakness.
	color = "#9ACD32"
	complementary_color = "#FFA500"
	damage_type = BRUTE
	damage_lower = 30
	damage_upper = 40
	armor_pen = 50 // Even with riot armor and tactical jumpsuit, you'd have 90 armor, reduced by 50, totaling 40.  Getting hit for around 21 damage is still rough.
	burn_multiplier = 2.0
	brute_multiplier = 2.0
	spread_modifier = 0.35 // Ranged projectiles tend to have a higher material cost, so ease up on the spreading.
	ai_aggressiveness = 40
	attack_message = "The blob stabs you"
	attack_message_living = ", and you feel sharp spines pierce your flesh"
	attack_message_synth = ", and your external plating is pierced by sharp spines"
	attack_verb = "stabs"

// Even if the melee attack is enough to one-shot this blob, it gets to retaliate at least once.
/datum/blob_type/reactive_spines/on_received_damage(var/obj/structure/blob/B, damage, damage_type, mob/living/attacker)
	if(damage > 0 && attacker && get_dist(B, attacker) <= 1)
		B.visible_message("<span class='danger'>The [name] retaliates, lashing out at \the [attacker]!</span>")
		B.blob_attack_animation(attacker, B.overmind)
		attacker.blob_act(B)
	return ..()


// Spreads damage to nearby blobs, and attacks with the force of all nearby blobs.
/datum/blob_type/synchronous_mesh
	name = "synchronous mesh"
	desc = "A mesh that seems strongly interconnected to itself.  It moves slowly, but with purpose."
	ai_desc = "defensive"
	effect_desc = "When damaged, spreads the damage to nearby blobs.  When attacking, damage is increased based on how many blobs are near the target.  It is resistant to burn damage."
	difficulty = BLOB_DIFFICULTY_EASY // Mostly a tank and spank.
	color = "#65ADA2"
	complementary_color = "#AD6570"
	damage_type = BRUTE
	damage_lower = 10
	damage_upper = 15
	brute_multiplier = 0.5
	burn_multiplier = 0.2 // Emitters do so much damage that this will likely not matter too much.
	spread_modifier = 0.3 // Since the blob spreads damage, it takes awhile to actually kill, so spread is reduced.
	ai_aggressiveness = 60
	attack_message = "The mesh synchronously strikes you"
	attack_verb = "synchronously strikes"
	var/synchronously_attacking = FALSE

/datum/blob_type/synchronous_mesh/on_attack(obj/structure/blob/B, mob/living/victim)
	if(synchronously_attacking)
		return
	synchronously_attacking = TRUE // To avoid infinite loops.
	for(var/obj/structure/blob/C in orange(1, victim))
		if(victim) // Some things delete themselves when dead...
			C.blob_attack_animation(victim)
			victim.blob_act(C)
	synchronously_attacking = FALSE

/datum/blob_type/synchronous_mesh/on_received_damage(var/obj/structure/blob/B, damage, damage_type)
	var/list/blobs_to_hurt = list() // Maximum split is 9, reducing the damage each blob takes to 11.1% but doing that damage to 9 blobs.
	for(var/obj/structure/blob/C in range(1, B))
		if(!istype(C, /obj/structure/blob/core) && !istype(C, /obj/structure/blob/node) && C.overmind && (C.overmind == B.overmind) ) //if it doesn't have the same 'ownership' or is a core or node, don't split damage to it
			blobs_to_hurt += C

	for(var/thing in blobs_to_hurt)
		var/obj/structure/blob/C = thing
		if(C == B)
			continue // We'll damage this later.

		C.adjust_integrity(-(damage / blobs_to_hurt.len))

	return damage / max(blobs_to_hurt.len, 1) // To hurt the blob that got hit.


/datum/blob_type/shifting_fragments
	name = "shifting fragments"
	desc = "A collection of fragments that seem to shuffle around constantly."
	ai_desc = "evasive"
	effect_desc = "Swaps places with nearby blobs when hit or when expanding."
	difficulty = BLOB_DIFFICULTY_EASY
	color = "#C8963C"
	complementary_color = "#3C6EC8"
	damage_type = BRUTE
	damage_lower = 20
	damage_upper = 30
	brute_multiplier = 0.5
	burn_multiplier = 0.5
	spread_modifier = 0.5
	ai_aggressiveness = 30
	attack_message = "A fragment strikes you"
	attack_verb = "strikes"

/datum/blob_type/shifting_fragments/on_received_damage(var/obj/structure/blob/B, damage, damage_type)
	if(damage > 0 && prob(60))
		var/list/available_blobs = list()
		for(var/obj/structure/blob/OB in orange(1, B))
			if((istype(OB, /obj/structure/blob/normal) || (istype(OB, /obj/structure/blob/shield) && prob(25))) && OB.overmind && OB.overmind == B.overmind)
				available_blobs += OB
		if(available_blobs.len)
			var/obj/structure/blob/targeted = pick(available_blobs)
			var/turf/T = get_turf(targeted)
			targeted.forceMove(get_turf(B))
			B.forceMove(T) // Swap places.
	return ..()

/datum/blob_type/shifting_fragments/on_expand(var/obj/structure/blob/B, var/obj/structure/blob/new_B, var/turf/T, var/mob/observer/blob/O)
	if(istype(B, /obj/structure/blob/normal) || (istype(B, /obj/structure/blob/shield) && prob(25)))
		new_B.forceMove(get_turf(B))
		B.forceMove(T)

// A very cool blob, literally.
/datum/blob_type/cryogenic_goo
	name = "cryogenic goo"
	desc = "A mass of goo that freezes anything it touches."
	ai_desc = "balanced"
	effect_desc = "Lowers the temperature of the room passively, and will also greatly lower the temperature of anything it attacks."
	difficulty = BLOB_DIFFICULTY_MEDIUM
	color = "#8BA6E9"
	complementary_color = "#7D6EB4"
	damage_type = BURN
	damage_lower = 15
	damage_upper = 25
	brute_multiplier = 0.25
	burn_multiplier = 1.2
	spread_modifier = 0.5
	ai_aggressiveness = 50
	attack_message = "The goo stabs you"
	attack_message_living = ", and you feel an intense chill from within"
	attack_message_synth = ", and your system reports lower internal temperatures"
	attack_verb = "stabs"

/datum/blob_type/cryogenic_goo/on_attack(obj/structure/blob/B, mob/living/victim)
	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		var/protection = H.get_cold_protection(50)
		if(protection < 1)
			var/temp_change = 80 // Each hit can reduce temperature by up to 80 kelvin.
			var/datum/species/baseline = GLOB.all_species["Human"]
			var/temp_cap = baseline.cold_level_3 - 5 // Can't go lower than this.

			var/cold_factor = abs(protection - 1)
			temp_change *= cold_factor // If protection was at 0.5, then they only lose 40 kelvin.

			H.bodytemperature = max(H.bodytemperature - temp_change, temp_cap)
	else // Just do some extra burn for mobs who don't process bodytemp
		victim.adjustFireLoss(20)

/datum/blob_type/cryogenic_goo/on_pulse(var/obj/structure/blob/B)
	var/turf/simulated/T = get_turf(B)
	if(!istype(T))
		return
	T.freeze_floor()
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		env.add_thermal_energy(-10 * 1000)

// Electric blob that stuns.
/datum/blob_type/energized_jelly
	name = "energized jelly"
	desc = "A substance that seems to generate electricity."
	ai_desc = "suppressive"
	effect_desc = "When attacking an entity, it will shock them with a strong electric shock.  Repeated attacks can stun the target."
	difficulty = BLOB_DIFFICULTY_MEDIUM
	color = "#EFD65A"
	complementary_color = "#00E5B1"
	damage_type = BURN
	damage_lower = 5
	damage_upper = 10
	brute_multiplier = 0.5
	burn_multiplier = 0.5
	spread_modifier = 0.35
	ai_aggressiveness = 80
	attack_message = "The jelly prods you"
	attack_message_living = ", and your flesh burns as electricity arcs into you"
	attack_message_synth = ", and your internal circuity is overloaded as electricity arcs into you"
	attack_verb = "prods"

/datum/blob_type/energized_jelly/on_attack(obj/structure/blob/B, mob/living/victim, def_zone)
	victim.electrocute_act(10, src, 1, def_zone)
	victim.stun_effect_act(0, 40, BP_TORSO, src)


// A blob with area of effect attacks.
/datum/blob_type/explosive_lattice
	name = "explosive lattice"
	desc = "A very unstable lattice that looks quite explosive."
	ai_desc = "aggressive"
	effect_desc = "When attacking an entity, it will cause a small explosion, hitting things near the target. It is somewhat resilient, but weaker to brute damage."
	difficulty = BLOB_DIFFICULTY_MEDIUM
	color = "#8B2500"
	complementary_color = "#00668B"
	damage_type = BURN
	damage_lower = 25
	damage_upper = 35
	armor_check = "bomb"
	armor_pen = 5 // This is so blob hits still hurt just slightly when wearing a bomb suit (100 bomb resist).
	brute_multiplier = 0.75
	burn_multiplier = 0.5
	spread_modifier = 0.4
	ai_aggressiveness = 75
	attack_message = "The lattice blasts you"
	attack_message_living = ", and your flesh burns from the blast wave"
	attack_message_synth = ", and your plating burns from the blast wave"
	attack_verb = "blasts"
	var/exploding = FALSE

/datum/blob_type/explosive_lattice/on_attack(obj/structure/blob/B, mob/living/victim, def_zone) // This doesn't use actual bombs since they're too strong and it would hurt the blob.
	if(exploding) // We're busy, don't infinite loop us.
		return

	exploding = TRUE
	for(var/mob/living/L in range(get_turf(victim), 1)) // We don't use orange(), in case there is more than one mob on the target tile.
		if(L == victim) // Already hit.
			continue
		if(L.faction == "blob") // No friendly fire
			continue
		L.blob_act()

	// Visual effect.
	var/datum/effect/system/explosion/E = new/datum/effect/system/explosion/smokeless()
	var/turf/T = get_turf(victim)
	E.set_up(T)
	E.start()

	// Now for sounds.
	playsound(T, "explosion", 75, 1) // Local sound.

	for(var/mob/M in player_list) // For everyone else.
		if(M.z == T.z && get_dist(M, T) > world.view && !M.ear_deaf && !istype(M.loc,/turf/space))
			M << 'sound/effects/explosionfar.ogg'

	exploding = FALSE


// A blob that slips and drowns you.
/datum/blob_type/pressurized_slime
	name = "pressurized slime"
	desc = "A large mass that seems to leak slippery fluid everywhere."
	ai_desc = "drowning"
	effect_desc = "Wets the floor when expanding and when hit. Tries to drown its enemies when attacking. It forces itself past internals. Resistant to burn damage."
	difficulty = BLOB_DIFFICULTY_HARD
	color = "#AAAABB"
	complementary_color = "#BBBBAA"
	damage_type = OXY
	damage_lower = 5
	damage_upper = 15
	armor_check = null
	brute_multiplier = 0.6
	burn_multiplier = 0.2
	spread_modifier = 0.4
	ai_aggressiveness = 75
	attack_message = "The slime splashes into you"
	attack_message_living = ", and you gasp for breath"
	attack_message_synth = ", and the fluid wears down on your components"
	attack_verb = "splashes"

/datum/blob_type/pressurized_slime/on_attack(obj/structure/blob/B, mob/living/victim, def_zone)
	victim.water_act(5)
	var/turf/simulated/T = get_turf(victim)
	if(T)
		T.wet_floor()

/datum/blob_type/pressurized_slime/on_received_damage(var/obj/structure/blob/B, damage, damage_type)
	wet_surroundings(B, damage)
	return ..()

/datum/blob_type/pressurized_slime/on_pulse(var/obj/structure/blob/B)
	var/turf/simulated/T = get_turf(B)
	if(!istype(T))
		return
	T.wet_floor()

/datum/blob_type/pressurized_slime/on_death(obj/structure/blob/B)
	B.visible_message("<span class='danger'>The blob ruptures, spraying the area with liquid!</span>")
	wet_surroundings(B, 50)

/datum/blob_type/pressurized_slime/proc/wet_surroundings(var/obj/structure/blob/B, var/probability = 50)
	for(var/turf/simulated/T in range(1, B))
		if(prob(probability))
			T.wet_floor()
		for(var/atom/movable/AM in T)
			AM.water_act(2)


// A blob that irradiates everything.
/datum/blob_type/radioactive_ooze
	name = "radioactive ooze"
	desc = "A goopy mess that glows with an unhealthy aura."
	ai_desc = "radical"
	effect_desc = "Irradiates the surrounding area, and inflicts toxic attacks. Weak to brute damage."
	difficulty = BLOB_DIFFICULTY_MEDIUM
	color = "#33CC33"
	complementary_color = "#99FF66"
	damage_type = TOX
	damage_lower = 20
	damage_upper = 30
	armor_check = "rad"
	brute_multiplier = 0.75
	burn_multiplier = 0.2
	spread_modifier = 0.8
	ai_aggressiveness = 50
	attack_message = "The ooze splashes you"
	attack_message_living = ", and you feel warm"
	attack_message_synth = ", and your internal systems are bombarded by ionizing radiation"
	attack_verb = "splashes"

/datum/blob_type/radioactive_ooze/on_pulse(var/obj/structure/blob/B)
	SSradiation.radiate(B, 200)

/datum/blob_type/volatile_alluvium
	name = "volatile alluvium"
	desc = "A churning, earthy mass that moves in waves."
	ai_desc = "earthen"
	effect_desc = "Moves slowly, producing weak ranged spores to defend itself, and inflicts brute attacks. Attempts to disarm nearby attackers. Weak to water."
	difficulty = BLOB_DIFFICULTY_HARD //Slow-starting, but can be overwhelming if left alone.
	color = "#6B481E"
	complementary_color = "#7F471F"
	damage_lower = 10
	damage_upper = 20
	armor_pen = 40
	brute_multiplier = 0.7
	burn_multiplier = 0.5
	spread_modifier = 0.5
	ai_aggressiveness = 50
	attack_message = "The alluvium crashes against you"
	attack_verb = "crashes against"
	can_build_factories = TRUE
	can_build_resources = TRUE
	spore_type = /mob/living/simple_mob/blob/spore/weak
	ranged_spores = TRUE
	spore_range = 3
	spore_projectile = /obj/item/projectile/energy/blob/splattering
	factory_type = /obj/structure/blob/factory/sluggish
	resource_type = /obj/structure/blob/resource/sluggish

/datum/blob_type/volatile_alluvium/on_received_damage(var/obj/structure/blob/B, damage, damage_type, mob/living/attacker)
	if(damage > 0 && attacker && get_dist(B, attacker) <= 2 && prob(min(damage, 70)) && istype(attacker, /mob/living/carbon/human)) // Melee weapons of any type carried by a human will have a high chance of being stolen.
		var/mob/living/carbon/human/H = attacker
		var/obj/item/I = H.get_active_hand()
		H.drop_item()
		if(I)
			if((I.sharp || I.edge) && !istype(I, /obj/item/weapon/gun))
				I.forceMove(get_turf(B)) // Disarmed entirely.
				B.visible_message("<span class='danger'>The [name] heaves, \the [attacker]'s weapon becoming stuck in the churning mass!</span>")
			else
				I.throw_at(B, 2, 4) // Just yoinked.
				B.visible_message("<span class='danger'>The [name] heaves, pulling \the [attacker]'s weapon from their hands!</span>")
		B.blob_attack_animation(attacker, B.overmind)
	return ..()

/datum/blob_type/volatile_alluvium/on_water(obj/structure/blob/B, amount)
	spawn(1)
		var/damage = amount * 2
		B.adjust_integrity(-(damage))
		if(B && prob(damage))
			B.visible_message("<span class='danger'>The [name] begins to crumble!</span>")
