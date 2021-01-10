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

	var/faction = "blob"				// The blob's faction.

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
	var/spore_accuracy = 0	// Projectile accuracy
	var/spore_dispersion = 0	// Dispersion.

	var/factory_type = /obj/structure/blob/factory
	var/resource_type = /obj/structure/blob/resource
	var/node_type = /obj/structure/blob/node
	var/shield_type = /obj/structure/blob/shield

	var/list/core_tech = list(TECH_BIO = 4, TECH_MATERIAL = 3)	// Tech for the item created when a core is destroyed.
	var/chunk_active_type = BLOB_CHUNK_TOGGLE
	var/chunk_active_ability_cooldown = 20 SECONDS
	var/chunk_passive_ability_cooldown = 5 SECONDS

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

// Called when the core processes.
/datum/blob_type/proc/on_core_process(var/obj/structure/blob/B)
	return

// Called when a node processes.
/datum/blob_type/proc/on_node_process(var/obj/structure/blob/B)
	return

// Called when hit by EMP.
/datum/blob_type/proc/on_emp(obj/structure/blob/B, severity)
	return

// Called when hit by water.
/datum/blob_type/proc/on_water(obj/structure/blob/B, amount)
	return

// Spore death
/datum/blob_type/proc/on_spore_death(mob/living/simple_mob/blob/spore/S)
	return

// Spore handle_special call.
/datum/blob_type/proc/on_spore_lifetick(mob/living/simple_mob/blob/spore/S)
	return

// Blob core chunk process.
/datum/blob_type/proc/on_chunk_tick(obj/item/weapon/blobcore_chunk/B)
	return

// Blob core chunk use in-hand.
/datum/blob_type/proc/on_chunk_use(obj/item/weapon/blobcore_chunk/B, mob/user)
	return

// Proc that is unique to the blob type.
/datum/blob_type/proc/chunk_unique(obj/item/weapon/blobcore_chunk/B, var/list/extra_args = null)
	return

// Set up the blob type for the chunk.
/datum/blob_type/proc/chunk_setup(obj/item/weapon/blobcore_chunk/B)
	return
