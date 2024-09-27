/client/proc/player_effects(var/mob/target in mob_list)
	set name = "Player Effects"
	set desc = "Modify a player character with various 'special treatments' from a list."
	set category = "Fun"
	if(!check_rights(R_FUN))
		return

	var/datum/eventkit/player_effects/spawner = new()
	spawner.target = target
	spawner.user = src.mob
	spawner.tgui_interact(src.mob)

/datum/eventkit/player_effects
	var/mob/target //The target of the effects
	var/mob/user

/datum/eventkit/player_effects/New()
	. = ..()

/datum/eventkit/player_effects/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlayerEffects", "Player Effects")
		ui.open()

/datum/eventkit/player_effects/Destroy()
	. = ..()

/datum/eventkit/player_effects/tgui_static_data(mob/user)
	var/list/data = list()

	data["real_name"] = target.name;
	data["player_ckey"] = target.ckey;
	data["target_mob"] = target;


	return data

/datum/eventkit/player_effects/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/eventkit/player_effects/tgui_act(action)
	. = ..()
	if(.)
		return
	if(!check_rights_for(usr.client, R_SPAWN))
		return

	log_and_message_admins("[key_name(user)] used player effect: [action] on [target.ckey] playing [target.name]")

	switch(action)

		////////////SMITES/////////////
		if("break_legs")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/broken_legs = 0
			var/obj/item/organ/external/left_leg = Tar.get_organ(BP_L_LEG)
			if(left_leg && left_leg.fracture())
				broken_legs++
			var/obj/item/organ/external/right_leg = Tar.get_organ(BP_R_LEG)
			if(right_leg && right_leg.fracture())
				broken_legs++
			if(!broken_legs)
				to_chat(user,"[target] didn't have any breakable legs, sorry.")

		if("bluespace_artillery")
			bluespace_artillery(target,src)

		if("spont_combustion")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.adjust_fire_stacks(10)
			Tar.IgniteMob()
			Tar.visible_message(span_danger("[target] bursts into flames!"))

		if("lightning_strike")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/turf/T = get_step(get_step(target, NORTH), NORTH)
			T.Beam(target, icon_state="lightning[rand(1,12)]", time = 5)
			Tar.electrocute_act(75,def_zone = BP_HEAD)
			target.visible_message(span_danger("[target] is struck by lightning!"))

		if("shadekin_attack")
			var/turf/Tt = get_turf(target) //Turf for target

			if(target.loc != Tt)
				return //Too hard to attack someone in something

			var/turf/Ts //Turf for shadekin

			//Try to find nondense turf
			for(var/direction in cardinal)
				var/turf/T = get_step(target,direction)
				if(T && !T.density)
					Ts = T //Found shadekin spawn turf
			if(!Ts)
				return //Didn't find shadekin spawn turf

			var/mob/living/simple_mob/shadekin/red/shadekin = new(Ts)
			//Abuse of shadekin
			shadekin.real_name = shadekin.name
			shadekin.init_vore()
			shadekin.ability_flags |= 0x1
			shadekin.phase_shift()
			shadekin.ai_holder.give_target(target)
			shadekin.ai_holder.hostile = FALSE
			shadekin.ai_holder.mauling = TRUE
			shadekin.Life()
			//Remove when done
			spawn(10 SECONDS)
				if(shadekin)
					shadekin.death()

		if("shadekin_vore")
			var/static/list/kin_types = list(
				"Red Eyes (Dark)" =	/mob/living/simple_mob/shadekin/red/dark,
				"Red Eyes (Light)" = /mob/living/simple_mob/shadekin/red/white,
				"Red Eyes (Brown)" = /mob/living/simple_mob/shadekin/red/brown,
				"Blue Eyes (Dark)" = /mob/living/simple_mob/shadekin/blue/dark,
				"Blue Eyes (Light)" = /mob/living/simple_mob/shadekin/blue/white,
				"Blue Eyes (Brown)" = /mob/living/simple_mob/shadekin/blue/brown,
				"Purple Eyes (Dark)" = /mob/living/simple_mob/shadekin/purple/dark,
				"Purple Eyes (Light)" = /mob/living/simple_mob/shadekin/purple/white,
				"Purple Eyes (Brown)" = /mob/living/simple_mob/shadekin/purple/brown,
				"Yellow Eyes (Dark)" = /mob/living/simple_mob/shadekin/yellow/dark,
				"Yellow Eyes (Light)" = /mob/living/simple_mob/shadekin/yellow/white,
				"Yellow Eyes (Brown)" = /mob/living/simple_mob/shadekin/yellow/brown,
				"Green Eyes (Dark)" = /mob/living/simple_mob/shadekin/green/dark,
				"Green Eyes (Light)" = /mob/living/simple_mob/shadekin/green/white,
				"Green Eyes (Brown)" = /mob/living/simple_mob/shadekin/green/brown,
				"Orange Eyes (Dark)" = /mob/living/simple_mob/shadekin/orange/dark,
				"Orange Eyes (Light)" = /mob/living/simple_mob/shadekin/orange/white,
				"Orange Eyes (Brown)" = /mob/living/simple_mob/shadekin/orange/brown,
				"Rivyr (Unique)" = /mob/living/simple_mob/shadekin/blue/rivyr)
			var/kin_type = tgui_input_list(usr, "Select the type of shadekin for [target] nomf","Shadekin Type Choice", kin_types)
			if(!kin_type || !target)
				return


			kin_type = kin_types[kin_type]

			var/myself = tgui_alert(usr, "Control the shadekin yourself or delete pred and prey after?","Control Shadekin?",list("Control","Cancel","Delete"))
			if(!myself || myself == "Cancel" || !target)
				return

			var/turf/Tt = get_turf(target)

			if(target.loc != Tt)
				return //Can't nom when not exposed

			//Begin abuse
			target.transforming = TRUE //Cheap hack to stop them from moving
			var/mob/living/simple_mob/shadekin/shadekin = new kin_type(Tt)
			shadekin.real_name = shadekin.name
			shadekin.init_vore()
			shadekin.can_be_drop_pred = TRUE
			shadekin.dir = SOUTH
			shadekin.ability_flags |= 0x1
			shadekin.phase_shift() //Homf
			shadekin.energy = initial(shadekin.energy)
			//For fun
			sleep(1 SECOND)
			shadekin.dir = WEST
			sleep(1 SECOND)
			shadekin.dir = EAST
			sleep(1 SECOND)
			shadekin.dir = SOUTH
			sleep(1 SECOND)
			shadekin.audible_message("<b>[shadekin]</b> belches loudly!", runemessage = "URRRRRP")
			sleep(2 SECONDS)
			shadekin.phase_shift()
			target.transforming = FALSE //Undo cheap hack

			if(myself == "Control") //Put admin in mob
				shadekin.ckey = target.ckey

			else //Permakin'd
				to_chat(target,span_danger("You're carried off into The Dark by the [shadekin]. Who knows if you'll find your way back?"))
				target.ghostize()
				qdel(target)
				qdel(shadekin)


		if("redspace_abduct")
			redspace_abduction(target, src)

		if("autosave")
			fake_autosave(target, src)

		if("autosave2")
			fake_autosave(target, src, TRUE)

		if("adspam")
			if(target.client)
				target.client.create_fake_ad_popup_multiple(/obj/screen/popup/default, 15)

		if("peppernade")
			var/obj/item/weapon/grenade/chem_grenade/teargas/grenade = new /obj/item/weapon/grenade/chem_grenade/teargas
			grenade.loc = target.loc
			to_chat(target,span_warning("GRENADE?!"))
			grenade.detonate()

		if("spicerequest")
			var/obj/item/weapon/reagent_containers/food/condiment/spacespice/spice = new /obj/item/weapon/reagent_containers/food/condiment/spacespice
			spice.loc = target.loc
			to_chat(target,"A bottle of spices appears at your feet... be careful what you wish for!")

		if("terror")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.fear = 200

		if("terror_aoe")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			for(var/mob/living/carbon/human/L in orange(Tar.client.view, Tar))
				L.fear = 200
			Tar.fear = 200

		if("spin")
			var/speed = tgui_input_number(user, "Spin speed (minimum 0.1):", "Speed")
			if(speed < 0.1)
				return
			var/loops = tgui_input_number(user, "Number of loops (-1 for infinite):", "Loops")
			var/direction_ask = tgui_alert(user, "Clockwise or Anti-Clockwise", "Direction", list("Clockwise", "Anti-Clockwise", "Cancel"))
			var/direction
			if(direction_ask == "Clockwise")
				direction = 1
			if(direction_ask == "Anti-Clockwise")
				direction = 0
			if(direction_ask == "Cancel")
				return
			target.SpinAnimation(speed, loops, direction)

		if("squish")
			var/is_squished = target.tf_scale_x || target.tf_scale_y
			playsound(target, 'sound/items/hooh.ogg', 50, 1)
			if(!is_squished)
				target.SetTransform(null, (target.size_multiplier * 1.2), (target.size_multiplier * 0.5))
			else
				target.ClearTransform()
				target.update_transform()

		if("pie_splat")
			new/obj/effect/decal/cleanable/pie_smudge(get_turf(target))
			playsound(target, 'sound/effects/slime_squish.ogg', 100, 1, get_rand_frequency(), falloff = 5)
			target.Weaken(1)
			target.visible_message(span_danger("[target] is struck by pie!"))

		if("spicy_air")
			to_chat(target, span_warning("Spice spice baby!"))
			target.eye_blurry = max(target.eye_blurry, 25)
			target.Blind(10)
			target.Stun(5)
			target.Weaken(5)
			playsound(target, 'sound/effects/spray2.ogg', 100, 1, get_rand_frequency(), falloff = 5)

		if("hot_dog")
			playsound(target, 'sound/effects/whistle.ogg', 50, 1, get_rand_frequency(), falloff = 5)
			sleep(2 SECONDS)
			target.Stun(10)
			if(!ishuman(target))
				return
			var/mob/living/carbon/human/H = target
			if(H.head)
				H.unEquip(H.head)
			if(H.wear_suit)
				H.unEquip(H.wear_suit)
			var/obj/item/clothing/suit = new /obj/item/clothing/suit/storage/hooded/foodcostume/hotdog
			var/obj/item/clothing/hood = new /obj/item/clothing/head/hood_vr/hotdog_hood
			H.equip_to_slot_if_possible(suit, slot_wear_suit, 0, 0, 1)
			H.equip_to_slot_if_possible(hood, slot_head, 0, 0, 1)
			sleep(5 SECONDS)
			qdel(suit)
			qdel(hood)

		if("mob_tf")
			var/mob/living/M = target

			if(!istype(M))
				return

			var/list/types = typesof(/mob/living)
			var/chosen_beast = tgui_input_list(user, "Which form would you like to take?", "Choose Beast Form", types)

			if(!chosen_beast)
				return

			var/mob/living/new_mob = new chosen_beast(get_turf(M))
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
						new_mob.gender = H.gender
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

		////////MEDICAL//////////////

		if("appendicitis")
			var/mob/living/carbon/human/Tar = target
			if(istype(Tar))
				Tar.appendicitis()

		if("damage_organ")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/organs = list()
			for(var/obj/item/organ/I in Tar.organs)
				organs |= I
			for(var/obj/item/organ/I in Tar.internal_organs)
				organs |= I
			var/obj/item/organ/our_organ = tgui_input_list(user, "Choose an organ to damage:", "Organs", organs)
			if(!our_organ)
				return
			var/effect = tgui_alert(user, "What do you want to do to the Organ", "Effect", list("Damage", "Kill", "Bruise", "Cancel"))
			if(effect == "Cancel")
				return
			if(effect == "Damage")
				var/organ_damage = tgui_input_number(user, "Add how much damage? It is currently at [our_organ.damage].", "Damage")
				our_organ.damage = max((our_organ.damage - organ_damage), 0)
			if(effect == "Kill")
				our_organ.die()
			if(effect == "Bruise")
				our_organ.bruise()

		if("assist_organ")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/organs = list()
			for(var/obj/item/organ/I in Tar.organs)
				organs |= I
			for(var/obj/item/organ/I in Tar.internal_organs)
				organs |= I
			var/obj/item/organ/our_organ = tgui_input_list(user, "Choose an organ to become assisted:", "Organs", organs)
			if(!our_organ)
				return
			our_organ.mechassist()

		if("robot_organ")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/organs = list()
			for(var/obj/item/organ/I in Tar.organs)
				organs |= I
			for(var/obj/item/organ/I in Tar.internal_organs)
				organs |= I
			var/obj/item/organ/our_organ = tgui_input_list(user, "Choose an organ to become robotic:", "Organs", organs)
			if(!our_organ)
				return
			our_organ.robotize()

		if("repair_organ")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/organs = list()
			for(var/obj/item/organ/I in Tar.organs)
				organs |= I
			for(var/obj/item/organ/I in Tar.internal_organs)
				organs |= I
			var/obj/item/organ/our_organ = tgui_input_list(user, "Choose an organ to heal:", "Organs", organs)
			if(!our_organ)
				return
			var/effect = tgui_alert(user, "What do you want to do to the Organ", "Effect", list("Heal", "Rejuvenate", "Cancel"))
			if(effect == "Cancel")
				return
			if(effect == "Heal")
				var/organ_damage = tgui_input_number(user, "Add how much damage? It is currently at [our_organ.damage].", "Damage")
				our_organ.damage = max((our_organ.damage - organ_damage), 0)
			if(effect == "Rejuvenate")
				our_organ.rejuvenate()

		if("drop_organ")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/organs = list()
			for(var/obj/item/organ/I in Tar.organs)
				organs |= I
			for(var/obj/item/organ/I in Tar.internal_organs)
				organs |= I
			var/obj/item/organ/our_organ = tgui_input_list(user, "Choose an organ to damage:", "Organs", organs)
			if(!our_organ)
				return
			our_organ.removed()

		if("break_bone")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/organs = list()
			for(var/obj/item/organ/external/E in Tar.organs)
				organs |= E
			var/obj/item/organ/external/our_organ = tgui_input_list(user, "Choose an bone to break:", "Organs", organs)
			if(!our_organ)
				return
			our_organ.fracture()

		if("stasis")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			if(Tar.in_stasis)
				Tar.Stasis(0)
			else
				Tar.Stasis(100000)

		////////ABILITIES//////////////

		if("vent_crawl")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			Tar.verbs |= /mob/living/proc/ventcrawl

		if("darksight")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/current_darksight = Tar.species.darksight
			var/change_sight = tgui_input_number(user, "What level do you wish to set their darksight to? It is currently [current_darksight].", "Darksight")
			if(change_sight)
				Tar.species.darksight = change_sight

		if("cocoon")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.verbs |= /mob/living/carbon/human/proc/enter_cocoon

		if("transformation")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.verbs |= /mob/living/carbon/human/proc/shapeshifter_select_hair
			Tar.verbs |= /mob/living/carbon/human/proc/shapeshifter_select_hair_colors
			Tar.verbs |= /mob/living/carbon/human/proc/shapeshifter_select_gender
			Tar.verbs |= /mob/living/carbon/human/proc/shapeshifter_select_wings
			Tar.verbs |= /mob/living/carbon/human/proc/shapeshifter_select_tail
			Tar.verbs |= /mob/living/carbon/human/proc/shapeshifter_select_ears
			Tar.verbs |= /mob/living/carbon/human/proc/lleill_select_shape //designed for non-shapeshifter mobs
			Tar.verbs |= /mob/living/carbon/human/proc/lleill_select_colour

		if("set_size")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			Tar.verbs |= /mob/living/proc/set_size

		if("lleill_energy")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/energy_max = tgui_input_number(user, "What should their max lleill energy be set to? It is currently [Tar.species.lleill_energy_max].", "Max energy")
			Tar.species.lleill_energy_max = energy_max
			var/energy_new = tgui_input_number(user, "What should their current lleill energy be set to? It is currently [Tar.species.lleill_energy].", "Max energy")
			Tar.species.lleill_energy = energy_new

		if("lleill_invisibility")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.verbs |= /mob/living/carbon/human/proc/lleill_invisibility

		if("beast_form")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.verbs |= /mob/living/carbon/human/proc/lleill_beast_form

		if("lleill_transmute")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.verbs |= /mob/living/carbon/human/proc/lleill_transmute

		if("lleill_alchemy")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.verbs |= /mob/living/carbon/human/proc/lleill_alchemy

		if("lleill_drain")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.verbs |= /mob/living/carbon/human/proc/lleill_contact

		if("brutal_pred")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			Tar.verbs |= /mob/living/proc/shred_limb

		if("trash_eater")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.verbs |= /mob/living/proc/eat_trash
			Tar.verbs |= /mob/living/proc/toggle_trash_catching


		////////INVENTORY//////////////

		if("drop_all")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/confirm = tgui_alert(user, "Make [Tar] drop everything?", "Message", list("Yes", "No"))
			if(confirm != "Yes")
				return

			for(var/obj/item/W in Tar)
				if(istype(W, /obj/item/weapon/implant/backup) || istype(W, /obj/item/device/nif))	//VOREStation Edit - There's basically no reason to remove either of these
					continue	//VOREStation Edit
				Tar.drop_from_inventory(W)

		if("drop_specific")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return

			var/list/items = Tar.get_equipped_items()
			var/item_to_drop = tgui_input_list(user, "Choose item to force drop:", "Drop Specific Item", items)
			if(item_to_drop)
				Tar.drop_from_inventory(item_to_drop)

		if("drop_held")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.drop_l_hand()
			Tar.drop_r_hand()

		if("list_all")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.get_equipped_items()

		if("give_item")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			if(!user.client.holder)
				return
			var/obj/item/X = user.client.holder.marked_datum
			if(!istype(X))
				return
			Tar.put_in_hands(X)

		if("equip_item")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			if(!user.client.holder)
				return
			var/obj/item/X = user.client.holder.marked_datum
			if(!istype(X))
				return
			if(Tar.equip_to_appropriate_slot(X))
				return
			else
				Tar.equip_to_storage(X)

		////////ADMIN//////////////

		if("quick_nif")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/input_NIF
			if(!Tar.get_organ(BP_HEAD))
				to_chat(user,span_warning("Target is unsuitable."))
				return
			if(Tar.nif)
				to_chat(user,span_warning("Target already has a NIF."))
				return
			if(Tar.species.flags & NO_SCAN)
				var/obj/item/device/nif/S = /obj/item/device/nif/bioadap
				input_NIF = initial(S.name)
				new /obj/item/device/nif/bioadap(Tar)
			else
				var/list/NIF_types = typesof(/obj/item/device/nif)
				var/list/NIFs = list()

				for(var/NIF_type in NIF_types)
					var/obj/item/device/nif/S = NIF_type
					NIFs[capitalize(initial(S.name))] = NIF_type

				var/list/show_NIFs = sortList(NIFs) // the list that will be shown to the user to pick from

				input_NIF = tgui_input_list(user, "Pick the NIF type","Quick NIF", show_NIFs)
				var/chosen_NIF = NIFs[capitalize(input_NIF)]

				if(chosen_NIF)
					new chosen_NIF(Tar)
				else
					new /obj/item/device/nif(Tar)
			log_and_message_admins("[key_name(user)] Quick NIF'd [Tar.real_name] with a [input_NIF].")

		if("resize")
			user.client.resize(target)

		if("teleport")
			var/where = tgui_alert(user, "Where to teleport?", "Where?", list("To Me", "To Mob", "To Area", "Cancel"))
			if(where == "Cancel")
				return
			if(where == "To Me")
				user.client.Getmob(target)
			if(where == "To Mob")
				var/mob/selection = tgui_input_list(usr, "Select a mob to jump [target] to:", "Jump to mob", mob_list)
				target.on_mob_jump()
				target.forceMove(get_turf(selection))
				log_admin("[key_name(user)] jumped [target] to [selection]")
			if(where == "To Area")
				var/area/A
				A = tgui_input_list(user, "Pick an area to teleport [target] to:", "Jump to Area", return_sorted_areas())
				target.on_mob_jump()
				target.forceMove(pick(get_area_turfs(A)))
				log_admin("[key_name(user)] jumped [target] to [A]")

		if("gib")
			var/death = tgui_alert(user, "Are you sure you want to destroy [target]?", "Gib?", list("KILL", "Cancel"))
			if(death == "KILL")
				target.gib()

		if("dust")
			var/death = tgui_alert(user, "Are you sure you want to destroy [target]?", "Dust?", list("KILL", "Cancel"))
			if(death == "KILL")
				target.dust()

		if("paralyse")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			user.client.holder.paralyze_mob(Tar)

		if("subtle_message")
			user.client.cmd_admin_subtle_message(target)

		if("direct_narrate")
			user.client.cmd_admin_direct_narrate(target)

		if("player_panel")
			user.client.holder.show_player_panel(target)

		if("view_variables")
			user.client.debug_variables(target)

		if("orbit")
			if(!user.client.holder.marked_datum)
				return
			var/atom/movable/X = user.client.holder.marked_datum
			X.orbit(target)

		if("ai")
			if(!istype(target, /mob/living))
				to_chat(usr, span_notice("This can only be used on instances of type /mob/living"))
				return
			var/mob/living/L = target
			if(L.client || L.teleop)
				to_chat(usr, span_warning("This cannot be used on player mobs!"))
				return

			if(L.ai_holder)	//Cleaning up the original ai
				var/ai_holder_old = L.ai_holder
				L.ai_holder = null
				qdel(ai_holder_old)	//Only way I could make #TESTING - Unable to be GC'd to stop. del() logs show it works.
			L.ai_holder_type = tgui_input_list(usr, "Choose AI holder", "AI Type", typesof(/datum/ai_holder/))
			L.initialize_ai_holder()
			L.faction = sanitize(tgui_input_text(usr, "Please input AI faction", "AI faction", "neutral"))
			L.a_intent = tgui_input_list(usr, "Please choose AI intent", "AI intent", list(I_HURT, I_HELP))
			if(tgui_alert(usr, "Make mob wake up? This is needed for carbon mobs.", "Wake mob?", list("Yes", "No")) == "Yes")
				L.AdjustSleeping(-100)


		////////FIXES//////////////

		if("rejuvenate")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			Tar.rejuvenate()

		if("popup-box")
			var/message = tgui_input_text(user, "Write a message to send to the user with a space for them to reply without using the text box:", "Message")
			if(!message)
				return
			log_admin("[key_name(user)] sent message to [target]: [message]")
			var/reply = tgui_input_text(target, "An admin has sent you a message: [message]", "Reply")
			if(!reply)
				return
			log_and_message_admins("[key_name(target)] replied to [user]'s message: [reply].")

		if("stop-orbits")
			for(var/datum/orbit/X in target.orbiters)
				X.orbiter.stop_orbit()

		if("revert-mob-tf")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			Tar.revert_mob_tf()
