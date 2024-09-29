/datum/power/lleill

// Simple ability to become invisible. Does not phase you out of the world, you can still interact with things and can not pass through walls.
// Essentially the same as traitor cloaking, using the same proc for it.

/datum/power/lleill/invisibility
	name = "Invisibility (75)"
	desc = "Change your appearance to match your surroundings, becoming completely invisible to the naked eye."
	verbpath = /mob/living/carbon/human/proc/lleill_invisibility
	ability_icon_state = "ling_camoflage"

/mob/living/carbon/human/proc/lleill_invisibility()
	set name = "Invisibility (75)"
	set desc = "Change your appearance to match your surroundings, becoming completely invisible to the naked eye."
	set category = "Abilities"

	var/energy_cost = 75

	if(stat)
		to_chat(src, "<span class='warning'>You can't go invisible when weakened like this.</span>")
		return

	if(!cloaked)
		if(species.lleill_energy < energy_cost)
			to_chat(src, "<span class='warning'>You do not have enough energy to do that! You currently have [species.lleill_energy] energy.</span>")
			return
		cloak()
		block_hud = 1
		hud_updateflag = 1
		to_chat(src, "<span class='warning'>Your fur shimmers and shifts around you, hiding you from the naked eye.</span>")
		species.lleill_energy -= energy_cost
	else
		uncloak()
		block_hud = 0
		hud_updateflag = 1
		to_chat(src, "<span class='warning'>The brustling of your fur settles down and you become visible once again.</span>")
	species.update_lleill_hud(src)

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

/datum/power/lleill/transmute
	name = "Transmute Object (50)"
	desc = "Convert an object into a piece of glamour."
	verbpath = /mob/living/carbon/human/proc/lleill_transmute
	ability_icon_state = "lleill_transmute"

/mob/living/carbon/human/proc/lleill_transmute()
	set name = "Transmute Object (50)"
	set desc = "Convert an object into a piece of glamour."
	set category = "Abilities"

	var/list/transmute_list = list(
		"Transparent Glamour" = /obj/item/potion_material/glamour_transparent,
		"Shrinking Glamour" = /obj/item/potion_material/glamour_shrinking,
		"Twinkling Glamour" = /obj/item/potion_material/glamour_twinkling,
		"Glamour Shard" = /obj/item/potion_material/glamour_shard,
		"Glamour Cell" = /obj/item/capture_crystal/glamour,
		"Face of Glamour" = /obj/item/glamour_face,
		"Speaking Glamour" = /obj/item/universal_translator/glamour,
		"Glamour Bubble" = /obj/item/clothing/mask/gas/glamour,
		"Pocket of Glamour" = /obj/item/clothing/under/permit/glamour
		)

	var/energy_cost = 50

	if(species.lleill_energy < energy_cost)
		to_chat(src, "<span class='warning'>You do not have enough energy to do that! You currently have [species.lleill_energy] energy.</span>")
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
		species.lleill_energy -= energy_cost
		species.update_lleill_hud(src)

/datum/power/lleill/rings
	name = "Glamour Rings"
	desc = "Place or teleport to a glamour ring."
	verbpath = /mob/living/carbon/human/proc/lleill_rings
	ability_icon_state = "lleill_ring"

/mob/living/carbon/human/proc/lleill_rings()
	set name = "Place/Use Rings"
	set desc = "Place or teleport to a glamour ring."
	set category = "Abilities"

	var/energy_cost_multi = src.teleporters.len
	var/energy_cost_spawn = (25 * energy_cost_multi)
	var/energy_cost_tele = 50

	if(stat)
		to_chat(src, "<span class='warning'>You can't go do that when weakened like this.</span>")
		return
	if(buckled)
		to_chat(src,"<span class='warning'>You can't do that when restrained.</span>")

	var/r_action = tgui_alert(src, "What would you like to do with your rings? You currently have [species.lleill_energy] energy remaining.", "Actions", list("Spawn New Ring ([energy_cost_spawn])", "Teleport to Ring ([energy_cost_tele])", "Cancel"))
	if(!r_action || r_action == "Cancel")
		return
	if(findtext(r_action,"Spawn New Ring"))
		if(species.lleill_energy < energy_cost_spawn)
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
		species.lleill_energy -= energy_cost_spawn
	if(findtext(r_action,"Teleport to Ring"))
		if(species.lleill_energy < energy_cost_tele)
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
			species.lleill_energy -= energy_cost_tele

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
	species.update_lleill_hud(src)

/datum/power/lleill/contact
	name = "Energy Transfer"
	desc = "Take the energy of another creature by making physical contact with them, the other party must consent. This will make them feel drained."
	verbpath = /mob/living/carbon/human/proc/lleill_contact
	ability_icon_state = "lleill_contact"

/mob/living/carbon/human/proc/lleill_contact()
	set name = "Energy Transfer"
	set desc = "Take the energy of another creature by making physical contact with them, the other party must consent. This will make them feel drained."
	set category = "Abilities"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.

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
		species.lleill_energy = species.lleill_energy_max
		nutrition += (chosen_target.nutrition / 2)
		to_chat(src, "<span class='warning'>You feel revitalised.</span>")
		chosen_target.tiredness += 70
		chosen_target.nutrition = max((chosen_target.nutrition / 2),75)
		chosen_target.remove_blood(40) //removes enough blood to make them feel a bit woozy, mostly just for flavour
		chosen_target.eye_blurry += 20
		to_chat(chosen_target, "<span class='warning'>You feel considerably weakened for the moment.</span>")
	species.update_lleill_hud(src)

/datum/power/lleill/alchemy
	name = "Alchemy (25)"
	desc = "Convert a potion material into a potion without the use of a base or alembic."
	verbpath = /mob/living/carbon/human/proc/lleill_alchemy
	ability_icon_state = "lleill_alchemy"

/mob/living/carbon/human/proc/lleill_alchemy()
	set name = "Alchemy (25)"
	set desc = "Convert a potion material into a potion without the use of a base or alembic."
	set category = "Abilities"

	var/energy_cost = 25


	if(species.lleill_energy < energy_cost)
		to_chat(src, "<span class='warning'>You do not have enough energy to do that! You currently have [species.lleill_energy] energy.</span>")
		return

	if(stat)
		to_chat(src, "<span class='warning'>You can't go do that when weakened like this.</span>")
		return

	var/obj/item/potion_material/I = get_active_hand()
	if(!I)
		to_chat(src, "<span class='warning'>You have no item in your active hand.</span>")
		return

	if(!istype(I))
		to_chat(src, "<span class='warning'>\The [I] is not a potion material.</span>")
		return
	var/obj/item/reagent_containers/glass/bottle/potion/transmute_product = I.product_potion

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
		species.lleill_energy -= energy_cost
	species.update_lleill_hud(src)

/datum/power/lleill/beastform
	name = "Beast Form (100)"
	desc = "Take the form of a non-humanoid creature."
	verbpath = /mob/living/carbon/human/proc/lleill_beast_form
	ability_icon_state = "lleill_beast"

/mob/living/carbon/human/proc/lleill_beast_form()
	set name = "Beast Form (100)"
	set desc = "Take the form of a non-humanoid creature."
	set category = "Abilities"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.

	var/energy_cost = 100

	if(species.lleill_energy < energy_cost)
		to_chat(src, "<span class='warning'>You do not have enough energy to do that! You currently have [species.lleill_energy] energy.</span>")
		return

	var/list/beast_options = list("Rabbit" = /mob/living/simple_mob/vore/rabbit,
									"Red Panda" = /mob/living/simple_mob/vore/redpanda,
									"Fennec" = /mob/living/simple_mob/vore/fennec,
									"Giant Frog" = /mob/living/simple_mob/vore/aggressive/frog,
									"Giant Rat" = /mob/living/simple_mob/vore/aggressive/rat,
									"Wolf" = /mob/living/simple_mob/vore/wolf,
									"Dire Wolf" = /mob/living/simple_mob/vore/wolf/direwolf,
									"Fox" = /mob/living/simple_mob/animal/passive/fox/beastmode,
									"Panther" = /mob/living/simple_mob/vore/aggressive/panther,
									"Giant Snake" = /mob/living/simple_mob/vore/aggressive/giant_snake,
									"Otie" = /mob/living/simple_mob/vore/otie,
									"Squirrel" = /mob/living/simple_mob/vore/squirrel,
									"Raptor" = /mob/living/simple_mob/vore/raptor,
									"Giant Bat" = /mob/living/simple_mob/vore/bat,
									"Horse" = /mob/living/simple_mob/vore/horse,
									"Horse (Big)" = /mob/living/simple_mob/vore/horse/big,
									"Kelpie" = /mob/living/simple_mob/vore/horse/kelpie,
									"Bear" = /mob/living/simple_mob/animal/space/bear/brown/beastmode,
									"Seagull" = /mob/living/simple_mob/vore/seagull,
									"Sheep" = /mob/living/simple_mob/vore/sheep,
									"Azure Tit" = /mob/living/simple_mob/animal/passive/bird/azure_tit/beastmode,
									"Robin" = /mob/living/simple_mob/animal/passive/bird/european_robin/beastmode,
									"Cat" = /mob/living/simple_mob/animal/passive/cat/black/beastmode,
									"Tamaskan Dog" = /mob/living/simple_mob/animal/passive/dog/tamaskan,
									"Corgi" = /mob/living/simple_mob/animal/passive/dog/corgi,
									"Bull Terrier" = /mob/living/simple_mob/animal/passive/dog/bullterrier,
									"Duck" = /mob/living/simple_mob/animal/sif/duck,
									"Cow" = /mob/living/simple_mob/animal/passive/cow,
									"Chicken" = /mob/living/simple_mob/animal/passive/chicken,
									"Goat" = /mob/living/simple_mob/animal/goat,
									"Penguin" = /mob/living/simple_mob/animal/passive/penguin,
									"Goose" = /mob/living/simple_mob/animal/space/goose
									)

	var/chosen_beast = tgui_input_list(src, "Which form would you like to take?", "Choose Beast Form", beast_options)

	if(!chosen_beast)
		return

	if(species.lleill_energy < energy_cost)
		to_chat(src, "<span class='warning'>You do not have enough energy to do that! You currently have [species.lleill_energy] energy.</span>")
		return

	var/mob/living/M = src
	log_debug("polymorph start")
	if(!istype(M))
		log_debug("polymorph istype")
		return

	if(M.stat)	//We can let it undo the TF, because the person will be dead, but otherwise things get weird.
		log_debug("polymorph stat")
		to_chat(src, "<span class='warning'>You can't do that in your condition.</span>")
		return

	if(M.health <= 10)	//We can let it undo the TF, because the person will be dead, but otherwise things get weird.
		log_debug("polymorph injured")
		to_chat(src, "<span class='warning'>You are too injured to transform into a beast.</span>")
		return

	visible_message("<b>\The [src]</b> begins significantly shifting their form.")
	if(!do_after(src, 10 SECONDS, src, exclusive = TASK_USER_EXCLUSIVE))
		visible_message("<b>\The [src]</b> ceases shifting their form.")
		return 0

	var/image/coolanimation = image('icons/obj/glamour.dmi', null, "animation")
	coolanimation.plane = PLANE_LIGHTING_ABOVE
	src.overlays += coolanimation
	spawn(10)
		src.overlays -= coolanimation

		log_debug("polymorph not dead")
		var/mob/living/new_mob = spawn_beast_mob(beast_options[chosen_beast])
		new_mob.faction = M.faction

		if(new_mob && isliving(new_mob))
			species.lleill_energy -= energy_cost
			log_debug("polymorph new_mob")
			for(var/obj/belly/B as anything in new_mob.vore_organs)
				log_debug("polymorph new_mob belly")
				new_mob.vore_organs -= B
				qdel(B)
			new_mob.vore_organs = list()
			new_mob.name = M.name
			new_mob.real_name = M.real_name
			new_mob.verbs |= /mob/living/proc/revert_beast_form
			new_mob.verbs |= /mob/living/proc/set_size
			for(var/lang in M.languages)
				new_mob.languages |= lang
			M.copy_vore_prefs_to_mob(new_mob)
			new_mob.vore_selected = M.vore_selected
			if(ishuman(M))
				log_debug("polymorph ishuman part2")
				var/mob/living/carbon/human/H = M
				if(ishuman(new_mob))
					log_debug("polymorph ishuman(newmob)")
					var/mob/living/carbon/human/N = new_mob
					N.gender = H.gender
					N.identifying_gender = H.identifying_gender
				else
					log_debug("polymorph gender else")
					new_mob.gender = H.gender
			else
				log_debug("polymorph gender else 2")
				new_mob.gender = M.gender
				if(ishuman(new_mob))
					var/mob/living/carbon/human/N = new_mob
					N.identifying_gender = M.gender

			for(var/obj/belly/B as anything in M.vore_organs)
				B.loc = new_mob
				B.forceMove(new_mob)
				B.owner = new_mob
				M.vore_organs -= B
				new_mob.vore_organs += B

			new_mob.ckey = M.ckey
			if(M.ai_holder && new_mob.ai_holder)
				var/datum/ai_holder/old_AI = M.ai_holder
				old_AI.set_stance(STANCE_SLEEP)
				var/datum/ai_holder/new_AI = new_mob.ai_holder
				new_AI.hostile = old_AI.hostile
				new_AI.retaliate = old_AI.retaliate
			M.loc = new_mob
			M.forceMove(new_mob)
			new_mob.tf_mob_holder = M
			new_mob.visible_message("<b>\The [src]</b> has transformed into \the [chosen_beast]!")
	species.update_lleill_hud(src)


/mob/living/carbon/human/proc/spawn_beast_mob(var/chosen_beast)
	log_debug("polymorph proc spawn mob")
	var/tf_type = chosen_beast
	log_debug("polymorph [tf_type]")
	if(!ispath(tf_type))
		log_debug("polymorph tf_type fail")
		return
	log_debug("polymorph tf_type pass")
	var/new_mob = new tf_type(get_turf(src))
	return new_mob

/mob/living/proc/revert_beast_form()
	set name = "Revert Beast Form"
	set desc = "Return to your humanoid form."
	set category = "Abilities"

	if(stat)
		to_chat(src, "<span class='warning'>You can't do that in your condition.</span>")
		return

	visible_message("<b>\The [src]</b> begins significantly shifting their form.")
	if(!do_after(src, 10 SECONDS, src, exclusive = TASK_USER_EXCLUSIVE))
		visible_message("<b>\The [src]</b> ceases shifting their form.")
		return 0
	visible_message("<b>\The [src]</b> has reverted to their original form.")
	revert_mob_tf()


//Hanner variant

/datum/power/lleill/beastform_hanner
	name = "Beast Form (100)"
	desc = "Take the form of a non-humanoid creature."
	verbpath = /mob/living/carbon/human/proc/hanner_beast_form
	ability_icon_state = "lleill_beast"

/mob/living/carbon/human/proc/hanner_beast_form()
	set name = "Beast Form (100)"
	set desc = "Take the form of a non-humanoid creature."
	set category = "Abilities"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.

	var/energy_cost = 100

	if(species.lleill_energy < energy_cost)
		to_chat(src, "<span class='warning'>You do not have enough energy to do that! You currently have [species.lleill_energy] energy.</span>")
		return

	var/list/beast_options = list("Rabbit" = /mob/living/simple_mob/vore/rabbit,
									"Red Panda" = /mob/living/simple_mob/vore/redpanda,
									"Fennec" = /mob/living/simple_mob/vore/fennec,
									"Giant Frog" = /mob/living/simple_mob/vore/aggressive/frog,
									"Giant Rat" = /mob/living/simple_mob/vore/aggressive/rat,
									"Wolf" = /mob/living/simple_mob/vore/wolf,
									"Dire Wolf" = /mob/living/simple_mob/vore/wolf/direwolf,
									"Fox" = /mob/living/simple_mob/animal/passive/fox/beastmode,
									"Panther" = /mob/living/simple_mob/vore/aggressive/panther,
									"Giant Snake" = /mob/living/simple_mob/vore/aggressive/giant_snake,
									"Otie" = /mob/living/simple_mob/vore/otie,
									"Squirrel" = /mob/living/simple_mob/vore/squirrel,
									"Raptor" = /mob/living/simple_mob/vore/raptor,
									"Giant Bat" = /mob/living/simple_mob/vore/bat,
									"Horse" = /mob/living/simple_mob/vore/horse,
									"Horse (Big)" = /mob/living/simple_mob/vore/horse/big,
									"Kelpie" = /mob/living/simple_mob/vore/horse/kelpie,
									"Bear" = /mob/living/simple_mob/animal/space/bear/brown/beastmode,
									"Seagull" = /mob/living/simple_mob/vore/seagull,
									"Sheep" = /mob/living/simple_mob/vore/sheep,
									"Azure Tit" = /mob/living/simple_mob/animal/passive/bird/azure_tit/beastmode,
									"Robin" = /mob/living/simple_mob/animal/passive/bird/european_robin/beastmode,
									"Cat" = /mob/living/simple_mob/animal/passive/cat/black/beastmode,
									"Tamaskan Dog" = /mob/living/simple_mob/animal/passive/dog/tamaskan,
									"Corgi" = /mob/living/simple_mob/animal/passive/dog/corgi,
									"Bull Terrier" = /mob/living/simple_mob/animal/passive/dog/bullterrier,
									"Duck" = /mob/living/simple_mob/animal/sif/duck,
									"Cow" = /mob/living/simple_mob/animal/passive/cow,
									"Chicken" = /mob/living/simple_mob/animal/passive/chicken,
									"Goat" = /mob/living/simple_mob/animal/goat,
									"Penguin" = /mob/living/simple_mob/animal/passive/penguin,
									"Goose" = /mob/living/simple_mob/animal/space/goose
									)

	var/chosen_beast = tgui_input_list(src, "Which form would you like to take?", "Choose Beast Form", beast_options)

	if(!chosen_beast)
		return

	if(species.lleill_energy < energy_cost)
		to_chat(src, "<span class='warning'>You do not have enough energy to do that! You currently have [species.lleill_energy] energy.</span>")
		return

	var/mob/living/M = src
	log_debug("polymorph start")
	if(!istype(M))
		log_debug("polymorph istype")
		return

	if(M.stat)	//We can let it undo the TF, because the person will be dead, but otherwise things get weird.
		log_debug("polymorph stat")
		to_chat(src, "<span class='warning'>You can't do that in your condition.</span>")
		return

	if(M.health <= 10)	//We can let it undo the TF, because the person will be dead, but otherwise things get weird.
		log_debug("polymorph injured")
		to_chat(src, "<span class='warning'>You are too injured to transform into a beast.</span>")
		return

	visible_message("<b>\The [src]</b> begins significantly shifting their form.")
	if(!do_after(src, 10 SECONDS, src, exclusive = TASK_USER_EXCLUSIVE))
		visible_message("<b>\The [src]</b> ceases shifting their form.")
		return 0

	var/image/coolanimation = image('icons/obj/glamour.dmi', null, "animation")
	coolanimation.plane = PLANE_LIGHTING_ABOVE
	src.overlays += coolanimation
	spawn(10)
		src.overlays -= coolanimation

		log_debug("polymorph not dead")
		var/mob/living/simple_mob/new_mob = spawn_beast_mob(beast_options[chosen_beast])
		new_mob.faction = M.faction

		if(new_mob && isliving(new_mob))
			species.lleill_energy -= energy_cost
			log_debug("polymorph new_mob")
			for(var/obj/belly/B as anything in new_mob.vore_organs)
				log_debug("polymorph new_mob belly")
				new_mob.vore_organs -= B
				qdel(B)
			new_mob.vore_organs = list()
			new_mob.name = M.name
			new_mob.real_name = M.real_name
			new_mob.verbs |= /mob/living/proc/revert_beast_form
			new_mob.verbs |= /mob/living/proc/set_size
			new_mob.hasthermals = 0
			new_mob.health = M.health
			new_mob.maxHealth = M.health
			for(var/lang in M.languages)
				new_mob.languages |= lang
			M.copy_vore_prefs_to_mob(new_mob)
			new_mob.vore_selected = M.vore_selected
			if(ishuman(M))
				log_debug("polymorph ishuman part2")
				var/mob/living/carbon/human/H = M
				if(ishuman(new_mob))
					log_debug("polymorph ishuman(newmob)")
					var/mob/living/carbon/human/N = new_mob
					N.gender = H.gender
					N.identifying_gender = H.identifying_gender
				else
					log_debug("polymorph gender else")
					new_mob.gender = H.gender
			else
				log_debug("polymorph gender else 2")
				new_mob.gender = M.gender
				if(ishuman(new_mob))
					var/mob/living/carbon/human/N = new_mob
					N.identifying_gender = M.gender

			for(var/obj/belly/B as anything in M.vore_organs)
				B.loc = new_mob
				B.forceMove(new_mob)
				B.owner = new_mob
				M.vore_organs -= B
				new_mob.vore_organs += B

			new_mob.ckey = M.ckey
			if(M.ai_holder && new_mob.ai_holder)
				var/datum/ai_holder/old_AI = M.ai_holder
				old_AI.set_stance(STANCE_SLEEP)
				var/datum/ai_holder/new_AI = new_mob.ai_holder
				new_AI.hostile = old_AI.hostile
				new_AI.retaliate = old_AI.retaliate
			M.loc = new_mob
			M.forceMove(new_mob)
			new_mob.tf_mob_holder = M
			new_mob.visible_message("<b>\The [src]</b> has transformed into \the [chosen_beast]!")
