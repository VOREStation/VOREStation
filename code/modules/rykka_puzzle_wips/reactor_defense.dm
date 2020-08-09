//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*	I have precisely 0 knowledge of what inspired me to make horrifically "pretty" code-comment blocks but fuck it here's Rykka's masterpiece.				//
 *	TL;DR - This is the Reactor Defense Code, based off of GTFO's Reactor Defense and Warframe's Defense style missions. Keep the objective alive,			//
 *	preferably undamaged through a number of waves, and you're able to progress. Mechanical challenges are more fun than "shoot thing, win". More to come.	//
 *////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*												Object Definition, Initialize, Process															*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GLOBAL_LIST_EMPTY(reactor_mob_spawners) // Define our global list here. This is used for the spawners.

// List of tabs used for NanoUI Displays and Reactor Stage Processing. If you're not sure how defines work, refer to the .dm reference docs.
#define IDLE 1
#define WARMUP 2
#define ENGAGED 3
#define FINISHED 4

/obj/structure/damaged_reactor // Damaged Reactor object used as the "thing" we interact with
	name = "damaged reactor"
	desc = "You shouldn't be able to read this! OOC: Poke @Rykka Stormheart or ask in dev, the reactors should be a subtype of damaged_reactor!"
	icon = 'icons/obj/damaged_reactor.dmi'
	icon_state = "reactor_off"
	density = 1
	anchored = TRUE
	climbable = FALSE
	breakable = FALSE
	var/icon_state_warmup = null					// Icon to use when the reactor is engaged/warming up. TODO: when I get sprites.
	var/icon_state_severe_damage = null				// Icon to use when the reactor has taken severe damage. TODO: when I get sprites.
	var/icon_state_powered = null					// Icon to use once the reactor is at full power. TODO: when I get sprites.
	var/active_defense = FALSE						// Are we actively in "defense" mode? (IE has someone engaged the defense gamemode?) This variable governs if the reactor can take damage or not (FALSE = immune!)
	var/list/spawners = list()						// The list of wave spawners we have (Defined at init.)
	var/reactor_id = null							// Our ID, used to link the reactor + the spawners specific to it, as well as the control console. This MUST be a WORD, not a NUMBER.
	var/state = IDLE								// What state are we in currently? (This is used for tracking what step we're on.)
	
	// Customization Options. Use these to customize how you want the mode to play out.
	var/health = 2000								// The reactor's health value (Set this to be what maxhealth is, the code will handle the rest).
	var/maxhealth = 2000							// The maximum health this object can have.
	var/list/waves = list(1)						// Total amount of waves we'll have, and what mob lists we'll use PER wave. Add more entries to the list to increase the # of waves.
													// The # (for instance, 1) NEEDS to match with the # of lists in wave_mobs. For instance, if list(1,2,3), we need to have wave_mobs with 3 list(/mob/blah) in it. Ask for help if you're not sure. 
													// TODO - figure out a method of spawning all at once on wave start vs continuous spawns.
	var/current_wave = 0							// The wave we're on currently. (Needed if # of waves is > 1). We start at 0 to allow ticking up and counting correctly.
	var/warmup = TRUE								// Does the reactor require a "warmup"/prep time before the waves start?
	var/warmup_time = 30 SECONDS					// How long is our warmup period?
	var/warmup_complete = null						// When is warmup complete? This is set in start_warmup()
	var/wave_length = 90 SECONDS					// How long are our waves?
	var/wave_complete = null						// When is the wave complete? This is set in start_wave()
	// var/area_defense = FALSE						// Are we using area defense as well as object defense? (IE, you must stay inside /area/ during the waves.) Currently nonfunctional, will re-evaluate after core functions complete.
	var/verification_required = TRUE				// Are users required to verify by hitting a button or typing in a phrase? (This is an AFK/cheese anti-measure, DO NOT DISABLE without a counter in place.)
	var/threshold_enabled = FALSE					// Is the requirement to keep the reactor above x hp enabled?
	var/damage_threshold = 0						// This is configurable, allowing you to choose if you want players to keep the reactor above x amount of HP.
	
	
	// Nano UI Variables, don't fuck with these unless you know what you're changing.
	// This is the current tab we're on, used for the UI/Menu.
	var/current_tab = IDLE
	
	/* 	== Spawning Variables. == */

	// Change these on the subtype of the reactor, for custom mob lists.
	// Weighted with values (not %chance, but relative weight)
	// Can be left value-less for all equally likely
	// Simply uncomment each additional list per wave you want to use. If you want to add more to the list, just copy the previous wave, and make sure to remove the comma at the end of the entry.
	var/list/wave_mobs = list(
		list(/mob/living/simple_mob/animal/wolf, /mob/living/simple_mob/mechanical/hivebot),
//		list(/mob/living/wave2mob, /mob/living/otherwave2mob, etc),
//		list(/mob/living/wave3mob, /mob/living/otherwave3mob, etc),
//		list(/mob/living/wave4mob, /mob/living/otherwave4mob, etc),
//		list(/mob/living/wave5mob, /mob/living/otherwave5mob, etc),
//		list(/mob/living/wave6mob, /mob/living/otherwave6mob, etc)
	)

	
	// Settings to help mappers/coders have their mobs do what they want in this case, and control the # of mobs.
	var/faction					// To prevent infighting if it spawns various mobs, set a faction
	var/atmos_comp = FALSE		// TRUE will set all their survivability to be within 20% of the current air
	var/total_spawns = -1 		// Total mob spawns, over all time, -1 for no limit
	var/simultaneous_spawns = 6 // Max spawned mobs active (from one landmark) at one time
	
	// Internal Use Only. (For those looking as to what this does, this is a typecast. We use this to handle setting up our mobs. If you're not sure what a typecast is, look it up or ask for help in #dev)
	var/mob/living/simple_mob/my_mob
	
/obj/structure/damaged_reactor/Initialize()
	. = ..()
		
	if(!LAZYLEN(wave_mobs)) // We create a runtime so that debugging is aware there is a problem. An empty list means nothing will happen when time comes for waves.
		log_runtime(EXCEPTION("Reactor ["[reactor_id]"] at [x],[y],[z] ([get_area(src)]) had no wave_mobs set on it!"))
		
	if(max(waves) > LAZYLEN(wave_mobs)) // We create a runtime so that debugging is aware there is a problem. A list out of index error will appear in addition to this.
		log_runtime(EXCEPTION("Reactor ["[reactor_id]"] at [x],[y],[z] ([get_area(src)]) had more wave mob lists chosen than were defined (Check how many wave_mobs lists you have!)!"))
			
	return INITIALIZE_HINT_LATELOAD // We want to initialize AFTER everything else and grab our list of spawners.
	// START_PROCESSING(SSobj, src) Moved this to lateload
	
/obj/structure/damaged_reactor/LateInitialize() // We initialize after the spawners do by way of INITIALIZE_HINT_LATELOAD
	. = ..()
	
	if(GLOB.reactor_mob_spawners["[reactor_id]"]) // Does the list exist? Great, then we set the spawners var = to that list.
		spawners = GLOB.reactor_mob_spawners["[reactor_id]"]
	else // Otherwise, we create a runtime so that debugging is aware there is a problem.
		log_runtime(EXCEPTION("Reactor ["[reactor_id]"] at [x],[y],[z] ([get_area(src)]) couldn't find any spawners!"))
		return
	
	START_PROCESSING(SSobj, src)
	
/obj/structure/damaged_reactor/process() // This runs every 2 seconds/MC tick of the SSobj subsystem. I think. DON'T ADD STUFF DIRECTLY INTO PROCESS, USE THE PROCS.
	switch(state)
		if(IDLE) // No need to do anything while we're idle/waiting for interaction. 
			return

		if(WARMUP) // All of the warmup stuff is handled by procs. Go down to PROCS section to modify this behavior.
			if(!warmup_complete)
				start_warmup()
				return // We return so that the second if isn't checked before warmup_complete is set - if this is removed, warmup_complete will be null/0 when the second if is run, returning true and running complete_warmup()
			if(world.time >= warmup_complete)
				complete_warmup()
				return
			warmup()
		
		if(ENGAGED) // All of the wave stuff is handled by procs. Go down to PROCS section to modify this behavior.
			if(!wave_complete)
				start_wave()
				return // We return so that the second if isn't checked before wave_complete is set - if this is removed, wave_complete will be null/0 when the second if is run, returning true and running end_wave()
			if(world.time >= wave_complete)
				end_wave()
				return
			defense_mode()
		
		if(FINISHED)
			STOP_PROCESSING(SSobj, src)
		
	/* Commenting out the my_mob stuff until I get a better handle on if it's needed or not.
	if(my_mob && my_mob.stat != DEAD) // Is our spawned mob alive still?
		return // No need to spawn
	*/
			
	

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*													End Object Definition																		*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*	//		=====							Interaction Code Begins															=====		//
 *	//		=====			Handle Examine, attempting to interact with object, other "generic" code here.					=====		//
 *////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/damaged_reactor/attack_hand(var/mob/living/user) // Is a LIVING mob clicking on us? Sorry ghosts. :p
	if(!isliving(user)) // You're not alive. Stop. Bad.
		return // No clicky.
	switch(user.a_intent)
		if(I_HELP)
			ui_interact(user) // Open NanoUI
		if(I_HURT)
			var/mob/living/carbon/human/H = usr
			if(H.species.can_shred(H)) // This is a hard vore proc. Whyyyyy???
				attack_generic(H,10) // Handle doing damage here too, since it counts as an interaction.
				return
			// else if(H.species.) TODO: Figure out how to handle SHARP claws/etc for a very little bit of damage.
			else // You can't damage it without a tool!
				playsound(src, 'sound/effects/grillehit.ogg', 50, 1)
				user.do_attack_animation(src)
				user.visible_message("<span class = 'danger'>\The [user] slams their hand against \the [src], not appearing to damage it!</span>",
									"<span class = 'danger'>You don't appear to do anything to the heavy exterior of \the [src]!</span>")
		if(I_GRAB)
			to_chat(user, "<span class ='notice'>You can't grab a reactor! To open the menu, use help intent!</span>")
			return
		if(I_DISARM)
			to_chat(user, "<span class ='notice'>You can't disarm a reactor! To open the menu, use help intent!</span>")
			return

/obj/structure/damaged_reactor/examine(mob/user) // Are they inspecting the reactor?
	. = ..()

	if(health >= maxhealth) // Use >= in case someone varedits health higher than the "max".
		. += "<span class='notice'>It looks fully intact.</span>"
	else
		var/perc = health / maxhealth
		if(perc > 0.75)
			. += "<span class='notice'>It appears to have slight damage on the exterior, but nothing serious.</span>"
		else if(perc > 0.5)
			. += "<span class='warning'>It appears to be slightly misaligned, and the motor is humming louder than expected.</span>"
		else if(perc > 0.25)
			. += "<span class='warning'>It appears to be having trouble running, the rotations appearing dangerously slower than expected!</span>"
		else
			. += "<span class='danger'>It appears to be on the verge of shutdown, as the turbine oscillates wildly!</span>"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*			=====							Interaction Code Ends															=====		*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////
//		=====		TGUI Menu Stuff Begins Here		=====			//
//////////////////////////////////////////////////////////////////////

/obj/structure/damaged_reactor/tgui_interact(mob/user, datum/tgui/ui)
	// End Header
	
	if(!user) // If for some reason the user is null, stop interaction.
		return

	// Footer
	// Update the UI if it exists, returns null if no ui is passed/found
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui) // The UI does not exist, so we'll create a new() one. For a list of parameters and their descriptions see the documentation in /tgui/README.md or /tgui/docs/
		ui = new(user, src, "DamagedReactor", "Reactor Interface v2.52") // This is the template (.js) it uses, and the 'name' of the UI. If you're used to NanoUI, we no longer pass window parameters, those are baked (part of) into the UI .js file.
		ui.open() // Display the UI to the user. Refreshing is handled by TGUI.

/* IF you're making a subtype and want to ADD data to this list, to add more things to NanoUI and such, do:
 *	/obj/structure/damaged_reactor/SUBTYPE/tgui_data()
 *		var/list/data = ..() 
 *		data['thing'] = "New thing we're adding to the list!" 
 *		return data 
 *	This allows you to add more data to tgui_data or change the information in certain fields without overriding the main data list.
 */ 

/obj/structure/damaged_reactor/tgui_data(mob/user)
	var/data[0]
	data["health"] = health
	data["wave"] = current_wave
	data["warmup_enabled"] = warmup
	data["currentTab"] = current_tab
	data["warmup_time_left"] = (warmup_complete - world.time) / 10 // We want to take the TOTAL time and subtract the CURRENT time, then divide it, to get our fancy UI percentage/time.
	data["wave_time_left"] = (wave_complete - world.time) / 10 // Same as above method, but for wave time.
	var/warmup_min = (warmup_complete - warmup_time)
	var/warmup_max = warmup_complete
	data["warmupcompletePercent"] = ((world.time - warmup_min) / (warmup_max - warmup_min))
	var/wave_min = (wave_complete - wave_length)
	var/wave_max = wave_complete
	data["wavecompletePercent"] = ((world.time - wave_min) / (wave_max - wave_min))
	return data

/obj/structure/damaged_reactor/tgui_act(action) // Someone hit a button or wants to do things~
	if(..())
		return 1
		
	if(action == "Engage Reactor")
		if(!warmup) // If we do not have warmup set to TRUE, then we go right to starting the waves.
			current_tab = ENGAGED
			state = ENGAGED
			to_world("<span class='danger'><big>DEBUG: DEFENSE MODE ENGAGED.</big></span>")
		else
			current_tab = WARMUP
			state = WARMUP
			to_world("<span class='danger'><big>DEBUG: WARMUP STARTED.</big></span>")
		

//////////////////////////////////////////////////////////////////
/*		=====		TGUI Menu Stuff Ends Here		=====		*/
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*	//		=====									-----Damage Handling Code-----																=====		//
 *	//		=====		We have to handle damage and health ourselves instead of relying on a parent to do so. 									=====		//
 *	//		=====		The following code handles health, taking damage, mobs inflicting damage, and any other damage-related scenarios. 		=====		//
 *////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/damaged_reactor/take_damage(var/damage = 0, var/sound_effect = 1)
	var/initialhealth = health // ...do we even need the initialhealth check?
	
	if(active_defense == FALSE) // Are we actively in a "defense" mode? If no, skip taking damage.
		return
	
	health = max(0, health - damage)
	
	if(health <= 0)
		failure_state() // You let it take too much damage!
	else
		if(sound_effect)
			playsound(src, 'sound/effects/grillehit.ogg', 100, 1) // Sound placeholder until I get something better
		if(health < maxhealth * 0.25 && initialhealth >= maxhealth * 0.25) // 25% or below
			visible_message("<span class='danger'><big>\The [src] groans under the strain, the motor thrumming in an off-pitch tone as safety parameters threaten to shut it down and the turbine oscillates inside!</big></span>")
			// update_icon() Commenting out update_icon() for now, I want players to use the menu to view health. TBD based on feedback.
		else if(health < maxhealth * 0.5 && initialhealth >= maxhealth * 0.5) // 50% or below
			visible_message("<span class='danger'>\The [src] whines dangerously as the turbine struggles to maintain RPMs with the sustained damage!</span>")
			// update_icon() Commenting out update_icon() for now, I want players to use the menu to view health. TBD based on feedback.
		else if(health < maxhealth * 0.75 && initialhealth >= maxhealth * 0.75) // 75% or below
			visible_message("<span class='notice'>\The [src] begins to shift out of alignment as the motor works harder to maintain speed!</span>")
			// update_icon() Commenting out update_icon() for now, I want players to use the menu to view health. TBD based on feedback.
	return

/obj/structure/damaged_reactor/bullet_act(var/obj/item/projectile/Proj) // A bullet hit us

	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage)
		return

	..()
	take_damage(proj_damage) // Take damage according to the bullet's damage value.
	return

/obj/structure/damaged_reactor/blob_act() // In the unlikely event a blob is attacking the reactor, deal a flat 50 damage to it.
	take_damage(50)
	
/obj/structure/damaged_reactor/hitby(AM as mob|obj) // I forget precisely what the fuck this is for but w/e.
	..()
	visible_message("<span class='danger'>\The [src] was hit by [AM].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	take_damage(tforce)

/obj/structure/damaged_reactor/attack_generic(var/mob/user, var/damage) // Are simplemobs trying to attack the reactor?
	user.setClickCooldown(user.get_attack_speed()) // Control how fast they can attack/click
	
	if(damage >= STRUCTURE_MIN_DAMAGE_THRESHOLD) // Is the damage over the minimum required threshold? Deal damage.
		visible_message("<span class='danger'>[user] tries to slice into \the [src] and does a little damage to the casing!</span>")
		take_damage(damage)
	else // Otherwise, they do nothing!
		visible_message("<span class='notice'>\The [user] doesn't appear to do anything to \the [src]!</span>")
	user.do_attack_animation(src)
	return 1

/obj/structure/damaged_reactor/attackby(obj/item/W as obj, mob/user as mob) // Object Interactions and more typecasting!
	if(!istype(W)) // This handles an edge case scenario.
		return

	// Slamming the reactor with something/someone.
	if(istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(istype(G.affecting,/mob/living))
			var/mob/living/M = G.affecting
			var/state = G.state
			qdel(W)	// gotta delete it here because if reactor breaks, it won't get deleted - not sure if this is needed since the reactor *can't* break.
			switch (state)
				if(1)
					M.visible_message("<span class='warning'>[user] slams [M] against \the [src]!</span>")
					M.apply_damage(7)
					hit(10)
				if(2)
					M.visible_message("<span class='danger'>[user] bashes [M] against \the [src]!</span>")
					if (prob(50))
						M.Weaken(1)
					M.apply_damage(10)
					hit(25)
				if(3)
					M.visible_message("<span class='danger'><big>[user] crushes [M] against \the [src]!</big></span>")
					M.Weaken(5)
					M.apply_damage(20)
					hit(50)
			return
	
	if(W.flags & NOBLUDGEON) // Is this an item incapable of producing an x hit y message (typically for weapons that can't attack)?
		return
	
	if(!W.force || W.force <= 0) // If for some reason it's null, not a number, or less than 0/negative, we don't handle damage from it.
		return
	
	else // A grab isn't the thing hitting us! Therefore, we receive damage based on the tool striking us!
		user.setClickCooldown(user.get_attack_speed(W))
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			hit(W.force)
		else
			playsound(src, 'sound/effects/grillehit.ogg', 75, 1)
		..()
	return

/obj/structure/damaged_reactor/proc/hit(var/damage, var/sound_effect = 1) // ...this is a silly way to do it but okay :p
	take_damage(damage)
	return

/* Commenting out update_icon() for now, I want players to use the menu to view health. TBD based on feedback.
/obj/structure/damaged_reactor/update_icon()
	overlays.Cut()
	
	// Damage overlays.
	var/ratio = health / maxhealth
	ratio = CEILING(ratio * 4, 1) * 25

	if(ratio > 75)
		return
	var/image/I = image(icon, "damage[ratio]", layer = layer + 0.1)
	overlays += I

	return
*/

//////////////////////////////////////////////////////////////////
/*			=====		End Damage Code			=====			*/
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
/*	//		=====			Proc Code			=====			//
 *	//		Handle all code pertaining to reactor procs here.	//
 *////////////////////////////////////////////////////////////////

/obj/structure/damaged_reactor/proc/failure_state() // Trigger this and you "fail" the current wave. If you want special stuff done here that ONLY affects failing a wave, do it here, NOT in end_wave().
	health = maxhealth // Reset our health to maximum
	active_defense = FALSE // We're no longer actively defending, because we failed. Make the reactor invulnerable again.
	
	if(current_wave - 1 < 0) // Failsafe in case we accidentally try to set the current_wave to a negative number.
		current_wave = 0
	else // Decrease the wave to what it was before the start of the wave.
		current_wave--
		
	end_wave() // Call this proc here to conclude everything with the current wave. This also allows for preventing the edge case of "Someone set the current_wave to 20 but there's only 5 'waves'", as end_wave will call success_state() in that case.
	
/obj/structure/damaged_reactor/proc/success_state() // Did we win? Is it finally over?
	active_defense = FALSE // We're no longer actively defending, because we won. Make the reactor invulnerable again.
	state = FINISHED // We're done, we won, let's set our state to Finished and lock the reactor until it's reset!
	
	reactor_finished() // Call this, does nothing for now but subtypes can use it for specialty things. - Such as opening doors, or enabling power.
	
/obj/structure/damaged_reactor/proc/reactor_finished() // Holder Proc, subtypes modify this to add special behavior onto success_state (such as opening doors once you 'end' the mode.)

/obj/structure/damaged_reactor/proc/defense_mode() // Do these things EVERY tick of SSProcess - if you need it to run once, put it in an if statement.
	if(active_defense == FALSE) // Just to keep from constantly forcing defense active.
		active_defense = TRUE // We're actively defending, enable this so the reactor takes damage.
		
	check_clearance()
	
/obj/structure/damaged_reactor/proc/start_wave()
	wave_complete = world.time + wave_length
	
	++current_wave // Increment the wave counter by 1 each time we call start_wave(). If an admin calls this improperly, it wil be handled in end_wave or failure_state.
		
	active_defense = TRUE // We set this here just in case to allow the reactor to start taking damage.
	
	setup_spawner(current_wave) // We're starting a new wave, so we need to setup the spawners. We feed current_wave in as the argument because it's converted to a #, and setup_spawner will read it as setup_spawner(1) and use the list from 1, then 2, etc.
	
	to_world("Wave started!")
	
	set_lights(#913a08) // Set our mood lighting!
	
	start_spawning() // Send in the troops!
	
/obj/structure/damaged_reactor/proc/end_wave()
	if(current_wave >= waves.len)
		success_state()
	else
		state = IDLE
		active_defense = FALSE
		
	to_world("Wave ended!")
		
	reset_lights() // Restoring lights to defaults!
	
	stop_spawning() // We're done, stop sending mobs at us!

/obj/structure/damaged_reactor/proc/warmup() // Do these things EVERY tick of SSProcess - if you need it to run once, put it in an if statement.
	check_clearance() // Check if we're clear and we have space around us.

/obj/structure/damaged_reactor/proc/start_warmup()
	warmup_complete = world.time + warmup_time 	// When is our warmup complete?
	
	to_world("Warmup started!")
	
	set_lights(#916508) // Set our mood lighting!

/obj/structure/damaged_reactor/proc/complete_warmup()
	state = ENGAGED
	warmup_complete = null // Set this to null to "clear" the countdown for reuse.
	
	to_world("Warmup ended!")
	
	reset_lights() // Restoring lights to defaults!
	
/obj/structure/damaged_reactor/proc/set_lights(var/color) // Call this with color as the argument (the item inside parenthesis) to set your lights at the start of wave/warmup.
	var/area/area = get_area(src)
	if(!area)
		log_runtime(EXCEPTION("Reactor [reactor_id] was in nullspace. [area] was returned from get_area check!"))
		return // Don't run the next step because if we're in nullspace, everything the for loop does will return null.
	area.requires_power = 0 // We're pretending like the reactor powers up the area. (Until I can untangle how to make the reactor actually generate power.)
	area.power_change() // Update the power in the area!
		
	for(var/obj/machinery/light/light in area) // We're going to setup the lights in our area and turn them on.
		if(!(light.status == LIGHT_OK)) // We're going to skip any broken, burned, or destroyed/unuseable lights.
			continue
		
		light.brightness_color = "color" // Setting the lights to bright yellow.
		light.brightness_power = 100 // Very high-powered lights.
		light.on = 1 // Turn the lights on.
		light.update()
		
/obj/structure/damaged_reactor/proc/reset_lights() // We're done fucking with lights, let's go ahead and reset them back to normal.
	var/area/area = get_area(src)
	if(!area)
		log_runtime(EXCEPTION("Reactor [reactor_id] was in nullspace. [area] was returned from get_area check!"))
		return // Don't run the next step because if we're in nullspace, everything the for loop does will return null.
	area.requires_power = 1 // We're pretending like the reactor powers up the area, and now disabling the special functionality of power. (Until I can untangle how to make the reactor actually generate power.)
	area.power_change() // Update the power in this area so that it actually updates!
	
	for(var/obj/machinery/light/light in area) // We're going to reset the lights now.
		light.brightness_color = initial(light.brightness_color) || "" // Set them to their original color.
		light.on = initial(light.on) // Reset lights to where they were before (on or off)
		light.brightness_power = initial(light.brightness_power) // Reset lights to what they were before.
		light.update()
		
/obj/structure/damaged_reactor/proc/reset_reactor(var/waves = waves.len, var/warmup = TRUE) // Called to reset our reactor to initial state, and re-add us to object processing. Primarily intended for the training reactor, or for admins/GM's to be able to reset the reactor easily for events.
	state = IDLE // Do this first, so SSobj doesn't immediately force us right back out of processing.
	current_wave = 0 // Reset our current wave to 0.
	
	reset_lights() // Reset the lights in our area to default.
	
	setup_spawner(1) // We're going to call this to set our wave mob list back to where it should be. We hardcode 1 because if you tell a list to return to 0, you've effectively said "look at 0 for our wave" and it won't find anything. 1 is the first entry in a list.
	
	START_PROCESSING(SSobj, src) // We're immediately going to flip over to processing. This comes LAST so all variables can safely be reset first.
	
/obj/structure/damaged_reactor/proc/check_clearance(var/tiles) // This proc is called by the defense_mode() and warmup() procs - what this does is check if we've got space around us, in x amount of tiles. This is to prevent explorers from walling us in and getting a 'free' win.
	

/obj/structure/damaged_reactor/proc/setup_spawner(var/wavenumber) // This proc is called when we're swapping over from one wave to the next - this 'preps' the mobs in the spawners.
	for(var/obj/effect/spawner/wave_spawner/spawner in spawners)
		spawner.spawn_types = wave_mobs[wavenumber]
		spawner.faction = faction 	// May as well update this here at the same time, just in case it was changed between waves.
		spawner.atmos = atmos_comp 	// May as well update this here at the same time, just in case it was changed between waves.
		
/obj/structure/damaged_reactor/proc/start_spawning()
	for(var/obj/effect/spawner/wave_spawner/spawner in spawners)
		spawner.enabled = TRUE
		
/obj/structure/damaged_reactor/proc/stop_spawning()
	for(var/obj/effect/spawner/wave_spawner/spawner in spawners)
		spawner.enabled = FALSE

//////////////////////////////////////////////////////////////
/*		=====			End Proc Code			=====		*/
//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////
/*		=====			Spawner Code			=====		//
 *		We'll handle mob spawning, spawners, etc here.		//
 *////////////////////////////////////////////////////////////

/obj/effect/spawner/wave_spawner
	name = "Wave Spawner"
	desc = "This is the location of our wave spawns!"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	invisibility = 101
	mouse_opacity = 0
	density = 0
	anchored = 1
	
	// Our Reactor ID - used in linking the parts together.
	var/reactor_id = null
	
	// Spawning/mob variables, set on the reactor.
	var/faction = null // What faction are we?
	var/atmos = null // What's our atmos comp?
	var/atmos_comp = FALSE		// TRUE will set all their survivability to be within 20% of the current air
	var/list/spawn_types = list() // Empty list, this is sent to us by the reactor.
	
	// The AI Holder we're going to assign our mobs.
	var/ai_holder = null
	
	// Are we on? Can we do the thing? GOGOGOGO.
	var/enabled = FALSE
	
	// Our mobs that we've spawned.
	var/list/spawned_mobs = list()
	
/obj/effect/spawner/wave_spawner/Initialize() // When our object is loaded for the first time.
	. = ..()
	
	if(GLOB.reactor_mob_spawners["[reactor_id]"]) // If our list already exists, just add ourselves to it.
		GLOB.reactor_mob_spawners["[reactor_id]"] += src
	else
		GLOB.reactor_mob_spawners["[reactor_id]"] = list(src) // No list yet for this reactor? Cool, we're starting one.

	START_PROCESSING(SSobj, src)
	
/obj/effect/spawner/wave_spawner/process()
	if(!enabled) // Are we off? No need to process anything.
		return
	
	if(faction) // Is there a faction var set? Set the spawned mobs faction to this.
		my_mob.faction = faction
	
	if(atmos_comp) // Are we actively setting the atmos survivability? Do so now.
		var/turf/T = get_turf(src)
		var/datum/gas_mixture/env = T.return_air()
		
		if(!env || env.return_pressure() < 0.01) // Is there no gas environment, or is the ambient pressure less than 0.01 (Basically space?) Then set our mobs min/max to 0.
			if(my_mob.minbodytemp > env.temperature)
				my_mob.minbodytemp = env.temperature * 0.8
			else if(my_mob.maxbodytemp < env.temperature)
				my_mob.maxbodytemp = env.temperature * 1.2
			
			my_mob.min_oxy = 0
			my_mob.min_tox = 0
			my_mob.min_n2 = 0
			my_mob.min_co2 = 0
			my_mob.max_oxy = 0
			my_mob.max_tox = 0
			my_mob.max_n2 = 0
			my_mob.max_co2 = 0
		
		else if(my_mob.minbodytemp > env.temperature)
			my_mob.minbodytemp = env.temperature * 0.8
		else if(my_mob.maxbodytemp < env.temperature)
			my_mob.maxbodytemp = env.temperature * 1.2

		var/list/gaslist = env.gas
		if(my_mob.min_oxy)
			my_mob.min_oxy = gaslist["oxygen"] * 0.8
		if(my_mob.min_tox)
			my_mob.min_tox = gaslist["phoron"] * 0.8
		if(my_mob.min_n2)
			my_mob.min_n2 = gaslist["nitrogen"] * 0.8
		if(my_mob.min_co2)
			my_mob.min_co2 = gaslist["carbon_dioxide"] * 0.8
		if(my_mob.max_oxy)
			my_mob.max_oxy = gaslist["oxygen"] * 1.2
		if(my_mob.max_tox)
			my_mob.max_tox = gaslist["phoron"] * 1.2
		if(my_mob.max_n2)
			my_mob.max_n2 = gaslist["nitrogen"] * 1.2
		if(my_mob.max_co2)
			my_mob.max_co2 = gaslist["carbon_dioxide"] * 1.2
	

//////////////////////////////////////////////////////////////
/*		=====		End Spawner Code			=====		*/
//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////
/*		=====			Mob AI Code				=====		//
 *		We'll handle mob AI and special mechanics here.		//
 *////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////
/*		=====		End Mob AI Code				=====		*/
//////////////////////////////////////////////////////////////

// We're done using these, undefine them.
#undef IDLE
#undef WARMUP
#undef ENGAGED
#undef FINISHED