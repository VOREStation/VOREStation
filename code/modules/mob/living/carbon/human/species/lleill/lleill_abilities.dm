/datum/power/lleill

// Simple ability to become invisible. Does not phase you out of the world, you can still interact with things and can not pass through walls.
// Essentially the same as traitor cloaking, using the same proc for it.

/datum/power/lleill/invisibility
	name = "Invisibility"
	desc = "Change your appearance to match your surroundings, becoming completely invisible to the naked eye."
	verbpath = /mob/living/carbon/human/proc/lleill_invisibility

/mob/living/carbon/human/proc/lleill_invisibility()
	set name = "Invisibility (75)"
	set desc = "Change your appearance to match your surroundings, becoming completely invisible to the naked eye."
	set category = "Abilities"

	var/energy_cost = 75

	var/datum/species/lleill/LL = species

	if(!istype(LL))
		to_chat(src, "<span class='warning'>Only a lleill can use that!</span>")
		return

	if(stat)
		to_chat(src, "<span class='warning'>You can't go invisible when weakened like this.</span>")
		return

	if(!cloaked)
		if(LL.lleill_energy < energy_cost)
			to_chat(src, "<span class='warning'>You do not have enough energy to do that!</span>")
			return
		cloak()
		block_hud = 1
		hud_updateflag = 1
		to_chat(src, "<span class='warning'>Your fur shimmers and shifts around you, hiding you from the naked eye.</span>")
		LL.lleill_energy -= energy_cost
	else
		uncloak()
		block_hud = 0
		hud_updateflag = 1
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
	set name = "Transmute Object (50)"
	set desc = "Convert an object into a piece of glamour."
	set category = "Abilities"

	var/list/transmute_list = list(
		"Transparent Glamour" = /obj/item/weapon/potion_material/glamour_transparent,
		"Shrinking Glamour" = /obj/item/weapon/potion_material/glamour_shrinking,
		"Twinkling Glamour" = /obj/item/weapon/potion_material/glamour_twinkling,
		"Glamour Shard" = /obj/item/weapon/potion_material/glamour_shard,
		"Glamour Cell" = /obj/item/capture_crystal/glamour,
		"Face of Glamour" = /obj/item/glamour_face,
		"Speaking Glamour" = /obj/item/device/universal_translator/glamour,
		"Glamour Bubble" = /obj/item/clothing/mask/gas/glamour,
		"Pocket of Glamour" = /obj/item/clothing/under/permit/glamour
		)

	var/energy_cost = 50

	var/datum/species/lleill/LL = species

	if(!istype(LL))
		to_chat(src, "<span class='warning'>Only a lleill can use that!</span>")
		return

	if(LL.lleill_energy < energy_cost)
		to_chat(src, "<span class='warning'>You do not have enough energy to do that!</span>")
		return

	if(stat)
		to_chat(src, "<span class='warning'>You can't go do that when weakened like this.</span>")
		return

	var/obj/item/I = get_active_hand()
	if(!I)
		to_chat(src, "<span class='warning'>You have no item in your active hand.</span>")
		return

	var/choice = tgui_input_list(src, "Choose a glamour to transmute the item into:", "Transmutation", transmute_list)

	if(!choice)
		return
	var/obj/item/transmute_product = transmute_list[choice]


	if(!get_active_hand(I))
		to_chat(src, "<span class='warning'>The item is no longer in your hands.</span>")
		return
	else
		visible_message("<b>\The [src]</b> begins to change the form of \the [I].")
		if(!do_after(usr, 10 SECONDS, I, exclusive = TASK_USER_EXCLUSIVE))
			visible_message("<b>\The [src]</b> leaves \the [I] in its original form.")
			return 0
		visible_message("<b>\The [src]</b> transmutes \the [I] into \the [transmute_product.name].")
		drop_item(I)
		qdel(I)
		var/spawnloc = get_turf(usr)
		var/obj/item/N = new transmute_product(spawnloc)
		put_in_active_hand(N)
		LL.lleill_energy -= energy_cost

/mob/living/carbon/human/proc/lleill_rings()
	set name = "Place/Use Rings"
	set desc = "Place or teleport to a glamour ring."
	set category = "Abilities"

	var/energy_cost_multi = src.teleporters.len
	var/energy_cost_spawn = (25 * energy_cost_multi)
	var/energy_cost_tele = 50

	var/datum/species/lleill/LL = species

	if(!istype(LL))
		to_chat(src, "<span class='warning'>Only a lleill can use that!</span>")
		return
	if(stat)
		to_chat(src, "<span class='warning'>You can't go do that when weakened like this.</span>")
		return
	if(buckled)
		to_chat(src,"<span class='warning'>You can't do that when restrained.</span>")

	var/r_action = tgui_alert(src, "What would you like to do with your rings? You currently have [LL.lleill_energy] energy remaining.", "Actions", list("Spawn New Ring ([energy_cost_spawn])", "Teleport to Ring ([energy_cost_tele])", "Cancel"))
	if(!r_action || r_action == "Cancel")
		return
	if(findtext(r_action,"Spawn New Ring"))
		if(LL.lleill_energy < energy_cost_spawn)
			to_chat(src, "<span class='warning'>You do not have enough energy to do that!</span>")
			return
		if(!do_after(src, 10 SECONDS, src, exclusive = TASK_USER_EXCLUSIVE))
			src.visible_message("<b>\The [src]</b> begins to form white rings on the ground.")
			return 0
		to_chat(src, "<span class='warning'>You place a new glamour ring at your feet.</span>")
		var/spawnloc = get_turf(src)
		var/obj/structure/glamour_ring/R = new(spawnloc)
		R.connected_mob = src
		src.teleporters |= R
		LL.lleill_energy -= energy_cost_spawn
	if(findtext(r_action,"Teleport to Ring"))
		if(LL.lleill_energy < energy_cost_tele)
			to_chat(src, "<span class='warning'>You do not have enough energy to do that!</span>")
			return
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
			LL.lleill_energy -= energy_cost_tele

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

/mob/living/carbon/human/proc/lleill_contact()
	set name = "Energy Transfer"
	set desc = "Take the energy of another creature by making physical contact with them, the other party must consent. This will make them feel drained."
	set category = "Abilities"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.
	var/datum/species/lleill/LL = species

	var/list/contact_options = list(
		"Kiss (lips)",
		"Kiss (neck)",
		"Bite (neck)",
		"Bite (wrist)",
		"Hold Hand",
		"Embrace",
		"Boop (nose)",
		"Stroke (hair)",
		"Custom"
		)

	if(!istype(LL))
		to_chat(src, "<span class='warning'>Only a lleill can use that!</span>")
		return
	if(stat)
		to_chat(src, "<span class='warning'>You can't go do that when weakened like this.</span>")
		return

	var/list/targets = list()
	for(var/mob/living/carbon/human/M in mob_list)
		if(M.z != src.z || get_dist(src,M) > 1)
			continue
		if(src == M)
			continue
		targets |= M

	if(!targets)
		to_chat(src, "<span class='warning'>There is nobody next to you.</span>")
		return
	var/mob/living/carbon/human/chosen_target = tgui_input_list(src, "Who do you wish to take energy from?", "Make contact", targets)
	if(!chosen_target)
		return

	var/contact_type = tgui_input_list(src, "How do you wish to make contact with \the [chosen_target]?", "Contact type", contact_options)
	if(!contact_type)
		return

	var/custom_text
	if(contact_type == "Custom")
		custom_text = tgui_input_text(src, "Write a description of how you make contact with \the [chosen_target], from a third person perspective.", "Custom contact")

	var/accepted = tgui_alert(chosen_target, "Do you accept the [contact_type] physical contact from \the [src]?", "Actions", list("Yes", "No"))
	if(get_dist(src,chosen_target) > 1)
		to_chat(src, "<span class='warning'>You need to be standing next to [chosen_target].</span>")
		return
	if(!accepted || accepted == "No")
		to_chat(src, "<span class='warning'>\The [chosen_target] refuses the contact.</span>")
		return
	if(accepted == "Yes")
		if(contact_type == "Kiss (lips)")
			src.visible_message("<b>\The [src]</b> presses their lips up against [chosen_target]'s own.")
		if(contact_type == "Kiss (neck)")
			src.visible_message("<b>\The [src]</b> presses their lips up against [chosen_target]'s neck.")
		if(contact_type == "Bite (neck)")
			src.visible_message("<b>\The [src]</b> bites down on [chosen_target]'s neck.")
		if(contact_type == "Bite (wrist)")
			src.visible_message("<b>\The [src]</b> bites down on [chosen_target]'s wrist.")
		if(contact_type == "Hold Hand")
			src.visible_message("<b>\The [src]</b> takes [chosen_target]'s hand into their own.")
		if(contact_type == "Embrace")
			src.visible_message("<b>\The [src]</b> embraces [chosen_target].")
		if(contact_type == "Stroke (hair)")
			src.visible_message("<b>\The [src]</b> runs their hand through [chosen_target]'s hair.")
		if(contact_type == "Boop (nose)")
			src.visible_message("<b>\The [src]</b> boops [chosen_target] on the nose.")
		if(contact_type == "Custom")
			src.visible_message("[custom_text]")
		if(!do_after(src, 10 SECONDS, chosen_target, exclusive = TASK_USER_EXCLUSIVE))
			return
		else
			src.visible_message("<b>\The [src]</b> and \the [chosen_target] break contact before energy has been transferred.")
		src.visible_message("<b>\The [src]</b> and \the [chosen_target] complete their contact.")
		LL.lleill_energy = LL.lleill_energy_max
		nutrition += (chosen_target.nutrition / 2)
		to_chat(src, "<span class='warning'>You feel revitalised.</span>")
		chosen_target.tiredness += 70
		chosen_target.nutrition = max((chosen_target.nutrition / 2),75)
		chosen_target.remove_blood(40) //removes enough blood to make them feel a bit woozy, mostly just for flavour
		chosen_target.eye_blurry += 20
		to_chat(chosen_target, "<span class='warning'>You feel considerably weakened for the moment.</span>")

/mob/living/carbon/human/proc/lleill_alchemy()
	set name = "Alchemy (25)"
	set desc = "Convert a potion material into a potion without the use of a base or alembic."
	set category = "Abilities"

	var/energy_cost = 25

	var/datum/species/lleill/LL = species

	if(!istype(LL))
		to_chat(src, "<span class='warning'>Only a lleill can use that!</span>")
		return

	if(LL.lleill_energy < energy_cost)
		to_chat(src, "<span class='warning'>You do not have enough energy to do that!</span>")
		return

	if(stat)
		to_chat(src, "<span class='warning'>You can't go do that when weakened like this.</span>")
		return

	var/obj/item/weapon/potion_material/I = get_active_hand()
	if(!I)
		to_chat(src, "<span class='warning'>You have no item in your active hand.</span>")
		return

	if(!istype(I))
		to_chat(src, "<span class='warning'>\The [I] is not a potion material.</span>")
		return
	var/obj/item/weapon/reagent_containers/glass/bottle/potion/transmute_product = I.product_potion

	if(!get_active_hand(I))
		to_chat(src, "<span class='warning'>The item is no longer in your hands.</span>")
		return
	else
		visible_message("<b>\The [src]</b> begins to change the form of \the [I].")
		if(!do_after(usr, 10 SECONDS, I, exclusive = TASK_USER_EXCLUSIVE))
			visible_message("<b>\The [src]</b> leaves \the [I] in its original form.")
			return 0
		visible_message("<b>\The [src]</b> transmutes \the [I] into \the [transmute_product.name].")
		drop_item(I)
		qdel(I)
		var/spawnloc = get_turf(usr)
		var/obj/item/N = new transmute_product(spawnloc)
		put_in_active_hand(N)
		LL.lleill_energy -= energy_cost
