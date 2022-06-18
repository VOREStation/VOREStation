/obj/item/capture_crystal
	name = "capture crystal"
	desc = "A silent, unassuming crystal in what appears to be some kind of steel housing."
	icon = 'icons/obj/capture_crystal_vr.dmi'
	icon_state = "inactive"
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'
	throwforce = 0
	force = 0
	action_button_name = "Command"

	var/active = FALSE					//Is it set up?
	var/mob/living/owner				//Reference to the owner
	var/mob/living/bound_mob			//Reference to our bound mob
	var/spawn_mob_type					//The kind of mob an inactive crystal will try to spawn when activated
	var/activate_cooldown = 30 SECONDS	//How long do we wait between unleashing and recalling
	var/last_activate					//Automatically set by things that try to move the bound mob or capture things
	var/empty_icon = "empty"
	var/full_icon = "full"
	var/capture_chance_modifier = 1		//So we can have special subtypes with different capture rates!

/obj/item/capture_crystal/Initialize()
	. = ..()
	update_icon()

//Let's make sure we clean up our references and things if the crystal goes away (such as when it's digested)
/obj/item/capture_crystal/Destroy()
	if(bound_mob)
		if(bound_mob in contents)
			unleash()
		to_chat(bound_mob, "<span class='notice'>You feel like yourself again. You are no longer under the influence of \the [src]'s command.</span>")
		UnregisterSignal(bound_mob, COMSIG_PARENT_QDELETING)
		bound_mob.capture_caught = FALSE
		bound_mob = null
	if(owner)
		UnregisterSignal(owner, COMSIG_PARENT_QDELETING)
		owner = null
	return ..()

/obj/item/capture_crystal/examine(user)
	. = ..()
	if(user == owner && bound_mob)
		. += "<span class = 'notice'>[bound_mob]'s crystal</span>"
		if(isanimal(bound_mob))
			. += "<span class = 'notice'>[bound_mob.health / bound_mob.maxHealth * 100]%</span>"
		if(bound_mob.ooc_notes)
			. += "<span class = 'deptradio'>OOC Notes:</span> <a href='?src=\ref[bound_mob];ooc_notes=1'>\[View\]</a>"
		. += "<span class='deptradio'><a href='?src=\ref[bound_mob];vore_prefs=1'>\[Mechanical Vore Preferences\]</a></span>"

//Command! This lets the owner toggle hostile on AI controlled mobs, or send a silent command message to your bound mob, wherever they may be.
/obj/item/capture_crystal/ui_action_click()
	if(!ismob(loc))
		return
	var/mob/living/M = src.loc
	if(M != owner)
		to_chat(M, "<span class='notice'>\The [src] emits an unpleasant tone... It does not respond to your command.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	else if(!bound_mob)
		to_chat(M, "<span class='notice'>\The [src] emits an unpleasant tone... There is nothing to command.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	else if(isanimal(bound_mob) && !bound_mob.client)
		if(!isnull(bound_mob.get_AI_stance()))
			var/datum/ai_holder/AI = bound_mob.ai_holder
			AI.hostile = !AI.hostile
			if(!AI.hostile)
				AI.set_stance(STANCE_IDLE)
			to_chat(M, span("notice", "\The [bound_mob] is now [AI.hostile ? "hostile" : "passive"]."))
			log_admin("[key_name_admin(M)] set [bound_mob] to [AI.hostile].")
	else if(bound_mob.client)
		var/transmit_msg = tgui_input_text(usr, "What is your command?", "Command")
		if(length(transmit_msg) >= MAX_MESSAGE_LEN)
			to_chat(M, "<span class='danger'>Your message was TOO LONG!:[transmit_msg]</span>")
			return
		transmit_msg = sanitize(transmit_msg, max_length = MAX_MESSAGE_LEN)
		if(isnull(transmit_msg))
			to_chat(M, "<span class='notice'>You decided against it.</span>")
			return
		to_chat(bound_mob, "<span class='notice'>\The [owner] commands, '[transmit_msg]'</span>")
		to_chat(M, "<span class='notice'>Your command has been transmitted, '[transmit_msg]'</span>")
		log_admin("[key_name_admin(M)] sent the command, '[transmit_msg]' to [bound_mob].")
	else
		to_chat(M, "<span class='notice'>\The [src] emits an unpleasant tone... \The [bound_mob] is unresponsive.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	
//Lets the owner get AI controlled bound mobs to follow them, or tells player controlled mobs to follow them.
/obj/item/capture_crystal/verb/follow_owner()
	set name = "Toggle Follow"
	set category = "Object"
	set src in usr
	if(!ismob(loc))
		return
	var/mob/living/M = src.loc
	if(M != owner)
		to_chat(M, "<span class='notice'>\The [src] emits an unpleasant tone... It does not respond to your command.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	else if(bound_mob.stat != CONSCIOUS)
		to_chat(M, "<span class='notice'>\The [src] emits an unpleasant tone... \The [bound_mob] is not able to hear your command.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	else if(bound_mob.client)
		to_chat(bound_mob, "<span class='notice'>\The [owner] wishes for you to follow them.</span>")
	else if(bound_mob in contents)
		if(!bound_mob.ai_holder)
			to_chat(M, "<span class='notice'>\The [src] emits an unpleasant tone... \The [bound_mob] is not able to follow your command.</span>")
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
			return
		var/datum/ai_holder/AI = bound_mob.ai_holder
		if(AI.leader)
			to_chat(M, "<span class='notice'>\The [src] chimes~ \The [bound_mob] stopped following [AI.leader].</span>")
			AI.lose_follow(AI.leader)
		else
			AI.set_follow(M)
			to_chat(M, "<span class='notice'>\The [src] chimes~ \The [bound_mob] started following following [AI.leader].</span>")
	else if(!(bound_mob in view(M)))
		to_chat(M, "<span class='notice'>\The [src] emits an unpleasant tone... \The [bound_mob] is not able to hear your command.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
		if(!bound_mob.ai_holder)
			to_chat(M, "<span class='notice'>\The [src] emits an unpleasant tone... \The [bound_mob] is not able to follow your command.</span>")
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
			return
		var/datum/ai_holder/AI = bound_mob.ai_holder
		if(AI.leader)
			to_chat(M, "<span class='notice'>\The [src] chimes~ \The [bound_mob] stopped following [AI.leader].</span>")
			AI.lose_follow(AI.leader)
		else
			AI.set_follow(M)
			to_chat(M, "<span class='notice'>\The [src] chimes~ \The [bound_mob] started following following [AI.leader].</span>")

//Don't really want people 'haha funny' capturing and releasing one another willy nilly. So! If you wanna release someone, you gotta destroy the thingy.
//(Which is consistent with how it works with digestion anyway.)
/obj/item/capture_crystal/verb/destroy_crystal()
	set name = "Destroy Crystal"
	set category = "Object"
	set src in usr
	if(!ismob(loc))
		return
	var/mob/living/M = src.loc
	if(M != owner)
		to_chat(M, "<span class='notice'>\The [src] is too hard for you to break.</span>")
	else
		M.visible_message("\The [M] crushes \the [src] into dust...", "\The [src] cracks and disintegrates in your hand.")
		qdel(src)

//If you catch something/someone and want to give it to someone else though, that's fine.
/obj/item/capture_crystal/verb/release_ownership()
	set name = "Release Ownership"
	set category = "Object"
	set src in usr
	if(!ismob(loc))
		return
	var/mob/living/M = src.loc
	if(M != owner)
		to_chat(M, "<span class='notice'>\The [src] emits an unpleasant tone... It does not respond to your command.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	else
		M.visible_message("\The [src] flickers in \the [M]'s hand and emits a little tone.", "\The [src] flickers in your hand and emits a little tone.")
		playsound(src, 'sound/effects/capture-crystal-out.ogg', 75, 1, -1)
		UnregisterSignal(owner, COMSIG_PARENT_QDELETING)
		owner = null

//Let's make inviting ghosts be an option you can do instead of an automatic thing!
/obj/item/capture_crystal/verb/invite_ghost()
	set name = "Enhance (Toggle Ghost Join)"
	set category = "Object"
	set src in usr
	if(!ismob(loc))
		return
	var/mob/living/U = src.loc
	if(!bound_mob)
		to_chat(U, "<span class='notice'>\The [src] emits an unpleasant tone... There is nothing to enhance.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
		return
	else if(U != owner)
		to_chat(U, "<span class='notice'>\The [src] emits an unpleasant tone... It does not respond to your command.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
		return
	else if(bound_mob.client || !isanimal(bound_mob))
		to_chat(U, "<span class='notice'>\The [src] emits an unpleasant tone... \The [bound_mob] is not eligable for enhancement.</span>")
		playsound(src, 'sound/effects/capture-crystal-problem.ogg', 75, 1, -1)
		return		//Need to type cast the mob so it can detect ghostjoin
	var/mob/living/simple_mob/M = bound_mob
	if(M.ghostjoin)
		M.ghostjoin = FALSE
		to_chat(U, "<span class='notice'>\The [bound_mob] is no longer eligable to be joined by ghosts.</span>")
	else if(tgui_alert(U, "Do you want to offer your [bound_mob] up to ghosts to play as? There is no way undo this once a ghost takes over.", "Invite ghosts?",list("No","Yes")) == "Yes")
		M.ghostjoin = TRUE
		to_chat(U, "<span class='notice'>\The [bound_mob] is now eligable to be joined by ghosts. It will need to be out of the crystal to be able to be joined.</span>")
	else
		to_chat(U, "<span class='notice'>You decided against it.</span>")

/obj/item/capture_crystal/update_icon()
	. = ..()
	if(spawn_mob_type)
		icon_state = full_icon
	else if(!bound_mob)
		icon_state = "inactive"
	else if(bound_mob in contents)
		icon_state = full_icon
	else
		icon_state = empty_icon
	if(!cooldown_check())
		icon_state = "[icon_state]-busy"
		spawn(activate_cooldown)		//If it's busy then we want to wait a bit to fix the sprite after the cooldown is done.
		update_icon()

/obj/item/capture_crystal/proc/cooldown_check()
	if(world.time < last_activate + activate_cooldown)
		return FALSE
	else return TRUE

/obj/item/capture_crystal/attack(mob/living/M, mob/living/user)
	if(bound_mob)	
		if(!bound_mob.devourable)	//Don't eat if prefs are bad
			return
		if(user.zone_sel.selecting == "mouth")	//Click while targetting the mouth and you eat/feed the stored mob to whoever you clicked on
			if(bound_mob in contents)
				user.visible_message("\The [user] moves \the [src] to [M]'s [M.vore_selected]...")
				M.perform_the_nom(M, bound_mob, M, M.vore_selected)
	else if(M == user)		//You don't have a mob, you ponder the orb instead of trying to capture yourself
		user.visible_message("\The [user] ponders \the [src]...", "You ponder \the [src]...")
	else if (cooldown_check())	//Try to capture someone without throwing
		user.visible_message("\The [user] taps \the [M] with \the [src].")
		activate(user, M)
	else
		to_chat(user, "<span class='notice'>\The [src] emits an unpleasant tone... It is not ready yet.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)

//Tries to unleash or recall your stored mob
/obj/item/capture_crystal/attack_self(mob/living/user)
	if(bound_mob && !owner)
		if(bound_mob == user)
			to_chat(user, "<span class='notice'>\The [src] emits an unpleasant tone... It does not activate for you.</span>")
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
			return
		if(tgui_alert(user, "\The [src] hasn't got an owner. It has \the [bound_mob] registered to it. Would you like to claim this as yours?", "Claim ownership", list("No","Yes")) == "Yes")
			owner = user
	if(!cooldown_check())
		to_chat(user, "<span class='notice'>\The [src] emits an unpleasant tone... It is not ready yet.</span>")
		if(bound_mob)
			playsound(src, 'sound/effects/capture-crystal-problem.ogg', 75, 1, -1)
		else
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	else if(user == bound_mob)	//You can't recall yourself
		to_chat(user, "<span class='notice'>\The [src] emits an unpleasant tone... It does not activate for you.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	else if(!active)
		activate(user)
	else
		determine_action(user)

//Make it so the crystal knows if its mob references get deleted to make sure things get cleaned up
/obj/item/capture_crystal/proc/knowyoursignals(mob/living/M, mob/living/U)
	RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/mob_was_deleted, TRUE)
	RegisterSignal(U, COMSIG_PARENT_QDELETING, .proc/owner_was_deleted, TRUE)

//The basic capture command does most of the registration work.
/obj/item/capture_crystal/proc/capture(mob/living/M, mob/living/U)
	if(!M.capture_crystal || M.capture_caught)
		to_chat(U, "<span class='warning'>This creature is not suitable for capture.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
		return
	knowyoursignals(M, U)
	owner = U
	if(isanimal(M))
		var/mob/living/simple_mob/S = M
		S.revivedby = U.name
	if(!bound_mob)
		bound_mob = M
		bound_mob.capture_caught = TRUE
		persist_storable = FALSE
	desc = "A glowing crystal in what appears to be some kind of steel housing."
	
//Determines the capture chance! So you can't capture AI mobs if they're perfectly healthy and all that
/obj/item/capture_crystal/proc/capture_chance(mob/living/M, user)
	if(capture_chance_modifier >= 100)		//Master crystal always work
		return 100
	var/capture_chance = ((1 - (M.health / M.maxHealth)) * 100)	//Inverted health percent! 100% = 0%
	//So I don't know how this works but here's a kind of explanation
	//Basic chance + ((Mob's max health - minimum calculated health) / (Max allowed health - Min allowed health)*(Chance at Max allowed health - Chance at minimum allowed health)
	capture_chance += 35 + ((M.maxHealth - 5)/ (1000-5)*(-100 - 35))
	//Basically! Mobs over 1000 max health will be unable to be caught without using status effects.
	//Thanks Aronai!
	var/effect_count = 0	//This will give you a smol chance to capture if you have applied status effects, even if the chance would ordinarily be <0
	if(M.stat == UNCONSCIOUS)
		capture_chance += 0.1
		effect_count += 1
	else if(M.stat == CONSCIOUS)
		capture_chance *= 0.9
	else
		capture_chance = 0
	if(M.weakened)			//Haha you fall down
		capture_chance += 0.1
		effect_count += 1
	if(M.stunned)			//What's the matter???
		capture_chance += 0.1
		effect_count += 1
	if(M.on_fire)			//AAAAAAAA
		capture_chance += 0.1
		effect_count += 1
	if(M.paralysis)			//Oh noooo
		capture_chance += 0.1
		effect_count += 1
	if(M.ai_holder.stance == STANCE_IDLE)	//SNEAK ATTACK???
		capture_chance += 0.1
		effect_count += 1

	capture_chance *= capture_chance_modifier

	if(capture_chance <= 0)
		capture_chance = 0 + effect_count
		if(capture_chance <= 0)
			capture_chance = 0
			to_chat(user, "<span class='notice'>There's no chance... It needs to be weaker.</span>")

	last_activate = world.time
	log_admin("[user] threw a capture crystal at [M] and got [capture_chance]% chance to catch.")
	return capture_chance

//Handles checking relevent bans, preferences, and asking the player if they want to be caught
/obj/item/capture_crystal/proc/capture_player(mob/living/M, mob/living/U)
	if(jobban_isbanned(M, "GhostRoles"))
		to_chat(U, "<span class='warning'>This creature is not suitable for capture.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	else if(!M.capture_crystal || M.capture_caught)
		to_chat(U, "<span class='warning'>This creature is not suitable for capture.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	else if(tgui_alert(M, "Would you like to be caught by in [src] by [U]? You will be bound to their will.", "Become Caught",list("No","Yes")) == "Yes")
		if(tgui_alert(M, "Are you really sure? The only way to undo this is to OOC escape while you're in the crystal.", "Become Caught", list("No","Yes")) == "Yes")
			log_admin("[key_name(M)] has agreed to become caught by [key_name(U)].")
			capture(M, U)
			recall(U)
			return
	to_chat(U, "<span class='warning'>This creature is too strong willed to be captured.</span>")
	playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)

//The clean up procs!
/obj/item/capture_crystal/proc/mob_was_deleted()
	UnregisterSignal(bound_mob, COMSIG_PARENT_QDELETING)
	UnregisterSignal(owner, COMSIG_PARENT_QDELETING)
	bound_mob.capture_caught = FALSE
	bound_mob = null
	owner = null
	active = FALSE
	persist_storable = TRUE
	update_icon()

/obj/item/capture_crystal/proc/owner_was_deleted()
	UnregisterSignal(owner, COMSIG_PARENT_QDELETING)
	owner = null
	active = FALSE
	update_icon()

//If the crystal hasn't been set up, it does this
/obj/item/capture_crystal/proc/activate(mob/living/user, target)
	if(!cooldown_check())		//Are we ready to do things yet?
		to_chat(thrower, "<span class='notice'>\The [src] clicks unsatisfyingly... It is not ready yet.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
		return
	if(spawn_mob_type && !bound_mob)			//We don't already have a mob, but we know what kind of mob we want
		bound_mob = new spawn_mob_type(src)		//Well let's spawn it then!
		bound_mob.faction = user.faction
		spawn_mob_type = null
		capture(bound_mob, user)
	if(bound_mob)								//We have a mob! Let's finish setting up.
		user.visible_message("\The [src] clicks, and then emits a small chime.", "\The [src] grows warm in your hand, something inside is awake.")
		active = TRUE
		if(!owner)								//Do we have an owner? It's pretty unlikely that this would ever happen! But it happens, let's claim the crystal.
			owner = user
			if(isanimal(bound_mob))
				var/mob/living/simple_mob/S = bound_mob
				S.revivedby = user.name
		determine_action(user, target)
		return
	else if(isliving(target))						//So we don't have a mob, let's try to claim one! Is the target a mob?
		var/mob/living/M = target
		last_activate = world.time
		if(M.capture_caught)					//Can't capture things that were already caught.
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
			to_chat(user, "<span class='notice'>\The [src] clicks unsatisfyingly... \The [M] is already under someone else's control.</span>")
			return
		else if(M.stat == DEAD)						//Is it dead? We can't influence dead things.
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
			to_chat(user, "<span class='notice'>\The [src] clicks unsatisfyingly... \The [M] is not in a state to be captured.</span>")
			return
		else if(M.client)							//Is it player controlled?
			capture_player(M, user)				//We have to do things a little differently if so.
			return
		else if(!isanimal(M))						//So it's not player controlled, but it's also not a simplemob?
			to_chat(user, "<span class='warning'>This creature is not suitable for capture.</span>")
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
			return
		var/mob/living/simple_mob/S = M
		if(!S.ai_holder)						//We don't really want to capture simplemobs that don't have an AI
			to_chat(user, "<span class='warning'>This creature is not suitable for capture.</span>")
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
		else if(prob(capture_chance(S, user)))				//OKAY! So we have an NPC simplemob with an AI, let's calculate its capture chance! It varies based on the mob's condition.
			capture(S, user)					//We did it! Woo! We capture it!
			user.visible_message("\The [src] clicks, and then emits a small chime.", "Alright! \The [S] was caught!")
			recall(user)
			active = TRUE
		else									//Shoot, it didn't work and now it's mad!!!
			S.ai_holder.go_wake()
			S.ai_holder.target = user
			S.ai_holder.track_target_position()
			S.ai_holder.set_stance(STANCE_FIGHT)
			user.visible_message("\The [src] bonks into \the [S], angering it!")
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
			to_chat(user, "<span class='notice'>\The [src] clicks unsatisfyingly.</span>")
		update_icon()
		return
	//The target is not a mob, so let's not do anything.
	playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	to_chat(user, "<span class='notice'>\The [src] clicks unsatisfyingly.</span>")

//We're using the crystal, but what will it do?
/obj/item/capture_crystal/proc/determine_action(mob/living/U, T)
	if(!cooldown_check())	//Are we ready yet?
		to_chat(thrower, "<span class='notice'>\The [src] clicks unsatisfyingly... It is not ready yet.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
		return				//No
	if(bound_mob in contents)	//Do we have our mob?
		if(T)
			unleash(U, T)		//Yes, let's let it out!
		else
			unleash(U)
	else if (bound_mob)			//Do we HAVE a mob?
		recall(U)				//Yes, let's try to put it back in the crystal
	else						//No we don't have a mob, let's reset the crystal.
		to_chat(U, "<span class='notice'>\The [src] clicks unsatisfyingly.</span>")
		active = FALSE
		update_icon()
		owner = null
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)

//Let's try to call our mob back!
/obj/item/capture_crystal/proc/recall(mob/living/user)
	if(bound_mob in view(user))		//We can only recall it if we can see it
		var/turf/turfmemory = get_turf(bound_mob)
		if(isanimal(bound_mob))
			var/mob/living/simple_mob/M = bound_mob
			M.ai_holder.go_sleep()	//AI doesn't need to think when it's in the crystal
		bound_mob.forceMove(src)
		last_activate = world.time
		bound_mob.visible_message("\The [user]'s [src] flashes, disappearing [bound_mob] in an instant!!!", "\The [src] pulls you back into confinement in a flash of light!!!")
		animate_action(turfmemory)
		playsound(src, 'sound/effects/capture-crystal-in.ogg', 75, 1, -1)
		update_icon()
	else
		to_chat(user, "<span class='notice'>\The [src] clicks and emits a small, unpleasant tone. \The [bound_mob] cannot be recalled.</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)

//Let's let our mob out!
/obj/item/capture_crystal/proc/unleash(mob/living/user, atom/target)
	if(!user && !target)			//We got thrown but we're not sure who did it, let's go to where the crystal is
		bound_mob.forceMove(src.drop_location())
		return
	if(!target)						//We know who wants to let us out, but they didn't say where, so let's drop us on them
		bound_mob.forceMove(user.drop_location())
	else							//We got thrown! Let's go where we got thrown
		bound_mob.forceMove(target.drop_location())
	last_activate = world.time
	if(isanimal(bound_mob))
		var/mob/living/simple_mob/M = bound_mob
		M.ai_holder.go_wake()		//Okay it's time to do work, let's wake up!
	bound_mob.faction = owner.faction	//Let's make sure we aren't hostile to our owner or their friends
	bound_mob.visible_message("\The [user]'s [src] flashes, \the [bound_mob] appears in an instant!!!", "The world around you rematerialize as you are unleashed from the [src] next to \the [user]. You feel a strong compulsion to enact \the [owner]'s will.")
	animate_action(get_turf(bound_mob))
	playsound(src, 'sound/effects/capture-crystal-out.ogg', 75, 1, -1)
	update_icon()

//Let's make a flashy sparkle when someone appears or disappears!
/obj/item/capture_crystal/proc/animate_action(atom/thing)
	var/image/coolanimation = image('icons/obj/capture_crystal_vr.dmi', null, "animation")
	coolanimation.plane = PLANE_LIGHTING_ABOVE
	thing.overlays += coolanimation
	sleep(11)
	thing.overlays -= coolanimation

//IF the crystal somehow ends up in a tummy and digesting with a bound mob who doesn't want to be eaten, let's move them to the ground
/obj/item/capture_crystal/digest_act(var/atom/movable/item_storage = null)
	if(bound_mob in contents && !bound_mob.devourable)
		bound_mob.forceMove(src.drop_location())
	return ..()

//We got thrown! Let's figure out what to do
/obj/item/capture_crystal/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, datum/callback/callback)
	. = ..()
	if(target == bound_mob && thrower != bound_mob)		//We got thrown at our bound mob (and weren't thrown by the bound mob) let's ignore the cooldown and just put them back in
		recall(thrower)
	else if(!cooldown_check())		//OTHERWISE let's obey the cooldown
		to_chat(thrower, "<span class='notice'>\The [src] emits an soft tone... It is not ready yet.</span>")
		if(bound_mob)
			playsound(src, 'sound/effects/capture-crystal-problem.ogg', 75, 1, -1)
		else
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	else if(!active)					//The ball isn't set up, let's try to set it up.
		if(isliving(target))	//We're hitting a mob, let's try to capture it.
			sleep(10)
			activate(thrower, target)
			return
		sleep(10)
		activate(thrower, src)
	else if(!bound_mob)				//We hit something else, and we don't have a mob, so we can't really do anything!
		to_chat(thrower, "<span class='notice'>\The [src] clicks unpleasantly...</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	else if(bound_mob in contents)	//We have our mob! Let's try to let it out.
		sleep(10)
		unleash(thrower, src)
		update_icon()
	else						//Our mob isn't here, we can't do anything.
		to_chat(thrower, "<span class='notice'>\The [src] clicks unpleasantly...</span>")
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)

/obj/item/capture_crystal/basic

/obj/item/capture_crystal/great
	name = "great capture crystal"
	capture_chance_modifier = 1.5

/obj/item/capture_crystal/ultra
	name = "ultra capture crystal"
	capture_chance_modifier = 2

/obj/item/capture_crystal/master
	name = "master capture crystal"
	capture_chance_modifier = 100

/obj/item/capture_crystal/cass
	spawn_mob_type = /mob/living/simple_mob/vore/woof/cass
/obj/item/capture_crystal/adg
	spawn_mob_type = /mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced
/obj/item/capture_crystal/bigdragon
	spawn_mob_type = /mob/living/simple_mob/vore/bigdragon
/obj/item/capture_crystal/bigdragon/friendly
	spawn_mob_type = /mob/living/simple_mob/vore/bigdragon/friendly
/obj/item/capture_crystal/teppi
	spawn_mob_type = /mob/living/simple_mob/vore/alienanimals/teppi
/obj/item/capture_crystal/broodmother
	spawn_mob_type = /mob/living/simple_mob/animal/giant_spider/broodmother
/obj/item/capture_crystal/skeleton
	spawn_mob_type = /mob/living/simple_mob/vore/alienanimals/skeleton
/obj/item/capture_crystal/dustjumper
	spawn_mob_type = /mob/living/simple_mob/vore/alienanimals/dustjumper

/obj/item/capture_crystal/random
	var/static/list/possible_mob_types = list(
		list(/mob/living/simple_mob/animal/goat),
		list(
			/mob/living/simple_mob/animal/passive/bird,
			/mob/living/simple_mob/animal/passive/bird/azure_tit,
			/mob/living/simple_mob/animal/passive/bird/black_bird,
			/mob/living/simple_mob/animal/passive/bird/european_robin,
			/mob/living/simple_mob/animal/passive/bird/goldcrest,
			/mob/living/simple_mob/animal/passive/bird/ringneck_dove,
			/mob/living/simple_mob/animal/passive/bird/parrot,
			/mob/living/simple_mob/animal/passive/bird/parrot/black_headed_caique,
			/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar,
			/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/blue,
			/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/bluegreen,
			/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel,
			/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/grey,
			/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/white,
			/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/yellowish,
			/mob/living/simple_mob/animal/passive/bird/parrot/eclectus,
			/mob/living/simple_mob/animal/passive/bird/parrot/grey_parrot,
			/mob/living/simple_mob/animal/passive/bird/parrot/kea,
			/mob/living/simple_mob/animal/passive/bird/parrot/pink_cockatoo,
			/mob/living/simple_mob/animal/passive/bird/parrot/sulphur_cockatoo,
			/mob/living/simple_mob/animal/passive/bird/parrot/white_caique,
			/mob/living/simple_mob/animal/passive/bird/parrot/white_cockatoo
		),
		list(
			/mob/living/simple_mob/animal/passive/cat,
			/mob/living/simple_mob/animal/passive/cat/black
		),
		list(/mob/living/simple_mob/animal/passive/chick),
		list(/mob/living/simple_mob/animal/passive/cow),
		list(/mob/living/simple_mob/animal/passive/dog/brittany),
		list(/mob/living/simple_mob/animal/passive/dog/corgi),
		list(/mob/living/simple_mob/animal/passive/dog/tamaskan),
		list(/mob/living/simple_mob/animal/passive/fox),
		list(/mob/living/simple_mob/animal/passive/hare),
		list(/mob/living/simple_mob/animal/passive/lizard),
		list(/mob/living/simple_mob/animal/passive/mouse),
		list(/mob/living/simple_mob/animal/passive/mouse/jerboa),
		list(/mob/living/simple_mob/animal/passive/opossum),
		list(/mob/living/simple_mob/animal/passive/pillbug),
		list(/mob/living/simple_mob/animal/passive/snake),
		list(/mob/living/simple_mob/animal/passive/tindalos),
		list(/mob/living/simple_mob/animal/passive/yithian),
		list(
			/mob/living/simple_mob/animal/wolf,
			/mob/living/simple_mob/animal/wolf/direwolf
			),
		list(/mob/living/simple_mob/vore/rabbit),
		list(/mob/living/simple_mob/vore/redpanda),
		list(/mob/living/simple_mob/vore/woof),
		list(/mob/living/simple_mob/vore/fennec),
		list(/mob/living/simple_mob/vore/fennix),
		list(/mob/living/simple_mob/vore/hippo),
		list(/mob/living/simple_mob/vore/horse),
		list(/mob/living/simple_mob/vore/bee),
		list(
			/mob/living/simple_mob/animal/space/bear,
			/mob/living/simple_mob/animal/space/bear/brown
			),
		list(
			/mob/living/simple_mob/otie/feral,
			/mob/living/simple_mob/otie/feral/chubby,
			/mob/living/simple_mob/otie/red,
			/mob/living/simple_mob/otie/red/chubby
			),
		list(/mob/living/simple_mob/animal/sif/diyaab),
		list(/mob/living/simple_mob/animal/sif/duck),
		list(/mob/living/simple_mob/animal/sif/frostfly),
		list(
			/mob/living/simple_mob/animal/sif/glitterfly =50,
			/mob/living/simple_mob/animal/sif/glitterfly/rare = 1
			),
		list(
			/mob/living/simple_mob/animal/sif/kururak = 10,
			/mob/living/simple_mob/animal/sif/kururak/leader = 1,
			/mob/living/simple_mob/animal/sif/kururak/hibernate = 2,
			),
		list(
			/mob/living/simple_mob/animal/sif/sakimm = 10,
			/mob/living/simple_mob/animal/sif/sakimm/intelligent = 1
			),
		list(/mob/living/simple_mob/animal/sif/savik) = 5,
		list(
			/mob/living/simple_mob/animal/sif/shantak = 10,
			/mob/living/simple_mob/animal/sif/shantak/leader = 1
			),
		list(/mob/living/simple_mob/animal/sif/siffet),
		list(/mob/living/simple_mob/animal/sif/tymisian),
		list(
			/mob/living/simple_mob/animal/giant_spider/nurse = 10,
			/mob/living/simple_mob/animal/giant_spider/electric = 5,
			/mob/living/simple_mob/animal/giant_spider/frost = 5,
			/mob/living/simple_mob/animal/giant_spider/hunter = 10,
			/mob/living/simple_mob/animal/giant_spider/ion = 5,
			/mob/living/simple_mob/animal/giant_spider/lurker = 10,
			/mob/living/simple_mob/animal/giant_spider/pepper = 10,
			/mob/living/simple_mob/animal/giant_spider/phorogenic = 10,
			/mob/living/simple_mob/animal/giant_spider/thermic = 5,
			/mob/living/simple_mob/animal/giant_spider/tunneler = 10,
			/mob/living/simple_mob/animal/giant_spider/webslinger = 5,
			/mob/living/simple_mob/animal/giant_spider/broodmother = 1),
		list(
			/mob/living/simple_mob/animal/wolf = 10,
			/mob/living/simple_mob/animal/wolf/direwolf = 5,
			/mob/living/simple_mob/vore/greatwolf = 1,
			/mob/living/simple_mob/vore/greatwolf/black = 1,
			/mob/living/simple_mob/vore/greatwolf/grey = 1
			),
		list(/mob/living/simple_mob/creature/strong),
		list(/mob/living/simple_mob/faithless/strong),
		list(/mob/living/simple_mob/animal/goat),
		list(
			/mob/living/simple_mob/animal/sif/shantak/leader = 1,
			/mob/living/simple_mob/animal/sif/shantak = 10),
		list(/mob/living/simple_mob/animal/sif/savik,),
		list(/mob/living/simple_mob/animal/sif/hooligan_crab),
		list(
			/mob/living/simple_mob/animal/space/alien = 50,
			/mob/living/simple_mob/animal/space/alien/drone = 40,
			/mob/living/simple_mob/animal/space/alien/sentinel = 25,
			/mob/living/simple_mob/animal/space/alien/sentinel/praetorian = 15,
			/mob/living/simple_mob/animal/space/alien/queen = 10,
			/mob/living/simple_mob/animal/space/alien/queen/empress = 5,
			/mob/living/simple_mob/animal/space/alien/queen/empress/mother = 1
			),
		list(/mob/living/simple_mob/animal/space/bats/cult/strong),
		list(
			/mob/living/simple_mob/animal/space/bear,
			/mob/living/simple_mob/animal/space/bear/brown
			),
		list(
			/mob/living/simple_mob/animal/space/carp = 50,
			/mob/living/simple_mob/animal/space/carp/large = 10,
			/mob/living/simple_mob/animal/space/carp/large/huge = 5
			),
		list(/mob/living/simple_mob/animal/space/goose),
		list(/mob/living/simple_mob/animal/space/jelly),
		list(/mob/living/simple_mob/animal/space/tree),
		list(
			/mob/living/simple_mob/vore/aggressive/corrupthound = 10,
			/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi = 1,
			),
		list(/mob/living/simple_mob/vore/aggressive/deathclaw),
		list(/mob/living/simple_mob/vore/aggressive/dino),
		list(/mob/living/simple_mob/vore/aggressive/dragon),
		list(/mob/living/simple_mob/vore/aggressive/dragon/virgo3b),
		list(/mob/living/simple_mob/vore/aggressive/frog),
		list(/mob/living/simple_mob/vore/aggressive/giant_snake),
		list(/mob/living/simple_mob/vore/aggressive/mimic),
		list(/mob/living/simple_mob/vore/aggressive/panther),
		list(/mob/living/simple_mob/vore/aggressive/rat),
		list(/mob/living/simple_mob/vore/bee),
		list(
			/mob/living/simple_mob/vore/sect_drone = 10,
			/mob/living/simple_mob/vore/sect_queen = 1
			),
		list(/mob/living/simple_mob/vore/solargrub),
		list(
			/mob/living/simple_mob/vore/oregrub = 5,
			/mob/living/simple_mob/vore/oregrub/lava = 1
			),
		list(/mob/living/simple_mob/vore/catgirl),
		list(/mob/living/simple_mob/vore/wolfgirl),
		list(
			/mob/living/simple_mob/vore/lamia,
			/mob/living/simple_mob/vore/lamia/albino,
			/mob/living/simple_mob/vore/lamia/albino/bra,
			/mob/living/simple_mob/vore/lamia/albino/shirt,
			/mob/living/simple_mob/vore/lamia/bra,
			/mob/living/simple_mob/vore/lamia/cobra,
			/mob/living/simple_mob/vore/lamia/cobra/bra,
			/mob/living/simple_mob/vore/lamia/cobra/shirt,
			/mob/living/simple_mob/vore/lamia/copper,
			/mob/living/simple_mob/vore/lamia/copper/bra,
			/mob/living/simple_mob/vore/lamia/copper/shirt,
			/mob/living/simple_mob/vore/lamia/green,
			/mob/living/simple_mob/vore/lamia/green/bra,
			/mob/living/simple_mob/vore/lamia/green/shirt,
			/mob/living/simple_mob/vore/lamia/zebra,
			/mob/living/simple_mob/vore/lamia/zebra/bra,
			/mob/living/simple_mob/vore/lamia/zebra/shirt
			),
		list(
			/mob/living/simple_mob/humanoid/merc = 100,
			/mob/living/simple_mob/humanoid/merc/melee/sword = 50,
			/mob/living/simple_mob/humanoid/merc/ranged = 25,
			/mob/living/simple_mob/humanoid/merc/ranged/grenadier = 1,
			/mob/living/simple_mob/humanoid/merc/ranged/ionrifle = 10,
			/mob/living/simple_mob/humanoid/merc/ranged/laser = 5,
			/mob/living/simple_mob/humanoid/merc/ranged/rifle = 5,
			/mob/living/simple_mob/humanoid/merc/ranged/smg = 5,
			/mob/living/simple_mob/humanoid/merc/ranged/sniper = 1,
			/mob/living/simple_mob/humanoid/merc/ranged/space = 10,
			/mob/living/simple_mob/humanoid/merc/ranged/technician = 5
			),
		list(
			/mob/living/simple_mob/humanoid/pirate = 3,
			/mob/living/simple_mob/humanoid/pirate/ranged = 1
			),
		list(/mob/living/simple_mob/mechanical/combat_drone),
		list(/mob/living/simple_mob/mechanical/corrupt_maint_drone),
		list(
			/mob/living/simple_mob/mechanical/hivebot = 100,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage = 20,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/backline = 10,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/basic = 20,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/dot = 5,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/ion = 20,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/laser = 10,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/rapid = 2,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege = 1,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/emp = 5,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/fragmentation = 1,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/radiation = 1,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong = 3,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong/guard = 3,
			/mob/living/simple_mob/mechanical/hivebot/support = 8,
			/mob/living/simple_mob/mechanical/hivebot/support/commander = 5,
			/mob/living/simple_mob/mechanical/hivebot/support/commander/autofollow = 10,
			/mob/living/simple_mob/mechanical/hivebot/swarm = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/armored = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_bullet = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_laser = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_melee = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/meatshield = 20
			),
		list(/mob/living/simple_mob/mechanical/infectionbot),
		list(/mob/living/simple_mob/mechanical/mining_drone),
		list(/mob/living/simple_mob/mechanical/technomancer_golem),
		list(
			/mob/living/simple_mob/mechanical/viscerator,
			/mob/living/simple_mob/mechanical/viscerator/piercing
			),
		list(/mob/living/simple_mob/mechanical/wahlem),
		list(/mob/living/simple_mob/animal/passive/fox/syndicate),
		list(/mob/living/simple_mob/animal/passive/fox),
		list(/mob/living/simple_mob/animal/wolf/direwolf),
		list(/mob/living/simple_mob/animal/space/jelly),
		list(
			/mob/living/simple_mob/otie/feral,
			/mob/living/simple_mob/otie/feral/chubby,
			/mob/living/simple_mob/otie/red,
			/mob/living/simple_mob/otie/red/chubby
			),
		list(
			/mob/living/simple_mob/shadekin/blue = 100,
			/mob/living/simple_mob/shadekin/green = 50,
			/mob/living/simple_mob/shadekin/orange = 20,
			/mob/living/simple_mob/shadekin/purple = 60,
			/mob/living/simple_mob/shadekin/red = 40,
			/mob/living/simple_mob/shadekin/yellow = 1
			),
		list(
			/mob/living/simple_mob/vore/aggressive/corrupthound,
			/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi
			),
		list(/mob/living/simple_mob/vore/aggressive/deathclaw),
		list(/mob/living/simple_mob/vore/aggressive/dino),
		list(/mob/living/simple_mob/vore/aggressive/dragon),
		list(/mob/living/simple_mob/vore/aggressive/dragon/virgo3b),
		list(/mob/living/simple_mob/vore/aggressive/frog),
		list(/mob/living/simple_mob/vore/aggressive/giant_snake),
		list(/mob/living/simple_mob/vore/aggressive/mimic),
		list(/mob/living/simple_mob/vore/aggressive/panther),
		list(/mob/living/simple_mob/vore/aggressive/rat),
		list(/mob/living/simple_mob/vore/bee),
		list(/mob/living/simple_mob/vore/catgirl),
		list(/mob/living/simple_mob/vore/cookiegirl),
		list(/mob/living/simple_mob/vore/fennec),
		list(/mob/living/simple_mob/vore/fennix),
		list(/mob/living/simple_mob/vore/hippo),
		list(/mob/living/simple_mob/vore/horse),
		list(/mob/living/simple_mob/vore/oregrub),
		list(/mob/living/simple_mob/vore/rabbit),
		list(
			/mob/living/simple_mob/vore/redpanda = 50,
			/mob/living/simple_mob/vore/redpanda/fae = 1
			),
		list(
			/mob/living/simple_mob/vore/sect_drone = 10,
			/mob/living/simple_mob/vore/sect_queen = 1
			),
		list(/mob/living/simple_mob/vore/solargrub),
		list(/mob/living/simple_mob/vore/woof),
		list(/mob/living/simple_mob/vore/alienanimals/teppi),
		list(/mob/living/simple_mob/vore/alienanimals/space_ghost),
		list(/mob/living/simple_mob/vore/alienanimals/catslug),
		list(/mob/living/simple_mob/vore/alienanimals/space_jellyfish),
		list(/mob/living/simple_mob/vore/alienanimals/startreader),
		list(/mob/living/simple_mob/vore/bigdragon),
		list(
			/mob/living/simple_mob/vore/leopardmander = 50,
			/mob/living/simple_mob/vore/leopardmander/blue = 10,
			/mob/living/simple_mob/vore/leopardmander/exotic = 1
			),
		list(/mob/living/simple_mob/vore/sheep),
		list(/mob/living/simple_mob/vore/weretiger),
		list(/mob/living/simple_mob/vore/alienanimals/skeleton),
		list(/mob/living/simple_mob/vore/alienanimals/dustjumper)
		)

/obj/item/capture_crystal/random/Initialize()
	var/subchoice = pickweight(possible_mob_types)		//Some of the lists have nested lists, so let's pick one of them
	var/choice = pickweight(subchoice)					//And then we'll pick something from whatever's left
	spawn_mob_type = choice								//Now when someone uses this, we'll spawn whatever we picked!
	return ..()

/mob/living
	var/capture_crystal = TRUE		//If TRUE, the mob is capturable. Otherwise it isn't.
	var/capture_caught = FALSE		//If TRUE, the mob has already been caught, and so cannot be caught again.