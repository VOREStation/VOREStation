/mob/living/simple_mob //makes it so that any simplemob can potentially be revived by players and joined by ghosts
	var/ghostjoin = FALSE
	var/ic_revivable = FALSE
	var/revivedby = "no one"

/mob/living/simple_mob/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, ghostjoin))
			if(ghostjoin == var_value)
				return

			if(var_value)
				ghostjoin = TRUE
				active_ghost_pods |= src
			else
				ghostjoin = FALSE
				active_ghost_pods -= src

			ghostjoin_icon()
			. =  TRUE

	if(!isnull(.))
		datum_flags |= DF_VAR_EDITED
		return

	. = ..()


//The stuff we want to be revivable normally
/mob/living/simple_mob/animal
	ic_revivable = TRUE
/mob/living/simple_mob/vore/otie
	ic_revivable = TRUE
/mob/living/simple_mob/vore
	ic_revivable = TRUE
//The stuff that would be revivable but that we don't want to be revivable
/mob/living/simple_mob/animal/giant_spider/nurse //no you can't revive the ones who can lay eggs and get webs everywhere
	ic_revivable = FALSE
/mob/living/simple_mob/animal/giant_spider/carrier //or the ones who fart babies when they die
	ic_revivable = FALSE

/// A ghost has clicked us
/mob/living/simple_mob/attack_ghost(mob/observer/dead/user as mob)
	if(!ghostjoin)
		return ..()
	if(jobban_isbanned(user, JOB_GHOSTROLES))
		to_chat(user, span_warning("You cannot inhabit this creature because you are banned from playing ghost roles."))
		return
	if(!evaluate_ghost_join(user))
		return ..()

	tgui_alert_async(user, "Would you like to become [src]? It is bound to [revivedby].", "Become Mob", list("Yes","No"), CALLBACK(src, PROC_REF(reply_ghost_join)), 20 SECONDS)

/// A reply to an async alert request was received
/mob/living/simple_mob/proc/reply_ghost_join(response)
	if(response != "Yes")
		return // ok

	var/mob/observer/dead/D = usr
	if(evaluate_ghost_join(D))
		ghost_join(D)

/// Inject a ghost into this mob. Assumes you've done all sanity before this point.
/mob/living/simple_mob/proc/ghost_join(mob/observer/dead/D)
	log_and_message_admins("joined [src] as a ghost [ADMIN_FLW(src)]", D)
	active_ghost_pods -= src

	// Move the ghost in
	if(D.mind)
		D.mind.active = TRUE
		D.mind.transfer_to(src)
	else
		src.ckey = D.ckey
	qdel(D)

	// Clean up the simplemob
	ghostjoin = FALSE
	ghostjoin_icon()
	if(capture_caught)
		to_chat(src, span_notice("You are bound to [revivedby], follow their commands within reason and to the best of your abilities, and avoid betraying or abandoning them.") + " " + span_warning("You are allied with [revivedby]. Do not attack anyone for no reason. Of course, you may do scenes as you like, but you must still respect preferences."))
		visible_message("[src]'s eyes flicker with a curious intelligence.", runemessage = "looks around")
		return
	if(revivedby != "no one")
		to_chat(src, span_notice("Where once your life had been rough and scary, you have been assisted by [revivedby]. They seem to be the reason you are on your feet again... so perhaps you should help them out.") + " " + span_warning("Being as you were revived, you are allied with the station. Do not attack anyone unless they are threatening the one who revived you. And try to listen to the one who revived you within reason. Of course, you may do scenes as you like, but you must still respect preferences."))
		visible_message("[src]'s eyes flicker with a curious intelligence.", runemessage = "looks around")

/// Evaluate someone for being allowed to join as this mob from being a ghost
/mob/living/simple_mob/proc/evaluate_ghost_join(mob/observer/dead/D)
	if(!istype(D) || !D.client)
		stack_trace("A non-ghost mob was evaluated for joining into a simplemob...")
		return FALSE

	// At this point we can at least send them messages as to why they can't join, since they are a mob with a client
	if(!ghostjoin)
		to_chat(D, span_notice("Sorry, [src] is no longer ghost-joinable."))
		return FALSE

	if(ckey)
		to_chat(D, span_notice("Sorry, someone else has already inhabited [src]."))
		return FALSE

	if(capture_caught && !D.client.prefs.capture_crystal)
		to_chat(D, span_notice("Sorry, [src] is participating in capture mechanics, and your preferences do not allow for that."))
		return FALSE

	// Insert whatever ban checks you want here if we ever add simplemob bans

	return TRUE

/obj/item/denecrotizer //Away map reward. FOR TRAINED NECROMANCERS ONLY. >:C
	name = "experimental denecrotizer"
	desc = "It looks simple on the outside but this device radiates some unknown dread. It does not appear to be of any ordinary make, and just how it works is unclear, but this device seems to interact with dead flesh."
	icon = 'icons/obj/device_vr.dmi'
	icon_state = "denecrotizer"
	w_class = ITEMSIZE_COST_NORMAL
	var/charges = 5 //your army of minions can only be this big
	var/last_used
	var/cooldown = 10 MINUTES //LONG
	var/revive_time = 30 SECONDS //Don't do this in combat
	var/advanced = 1 //allows for ghosts to join mobs who get revived by this, and updates their faction to yours

/obj/item/denecrotizer/examine(var/mob/user)
	. = ..()
	var/cooldowntime = round((cooldown - (world.time - last_used)) * 0.1)
	if(Adjacent(user))
		if(cooldowntime <= 0)
			. += span_notice("The screen indicates that this device is ready to be used, and that it has enough energy for [charges] uses.")
		else
			. += span_notice("The screen indicates that this device can be used again in [cooldowntime] seconds, and that it has enough energy for [charges] uses.")

/obj/item/denecrotizer/proc/check_target(mob/living/simple_mob/target, mob/living/user)
	if(!target.Adjacent(user))
		return FALSE
	if(user.a_intent != I_HELP) //be gentle
		user.visible_message("[user] bonks [target] with [src].", runemessage = "bonks [target]")
		return FALSE
	if(!istype(target))
		to_chat(user, span_notice("[target] seems to be too complicated for [src] to interface with."))
		return FALSE
	if(!(world.time - last_used > cooldown))
		to_chat(user, span_notice("[src] doesn't seem to be ready yet."))
		return FALSE
	if(!charges)
		to_chat(user, span_notice("[src] doesn't seem to be active anymore."))
		return FALSE
	if(!target.ic_revivable)
		to_chat(user, span_notice("[src] doesn't seem to interface with [target]."))
		return FALSE
	if(target.stat != DEAD)
		if(!advanced)
			to_chat(user, span_notice("[src] doesn't seem to work on that."))
			return FALSE
		if(target.ai_holder.retaliate || target.ai_holder.hostile) // You can be friends with still living mobs if they are passive I GUESS
			to_chat(user, span_notice("[src] doesn't seem to work on that."))
			return FALSE
		if(!target.mind)
			user.visible_message("[user] gently presses [src] to [target]...", runemessage = "presses [src] to [target]")
			if(do_after(user, revive_time, exclusive = TASK_USER_EXCLUSIVE, target = target))
				target.faction = user.faction
				target.revivedby = user.name
				target.ghostjoin = 1
				active_ghost_pods += target
				target.ghostjoin_icon()
				last_used = world.time
				charges--
				log_and_message_admins("used a denecrotizer to tame/offer a simplemob to ghosts: [target]. [ADMIN_FLW(src)]", user)
				target.visible_message("[target]'s eyes widen, as though in revelation as it looks at [user].", runemessage = "eyes widen")
				if(charges == 0)
					icon_state = "[initial(icon_state)]-o"
					update_icon()
			return FALSE
		else
			to_chat(user, span_notice("[src] doesn't seem to work on that."))
			return FALSE
	return TRUE

/obj/item/denecrotizer/proc/ghostjoin_rez(mob/living/simple_mob/target, mob/living/user)
	user.visible_message("[user] gently presses [src] to [target]...", runemessage = "presses [src] to [target]")
	if(do_after(user, revive_time, exclusive = TASK_ALL_EXCLUSIVE, target = target))
		target.faction = user.faction
		target.revivedby = user.name
		target.ai_holder.returns_home = FALSE
		target.revive()
		target.sight = initial(target.sight)
		target.see_in_dark = initial(target.see_in_dark)
		target.see_invisible = initial(target.see_invisible)
		target.update_icon()
		visible_message("[target] lifts its head and looks at [user].", runemessage = "lifts its head and looks at [user]")
		log_and_message_admins("used a denecrotizer to revive a simple mob: [target]. [ADMIN_FLW(src)]", user)
		if(!target.mind) //if it doesn't have a mind then no one has been playing as it, and it is safe to offer to ghosts.
			target.ghostjoin = 1
			active_ghost_pods |= target
			target.ghostjoin_icon()
		last_used = world.time
		charges--
		if(charges == 0)
			icon_state = "[initial(icon_state)]-o"
			update_icon()
		return

/obj/item/denecrotizer/proc/basic_rez(mob/living/simple_mob/target, mob/living/user) //so medical can have a way to bring back people's pets or whatever, does not change any settings about the mob or offer it to ghosts.
	user.visible_message("[user] presses [src] to [target]...", runemessage = "presses [src] to [target]")
	if(do_after(user, revive_time, exclusive = TASK_ALL_EXCLUSIVE, target = target))
		target.revive()
		target.sight = initial(target.sight)
		target.see_in_dark = initial(target.see_in_dark)
		target.see_invisible = initial(target.see_invisible)
		target.update_icon()
		visible_message("[target] lifts its head and looks at [user].", runemessage = "lifts its head and looks at [user]")
		last_used = world.time
		charges--
		if(charges == 0)
			icon_state = "[initial(icon_state)]-o"
			update_icon()
		return
	else
		user.visible_message("[user] bonks [target] with [src]. Nothing happened.")
		return



/obj/item/denecrotizer/attack(mob/living/simple_mob/target, mob/living/user)
	if(check_target(target, user))
		if(advanced)
			ghostjoin_rez(target, user)
		else
			basic_rez(target, user)
	else
		return ..()

/mob/living/simple_mob/proc/ghostjoin_icon() //puts an icon on mobs for ghosts, so they can see if a mob has been revived and is joinable
	var/static/image/I
	if(!I)
		I = image('icons/mob/hud_vr.dmi', "ghostjoin")
		I.invisibility = INVISIBILITY_OBSERVER
		I.plane = PLANE_GHOSTS
		I.appearance_flags = KEEP_APART|RESET_TRANSFORM

	cut_overlay(I)

	if(ghostjoin)
		add_overlay(I)

/obj/item/denecrotizer/medical //Can revive more things, but without the special ghost and faction stuff. For medical use.
	name = "commercial denecrotizer"
	desc = "A curious device who's purpose is reviving simpler life forms. It seems to radiate menace."
	icon_state = "m-denecrotizer"
	advanced = 0 //This one isn't as fancy
	cooldown = 5 MINUTES //not as long
	charges = 20 //in case spiders merc Ian
