// Base
/obj/item/slime_extract
	name = "slime extract"
	desc = "Goo extracted from a slime, which can do different things depending on its color and what it is injected with."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey slime extract"
	force = 1
	w_class = ITEMSIZE_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6
	origin_tech = list(TECH_BIO = 4)
	var/uses = 1 // uses before it goes inert
	var/enhanced = FALSE
	var/slime_type
	flags = OPENCONTAINER


/obj/item/slime_extract/Initialize()
	. = ..()
	create_reagents(60)

/obj/item/slime_extract/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/slimepotion/enhancer))
		if(enhanced)
			to_chat(user, "<span class='warning'>You cannot enhance this extract further!</span>")
			return ..()
		to_chat(user, "<span class='notice'>You apply the enhancer to the slime extract. It may now be reused one more time.</span>")
		playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
		uses += 2
		enhanced = TRUE
		name = initial(name) // To remove the 'inert' part of the name.
		qdel(O)
	else if(istype(O, /obj/item/slimepotion/reinvigoration))
		to_chat(user, "<span class='notice'>You apply the reinvigorator to the slime extract. It rapidly expands, creating a brand new slime!</span>")
		playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
		new slime_type(get_turf(src))
		qdel(O)
		qdel(src)
	..()

/obj/item/slime_extract/examine(mob/user)
	. = ..()
	if(uses)
		. += "This extract has [uses] more use\s."
	else
		. += "This extract is inert."

/decl/chemical_reaction/instant/slime
	var/required = null

/decl/chemical_reaction/instant/slime/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, required))
		var/obj/item/slime_extract/T = holder.my_atom
		if(T.uses > 0)
			return ..()
	return FALSE

/decl/chemical_reaction/instant/slime/on_reaction(var/datum/reagents/holder)
	var/obj/item/slime_extract/T = holder.my_atom
	T.uses--
	if(T.uses <= 0)
		T.visible_message("\icon[T][bicon(T)]<b>\The [T]</b> goes inert.")
		T.name = "inert [initial(T.name)]"


// ***************
// * Grey slimes *
// ***************

/obj/item/slime_extract/grey
	name = "grey slime extract"
	icon_state = "grey slime extract"
	description_info = "When injected with phoron, this extract creates a grey slime. When injected with blood, this extract creates some monkey cubes. \
	When injected with water, this extract creates some slime jelly."
	slime_type = /mob/living/simple_mob/slime/xenobio


/decl/chemical_reaction/instant/slime/grey_new_slime
	name = "Slime Spawn"
	id = "m_grey_spawn"
	result = null
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/decl/chemical_reaction/instant/slime/grey_new_slime/on_reaction(var/datum/reagents/holder)
	holder.my_atom.visible_message("<span class='warning'>Infused with phoron, the core begins to quiver and grow, and soon a new baby slime emerges from it!</span>")
	new /mob/living/simple_mob/slime/xenobio(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/grey_monkey
	name = "Slime Monkey"
	id = "m_grey_monkey"
	result = null
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/decl/chemical_reaction/instant/slime/grey_monkey/on_reaction(var/datum/reagents/holder)
	for(var/i = 1 to 4)
		new /obj/item/reagent_containers/food/snacks/monkeycube(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/grey_slimejelly
	name = "Slime Jelly"
	id = "m_grey_jelly"
	result = "slimejelly"
	required_reagents = list("water" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/grey

// ****************
// * Metal slimes *
// ****************

/obj/item/slime_extract/metal
	name = "metal slime extract"
	icon_state = "metal slime extract"
	description_info = "When injected with phoron, this extract creates some basic construction materials. When injected with blood, this extract creates some advanced construction materials. \
	When injected with water, this extract creates some unorthodox materials. When injected with slime jelly, this extract creates some steel."
	slime_type = /mob/living/simple_mob/slime/xenobio/metal


/decl/chemical_reaction/instant/slime/metal_materials_basic
	name = "Slime Basic Construction Materials"
	id = "m_metal_basic"
	result = null
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/metal

/decl/chemical_reaction/instant/slime/metal_materials_basic/on_reaction(var/datum/reagents/holder)
	for(var/i = 1 to 3)
		var/type_to_spawn = pickweight(xenobio_metal_materials_normal)
		new type_to_spawn(get_turf(holder.my_atom), 10)
	..()


/decl/chemical_reaction/instant/slime/metal_materials_adv
	name = "Slime Advanced Construction Materials"
	id = "m_metal_adv"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/metal

/decl/chemical_reaction/instant/slime/metal_materials_adv/on_reaction(var/datum/reagents/holder)
	for(var/i = 1 to 2)
		var/type_to_spawn = pickweight(xenobio_metal_materials_adv)
		new type_to_spawn(get_turf(holder.my_atom), 10)
	..()


/decl/chemical_reaction/instant/slime/metal_materials_weird
	name = "Slime Weird Construction Materials"
	id = "m_metal_weird"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/metal

/decl/chemical_reaction/instant/slime/metal_materials_weird/on_reaction(var/datum/reagents/holder)
	for(var/i = 1 to 3)
		var/type_to_spawn = pickweight(xenobio_metal_materials_weird)
		new type_to_spawn(get_turf(holder.my_atom), 5)
	..()


/decl/chemical_reaction/instant/slime/metal_materials_steel
	name = "Slime Weird Construction Materials"
	id = "m_metal_steel"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/metal

/decl/chemical_reaction/instant/slime/metal_materials_steel/on_reaction(var/datum/reagents/holder)
	new /obj/item/stack/material/steel(get_turf(holder.my_atom), 25)
	..()

// ***************
// * Blue slimes *
// ***************

/obj/item/slime_extract/blue
	name = "blue slime extract"
	icon_state = "blue slime extract"
	description_info = "When injected with phoron, this extract creates some frost oil. When injected with blood, this extract creates stability agent that can reduce slime's mutation chance. \
	When injected with water, this extract creates a clamness wave that calms enraged slimes. When injected with slime jelly, this extract creates some cryotoxin."
	slime_type = /mob/living/simple_mob/slime/xenobio/blue


/decl/chemical_reaction/instant/slime/blue_frostoil
	name = "Slime Frost Oil"
	id = "m_blue_frostoil"
	result = "frostoil"
	required_reagents = list("phoron" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/blue


/decl/chemical_reaction/instant/slime/blue_stability
	name = "Slime Stability"
	id = "m_blue_stability"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/blue

/decl/chemical_reaction/instant/slime/blue_stability/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/stabilizer(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/blue_calm
	name = "Slime Calm"
	id = "m_blue_calm"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/blue

/decl/chemical_reaction/instant/slime/blue_calm/on_reaction(var/datum/reagents/holder)
	for(var/mob/living/simple_mob/slime/S in view(get_turf(holder.my_atom)))
		if(S.stat)
			continue

		if(istype(S, /mob/living/simple_mob/slime/xenobio))
			var/mob/living/simple_mob/slime/xenobio/X = S
			if(X.harmless)
				continue
			if(!X.client)
				X.relax()

		S.remove_modifiers_of_type(/datum/modifier/berserk)

		if(S.client) // Player slimes always have free will.
			to_chat(S, "<span class='warning'>An intense wave of relaxing calm is felt from inside, but you remain in control of yourself.</span>")

	for(var/mob/living/carbon/human/H in view(get_turf(holder.my_atom)))
		if(H.species.name == SPECIES_PROMETHEAN)
			H.remove_modifiers_of_type(/datum/modifier/berserk)
			to_chat(H, "<span class='warning'>An intense wave of relaxing calm is felt from inside, but you remain in control of yourself.</span>")

	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 75, 1)
	..()


/decl/chemical_reaction/instant/slime/blue_cryotoxin
	name = "Slime Cryotoxin"
	id = "m_blue_cryotoxin"
	result = "cryotoxin"
	required_reagents = list("slimejelly" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/blue

// *****************
// * Purple slimes *
// *****************

/obj/item/slime_extract/purple
	name = "purple slime extract"
	icon_state = "purple slime extract"
	description_info = "When injected with phoron, this extract creates steroid agent, which can be used to increase amount of extracts in a slime. When injected with blood, this extract creates \
	infertility agent, which can be used to decrease amount of slime's offspring. When injected with water, this extract creates shrink agent, which can be used to turn an adult slime into a baby. \
	When injected with slime jelly, this extract creates a fertility agent, which can be used to increase amount of slime's offspring."
	slime_type = /mob/living/simple_mob/slime/xenobio/purple


/decl/chemical_reaction/instant/slime/purple_steroid
	name = "Slime Steroid"
	id = "m_purple_steroid"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/purple

/decl/chemical_reaction/instant/slime/purple_steroid/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/steroid(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/purple_infertility
	name = "Slime Infetility"
	id = "m_purple_infertility"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/purple

/decl/chemical_reaction/instant/slime/purple_infertility/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/infertility(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/purple_shrink
	name = "Slime Shrink"
	id = "m_purple_shrink"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/purple

/decl/chemical_reaction/instant/slime/purple_shrink/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/shrink(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/purple_fertility
	name = "Slime Fetility"
	id = "m_purple_fertility"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/purple

/decl/chemical_reaction/instant/slime/purple_fertility/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/fertility(get_turf(holder.my_atom))
	..()

// *****************
// * Orange slimes *
// *****************

/obj/item/slime_extract/orange
	name = "orange slime extract"
	icon_state = "orange slime extract"
	description_info = "When injected with phoron, this extract creates a phoron fire. When injected with blood, this extract creates a heat wave. When injected with water, this extract creates \
	some smoke. When injected with slime jelly, this extract creates some pyrotoxin."
	slime_type = /mob/living/simple_mob/slime/xenobio/orange


/decl/chemical_reaction/instant/slime/orange_fire
	name = "Slime Fire"
	id = "m_orange_fire"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/orange

/decl/chemical_reaction/instant/slime/orange_fire/on_reaction(var/datum/reagents/holder)
	log_and_message_admins("Orange extract reaction (fire) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")
	holder.my_atom.visible_message("<span class='danger'>\The [src] begins to vibrate violently!</span>")
	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 75, 1)
	spawn(5 SECONDS)
		if(holder && holder.my_atom)
			var/turf/simulated/T = get_turf(holder.my_atom)
			if(!istype(T))
				return

			for(var/turf/simulated/target_turf in view(2, T))
				target_turf.assume_gas("volatile_fuel", 33, 1500+T0C)
				target_turf.assume_gas("oxygen", 66, 1500+T0C)
				spawn(0)
					target_turf.hotspot_expose(1500+T0C, 400)

			playsound(T, 'sound/effects/phasein.ogg', 75, 1)
	..()


/decl/chemical_reaction/instant/slime/orange_heatwave
	name = "Slime Heat Wave"
	id = "m_orange_heatwave"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/orange

/decl/chemical_reaction/instant/slime/orange_heatwave/on_reaction(var/datum/reagents/holder)
	var/turf/simulated/T = get_turf(holder.my_atom)
	if(!T) // Nullspace lacks zones.
		return

	if(!istype(T))
		return

	var/zone/Z = T.zone
	if(!Z) // Paranoid.
		return

	log_and_message_admins("Orange extract reaction (heat wave) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")

	var/list/nearby_things = view(T)

	// Hurt mobs.
	for(var/mob/living/L in nearby_things)
		var/turf/simulated/their_turf = get_turf(L)
		if(!istype(their_turf)) // Not simulated.
			continue

		if(!(their_turf in Z.contents)) // Not in the same zone.
			continue

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/protection = H.get_heat_protection()

			if(protection < 1)
				var/cold_factor = abs(protection - 1)
				H.bodytemperature = between(50, (H.bodytemperature - ((H.bodytemperature + 50) * cold_factor) ), H.bodytemperature)

			if(protection < 0.7)
				to_chat(L, "<span class='danger'>A scalding wave of heat overwhelms you!</span>")
			else
				to_chat(L, "<span class='warning'>A scalding wave of heat passes by you, as your armor protects you from it.</span>")
			continue

	// Now make it very cold.
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		// This is most likely physically impossible but when has that stopped slimes before?
		env.add_thermal_energy(15 * 1000 * 1000)

	playsound(T, 'sound/effects/phasein.ogg', 75, 1)
	..()


/decl/chemical_reaction/instant/slime/orange_smoke
	name = "Slime Smoke"
	id = "m_orange_smoke"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/orange

/decl/chemical_reaction/instant/slime/orange_smoke/on_reaction(var/datum/reagents/holder)
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/smoke_spread/chem/S = new /datum/effect_system/smoke_spread/chem
	S.attach(location)
	S.set_up(holder, 120, 0, location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		S.start()
	..()


/decl/chemical_reaction/instant/slime/orange_pyrotoxin
	name = "Slime Pyrotoxin"
	id = "m_orange_pyrotoxin"
	result = "thermite_v"
	required_reagents = list("slimejelly" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/orange

// *****************
// * Yellow slimes *
// *****************

/obj/item/slime_extract/yellow
	name = "yellow slime extract"
	icon_state = "yellow slime extract"
	description_info = "When injected with phoron, this extract creates a lightning strike. When injected with blood, this extract creates a slime flashlight. When injected with water \
	this extract creates an EMP puls. When injected with slime jelly, this extract creates a self-charging slime battery."
	slime_type = /mob/living/simple_mob/slime/xenobio/yellow


/decl/chemical_reaction/instant/slime/yellow_lightning
	name = "Slime Lightning"
	id = "m_yellow_lightning"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/yellow

/decl/chemical_reaction/instant/slime/yellow_lightning/on_reaction(var/datum/reagents/holder)
	log_and_message_admins("Yellow extract reaction (lightning) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")
	holder.my_atom.visible_message("<span class='danger'>\The [src] begins to vibrate violently!</span>")
	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 75, 1)
	spawn(5 SECONDS)
		if(holder && holder.my_atom)
			lightning_strike(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/yellow_flashlight
	name = "Slime Flashlight"
	id = "m_yellow_flashlight"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/yellow

/decl/chemical_reaction/instant/slime/yellow_flashlight/on_reaction(var/datum/reagents/holder)
	new /obj/item/flashlight/slime(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/yellow_emp
	name = "Slime EMP"
	id = "m_yellow_emp"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/yellow

/decl/chemical_reaction/instant/slime/yellow_emp/on_reaction(var/datum/reagents/holder)
	log_and_message_admins("Yellow extract reaction (emp) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")
	holder.my_atom.visible_message("<span class='danger'>\The [src] begins to vibrate violently!</span>")
	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 75, 1)
	spawn(5 SECONDS)
		if(holder && holder.my_atom)
			empulse(get_turf(holder.my_atom), 2, 4, 7, 10) // As strong as a normal EMP grenade.
			playsound(holder.my_atom, 'sound/effects/phasein.ogg', 75, 1)
	..()


/decl/chemical_reaction/instant/slime/yellow_battery
	name = "Slime Cell"
	id = "m_yellow_cell"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/yellow

/decl/chemical_reaction/instant/slime/yellow_battery/on_reaction(var/datum/reagents/holder)
	new /obj/item/cell/slime(get_turf(holder.my_atom))
	..()

// ***************
// * Gold slimes *
// ***************

/obj/item/slime_extract/gold
	name = "gold slime extract"
	icon_state = "gold slime extract"
	description_info = "When injected with phoron, this extract creates a few random creatures. When injected with blood, this extract a random hostile creature. \
	When injected with water, this extract creates a random passive creature. When injected with slime jelly, this extract creates some gold."
	slime_type = /mob/living/simple_mob/slime/xenobio/gold


/decl/chemical_reaction/instant/slime/gold_random_mobs
	name = "Slime Random Mobs"
	id = "m_gold_random_mobs"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/gold

/decl/chemical_reaction/instant/slime/gold_random_mobs/on_reaction(var/datum/reagents/holder)
	log_and_message_admins("Gold extract reaction (random mobs) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")
	var/type_to_spawn
	var/list/all_spawnable_types = list()
	all_spawnable_types += xenobio_gold_mobs_safe
	all_spawnable_types += xenobio_gold_mobs_hostile
	all_spawnable_types += xenobio_gold_mobs_birds
	for(var/j = 1, j <= 3, j++)
		if(prob(1))
			type_to_spawn = pickweight(xenobio_gold_mobs_bosses)
		else
			type_to_spawn = pickweight(all_spawnable_types)

		var/mob/living/C = new type_to_spawn(get_turf(holder.my_atom))
		for(var/l = 1, l <= rand(1, 3), l++)
			step(C, pick(NORTH,SOUTH,EAST,WEST))
	..()


/decl/chemical_reaction/instant/slime/gold_hostile_mob
	name = "Slime Hostile Mob"
	id = "m_gold_hostile_mob"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/gold

/decl/chemical_reaction/instant/slime/gold_hostile_mob/on_reaction(var/datum/reagents/holder)
	log_and_message_admins("Gold extract reaction (dangerous mob) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")
	var/type_to_spawn = pickweight(xenobio_gold_mobs_hostile)
	var/mob/living/C = new type_to_spawn(get_turf(holder.my_atom))
	for(var/l = 1, l <= rand(1, 3), l++)
		step(C, pick(NORTH,SOUTH,EAST,WEST))
	..()


/decl/chemical_reaction/instant/slime/gold_safe_mob
	name = "Slime Safe Mob"
	id = "m_gold_safe_mob"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/gold

/decl/chemical_reaction/instant/slime/gold_safe_mob/on_reaction(var/datum/reagents/holder)
	var/type_to_spawn
	if(prob(100/(xenobio_gold_mobs_safe.len + 1)))
		type_to_spawn = pickweight(xenobio_gold_mobs_birds)
	else
		type_to_spawn = pickweight(xenobio_gold_mobs_safe)
	var/mob/living/C = new type_to_spawn(get_turf(holder.my_atom))
	for(var/l = 1, l <= rand(1, 3), l++)
		step(C, pick(NORTH,SOUTH,EAST,WEST))
	..()


/decl/chemical_reaction/instant/slime/gold_materials_gold
	name = "Slime Gold"
	id = "m_gold_gold"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/gold

/decl/chemical_reaction/instant/slime/gold_materials_gold/on_reaction(var/datum/reagents/holder)
	new /obj/item/stack/material/gold(get_turf(holder.my_atom), 10)
	..()

// *****************
// * Silver slimes *
// *****************

/obj/item/slime_extract/silver
	name = "silver slime extract"
	icon_state = "silver slime extract"
	description_info = "When injected with phoron, this extract creates some basic science materials. When injected with blood, this extract creates some advanced science materials. When injected \
	with water, this extract creates some completely random materials. When injected with slime jelly, this extract creates some silver."
	slime_type = /mob/living/simple_mob/slime/xenobio/silver


/decl/chemical_reaction/instant/slime/silver_materials_basic
	name = "Slime Basic Science Materials"
	id = "m_silver_basic"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/silver

/decl/chemical_reaction/instant/slime/silver_materials_basic/on_reaction(var/datum/reagents/holder)
	for(var/i = 1 to 2)
		var/type_to_spawn = pickweight(xenobio_silver_materials_basic)
		new type_to_spawn(get_turf(holder.my_atom), 5)
	..()


/decl/chemical_reaction/instant/slime/silver_materials_adv
	name = "Slime Advanced Science Materials"
	id = "m_silver_adv"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/silver

/decl/chemical_reaction/instant/slime/silver_materials_adv/on_reaction(var/datum/reagents/holder)
	var/type_to_spawn = pickweight(xenobio_silver_materials_adv)
	new type_to_spawn(get_turf(holder.my_atom), 3)
	..()


/decl/chemical_reaction/instant/slime/silver_materials_random
	name = "Slime Random Materials"
	id = "m_silver_random"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/silver

/decl/chemical_reaction/instant/slime/silver_materials_random/on_reaction(var/datum/reagents/holder)
	var/type_to_spawn
	var/amount = 5
	var/all_spawnable_types = list()
	all_spawnable_types += xenobio_metal_materials_normal
	all_spawnable_types += xenobio_metal_materials_adv
	all_spawnable_types += xenobio_metal_materials_weird
	all_spawnable_types += xenobio_silver_materials_basic
	all_spawnable_types += xenobio_silver_materials_adv
	all_spawnable_types += xenobio_silver_materials_special
	for(var/i = 1 to 3)
		type_to_spawn = pickweight(all_spawnable_types)
		if(type_to_spawn in xenobio_silver_materials_special)
			amount = 1
		new type_to_spawn(get_turf(holder.my_atom), amount)
	..()


/decl/chemical_reaction/instant/slime/silver_materials_silver
	name = "Slime Silver"
	id = "m_silver_silver"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/silver

/decl/chemical_reaction/instant/slime/silver_materials_silver/on_reaction(var/datum/reagents/holder)
	new /obj/item/stack/material/silver(get_turf(holder.my_atom), 10)
	..()

// **********************
// * Dark Purple slimes *
// **********************

/obj/item/slime_extract/dark_purple
	name = "dark purple slime extract"
	icon_state = "dark purple slime extract"
	description_info = "When injected with water, this extract creates some phoron. When injected with slime jelly, this extract creates some blood."
	slime_type = /mob/living/simple_mob/slime/xenobio/dark_purple


/decl/chemical_reaction/instant/slime/dark_purple_phoron
	name = "Slime Phoron"
	id = "m_darkpurple_phoron"
	result = "phoron"
	required_reagents = list("water" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/dark_purple


/decl/chemical_reaction/instant/slime/dark_purple_blood
	name = "Slime Blood"
	id = "m_darkpurple_blood"
	result = "blood"
	required_reagents = list("slimejelly" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/dark_purple

// ********************
// * Dark Blue slimes *
// ********************

/obj/item/slime_extract/dark_blue
	name = "dark blue slime extract"
	icon_state = "dark blue slime extract"
	description_info = "When injected with phoron, this extract creates a cold wave. When injected with blood, this extract grants ability to resist temperature for a while. \
	When injected with water, the water freezes. When injected with slime jelly, this extract creates a death agent, which can be used to instantly kill a slime."
	slime_type = /mob/living/simple_mob/slime/xenobio/dark_blue


/decl/chemical_reaction/instant/slime/dark_blue_cold_snap
	name = "Slime Cold Snap"
	id = "m_darkblue_coldsnap"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/dark_blue

// This iterates over a ZAS zone's contents, so that things seperated in other zones aren't subjected to the temperature drop.
/decl/chemical_reaction/instant/slime/dark_blue_cold_snap/on_reaction(var/datum/reagents/holder)
	var/turf/simulated/T = get_turf(holder.my_atom)
	if(!T) // Nullspace lacks zones.
		return

	if(!istype(T))
		return

	var/zone/Z = T.zone
	if(!Z) // Paranoid.
		return

	log_and_message_admins("Dark Blue extract reaction (cold snap) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")

	var/list/nearby_things = view(T)

	// Hurt mobs.
	for(var/mob/living/L in nearby_things)
		var/turf/simulated/their_turf = get_turf(L)
		if(!istype(their_turf)) // Not simulated.
			continue

		if(!(their_turf in Z.contents)) // Not in the same zone.
			continue

		if(istype(L, /mob/living/simple_mob/slime))
			var/mob/living/simple_mob/slime/S = L
			if(S.cold_resist >= 1) // Immune to cold.
				to_chat(S, "<span class='warning'>A chill is felt around you, however it cannot harm you.</span>")
				continue
			if(S.client) // Don't instantly kill player slimes.
				to_chat(S, "<span class='danger'>You feel your body crystalize as an intense chill overwhelms you!</span>")
				S.inflict_cold_damage(100)
			else
				S.inflict_cold_damage(200) // Metal slimes can survive this 'slime nuke'.
			continue

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/protection = H.get_cold_protection()

			if(protection < 1)
				var/cold_factor = abs(protection - 1)
				H.bodytemperature = between(50, (H.bodytemperature - ((H.bodytemperature - 50) * cold_factor) ), H.bodytemperature)

			if(protection < 0.7)
				to_chat(L, "<span class='danger'>A chilling wave of cold overwhelms you!</span>")
			else
				to_chat(L, "<span class='warning'>A chilling wave of cold passes by you, as your armor protects you from it.</span>")
			continue

	// Now make it very cold.
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		// This is most likely physically impossible but when has that stopped slimes before?
		env.add_thermal_energy(-10 * 1000 * 1000) // For a moderately sized room this doesn't actually lower it that much.

	playsound(T, 'sound/effects/phasein.ogg', 75, 1)

	..()


/decl/chemical_reaction/instant/slime/dark_blue_temp_resist
	name = "Slime Temperature Resistance"
	id = "m_darkblue_temperature_resist"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/dark_blue

/decl/chemical_reaction/instant/slime/dark_blue_temp_resist/on_reaction(var/datum/reagents/holder)
	for(var/mob/living/L in range(1, holder.my_atom))
		L.add_modifier(/datum/modifier/slime_temp_resist, 5 MINUTES, src)
	..()

/datum/modifier/slime_temp_resist
	name = "slime temperature resistance"
	desc = "You feel immune to heat and cold."
	mob_overlay_state = "corona"

	on_created_text = "<span class='warning'>A shield of goo surround you. It makes you feel protected against temperature.</span>"
	on_expired_text = "<span class='notice'>The shield of goo has faded, and you feel vulnerable to temperature again.</span>"
	stacks = MODIFIER_STACK_EXTEND

	incoming_fire_damage_percent = 0.5
	heat_protection = 1
	cold_protection = 1


/decl/chemical_reaction/instant/slime/dark_blue_ice
	name = "Slime Ice"
	id = "m_darkblue_ice"
	result = "ice"
	required_reagents = list("water" = 5)
	result_amount = 5
	required = /obj/item/slime_extract/dark_blue


/decl/chemical_reaction/instant/slime/dark_blue_death
	name = "Slime Death"
	id = "m_darkblue_death"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/dark_blue

/decl/chemical_reaction/instant/slime/dark_blue_death/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/death(get_turf(holder.my_atom))
	..()

// **************
// * Red slimes *
// **************

/obj/item/slime_extract/red
	name = "red slime extract"
	icon_state = "red slime extract"
	description_info = "When injected with phoron, this extract creates a mutation agent, that can be used to increase a slime's mutation chance. When injected with blood, this extract causes \
	nearby slimes to fall into rage. When injected with water, this extract creates some hot sauce. When injected with slime jelly, this extract creates a ferality agent, which makes slimes \
	unreceptive to discipline."
	slime_type = /mob/living/simple_mob/slime/xenobio/red


/decl/chemical_reaction/instant/slime/red_mutation
	name = "Slime Mutation"
	id = "m_red_mutation"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/red

/decl/chemical_reaction/instant/slime/red_mutation/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/mutator(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/red_enrage
	name = "Slime Enrage"
	id = "m_red_enrage"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/red

/decl/chemical_reaction/instant/slime/red_enrage/on_reaction(var/datum/reagents/holder)
	for(var/mob/living/simple_mob/slime/S in view(get_turf(holder.my_atom)))
		if(S.stat)
			continue

		if(istype(S, /mob/living/simple_mob/slime/xenobio))
			var/mob/living/simple_mob/slime/xenobio/X = S
			if(X.harmless)
				continue
			if(!X.client)
				X.enrage()

		S.add_modifier(/datum/modifier/berserk, 30 SECONDS)

		if(S.client) // Player slimes always have free will.
			to_chat(S, "<span class='warning'>An intense wave of rage is felt from inside, but you remain in control of yourself.</span>")

	for(var/mob/living/carbon/human/H in view(get_turf(holder.my_atom)))
		if(H.species.name == SPECIES_PROMETHEAN)
			H.add_modifier(/datum/modifier/berserk, 30 SECONDS)
			to_chat(H, "<span class='warning'>An intense wave of rage is felt from inside, but you remain in control of yourself.</span>")

	log_and_message_admins("Red extract reaction (enrage) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")

	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 75, 1)
	..()


/decl/chemical_reaction/instant/slime/red_hotsauce
	name = "Slime Hot Sauce"
	id = "m_red_hotsauce"
	result = "capsaicin"
	required_reagents = list("water" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/red


/decl/chemical_reaction/instant/slime/red_ferality
	name = "Slime Ferality"
	id = "m_red_ferality"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/red

/decl/chemical_reaction/instant/slime/red_ferality/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/ferality(get_turf(holder.my_atom))
	..()

// ***************
// * Green slime *
// ***************

/obj/item/slime_extract/green
	name = "green slime extract"
	icon_state = "green slime extract"
	description_info = "When injected with phoron, this extract creates a single radioactive pulse. When injected with blood, this extract creates a radioactive glob. When injected with water \
	this extract creates some radium. When injected with slime jelly, this extract creates some uranium."
	slime_type = /mob/living/simple_mob/slime/xenobio/green


/decl/chemical_reaction/instant/slime/green_radpulse
	name = "Slime Radiation Pulse"
	id = "m_green_radpulse"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/green

/decl/chemical_reaction/instant/slime/green_radpulse/on_reaction(var/datum/reagents/holder)
	log_and_message_admins("Green extract reaction (radiation pulse) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")
	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 75, 1)
	holder.my_atom.visible_message("<span class='danger'>\The [holder.my_atom] begins to vibrate violently!</span>")
	spawn(5 SECONDS)
		SSradiation.flat_radiate(src, 30, 7, TRUE)
	..()


/decl/chemical_reaction/instant/slime/green_emitter
	name = "Slime Radiation Emitter"
	id = "m_green_emitter"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/green

/decl/chemical_reaction/instant/slime/green_emitter/on_reaction(var/datum/reagents/holder)
	log_and_message_admins("Green extract reaction (radiation emitter) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")
	new /obj/item/slime_irradiator(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/green_radium
	name = "Slime Radium"
	id = "m_green_radium"
	result = "radium"
	required_reagents = list("water" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/green


/decl/chemical_reaction/instant/slime/green_uranium
	name = "Slime Uranium"
	id = "m_green_uranium"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/green

/decl/chemical_reaction/instant/slime/green_uranium/on_reaction(var/datum/reagents/holder)
	new /obj/item/stack/material/uranium(get_turf(holder.my_atom), 10)
	..()

// ***************
// * Pink slimes *
// ***************

/obj/item/slime_extract/pink
	name = "pink slime extract"
	icon_state = "pink slime extract"
	description_info = "When injected with phoron, this extract creates some bone fixing agent. When injected with blood, this extract creates some clotting agent. When injected with water, this \
	extract creates some organ healing agent. When injected with slime jelly, this extract creates a powerful regenerative wave."
	slime_type = /mob/living/simple_mob/slime/xenobio/pink


/decl/chemical_reaction/instant/slime/pink_bone_fix
	name = "Slime Bone Med"
	id = "m_pink_bone_fixer"
	result = "slime_bone_fixer"
	required_reagents = list("phoron" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/pink


/decl/chemical_reaction/instant/slime/pink_clotting
	name = "Slime Clotting Med"
	id = "m_pink_clotting"
	result = "slime_bleed_fixer"
	required_reagents = list("blood" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/pink


/decl/chemical_reaction/instant/slime/pink_organ_fix
	name = "Slime Organ Med"
	id = "m_pink_organ_fixer"
	result = "slime_organ_fixer"
	required_reagents = list("water" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/pink


/decl/chemical_reaction/instant/slime/pink_heal_pulse
	name = "Slime Heal Pulse"
	id = "m_pink_heal_pulse"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/pink

/decl/chemical_reaction/instant/slime/pink_heal_pulse/on_reaction(var/datum/reagents/holder)
	for(var/mob/living/carbon/C in viewers(get_turf(holder.my_atom), null))
		to_chat(C, "<span class='notice'>A wave of energy suddenly invigorates you.</span>")
		C.adjustBruteLoss(-25)
		C.adjustFireLoss(-25)
		C.adjustToxLoss(-25)
		C.adjustOxyLoss(-25)
		C.adjustBrainLoss(-25)
		C.adjustCloneLoss(-25)
		C.updatehealth()
	..()

// **************
// * Oil slimes *
// **************

/obj/item/slime_extract/oil
	name = "oil slime extract"
	icon_state = "oil slime extract"
	description_info = "When injected with phoron, this extract creates some fuel. When injected with blood, this extract creates some cooking oil. When injected with water, this extract \
	creates a fake explosion sound. When injected with slime jelly, this extract explodes."
	slime_type = /mob/living/simple_mob/slime/xenobio/oil


/decl/chemical_reaction/instant/slime/oil_fuel
	name = "Slime Fuel"
	id = "m_oil_fuel"
	result = "fuel"
	required_reagents = list("phoron" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/oil


/decl/chemical_reaction/instant/slime/oil_oil
	name = "Slime Oil"
	id = "m_oil_oil"
	result = "cookingoil"
	required_reagents = list("blood" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/oil


/decl/chemical_reaction/instant/slime/oil_fakesplosion
	name = "Slime Fake Explosion"
	id = "m_oil_fakeboom"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/oil

/decl/chemical_reaction/instant/slime/oil_fakesplosion/on_reaction(var/datum/reagents/holder)
	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 75, 1)
	explosion(get_turf(holder.my_atom), 0, 0, 0)
	..()


/decl/chemical_reaction/instant/slime/oil_explosion
	name = "Slime Explosion"
	id = "m_oil_boom"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/oil

/decl/chemical_reaction/instant/slime/oil_explosion/on_reaction(var/datum/reagents/holder)
	..()
	var/obj/item/slime_extract/E = holder.my_atom
	var/power = 1
	if(E.enhanced)
		power++
	E.uses = 0

	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 75, 1)
	holder.my_atom.visible_message("<span class='danger'>\The [holder.my_atom] begins to vibrate violently!</span>")
	log_and_message_admins("Oil extract reaction (explosion) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")

	spawn(5 SECONDS)
		if(holder && holder.my_atom)
			explosion(get_turf(holder.my_atom), 1 * power, 3 * power, 6 * power)

		if(holder && holder.my_atom) // Explosion may or may not have deleted the extract.
			qdel(holder.my_atom)

// ********************
// * Bluespace slimes *
// ********************

/obj/item/slime_extract/bluespace
	name = "bluespace slime extract"
	icon_state = "bluespace slime extract"
	description_info = "When injected with phoron, this extract creates some bluespace crystals. When injected with blood, this extract creates a bluespace bag. When injected with water, this \
	extract causes random teleportation. When injected with slime jelly, this extract creates a disposable precise teleportation tool."
	slime_type = /mob/living/simple_mob/slime/xenobio/bluespace


/decl/chemical_reaction/instant/slime/bluespace_crystals
	name = "Slime Bluespace Crystals"
	id = "m_bs_crystals"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/bluespace

/decl/chemical_reaction/instant/slime/bluespace_crystals/on_reaction(var/datum/reagents/holder)
	for(var/i = 1 to 5)
		new /obj/item/slime_crystal(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/bluespace_pouch
	name = "Slime Bluespace Pouch"
	id = "m_bs_pouch"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/bluespace

/decl/chemical_reaction/instant/slime/bluespace_pouch/on_reaction(var/datum/reagents/holder)
	new /obj/item/storage/backpack/holding/slime(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/bluespace_chaotic_tele
	name = "Slime Bluespace Chaos"
	id = "m_bs_chaos"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/bluespace

/decl/chemical_reaction/instant/slime/bluespace_chaotic_tele/on_reaction(var/datum/reagents/holder)
	log_and_message_admins("Bluespace extract reaction (chaos teleport) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")
	for(var/mob/living/M in range(2,get_turf(holder.my_atom)))
		if(M.buckled)
			M.buckled.unbuckle_mob()

		var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
		sparks.set_up(3, 0, get_turf(M))
		sparks.start()

		M.forceMove(pick(trange(50, get_turf(holder.my_atom))))

		sparks = new /datum/effect_system/spark_spread()
		sparks.set_up(3, 0, M.loc)
		sparks.start()
	..()


/decl/chemical_reaction/instant/slime/bluespace_teleporter
	name = "Slime Bluespace Teleporter"
	id = "m_bs_teleporter"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/bluespace

/decl/chemical_reaction/instant/slime/bluespace_teleporter/on_reaction(var/datum/reagents/holder)
	new /obj/item/disposable_teleporter/slime(get_turf(holder.my_atom))
	..()

// *******************
// * Cerulean slimes *
// *******************

/obj/item/slime_extract/cerulean
	name = "cerulean slime extract"
	icon_state = "cerulean slime extract"
	description_info = "When injected with phoron, this extract creates an enhancer agent, which can be used to increase amount of uses any extract has once. When injected with blood, this extact \
	creates an invigoration agent, which can be used to create a slime out of an extract. When injected with water, this extract creates a mimic agent, which can copy properties of other agents. \
	When injected with slime jelly, this extract creates a random agent."
	slime_type = /mob/living/simple_mob/slime/xenobio/cerulean


/decl/chemical_reaction/instant/slime/cerulean_enhancer
	name = "Slime Enhancer"
	id = "m_cerulean_enhancer"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/cerulean

/decl/chemical_reaction/instant/slime/cerulean_enhancer/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/enhancer(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/cerulean_reinvigoration
	name = "Slime Reinvigoration"
	id = "m_cerulean_reinvigoration"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/cerulean

/decl/chemical_reaction/instant/slime/cerulean_reinvigoration/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/reinvigoration(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/cerulean_potion_mimic
	name = "Slime Potion Mimic"
	id = "m_cerulean_potion_mimic"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/cerulean

/decl/chemical_reaction/instant/slime/cerulean_potion_mimic/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/mimic(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/cerulean_random_potion
	name = "Slime Random Potion"
	id = "m_cerulean_random_potion"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/cerulean

/decl/chemical_reaction/instant/slime/cerulean_random_potion/on_reaction(var/datum/reagents/holder)
	var/spawn_type = pickweight(xenobio_cerulean_potions)
	new spawn_type(get_turf(holder.my_atom))
	..()

// ****************
// * Amber slimes *
// ****************

/obj/item/slime_extract/amber
	name = "amber slime extract"
	icon_state = "amber slime extract"
	description_info = "When injected with phoron, this extract creates a feeding agent, which can be used to instantly split a slime. When injected with blood, this extract creates some food. \
	When injected with water, this extract creates some edible slime globs. When injected with slime jelly, this extract creates some super-nutritious slime goop."
	slime_type = /mob/living/simple_mob/slime/xenobio/amber


/decl/chemical_reaction/instant/slime/amber_slimefood
	name = "Slime Feeding"
	id = "m_amber_slime_food"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/amber

/decl/chemical_reaction/instant/slime/amber_slimefood/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/feeding(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/amber_random_food
	name = "Slime Random Food"
	id = "m_amber_random_food"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/amber

/decl/chemical_reaction/instant/slime/amber_random_food/on_reaction(var/datum/reagents/holder)
	var/list/edibles = subtypesof(/obj/item/reagent_containers/food/snacks)

	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 100, 1)

	for(var/i = 1 to rand(2, 4))
		var/chosen = pick(edibles)
		var/obj/B = new chosen
		if(B)
			B.loc = get_turf(holder.my_atom)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH,SOUTH,EAST,WEST))
	..()


/decl/chemical_reaction/instant/slime/amber_snack
	name = "Slime Snack"
	id = "m_amber_snack"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/amber

/decl/chemical_reaction/instant/slime/amber_snack/on_reaction(var/datum/reagents/holder)
	for(var/i = 1 to rand(3, 5))
		new /obj/item/reagent_containers/food/snacks/slime(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/amber_goop
	name = "Slime Goop"
	id = "m_amber_goop"
	result = "slime_goop"
	required_reagents = list("slimejelly" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/amber

// *******************
// * Sapphire slimes *
// *******************

/obj/item/slime_extract/sapphire
	name = "sapphire slime extract"
	icon_state = "sapphire slime extract"
	description_info = "When injected with phoron, this extract creates a promethean cube, which can be used to create a new promethean. When injected with blood, this extract creates some mutation \
	toxin. When injected with water, this extract creates some plushies. When injected with slime jelly, this extract creates a sapience agent, which can be used to develop sentience in \
	various creatures."
	slime_type = /mob/living/simple_mob/slime/xenobio/sapphire


/decl/chemical_reaction/instant/slime/sapphire_promethean
	name = "Slime Promethean"
	id = "m_sapphire_promethean"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/sapphire

/decl/chemical_reaction/instant/slime/sapphire_promethean/on_reaction(var/datum/reagents/holder)
	new /obj/item/slime_cube(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/sapphire_mutation
	name = "Slime Mutation Toxins"
	id = "m_sapphire_mutation_tox"
	result = "mutationtoxin"
	required_reagents = list("blood" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/sapphire


/decl/chemical_reaction/instant/slime/sapphire_plushies
	name = "Slime Plushies"
	id = "m_sapphire_plushies"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/sapphire

/decl/chemical_reaction/instant/slime/sapphire_plushies/on_reaction(var/datum/reagents/holder)
	var/spawn_type
	var/list/possible_types = subtypesof(/obj/item/toy/plushie)
	possible_types -= subtypesof(/obj/item/toy/plushie/fluff)
	possible_types -= subtypesof(/obj/item/toy/plushie/therapy)
	for(var/i = 1 to rand(3, 5))
		spawn_type = pickweight(possible_types)
		new spawn_type(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/sapphire_sapience
	name = "Slime Sapience"
	id = "m_sapphire_sapience"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/sapphire

/decl/chemical_reaction/instant/slime/sapphire_sapience/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/sapience(get_turf(holder.my_atom))
	..()

// ***************
// * Ruby slimes *
// ***************

/obj/item/slime_extract/ruby
	name = "ruby slime extract"
	icon_state = "ruby slime extract"
	description_info = "When injected with phoron, this extract grants extra strength for a time. When injected with blood, this extract causes a wave of pulling force. When injected with water, \
	this extract creates some brute juice. When injected with slime jelly, this extract creates a pushing force."
	slime_type = /mob/living/simple_mob/slime/xenobio/ruby

/decl/chemical_reaction/instant/slime/ruby_swole
	name = "Slime Strength"
	id = "m_ruby_strength"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/ruby

/decl/chemical_reaction/instant/slime/ruby_swole/on_reaction(var/datum/reagents/holder)
	for(var/mob/living/L in range(1, holder.my_atom))
		L.add_modifier(/datum/modifier/slime_strength, 10 MINUTES, src)
	..()

/datum/modifier/slime_strength
	name = "slime strength"
	desc = "You feel much stronger than usual."
	mob_overlay_state = "pink_sparkles"

	on_created_text = "<span class='warning'>Twinkling spores of goo surround you.  It makes you feel stronger and more robust.</span>"
	on_expired_text = "<span class='notice'>The spores of goo have faded, and you feel your strength returning to what it was before.</span>"
	stacks = MODIFIER_STACK_EXTEND

	max_health_flat = 50
	outgoing_melee_damage_percent = 2
	disable_duration_percent = 0.5
	incoming_damage_percent = 0.75


/decl/chemical_reaction/instant/slime/ruby_pull
	name = "Slime Pull"
	id = "m_ruby_pull"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/ruby

/decl/chemical_reaction/instant/slime/ruby_pull/on_reaction(var/datum/reagents/holder)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/weapons/gauss_shoot.ogg', 50, 1)
	var/datum/effect_system/grav_pull/s = new /datum/effect_system/grav_pull
	s.set_up(3, 3, location)
	s.start()
	..()


/decl/chemical_reaction/instant/slime/ruby_brute_juice
	name = "Slime Brute Juice"
	id = "m_ruby_brute_juice"
	result = "berserkmed"
	required_reagents = list("water" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/ruby


/decl/chemical_reaction/instant/slime/ruby_push
	name = "Slime Push"
	id = "m_ruby_push"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/ruby

/decl/chemical_reaction/instant/slime/ruby_push/on_reaction(var/datum/reagents/holder)
	var/location = get_turf(holder.my_atom)
	for(var/X in orange(3, location))
		var/atom/movable/AM = X
		if(!ismovable(X) || istype(X, /obj/effect/overlay))
			continue

		if(isobj(X))
			var/obj/O = X
			if(O.anchored)
				continue

		var/throwdir = get_dir(location, AM)
		AM.throw_at(get_edge_target_turf(AM, throwdir), 3, 1, src)

	playsound(location, 'sound/weapons/gauss_shoot.ogg', 50, 1)
	..()

// *****************
// * Emerald slime *
// *****************

/obj/item/slime_extract/emerald
	name = "emerald slime extract"
	icon_state = "emerald slime extract"
	description_info = "When injected with phoron, this extract grants extra agility, making you more evasive and fast-acting for a while. When injected with blood, this extract grants extra speed \
	for a short time. When injected with water, this extract creates some hyperzine. When injected with slime jelly, this extract causes area around to become slippery for a time."
	slime_type = /mob/living/simple_mob/slime/xenobio/emerald


/decl/chemical_reaction/instant/slime/emerald_agility
	name = "Slime Agility"
	id = "m_emerald_agility"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/emerald

/decl/chemical_reaction/instant/slime/emerald_agility/on_reaction(var/datum/reagents/holder)
	for(var/mob/living/L in range(1, holder.my_atom))
		L.add_modifier(/datum/modifier/slime_agility, 10 MINUTES, src)
	..()

/datum/modifier/slime_agility
	name = "slime agility"
	desc = "You feel much more agile than usual."
	mob_overlay_state = "green_sparkles"

	on_created_text = "<span class='warning'>Twinkling spores of goo surround you.  It makes you feel more agile.</span>"
	on_expired_text = "<span class='notice'>The spores of goo have faded, and you feel your agility returning to what it was before.</span>"
	stacks = MODIFIER_STACK_EXTEND

	evasion = 45
	attack_speed_percent = 0.5
	disable_duration_percent = 0.5


/decl/chemical_reaction/instant/slime/emerald_speed
	name = "Slime Speed"
	id = "m_emerald_speed"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/emerald

/decl/chemical_reaction/instant/slime/emerald_speed/on_reaction(var/datum/reagents/holder)
	for(var/mob/living/L in range(1, holder.my_atom))
		L.add_modifier(/datum/modifier/slime_speed, 1 MINUTE, src)
	..()

/datum/modifier/slime_speed
	name = "slime speed"
	desc = "You feel much faster than usual."
	mob_overlay_state = "haste"

	on_created_text = "<span class='warning'>Twinkling spores of goo surround you.  It makes you feel very fast.</span>"
	on_expired_text = "<span class='notice'>The spores of goo have faded, and you feel your speed returning to what it was before.</span>"
	stacks = MODIFIER_STACK_EXTEND

	slowdown = -3


/decl/chemical_reaction/instant/slime/emerald_hyperzine
	name = "Slime Hyperzine"
	id = "m_emerald_hyperzine"
	result = "hyperzine"
	required_reagents = list("water" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/emerald


/decl/chemical_reaction/instant/slime/emerald_hell
	name = "Slime Hell"
	id = "m_emerald_hell"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/emerald

/decl/chemical_reaction/instant/slime/emerald_hell/on_reaction(var/datum/reagents/holder)
	log_and_message_admins("Emerald extract reaction (slip hell) has been activated in [get_area(holder.my_atom)].  Last fingerprints: [holder.my_atom.fingerprintslast]")
	for(var/turf/simulated/T in trange(5, get_turf(holder.my_atom)))
		if(!istype(T))
			continue
		T.wet = 1
		T.freeze_floor()
	..()

// *********************
// * Light Pink slimes *
// *********************

/obj/item/slime_extract/light_pink
	name = "light pink slime extract"
	icon_state = "light pink slime extract"
	description_info = "When injected with phoron, this extract creates a friendship agent, which can be used to make a slime or a creature consider you a friend. When injected with blood, \
	this extract creates a loyalty agent, which can be used to make a slime or a creature think of those like you as their own. When injected with water, this extract creates a docility agent, \
	which can be used to pacify a slime or a creature permanently. When injected with slime jelly, this extract creates an obedience agent, which can be used to instantly fully discipline a slime."
	slime_type = /mob/living/simple_mob/slime/xenobio/light_pink


/decl/chemical_reaction/instant/slime/light_pink_friendship
	name = "Slime Friendship"
	id = "m_lightpink_friendship"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/light_pink

/decl/chemical_reaction/instant/slime/light_pink_friendship/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/friendship(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/light_pink_loyalty
	name = "Slime Loyalty"
	id = "m_lightpink_loyalty"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/light_pink

/decl/chemical_reaction/instant/slime/light_pink_loyalty/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/loyalty(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/light_pink_docility
	name = "Slime Docility"
	id = "m_lightpink_docility"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/light_pink

/decl/chemical_reaction/instant/slime/light_pink_docility/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/docility(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/light_pink_obedience
	name = "Slime Obedience"
	id = "m_lightpink_obedience"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/light_pink

/decl/chemical_reaction/instant/slime/light_pink_obedience/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/obedience(get_turf(holder.my_atom))
	..()

// ******************
// * Rainbow slimes *
// ******************


/obj/item/slime_extract/rainbow
	name = "rainbow slime extract"
	icon_state = "rainbow slime extract"
	description_info = "When injected with phoron, this extract will create a random slime. When injected with blood, this extract will create a random slime extract. When injected with water, \
	this extract with create pretty colors. When injected with slime jelly, this extract will create unity agent, which can be used to make slime non-hostile to slimes of other colors."
	slime_type = /mob/living/simple_mob/slime/xenobio/rainbow


/decl/chemical_reaction/instant/slime/rainbow_random_slime
	name = "Slime Random Slime"
	id = "m_rainow_random_slime"
	required_reagents = list("phoron" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/rainbow

/decl/chemical_reaction/instant/slime/rainbow_random_slime/on_reaction(var/datum/reagents/holder)
	var/mob/living/simple_mob/slime/xenobio/S
	var/list/slime_types = typesof(/mob/living/simple_mob/slime/xenobio)

	while(slime_types.len)
		S = pick(slime_types)
		if(initial(S.rainbow_core_candidate) == TRUE)
			break
		else
			slime_types -= S
			S = null

	if(S)
		new S(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/rainbow_random_extract
	name = "Slime Random Extract"
	id = "m_rainow_random_extract"
	required_reagents = list("blood" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/rainbow

/decl/chemical_reaction/instant/slime/rainbow_random_extract/on_reaction(var/datum/reagents/holder)
	var/spawn_type = pickweight(xenobio_rainbow_extracts)
	new spawn_type(get_turf(holder.my_atom))
	..()


/decl/chemical_reaction/instant/slime/rainbow_colors
	name = "Slime Colors"
	id = "m_rainbow_colors"
	required_reagents = list("water" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/rainbow

/decl/chemical_reaction/instant/slime/rainbow_colors/on_reaction(var/datum/reagents/holder)
	for(var/mob/living/carbon/human/H in range(3, holder.my_atom))
		H.druggy = max(H.druggy, 30)
	..()


/decl/chemical_reaction/instant/slime/rainbow_unity
	name = "Slime Unity"
	id = "m_rainbow_unity"
	required_reagents = list("slimejelly" = 5)
	result_amount = 1
	required = /obj/item/slime_extract/rainbow

/decl/chemical_reaction/instant/slime/rainbow_unity/on_reaction(var/datum/reagents/holder)
	new /obj/item/slimepotion/unity(get_turf(holder.my_atom))
	..()
