/client/proc/player_effects(var/mob/target in player_list)
	set name = "Player Effects"
	set desc = "Modify a player character with various 'special treatments' from a list."
	set category = "Fun"
	if(!check_rights(R_FUN))
		return

	var/datum/eventkit/player_effects/spawner = new()
	spawner.tgui_interact(usr, target)

/datum/eventkit/player_effects
	var/mob/target //The target of the effects

/datum/eventkit/player_effects/New()
	. = ..()

/datum/eventkit/player_effects/tgui_interact(mob/user, mob/targetx, datum/tgui/ui)
	target = targetx
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

/datum/eventkit/player_effects/tgui_act(action, mob/target)
	. = ..()
	if(.)
		return
	if(!check_rights_for(usr.client, R_SPAWN))
		return

	var/ckey = target.ckey
	var/mob/living/carbon/human/Tar = target

	switch(action)

		////////////SMITES/////////////
		if("break_legs")
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
				to_chat(src,"[target] didn't have any breakable legs, sorry.")

		if("bluespace_artillery")
			bluespace_artillery(target,src)

		if("spont_combustion")
			if(!istype(Tar))
				return
			Tar.adjust_fire_stacks(10)
			Tar.IgniteMob()
			Tar.visible_message("<span class='danger'>[target] bursts into flames!</span>")

		if("lightning_strike")
			var/turf/T = get_step(get_step(target, NORTH), NORTH)
			T.Beam(target, icon_state="lightning[rand(1,12)]", time = 5)
			Tar.electrocute_act(75,def_zone = BP_HEAD)
			target.visible_message("<span class='danger'>[target] is struck by lightning!</span>")

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
				shadekin.ckey = ckey

			else //Permakin'd
				to_chat(target,"<span class='danger'>You're carried off into The Dark by the [shadekin]. Who knows if you'll find your way back?</span>")
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
			to_chat(target,"<span class='warning'>GRENADE?!</span>")
			grenade.detonate()

		if("spicerequest")
			var/obj/item/weapon/reagent_containers/food/condiment/spacespice/spice = new /obj/item/weapon/reagent_containers/food/condiment/spacespice
			spice.loc = target.loc
			to_chat(target,"A bottle of spices appears at your feet... be careful what you wish for!")

		if("terror")
			if(ishuman(Tar))
				Tar.fear = 200

		////////MEDICAL//////////////

		if("appendicitis")
			if(istype(Tar))
				Tar.appendicitis()