/datum/power/lleill

// Simple ability to become invisible. Does not phase you out of the world, you can still interact with things and can not pass through walls.
// Essentially the same as traitor cloaking, using the same proc for it.

/datum/power/lleill/invisibility
	name = "Invisibility"
	desc = "Change your appearance to match your surroundings, becoming completely invisible to the naked eye."
	verbpath = /mob/living/carbon/human/proc/lleill_invisibility

/mob/living/carbon/human/proc/lleill_invisibility()
	set name = "Invisibility"
	set desc = "Change your appearance to match your surroundings, becoming completely invisible to the naked eye."
	set category = "Abilities"

	if(stat)
		to_chat(src, "<span class='warning'>You can't go invisible when weakened like this.</span>")
		return

	if(!cloaked)
		cloak()
		to_chat(src, "<span class='warning'>Your fur shimmers and shifts around you, hiding you from the naked eye.</span>")
	else
		uncloak()
		to_chat(src, "<span class='warning'>The brustling of your fur settles down and you become visible once again.</span>")

/mob/living/carbon/human/proc/lleill_select_shape()

	set name = "Select Body Shape"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_species = null
	new_species = tgui_input_list(usr, "Please select a species to emulate.", "Shapeshifter Body", species.get_valid_shapeshifter_forms(src))

	if(!new_species || !GLOB.all_species[new_species] || wrapped_species_by_ref["\ref[src]"] == new_species)
		return
	lleill_change_shape(new_species)

/mob/living/carbon/human/proc/lleill_change_shape(var/new_species = null)
	if(!new_species)
		return

	wrapped_species_by_ref["\ref[src]"] = new_species
	dna.base_species = new_species
	species.base_species = new_species
	visible_message("<b>\The [src]</b> shifts and contorts, taking the form of \a [new_species]!")
	regenerate_icons()

/mob/living/carbon/human/proc/lleill_select_colour()

	set name = "Select Body Colour"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_skin = input(usr, "Please select a new body color.", "Shapeshifter Colour", rgb(r_skin, g_skin, b_skin)) as null|color
	if(!new_skin)
		return
	lleill_set_colour(new_skin)

/mob/living/carbon/human/proc/lleill_set_colour(var/new_skin)

	r_skin =   hex2num(copytext(new_skin, 2, 4))
	g_skin =   hex2num(copytext(new_skin, 4, 6))
	b_skin =   hex2num(copytext(new_skin, 6, 8))
	r_synth = r_skin
	g_synth = g_skin
	b_synth = b_skin

	for(var/obj/item/organ/external/E in organs)
		E.sync_colour_to_human(src)

	regenerate_icons()

/mob/living/carbon/human/proc/lleill_transmute()
	set name = "Transmute Object"
	set desc = "Convert an object into a piece of glamour."
	set category = "Abilities"

	var/list/transmute_list = list(
		/obj/item/weapon/potion_material/glamour_transparent,
		/obj/item/weapon/potion_material/glamour_shrinking,
		/obj/item/weapon/potion_material/glamour_twinkling,
		/obj/item/weapon/potion_material/glamour_shard,
		/obj/item/capture_crystal/glamour,
		/obj/item/glamour_face,
		/obj/item/device/universal_translator/glamour
		)

	if(stat)
		to_chat(src, "<span class='warning'>You can't go do that when weakened like this.</span>")
		return

	var/obj/item/I = get_active_hand()
	if(!I)
		to_chat(src, "<span class='warning'>You have no item in your active hand.</span>")
		return

	var/obj/item/transmute_product = tgui_input_list(src, "Choose an glamour to transmute the item into:", "Transmutation", transmute_list)
	if(!get_active_hand(I))
		to_chat(src, "<span class='warning'>The item is no longer in your hands.</span>")
		return
	else
		visible_message("<b>\The [src]</b> begins to change the form of \the [I].")
		if(!do_after(usr, 10 SECONDS, I, exclusive = TASK_USER_EXCLUSIVE))
			visible_message("<b>\The [src]</b> leaves \the [I] in its original form.")
			return 0
		visible_message("<b>\The [src]</b> transmutes \the [I] into a \the [transmute_product.name].")
		drop_item(I)
		qdel(I)
		var/spawnloc = get_turf(usr)
		var/obj/item/N = new transmute_product(spawnloc)
		put_in_active_hand(N)

/mob/living/carbon/human/proc/lleill_rings()
	set name = "Place/Use Rings"
	set desc = "Place or teleport to a glamour ring."
	set category = "Abilities"

	if(stat)
		to_chat(src, "<span class='warning'>You can't go do that when weakened like this.</span>")
		return
	if(buckled)
		to_chat(src,"<span class='warning'>You can't do that when restrained.</span>")

	var/r_action = tgui_alert(src, "What would you like to do with your rings?", "Actions", list("Spawn New Ring", "Teleport to Ring", "Cancel"))
	if(r_action == "Cancel")
		return
	if(r_action == "Spawn New Ring")
		if(!do_after(src, 10 SECONDS, src, exclusive = TASK_USER_EXCLUSIVE))
			src.visible_message("<b>\The [src]</b> begins to form white rings on the ground.")
			return 0
		to_chat(src, "<span class='warning'>You place a new glamour ring at your feet.</span>")
		var/spawnloc = get_turf(src)
		var/obj/structure/glamour_ring/R = new(spawnloc)
		src.teleporters |= R
	if(r_action == "Teleport to Ring")
		if(!src.teleporters.len)
			to_chat(src, "<span class='warning'>You need to place rings to teleport to them.</span>")
			return
		else
			var/obj/structure/glamour_ring/R = tgui_input_list(src, "Where do you wish to teleport?", "Teleport", src.teleporters)

			var/datum/effect/effect/system/spark_spread/spk
			spk = new(src)

			var/T = get_turf(src)
			spk.set_up(5, 0, src)
			spk.attach(src)
			playsound(T, "sparks", 50, 1)
			anim(T,src,'icons/mob/mob.dmi',,"phaseout",,src.dir)

			var/S = get_turf(R)
			src.forceMove(S)

			spk.start()
			playsound(S, 'sound/effects/phasein.ogg', 25, 1)
			playsound(S, 'sound/effects/sparks2.ogg', 50, 1)
			anim(S,src,'icons/mob/mob.dmi',,"phasein",,src.dir)
			spk.set_up(5, 0, src)
			spk.attach(src)

			//Would be fun to eat people standing on your ring...
			if(can_be_drop_pred && vore_selected)
				var/list/target_list = src.living_mobs(0)
				if(target_list.len)
					for(var/mob/living/M in target_list)
						if(M.devourable && M.can_be_drop_prey)
							M.forceMove(vore_selected)
							to_chat(M,"<span class='vwarning'>In a bright flash of white light, you suddenly find yourself trapped in \the [src]'s [vore_selected.name]!</span>")

