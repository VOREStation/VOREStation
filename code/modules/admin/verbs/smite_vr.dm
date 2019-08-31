/client/proc/smite_vr(var/mob/living/carbon/human/target in player_list)
	set name = "Smite (Vore)"
	set desc = "Abuse a player with various 'special Vore-brand treatments' from a list."
	set category = "Fun"
	if(!check_rights(R_ADMIN|R_FUN))
		return

	if(!istype(target))
		return

	var/list/smite_types = list(SMITE_SHADEKIN_ATTACK,SMITE_SHADEKIN_NOMF,SMITE_REDSPACE_ABDUCT)

	var/smite_choice = input("Select the type of SMITE for [target]","SMITE Type Choice") as null|anything in smite_types
	if(!smite_choice)
		return

	log_and_message_admins("[key_name(src)] has used SMITE (Vore) ([smite_choice]) on [key_name(target)].")
	feedback_add_details("admin_verb","SMITEV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	switch(smite_choice)
		if(SMITE_SHADEKIN_ATTACK)
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

			var/mob/living/simple_mob/shadekin/red/ai/shadekin = new(Ts)
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

		if(SMITE_SHADEKIN_NOMF)
			var/list/kin_types = list(
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
			var/kin_type = input("Select the type of shadekin for [target] nomf","Shadekin Type Choice") as null|anything in kin_types
			if(!kin_type || !target)
				return


			kin_type = kin_types[kin_type]

			var/myself = alert("Control the shadekin yourself or delete pred and prey after?","Control Shadekin?","Control","Cancel","Delete")
			if(myself == "Cancel" || !target)
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
			shadekin.audible_message("<b>[shadekin]</b> belches loudly!")
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


		if(SMITE_REDSPACE_ABDUCT)
			redspace_abduction(target, src)

		else
			return //Injection? Don't print any messages.

var/redspace_abduction_z

/area/redspace_abduction
	name = "Another Time And Place"
	requires_power = FALSE
	dynamic_lighting = FALSE

/proc/redspace_abduction(mob/living/target, user)
	if(redspace_abduction_z < 0)
		to_chat(user,"<span class='warning'>The abduction z-level is already being created. Please wait.</span>")
		return
	if(!redspace_abduction_z)
		redspace_abduction_z = -1
		to_chat(user,"<span class='warning'>This is the first use of the verb this shift, it will take a minute to configure the abduction z-level. It will be z[world.maxz+1].</span>")
		var/z = ++world.maxz
		for(var/x = 1 to world.maxx)
			for(var/y = 1 to world.maxy)
				var/turf/T = locate(x,y,z)
				new /area/redspace_abduction(T)
				T.ChangeTurf(/turf/unsimulated/fake_space)
				T.plane = -100
				CHECK_TICK
		redspace_abduction_z = z

	if(!target || !user)
		return

	var/size_of_square = 26
	var/halfbox = round(size_of_square*0.5)
	target.transforming = TRUE
	to_chat(target,"<span class='danger'>You feel a strange tug, deep inside. You're frozen in momentarily...</span>")
	to_chat(user,"<span class='notice'>Beginning vis_contents copy to abduction site, player mob is frozen.</span>")
	sleep(1 SECOND)
	//Lower left corner of a working box
	var/llc_x = max(0,halfbox-target.x) + min(target.x+halfbox, world.maxx) - size_of_square
	var/llc_y = max(0,halfbox-target.y) + min(target.y+halfbox, world.maxy) - size_of_square

	//Copy them all
	for(var/x = llc_x to llc_x+size_of_square)
		for(var/y = llc_y to llc_y+size_of_square)
			var/turf/T_src = locate(x,y,target.z)
			var/turf/T_dest = locate(x,y,redspace_abduction_z)
			T_dest.vis_contents.Cut()
			T_dest.vis_contents += T_src
			T_dest.density = T_src.density
			T_dest.opacity = T_src.opacity
			CHECK_TICK

	//Feather the edges
	for(var/x = llc_x to llc_x+1) //Left
		for(var/y = llc_y to llc_y+size_of_square)
			if(prob(50))
				var/turf/T = locate(x,y,redspace_abduction_z)
				T.density = FALSE
				T.opacity = FALSE
				T.vis_contents.Cut()

	for(var/x = llc_x+size_of_square-1 to llc_x+size_of_square) //Right
		for(var/y = llc_y to llc_y+size_of_square)
			if(prob(50))
				var/turf/T = locate(x,y,redspace_abduction_z)
				T.density = FALSE
				T.opacity = FALSE
				T.vis_contents.Cut()

	for(var/x = llc_x to llc_x+size_of_square) //Top
		for(var/y = llc_y+size_of_square-1 to llc_y+size_of_square)
			if(prob(50))
				var/turf/T = locate(x,y,redspace_abduction_z)
				T.density = FALSE
				T.opacity = FALSE
				T.vis_contents.Cut()

	for(var/x = llc_x to llc_x+size_of_square) //Bottom
		for(var/y = llc_y to llc_y+1)
			if(prob(50))
				var/turf/T = locate(x,y,redspace_abduction_z)
				T.density = FALSE
				T.opacity = FALSE
				T.vis_contents.Cut()

	target.forceMove(locate(target.x,target.y,redspace_abduction_z))
	to_chat(target,"<span class='danger'>The tug relaxes, but everything around you looks... slightly off.</span>")
	to_chat(user,"<span class='notice'>The mob has been moved. ([admin_jump_link(target,usr.client.holder)])</span>")

	target.transforming = FALSE
