/**
 * Stuff having to do with inter-round persistence. 
 */

// Minds represent IC characters.
// Therefore it is the MIND we actually want to track here to find out
// what "character" a mob is.
// However right now minds don't keep track of what save file & slot they came from.
// So that is what we need to add!  Whenever a mind is initialized from a save file slot,
// we record that so we can save it back when persisting!

/datum/mind
	var/loaded_from_ckey = null
	var/loaded_from_slot = null

// Handle people leaving due to round ending.
/hook/roundend/proc/persist_locations()
	for(var/mob/Player in human_mob_list)
		if(!Player.mind || isnewplayer(Player))
			continue // No mind we can do nothing, new players we care not for
		else if(Player.stat == DEAD)
			if(istype(Player,/mob/observer/dead))
				var/mob/observer/dead/O = Player
				if(O.started_as_observer)
					continue // They are just a pure observer, ignore
			// Died and were not cloned - Respawn at centcomm
			persist_interround_data(Player, using_map.spawnpoint_died)
		else
			var/turf/playerTurf = get_turf(Player)
			if(isAdminLevel(playerTurf.z))
				// Evac'd - Next round they arrive on the shuttle.
				persist_interround_data(Player, using_map.spawnpoint_left)
			else
				// Stayed on station, go to dorms
				persist_interround_data(Player, using_map.spawnpoint_stayed)
	return 1

/**
 * Prep for save: returns a preferences object if we're ready and allowed to save this mob.
 */
/proc/prep_for_persist(var/mob/persister)
	if(!istype(persister))
		crash_with("Persist (P4P): Given non-mob [persister].")
		return

	// Find out of this mob is a proper mob!
	if (persister.mind && persister.mind.loaded_from_ckey)
		// Okay this mob has a real loaded-from-savefile mind in it!
		var/datum/preferences/prefs = preferences_datums[persister.mind.loaded_from_ckey]
		if(!prefs)
			WARNING("Persist (P4P): [persister.mind] was loaded from ckey [persister.mind.loaded_from_ckey] but no prefs datum found.")
			return

		// Okay, lets do a few checks to see if we should really save tho!
		if(!prefs.load_character(persister.mind.loaded_from_slot))
			WARNING("Persist (P4P): [persister.mind] was loaded from slot [persister.mind.loaded_from_slot] but loading prefs failed.")
			return // Failed to load character

		// For now as a safety measure we will only save if the name matches.
		if(prefs.real_name != persister.real_name)
			log_debug("Persist (P4P): Skipping [persister] because ORIG:[persister.real_name] != CURR:[prefs.real_name].")
			return

		return prefs

/**
 * Called when mob despawns early (via cryopod)!
 */
/hook/despawn/proc/persist_despawned_mob(var/mob/occupant, var/obj/machinery/cryopod/pod)
	ASSERT(istype(pod))
	ASSERT(ispath(pod.spawnpoint_type, /datum/spawnpoint))
	persist_interround_data(occupant, pod.spawnpoint_type)
	return 1

/proc/persist_interround_data(var/mob/occupant, var/datum/spawnpoint/new_spawn_point_type)
	if(!istype(occupant))
		crash_with("Persist (PID): Given non-mob [occupant].")
		return

	var/datum/preferences/prefs = prep_for_persist(occupant)
	if(!prefs)
		WARNING("Persist (PID): Skipping [occupant] for persisting, as they have no prefs.")
		return

	//This one doesn't rely on persistence prefs
	if(ishuman(occupant) && occupant.stat != DEAD)
		persist_nif_data(occupant, prefs)

	if(!prefs.persistence_settings)
		return // Persistence disabled by preference settings

	// Okay we can start saving the data
	if(new_spawn_point_type && prefs.persistence_settings & PERSIST_SPAWN)
		prefs.spawnpoint = initial(new_spawn_point_type.display_name)
	if(ishuman(occupant) && occupant.stat != DEAD)
		var/mob/living/carbon/human/H = occupant
		testing("Persist (PID): Saving stuff from [H] to [prefs] (\ref[prefs]).")
		if(prefs.persistence_settings & PERSIST_ORGANS)
			apply_organs_to_prefs(H, prefs)
		if(prefs.persistence_settings & PERSIST_MARKINGS)
			apply_markings_to_prefs(H, prefs)
		if(prefs.persistence_settings & PERSIST_WEIGHT)
			resolve_excess_nutrition(H)
			prefs.weight_vr = H.weight
		if(prefs.persistence_settings & PERSIST_SIZE)
			prefs.size_multiplier = H.size_multiplier

	prefs.save_character()

// Saves mob's current coloration state to prefs
// This basically needs to be the reverse of /datum/category_item/player_setup_item/general/body/copy_to_mob() ~Leshana
/proc/apply_coloration_to_prefs(var/mob/living/carbon/human/character, var/datum/preferences/prefs)
	if(!istype(character)) return
	prefs.r_eyes	= character.r_eyes
	prefs.g_eyes	= character.g_eyes
	prefs.b_eyes	= character.b_eyes
	prefs.h_style	= character.h_style
	prefs.r_hair	= character.r_hair
	prefs.g_hair	= character.g_hair
	prefs.b_hair	= character.b_hair
	prefs.f_style	= character.f_style
	prefs.r_facial	= character.r_facial
	prefs.g_facial	= character.g_facial
	prefs.b_facial	= character.b_facial
	prefs.r_skin	= character.r_skin
	prefs.g_skin	= character.g_skin
	prefs.b_skin	= character.b_skin
	prefs.s_tone	= character.s_tone
	prefs.h_style	= character.h_style
	prefs.f_style	= character.f_style
	prefs.b_type	= character.b_type

// Saves mob's current custom species, ears, and tail state to prefs
// This basically needs to be the reverse of /datum/category_item/player_setup_item/vore/ears/copy_to_mob() ~Leshana
/proc/apply_ears_to_prefs(var/mob/living/carbon/human/character, var/datum/preferences/prefs)
	if(character.ear_style) prefs.ear_style = character.ear_style.type
	if(character.tail_style) prefs.tail_style = character.tail_style.type
	prefs.r_tail			= character.r_tail
	prefs.b_tail			= character.b_tail
	prefs.g_tail			= character.g_tail
	prefs.custom_species	= character.custom_species

// Saves mob's current organ state to prefs.
// This basically needs to be the reverse of /datum/category_item/player_setup_item/general/body/copy_to_mob() ~Leshana
/proc/apply_organs_to_prefs(var/mob/living/carbon/human/character, var/datum/preferences/prefs)
	if(!istype(character) || !character.species) return
	// Checkify the limbs!
	for(var/name in character.species.has_limbs)
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O)
			prefs.organ_data[name] = "amputated"
		else if(O.robotic >= ORGAN_ROBOT)
			prefs.organ_data[name] = "cyborg"
			if(O.model)
				prefs.rlimb_data[name] = O.model
			else
				prefs.rlimb_data.Remove(name) // Missing rlimb_data entry means default model
		else
			prefs.organ_data.Remove(name) // Misisng organ_data entry means normal

	// Internal organs also
	for(var/name in character.species.has_organ)
		var/obj/item/organ/I = character.internal_organs_by_name[name]
		if(I)
			if(istype(I, /obj/item/organ/internal/mmi_holder/robot))
				prefs.organ_data[name] = "digital" // Need a better way to detect this special type
			else if(I.robotic == ORGAN_ASSISTED)
				prefs.organ_data[name] = "assisted"
			else if(I.robotic >= ORGAN_ROBOT)
				prefs.organ_data[name] = "mechanical"
			else
				prefs.organ_data.Remove(name) // Missing organ_data entry means normal

// Saves mob's current body markings state to prefs.
// This basically needs to be the reverse of /datum/category_item/player_setup_item/general/body/copy_to_mob() ~Leshana
/proc/apply_markings_to_prefs(var/mob/living/carbon/human/character, var/datum/preferences/prefs)
	if(!istype(character)) return
	var/list/new_body_markings = list()
	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		if(!O) continue // Skip missing limbs!

		for(var/name in O.markings)
			// Expected to be list("color" = mark_color, "datum" = mark_datum). Sanity checks to ensure it.
			var/list/ML = O.markings[name]
			var/datum/sprite_accessory/marking/mark_datum = ML["datum"]
			var/mark_color = ML["color"]
			if(!istype(mark_datum) || !mark_color)
				log_debug("[character]'s organ [O] ([O.type]) has marking [list2params(ML)] with invalid/missing color/datum!")
				continue;
			if(!(mark_datum.name in body_marking_styles_list))
				log_debug("[character]'s organ [O] ([O.type]) has marking [mark_datum] which is not in body_marking_styles_list!")
				continue;
			// Note: Since datums can cover multiple organs, we may encounter it multiple times, but this is okay
			// because you're only allowed to have each marking type once! If this assumption changes, obviously update this. ~Leshana
			new_body_markings[mark_datum.name] = mark_color
	prefs.body_markings = new_body_markings // Overwrite with new list!

/**
* Resolve any surplus/deficit in nutrition's effet on weight all at once.
* Normally this would slowly apply during the round; once we get to the end
* we need to apply it all at once.
*/
/proc/resolve_excess_nutrition(var/mob/living/carbon/C)
	if(C.stat == DEAD)
		return // You don't metabolize if dead
	if(!C.metabolism || !C.species || !C.species.hunger_factor)
		return // You don't metabolize if you have no metabolism or your species doesn't eat!
	// Each Life() tick, you gain/lose weight proportional to your metabolism, and lose species.hunger_factor nutrition
	var/weight_per_nutrition = C.metabolism / C.species.hunger_factor

	if(C.nutrition > MIN_NUTRITION_TO_GAIN && C.weight < MAX_MOB_WEIGHT && C.weight_gain)
		// Weight Gain!
		var/gain = (C.nutrition - MIN_NUTRITION_TO_GAIN) * weight_per_nutrition * C.weight_gain/100
		C.weight = min(MAX_MOB_WEIGHT, C.weight + gain)
	else if(C.nutrition <= MAX_NUTRITION_TO_LOSE && C.weight > MIN_MOB_WEIGHT && C.weight_loss)
		// Weight Loss!
		var/loss = (MAX_NUTRITION_TO_LOSE - C.nutrition) * weight_per_nutrition * C.weight_loss/100
		C.weight = max(MIN_MOB_WEIGHT, C.weight - loss)

/**
* Persist any NIF data that needs to be persisted. It's stored in a list to make it more malleable
* towards future shenanigans such as upgradable NIFs or different types or things of that nature,
* without invoking the need for a bunch of different save file variables.
*/
/proc/persist_nif_data(var/mob/living/carbon/human/H,var/datum/preferences/prefs)
	if(!istype(H))
		crash_with("Persist (NIF): Given a nonhuman: [H]")
		return

	if(!prefs)
		prefs = prep_for_persist(H)

	if(!prefs)
		WARNING("Persist (NIF): [H] has no prefs datum, skipping")
		return

	var/obj/item/device/nif/nif = H.nif

	//If they have one, and if it's not installing without an owner, because
	//Someone who joins and immediately leaves again (wrong job choice, maybe)
	//should keep it even though it was probably doing the quick-calibrate, and their
	//owner will have been pre-set during the constructor.
	if(nif && !(nif.stat == NIF_INSTALLING && !nif.owner))
		prefs.nif_path = nif.type
		prefs.nif_durability = nif.durability
		prefs.nif_savedata = nif.save_data.Copy()
	else
		prefs.nif_path = null
		prefs.nif_durability = null
		prefs.nif_savedata = null

	var/datum/category_group/player_setup_category/vore_cat = prefs.player_setup.categories_by_name["VORE"]
	var/datum/category_item/player_setup_item/vore/nif/nif_prefs = vore_cat.items_by_name["NIF Data"]

	var/savefile/S = new /savefile(prefs.path)
	if(!S) WARNING ("Persist (NIF): Couldn't load NIF save savefile? [prefs.real_name]")
	S.cd = "/character[prefs.default_slot]"
	nif_prefs.save_character(S)
