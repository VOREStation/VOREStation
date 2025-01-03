
//////////////////////////////
//////VORE-MOB REPLICATOR/////
//////////////////////////////
/obj/machinery/replicator/vore
	name = "alien machine"
	desc = "It's some kind of pod with strange wires and gadgets all over it. This one appears to have a humanoid shaped slot as an input. It has depictions of various creatures on the buttons." //Explain to the user that it turns people into mobs.
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "borgcharger0(old)"
	var/quantity = 18 //This needs to be replaced with a GUI that lets you select the item you want.
	var/list/created_mobs = list()
	var/list/tgui_vore_selection = list()
	var/list/viable_mobs = list(
	/mob/living/simple_mob/animal/passive/fox,
	/mob/living/simple_mob/animal/passive/cow,
	/mob/living/simple_mob/animal/passive/chicken,
	/mob/living/simple_mob/animal/passive/opossum,
	/mob/living/simple_mob/animal/passive/mouse,
	/mob/living/simple_mob/vore/rabbit,
	/mob/living/simple_mob/animal/goat,
	/mob/living/simple_mob/animal/sif/tymisian,
	/mob/living/simple_mob/vore/wolf/direwolf,
	/mob/living/simple_mob/vore/otie/friendly,
	/mob/living/simple_mob/vore/alienanimals/catslug,
	/mob/living/simple_mob/vore/fennec,
	/mob/living/simple_mob/vore/xeno_defanged,
	/mob/living/simple_mob/vore/redpanda/fae,
	/mob/living/simple_mob/vore/aggressive/rat,
	/mob/living/simple_mob/vore/aggressive/panther,
	/mob/living/simple_mob/vore/aggressive/frog
	)
	//Mostly friendly mobs, but occasionally some dangerous ones.
	//So if xenoarch isn't careful and is just shoving items willy-nilly without taking the proper precautions they can end up in a bit of trouble!


/obj/machinery/replicator/vore/New() //This replicator turns people into mobs!
	..() //TODO: Someone can replace the 'alien' interface with something neater sometime. It is simply out of my abilities at the current moment.

	for(var/i=0, i<quantity, i++)
		var/background = pick("yellow","purple","green","blue","red","orange","white")
		var/list/icons = list(
			"round" = "circle",
			"square" = "square",
			"diamond" = "gem",
			"heart" = "heart",
			"dog" = "dog",
			"human" = "user",
		)
		var/icon = pick(icons)
		var/list/colors = list(
			"toggle" = "pink",
			"switch" = "yellow",
			"lever" = "red",
			"button" = "black",
			"pad" = "white",
			"hole" = "black",
		)
		var/color = pick(colors)
		var/button_desc = "a [background], [icon] shaped [color]"
		var/generated_mob = pick(viable_mobs)
		viable_mobs.Remove(type)
		created_mobs[button_desc] = generated_mob
		tgui_vore_selection.Add(list(list(
			"key" = button_desc,
			"background" = background,
			"icon" = icons[icon],
			"foreground" = colors[color],
		)))

/obj/machinery/replicator/vore/process()
	if(spawning_types.len && powered())
		spawn_progress_time += world.time - last_process_time
		if(spawn_progress_time > max_spawn_time)
			src.visible_message(span_notice("[icon2html(src,viewers(src))] [src] pings!"))

			var/obj/source_material = pop(stored_materials)
			var/spawn_type = pop(spawning_types)
			var/mob/living/simple_mob/new_mob = new spawn_type(src.loc) //The MOB that's spawned in.

			if(source_material)
				if(length(source_material.name) < MAX_MESSAGE_LEN)
					new_mob.name = "[source_material] " +  new_mob.name
				if(length(source_material.desc) < MAX_MESSAGE_LEN * 2)
					if(new_mob.desc)
						new_mob.desc += " It is made of [source_material]."
					else
						new_mob.desc = "It is made of [source_material]."
			//Did they use an item? If so, we're done here.

			//Did they put a micro in it?
			if(istype(source_material,/obj/item/holder/micro))
				var/obj/item/holder/micro/micro_holder = source_material
				var/mob/mob_to_be_changed = micro_holder.held_mob
				var/mob/living/M = mob_to_be_changed
				//Start of mob code shamelessly ripped from mouseray
				new_mob.faction = M.faction

				if(new_mob && isliving(new_mob))
					for(var/obj/belly/B as anything in new_mob.vore_organs)
						new_mob.vore_organs -= B
						qdel(B)
					new_mob.vore_organs = list()
					new_mob.name = M.name
					new_mob.real_name = M.real_name
					for(var/lang in M.languages)
						new_mob.languages |= lang
					M.copy_vore_prefs_to_mob(new_mob)
					new_mob.vore_selected = M.vore_selected
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(ishuman(new_mob))
							var/mob/living/carbon/human/N = new_mob
							N.gender = H.gender
							N.identifying_gender = H.identifying_gender
						else
							new_mob.gender = H.identifying_gender
					else
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
					///End of mobcode.
					qdel(source_material)
				M.forceMove(new_mob)

			//Did they put a person in it?
			else if(isliving(source_material))
				var/mob/living/M = source_material
				//Start of mob code shamelessly ripped from mouseray
				new_mob.faction = M.faction

				if(new_mob && isliving(new_mob))
					for(var/obj/belly/B as anything in new_mob.vore_organs)
						new_mob.vore_organs -= B
						qdel(B)
					new_mob.vore_organs = list()
					new_mob.name = M.name
					new_mob.real_name = M.real_name
					for(var/lang in M.languages)
						new_mob.languages |= lang
					M.copy_vore_prefs_to_mob(new_mob)
					new_mob.vore_selected = M.vore_selected
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(ishuman(new_mob))
							var/mob/living/carbon/human/N = new_mob
							N.gender = H.gender
							N.identifying_gender = H.identifying_gender
						else
							new_mob.gender = H.identifying_gender
					else
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
					///End of mobcode.


			spawn_progress_time = 0
			max_spawn_time = rand(30,100)

			if(!spawning_types.len || !stored_materials.len)
				update_use_power(USE_POWER_IDLE)
				icon_state = "borgcharger0(old)"

		else if(prob(5))
			src.visible_message(span_notice("[icon2html(src,viewers(src))] [src] [pick("clicks","whizzes","whirrs","whooshes","clanks","clongs","clonks","bangs")]."))

	last_process_time = world.time


/obj/machinery/replicator/vore/attackby(obj/item/W as obj, mob/living/user as mob)
	if(!W.canremove || !user.canUnEquip(W) || W.possessed_voice || is_type_in_list(W,item_vore_blacklist)) //No armblades, no putting possessed items in it!
		to_chat(user, span_notice("You cannot put \the [W] into the machine."))
		return
	if(istype(W, /obj/item/holder/micro)) //Are you putting a micro in it?
		var/obj/item/holder/micro/micro_holder = W
		var/mob/living/inserted_mob = micro_holder.held_mob //Get the actual mob.
		if(!inserted_mob.allow_spontaneous_tf) //Do they allow TF?
			to_chat(user, span_notice("You cannot put \the [W] into the machine. ((The prefs of the micro forbid this action.))"))
			return
		if(inserted_mob.stat == DEAD) //Hey medical...
			to_chat(user, span_notice("[W] is dead."))
			return
		if(inserted_mob.tf_mob_holder)
			to_chat(user, span_notice("[W] must be in their original form."))
			return
		if(inserted_mob.client)
			var/response //Let's see if they are SURE they accept the fact they will be a clothing, plushie, or something else.
			response = tgui_alert(inserted_mob, "Are you -sure- you want to be put in this machine?\n(This machine will turn you into one of the various types of mobs in the game.)", "WARNING: Are you sure you want to be put in the machine and transformed?", list("No", "Certain"))
			if(response != "Certain") //If they don't agree, stop.
				to_chat(user, span_notice("[W] stops you from placing them in the machine."))
				return
			else //If they /do/ agree, give them one last chance.
				response = tgui_alert(inserted_mob, "This is the last warning: Are you absolutely certain you want to be transformed into a mob?", "WARNING: FINAL CHANCE!", list("No", "Certain"))
				if(response != "Certain")
					to_chat(user, span_notice("[W] stops you from placing them in the machine."))
					return
				if(isvoice(inserted_mob) || W.loc == src) //Sanity.
					return
				log_and_message_admins("[user] has just placed [inserted_mob] into a mob transformation machine.", user)
		else
			to_chat(user, span_notice("You cannot put \the [W] into the machine. ((The micro must be connected to the server.))"))
			return
	else if(istype(W,/obj/item/grab)) //Is someone being shoved into the machine?
		var/obj/item/grab/the_grab = W
		var/mob/living/inserted_mob = the_grab.affecting //Get the mob that is grabbed.
		if(!inserted_mob.allow_spontaneous_tf)
			to_chat(user, span_notice("You cannot put \the [W] into the machine. ((The prefs of the micro forbid this action.))"))
			return
		if(inserted_mob.stat == DEAD)
			to_chat(user, span_notice("[W] is dead."))
			return
		if(inserted_mob.tf_mob_holder)
			to_chat(user, span_notice("[W] must be in their original form."))
			return
		if(inserted_mob.client)
			var/response
			response = tgui_alert(inserted_mob, "Are you -sure- you want to be put in this machine?\n(This machine will turn you into one of the various types of mobs in the game.)", "WARNING: Are you sure you want to be put in the machine and transformed?", list("No", "Certain"))
			if(response != "Certain")
				to_chat(user, span_notice("[W] stops you from placing them in the machine."))
				return
			else
				response = tgui_alert(inserted_mob, "This is the last warning: Are you absolutely certain you want to be transformed into a mob?", "WARNING: FINAL CHANCE!", list("No", "Certain"))
				if(response != "Certain")
					to_chat(user, span_notice("[W] stops you from placing them in the machine."))
					return
				if(isvoice(inserted_mob) || W.loc == src)
					return
				log_and_message_admins("[user] has just placed [inserted_mob] into a mob transformation machine.", user)
				user.drop_item() //Dropping a grab destroys it.
				//Grabs require a bit of extra work.
				//We want them to drop their clothing/items as well.
				if(ishuman(inserted_mob)) //So, this WORKS. Works very well!
					var/mob/living/carbon/human/inserted_human = inserted_mob
					for(var/obj/item/I in inserted_mob)
						if(istype(I, /obj/item/implant) || istype(I, /obj/item/nif))
							continue
						inserted_human.drop_from_inventory(I)
				inserted_mob.loc = src
				stored_materials.Add(inserted_mob)
				src.visible_message(span_filter_notice(span_bold("\The [user]") + " inserts \the [inserted_mob] into \the [src]."))
				return
		else
			to_chat(user, span_notice("You cannot put \the [W] into the machine. ((The micro must be connected to the server.))"))
			return
	else if(istype(W, /obj/item/holder/mouse)) //No you can't turn your army of mice into giant rats.
		to_chat(user, span_notice("You cannot put \the [W] into the machine. The machine reads 'NOT ENOUGH BIOMASS'."))
		return
	user.drop_item() //Put the micro on the floor (or drop the item)
	if(istype(W, /obj/item/holder/micro)) //I hate this but it's the only way to get their stuff to drop.
		var/obj/item/holder/micro/micro_holder = W
		var/mob/living/inserted_mob = micro_holder.held_mob //Get the actual mob.
		if(ishuman(inserted_mob)) //Only humans have the drop_from_inventory proc.
			var/mob/living/carbon/human/inserted_human = inserted_mob
			for(var/obj/item/I in inserted_human) //Drop any remaining items! This only really seems to affect hands.
				if(istype(I, /obj/item/implant) || istype(I, /obj/item/nif))
					continue
				inserted_human.drop_from_inventory(I)
			//Now that we've dropped all the items they have, let's shove them back into the micro holder.
	W.loc = src
	stored_materials.Add(W)
	src.visible_message(span_filter_notice(span_bold("\The [user]") + " inserts \the [W] into \the [src]."))

/obj/machinery/replicator/vore/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["tgui_construction"] = tgui_vore_selection
	return data

/obj/machinery/replicator/vore/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("construct")
			var/key = params["key"]
			if(key in created_mobs)
				if(LAZYLEN(stored_materials) > LAZYLEN(spawning_types))
					if(LAZYLEN(spawning_types))
						visible_message(span_notice("[icon2html(src,viewers(src))] a [pick("light","dial","display","meter","pad")] on [src]'s front [pick("blinks","flashes")] [pick("red","yellow","blue","orange","purple","green","white")]."))
					else
						visible_message(span_notice("[icon2html(src,viewers(src))] [src]'s front compartment slides shut."))
					spawning_types.Add(created_mobs[key])
					spawn_progress_time = 0
					update_use_power(USE_POWER_ACTIVE)
					icon_state = "borgcharger1(old)"
				else
					visible_message(fail_message)


/obj/machinery/replicator/clothing/tgui_interact(mob/user, datum/tgui/ui) //This creates the menu.
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenoarchReplicator_voremob_vr", name)
		ui.open()





//////////////////////////////
//////CLOTHING REPLICATOR/////
//////////////////////////////

/obj/machinery/replicator/clothing
	name = "alien machine"
	desc = "It's some kind of pod with strange wires and gadgets all over it. This one appears to have a humanoid shaped slot as an input and images of various objects on the buttons." //This hole was made for me!
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "borgcharger0(old)"
	var/quantity = 35 //This needs to be replaced with a GUI that lets you select the item you want.
	var/list/created_items = list()
	var/list/tgui_vore_selection = list()
	var/list/viable_items = list(
	/obj/item/clothing/accessory/ring,
	/obj/item/clothing/gloves/evening,
	/obj/item/clothing/gloves/black,
	/obj/item/clothing/under/swimsuit/black,
	/obj/item/clothing/under/shorts/black,
	/obj/item/clothing/under/wetsuit_skimpy,
	/obj/item/clothing/under/dress/maid,
	/obj/item/clothing/under/fluff/latexmaid,
	/obj/item/clothing/suit/oversize,
	/obj/item/clothing/suit/kimono/red,
	/obj/item/clothing/suit/storage/fluff/loincloth,
	/obj/item/toy/plushie/lizardplushie/kobold,
	/obj/item/toy/plushie/borgplushie/medihound,
	/obj/item/toy/plushie/marble_fox,
	/obj/item/toy/plushie/lizard,
	/obj/item/toy/plushie/tuxedo_cat,
	/obj/item/clothing/head/pin/flower,
	/obj/item/clothing/head/wizard,
	/obj/item/clothing/head/wizard/marisa,
	/obj/item/clothing/head/beret,
	/obj/item/clothing/head/that,
	/obj/item/clothing/head/bowler,
	/obj/item/clothing/shoes/hitops/red,
	/obj/item/clothing/shoes/boots/jackboots,
	/obj/item/clothing/shoes/boots/workboots,
	/obj/item/clothing/shoes/boots/workboots/toeless,
	/obj/item/clothing/shoes/flipflop,
	/obj/item/clothing/shoes/boots/duty,
	/obj/item/clothing/shoes/footwraps,
	/obj/item/storage/smolebrickcase,
	/obj/item/lipstick,
	/obj/item/material/fishing_rod/modern,
	/obj/item/inflatable_duck,
	/obj/item/toy/syndicateballoon,
	/obj/item/towel,
	/obj/item/bedsheet/rainbowdouble
	) 	// Currently: 3 gloves, 5 undersuits, 3 oversuits, 5 plushies, 5 headwear, 7 shoes, 7 misc. = 35
		//Fishing hat was going to be added, but it was simply too powerful for this world.

/obj/machinery/replicator/clothing/New() //The specific thing about the VORE replicator is that it will only contain obj/items. Only things that can be picked up, used, and worn!
	..() //TODO: Someone can replace the 'alien' interface with something neater sometime. It is simply out of my abilities at the current moment.

	for(var/i=0, i<quantity, i++)
		var/background = pick("yellow","purple","green","blue","red","orange","white")
		var/list/icons = list(
			"round" = "circle",
			"square" = "square",
			"diamond" = "gem",
			"heart" = "heart",
			"dog" = "dog",
			"human" = "user",
		)
		var/icon = pick(icons)
		var/list/colors = list(
			"toggle" = "pink",
			"switch" = "yellow",
			"lever" = "red",
			"button" = "black",
			"pad" = "white",
			"hole" = "black",
		)
		var/color = pick(colors)
		var/button_desc = "a [background], [icon] shaped [color]"
		var/generated_item = pick(viable_items)
		viable_items.Remove(type)
		created_items[button_desc] = generated_item
		tgui_vore_selection.Add(list(list(
			"key" = button_desc,
			"background" = background,
			"icon" = icons[icon],
			"foreground" = colors[color],
		)))

/obj/machinery/replicator/clothing/process()
	if(spawning_types.len && powered())
		spawn_progress_time += world.time - last_process_time
		if(spawn_progress_time > max_spawn_time)
			src.visible_message(span_notice("[icon2html(src,viewers(src))] [src] pings!"))

			var/obj/source_material = pop(stored_materials)
			var/spawn_type = pop(spawning_types)
			var/obj/item/spawned_obj = new spawn_type(src.loc)
			var/obj/item/original_name = spawned_obj.name //Get the item's name before it's prefixed. Used for micro code.
			if(source_material)
				if(length(source_material.name) < MAX_MESSAGE_LEN)
					spawned_obj.name = "[source_material] " +  spawned_obj.name
				if(length(source_material.desc) < MAX_MESSAGE_LEN * 2)
					if(spawned_obj.desc)
						spawned_obj.desc += " It is made of [source_material]."
					else
						spawned_obj.desc = "It is made of [source_material]."
			if(istype(source_material,/obj/item/holder/micro))
				var/obj/item/holder/micro/micro_holder = source_material //Tells the machine that a micro is the material being used
				var/mob/mob_to_be_changed = micro_holder.held_mob //Get the mob.
				var/mob/living/M = mob_to_be_changed
				M.release_vore_contents(TRUE, TRUE) //Release their stomach contents. Don't spam the chat, either.
				spawned_obj.inhabit_item(M, original_name, M) //Take the spawned mob and call the TF proc on it.
				var/mob/living/possessed_voice = spawned_obj.possessed_voice //Get the possessed voice.
				qdel(source_material) 	//Deletes the micro holder, we don't need it anymore.
				spawned_obj.trash_eatable = M.devourable //Can this item be eaten? Let's decide based on the person's prefs!
				spawned_obj.unacidable = !M.digestable //Can this item be digested?
				M.forceMove(possessed_voice) //Places them in the 'voice' for later recovery! Essentially: The item contains a 'possessed voice' mob, which contains their original mob.


			else if(isliving(source_material))//Did they shove a person in there normally?
				var/mob/living/M = source_material //If so, this cuts down the work we have to do!
				M.release_vore_contents(TRUE, TRUE) //Release their stomach contents. Don't spam the chat, either.
				spawned_obj.inhabit_item(M, original_name, M)
				var/mob/living/possessed_voice = spawned_obj.possessed_voice
				spawned_obj.trash_eatable = M.devourable
				spawned_obj.unacidable = !M.digestable
				M.forceMove(possessed_voice)


			spawn_progress_time = 0
			max_spawn_time = rand(30,100)

			if(!spawning_types.len || !stored_materials.len)
				update_use_power(USE_POWER_IDLE)
				icon_state = "borgcharger0(old)"

		else if(prob(5))
			src.visible_message(span_notice("[icon2html(src,viewers(src))] [src] [pick("clicks","whizzes","whirrs","whooshes","clanks","clongs","clonks","bangs")]."))

	last_process_time = world.time

/obj/machinery/replicator/clothing/attackby(obj/item/W as obj, mob/living/user as mob)
	if(!W.canremove || !user.canUnEquip(W) || W.possessed_voice || is_type_in_list(W,item_vore_blacklist)) //No armblades, no putting already possessed items in it!
		to_chat(user, span_notice("You cannot put \the [W] into the machine."))
		return
	if(istype(W, /obj/item/holder/micro) || istype(W, /obj/item/holder/mouse)) //Are you putting a micro/mouse in it?
		var/obj/item/holder/micro/micro_holder = W
		var/mob/living/inserted_mob = micro_holder.held_mob //Get the actual mob.
		if(!inserted_mob.allow_spontaneous_tf) //Do they allow TF?
			to_chat(user, span_notice("You cannot put \the [W] into the machine. ((The prefs of the micro forbid this action.))"))
			return
		if(inserted_mob.stat == DEAD) //Hey medical...
			to_chat(user, span_notice("[W] is dead."))
			return
		if(inserted_mob.tf_mob_holder) //No recursion!!!
			to_chat(user, span_notice("[W] must be in their original form."))
			return
		if(inserted_mob.client)
			var/response //Let's see if they are SURE they accept the fact they will be a clothing, plushie, or something else.
			response = tgui_alert(inserted_mob, "Are you -sure- you want to be put in this machine?\n(This machine can turn you into various clothing, footwear, plushies, and other miscellaneous objects. This means that more likely than not, you will be used as whatever object is used. Make certain your preferences align with this possibility.)", "WARNING: Are you sure you want to be put in the machine and transformed?", list("No", "Certain"))
			if(response != "Certain") //If they don't agree, stop.
				to_chat(user, span_notice("[W] stops you from placing them in the machine."))
				return
			else //If they /do/ agree, give them one last chance.
				response = tgui_alert(inserted_mob, "This is the last warning: Are you absolutely certain you want to be transformed into an object and have the possibility of being used as such?", "WARNING: FINAL CHANCE!", list("No", "I accept the possibilities"))
				if(response != "I accept the possibilities")
					to_chat(user, span_notice("[W] stops you from placing them in the machine."))
					return
				if(isvoice(inserted_mob) || W.loc == src) //This is a sanity check to keep them from entering it multiple times.
					return
				log_and_message_admins("[user] has just placed [inserted_mob] into an item transformation machine.", user)
		else
			to_chat(user, span_notice("You cannot put \the [W] into the machine. ((The micro must be connected to the server.))"))
			return
	else if(istype(W,/obj/item/grab)) //Is someone being shoved into the machine?
		var/obj/item/grab/the_grab = W
		var/mob/living/inserted_mob = the_grab.affecting //Get the mob that is grabbed.
		if(!inserted_mob.allow_spontaneous_tf)
			to_chat(user, span_notice("You cannot put \the [W] into the machine. ((The prefs of the micro forbid this action.))"))
			return
		if(inserted_mob.stat == DEAD)
			to_chat(user, span_notice("[W] is dead."))
			return
		if(inserted_mob.tf_mob_holder)
			to_chat(user, span_notice("[W] must be in their original form."))
			return
		if(inserted_mob.client)
			var/response
			response = tgui_alert(inserted_mob, "Are you -sure- you want to be put in this machine?\n(This machine can turn you into various clothing, footwear, plushies, and other miscellaneous objects. This means that more likely than not, you will be used as whatever object is used. Make certain your preferences align with this possibility.)", "WARNING: Are you sure you want to be put in the machine and transformed?", list("No", "Certain"))
			if(response != "Certain")
				to_chat(user, span_notice("[W] stops you from placing them in the machine."))
				return
			else
				response = tgui_alert(inserted_mob, "This is the last warning: Are you absolutely certain you want to be transformed into an object and have the possibility of being used as such?", "WARNING: FINAL CHANCE!", list("No", "I accept the possibilities"))
				if(response != "I accept the possibilities")
					to_chat(user, span_notice("[W] stops you from placing them in the machine."))
					return
				if(isvoice(inserted_mob) || W.loc == src)
					return
				log_and_message_admins("[user] has just placed [inserted_mob] into an item transformation machine.", user)
				user.drop_item() //Dropping a grab destroys it.
				//Grabs require a bit of extra work.
				//We want them to drop their clothing/items as well.
				if(ishuman(inserted_mob)) //So, this WORKS. Works very well!
					var/mob/living/carbon/human/inserted_human = inserted_mob
					for(var/obj/item/I in inserted_mob)
						if(istype(I, /obj/item/implant) || istype(I, /obj/item/nif))
							continue
						inserted_human.drop_from_inventory(I)
				inserted_mob.loc = src
				stored_materials.Add(inserted_mob)
				src.visible_message(span_filter_notice(span_bold("\The [user]") + " inserts \the [inserted_mob] into \the [src]."))
				return
		else
			to_chat(user, span_notice("You cannot put \the [W] into the machine. ((They must be connected to the server.))"))
			return

	user.drop_item() //Put the micro on the floor (or drop the item)
	if(istype(W, /obj/item/holder/micro)) //I hate this but it's the only way to get their stuff to drop.
		var/obj/item/holder/micro/micro_holder = W
		var/mob/living/inserted_mob = micro_holder.held_mob //Get the actual mob.
		if(ishuman(inserted_mob)) //Only humans have the drop_from_inventory proc.
			var/mob/living/carbon/human/inserted_human = inserted_mob
			for(var/obj/item/I in inserted_human) //Drop any remaining items! This only really seems to affect hands.
				if(istype(I, /obj/item/implant) || istype(I, /obj/item/nif))
					continue
				inserted_human.drop_from_inventory(I)
			//Now that we've dropped all the items they have, let's shove them back into the micro holder.
	W.loc = src
	stored_materials.Add(W)
	src.visible_message(span_filter_notice(span_bold("\The [user]") + " inserts \the [W] into \the [src]."))


/obj/machinery/replicator/clothing/tgui_interact(mob/user, datum/tgui/ui) //This creates the menu.
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenoarchReplicator_clothing_vr", name) //This is required to prevent UI contamination.
		ui.open()

/obj/machinery/replicator/clothing/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state) //Gives data to the menu.
	var/list/data = ..()
	data["tgui_construction"] = tgui_vore_selection
	return data

/obj/machinery/replicator/clothing/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("construct")
			var/key = params["key"]
			if(key in created_items)
				if(LAZYLEN(stored_materials) > LAZYLEN(spawning_types))
					if(LAZYLEN(spawning_types))
						visible_message(span_notice("[icon2html(src,viewers(src))] a [pick("light","dial","display","meter","pad")] on [src]'s front [pick("blinks","flashes")] [pick("red","yellow","blue","orange","purple","green","white")]."))
					else
						visible_message(span_notice("[icon2html(src,viewers(src))] [src]'s front compartment slides shut."))
					spawning_types.Add(created_items[key])
					spawn_progress_time = 0
					update_use_power(USE_POWER_ACTIVE)
					icon_state = "borgcharger1(old)"
				else
					visible_message(fail_message)
