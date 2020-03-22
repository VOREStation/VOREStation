///////////////////// Mob Living /////////////////////
/mob/living
	var/digestable = TRUE				// Can the mob be digested inside a belly?
	var/devourable = TRUE				// Can the mob be devoured at all?
	var/feeding = TRUE					// Can the mob be vorishly force fed or fed to others?
	var/absorbable = TRUE				// Are you allowed to absorb this person? TFF addition 14/12/19
	var/digest_leave_remains = FALSE	// Will this mob leave bones/skull/etc after the melty demise?
	var/allowmobvore = TRUE				// Will simplemobs attempt to eat the mob?
	var/showvoreprefs = TRUE			// Determines if the mechanical vore preferences button will be displayed on the mob or not.
	var/obj/belly/vore_selected			// Default to no vore capability.
	var/list/vore_organs = list()		// List of vore containers inside a mob
	var/absorbed = FALSE				// If a mob is absorbed into another
	var/weight = 137					// Weight for mobs for weightgain system
	var/weight_gain = 1 				// How fast you gain weight
	var/weight_loss = 0.5 				// How fast you lose weight
	var/vore_egg_type = "egg" 				// Default egg type.
	var/feral = 0 						// How feral the mob is, if at all. Does nothing for non xenochimera at the moment.
	var/revive_ready = REVIVING_READY	// Only used for creatures that have the xenochimera regen ability, so far.
	var/metabolism = 0.0015
	var/vore_taste = null				// What the character tastes like
	var/no_vore = FALSE					// If the character/mob can vore.
	var/noisy = FALSE					// Toggle audible hunger.
	var/absorbing_prey = 0 				// Determines if the person is using the succubus drain or not. See station_special_abilities_vr.
	var/drain_finalized = 0				// Determines if the succubus drain will be KO'd/absorbed. Can be toggled on at any time.
	var/fuzzy = 1						// Preference toggle for sharp/fuzzy icon.
	var/tail_alt = 0					// Tail layer toggle.
	var/permit_healbelly = TRUE
	var/can_be_drop_prey = FALSE
	var/can_be_drop_pred = TRUE			// Mobs are pred by default.
	var/next_preyloop					// For Fancy sound internal loop
	var/adminbus_trash = FALSE			// For abusing trash eater for event shenanigans.
	var/vis_height = 32					// Sprite height used for resize features.

//
// Hook for generic creation of stuff on new creatures
//
/hook/living_new/proc/vore_setup(mob/living/M)
	M.verbs += /mob/living/proc/escapeOOC
	M.verbs += /mob/living/proc/lick
	M.verbs += /mob/living/proc/switch_scaling
	if(M.no_vore) //If the mob isn't supposed to have a stomach, let's not give it an insidepanel so it can make one for itself, or a stomach.
		return TRUE
	M.vorePanel = new
	M.verbs += /mob/living/proc/insidePanel

	//Tries to load prefs if a client is present otherwise gives freebie stomach
	spawn(2 SECONDS)
		if(M)
			M.init_vore()

	//return TRUE to hook-caller
	return TRUE

/mob/living/proc/init_vore()
	//Something else made organs, meanwhile.
	if(LAZYLEN(vore_organs))
		return TRUE

	//We'll load our client's organs if we have one
	if(client && client.prefs_vr)
		if(!copy_from_prefs_vr())
			to_chat(src,"<span class='warning'>ERROR: You seem to have saved VOREStation prefs, but they couldn't be loaded.</span>")
			return FALSE
		if(LAZYLEN(vore_organs))
			vore_selected = vore_organs[1]
			return TRUE

	//Or, we can create a basic one for them
	if(!LAZYLEN(vore_organs))
		LAZYINITLIST(vore_organs)
		var/obj/belly/B = new /obj/belly(src)
		vore_selected = B
		B.immutable = TRUE
		B.name = "Stomach"
		B.desc = "It appears to be rather warm and wet. Makes sense, considering it's inside \the [name]."
		B.can_taste = TRUE
		return TRUE

//
// Hide vore organs in contents
//
///mob/living/view_variables_filter_contents(list/L)
//	. = ..()
//	var/len_before = L.len
//	L -= vore_organs
//	. += len_before - L.len
//
//
// Handle being clicked, perhaps with something to devour
//
/mob/living/proc/vore_attackby(obj/item/I, mob/user)
	//Handle case: /obj/item/weapon/grab
	if(istype(I, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = I

		//Has to be aggressive grab, has to be living click-er and non-silicon grabbed
		if(G.state >= GRAB_AGGRESSIVE && (isliving(user) && !issilicon(G.affecting)))
			var/mob/living/attacker = user  // Typecast to living

			// src is the mob clicked on and attempted predator

			///// If user clicked on themselves
			if(src == G.assailant && is_vore_predator(src))
				if(!G.affecting.devourable)
					to_chat(user, "<span class='notice'>They aren't able to be devoured.</span>")
					log_and_message_admins("[key_name_admin(src)] attempted to devour [key_name_admin(G.affecting)] against their prefs ([G.affecting ? ADMIN_JMP(G.affecting) : "null"])")
					return FALSE

				if(feed_grabbed_to_self(src, G.affecting))
					qdel(G)
					return TRUE
				else
					log_debug("[attacker] attempted to feed [G.affecting] to [user] ([user.type]) but it failed.")

			///// If user clicked on their grabbed target
			else if((src == G.affecting) && (attacker.a_intent == I_GRAB) && (attacker.zone_sel.selecting == BP_TORSO) && (is_vore_predator(G.affecting)))
				if(!G.affecting.feeding)
					to_chat(user, "<span class='notice'>[G.affecting] isn't willing to be fed.</span>")
					log_and_message_admins("[key_name_admin(src)] attempted to feed themselves to [key_name_admin(G.affecting)] against their prefs ([G.affecting ? ADMIN_JMP(G.affecting) : "null"])")
					return FALSE

				if(attacker.feed_self_to_grabbed(attacker, G.affecting))
					qdel(G)
					return TRUE
				else
					log_debug("[attacker] attempted to feed [user] to [G.affecting] ([G.affecting ? G.affecting.type : "null"]) but it failed.")

			///// If user clicked on anyone else but their grabbed target
			else if((src != G.affecting) && (src != G.assailant) && (is_vore_predator(src)))
				if(!feeding)
					to_chat(user, "<span class='notice'>[src] isn't willing to be fed.</span>")
					log_and_message_admins("[key_name_admin(attacker)] attempted to feed [key_name_admin(G.affecting)] to [key_name_admin(src)] against predator's prefs ([src ? ADMIN_JMP(src) : "null"])")
					return FALSE
				if(!(G.affecting.devourable))
					to_chat(user, "<span class='notice'>[G.affecting] isn't able to be devoured.</span>")
					log_and_message_admins("[key_name_admin(attacker)] attempted to feed [key_name_admin(G.affecting)] to [key_name_admin(src)] against prey's prefs ([G.affecting ? ADMIN_JMP(G.affecting) : "null"])")
					return FALSE
				if(attacker.feed_grabbed_to_other(attacker, G.affecting, src))
					qdel(G)
					return TRUE
				else
					log_debug("[attacker] attempted to feed [G.affecting] to [src] ([type]) but it failed.")

	//Handle case: /obj/item/weapon/holder
	else if(istype(I, /obj/item/weapon/holder))
		var/obj/item/weapon/holder/H = I

		if(!isliving(user))
			return FALSE // return FALSE to continue upper procs
		
		var/mob/living/attacker = user  // Typecast to living
		if(is_vore_predator(src))
			for(var/mob/living/M in H.contents)
				if(attacker.eat_held_mob(attacker, M, src))
					if(H.held_mob == M)
						H.held_mob = null
			return TRUE //return TRUE to exit upper procs
		else
			log_debug("[attacker] attempted to feed [H.contents] to [src] ([type]) but it failed.")

	//Handle case: /obj/item/device/radio/beacon
	else if(istype(I,/obj/item/device/radio/beacon))
		var/confirm = alert(user,
			"[src == user ? "Eat the beacon?" : "Feed the beacon to [src]?"]",
			"Confirmation",
			"Yes!", "Cancel")
		if(confirm == "Yes!")
			var/obj/belly/B = input("Which belly?", "Select A Belly") as null|anything in vore_organs
			if(!istype(B))
				return TRUE
			visible_message("<span class='warning'>[user] is trying to stuff a beacon into [src]'s [lowertext(B.name)]!</span>",
				"<span class='warning'>[user] is trying to stuff a beacon into you!</span>")
			if(do_after(user,30,src))
				user.drop_item()
				I.forceMove(B)
				return TRUE
			else
				return TRUE //You don't get to hit someone 'later'

	return FALSE

//
// Our custom resist catches for /mob/living
//
/mob/living/proc/vore_process_resist()
	//Are we resisting from inside a belly?
	if(isbelly(loc))
		var/obj/belly/B = loc
		B.relay_resist(src)
		return TRUE //resist() on living does this TRUE thing.

	//Other overridden resists go here
	return FALSE

//
//	Verb for saving vore preferences to save file
//
/mob/living/proc/save_vore_prefs()
	if(!client || !client.prefs_vr)
		return FALSE
	if(!copy_to_prefs_vr())
		return FALSE
	if(!client.prefs_vr.save_vore())
		return FALSE

	return TRUE

/mob/living/proc/apply_vore_prefs()
	if(!client || !client.prefs_vr)
		return FALSE
	if(!client.prefs_vr.load_vore())
		return FALSE
	if(!copy_from_prefs_vr())
		return FALSE

	return TRUE

/mob/living/proc/copy_to_prefs_vr()
	if(!client || !client.prefs_vr)
		to_chat(src,"<span class='warning'>You attempted to save your vore prefs but somehow you're in this character without a client.prefs_vr variable. Tell a dev.</span>")
		return FALSE

	var/datum/vore_preferences/P = client.prefs_vr

	P.digestable = src.digestable
	P.devourable = src.devourable
	P.feeding = src.feeding
	P.absorbable = src.absorbable	//TFF 14/12/19 - choose whether allowing absorbing
	P.digest_leave_remains = src.digest_leave_remains
	P.allowmobvore = src.allowmobvore
	P.vore_taste = src.vore_taste
	P.permit_healbelly = src.permit_healbelly
	P.can_be_drop_prey = src.can_be_drop_prey
	P.can_be_drop_pred = src.can_be_drop_pred

	var/list/serialized = list()
	for(var/belly in src.vore_organs)
		var/obj/belly/B = belly
		serialized += list(B.serialize()) //Can't add a list as an object to another list in Byond. Thanks.

	P.belly_prefs = serialized

	return TRUE

//
//	Proc for applying vore preferences, given bellies
//
/mob/living/proc/copy_from_prefs_vr(var/bellies = TRUE)
	if(!client || !client.prefs_vr)
		to_chat(src,"<span class='warning'>You attempted to apply your vore prefs but somehow you're in this character without a client.prefs_vr variable. Tell a dev.</span>")
		return FALSE

	var/datum/vore_preferences/P = client.prefs_vr

	digestable = P.digestable
	devourable = P.devourable
	feeding = P.feeding
	absorbable = P.absorbable	//TFF 14/12/19 - choose whether allowing absorbing
	digest_leave_remains = P.digest_leave_remains
	allowmobvore = P.allowmobvore
	vore_taste = P.vore_taste
	permit_healbelly = P.permit_healbelly
	can_be_drop_prey = P.can_be_drop_prey
	can_be_drop_pred = P.can_be_drop_pred

	if(bellies)
		release_vore_contents(silent = TRUE)
		vore_organs.Cut()
		for(var/entry in P.belly_prefs)
			list_to_object(entry,src)

	return TRUE

//
// Release everything in every vore organ
//
/mob/living/proc/release_vore_contents(var/include_absorbed = TRUE, var/silent = FALSE)
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		B.release_all_contents(include_absorbed, silent)

//
// Returns examine messages for bellies
//
/mob/living/proc/examine_bellies()
	if(!show_pudge()) //Some clothing or equipment can hide this.
		return ""

	var/message = ""
	for (var/belly in vore_organs)
		var/obj/belly/B = belly
		message += B.get_examine_msg()

	return message

//
// Whether or not people can see our belly messages
//
/mob/living/proc/show_pudge()
	return TRUE //Can override if you want.

/mob/living/carbon/human/show_pudge()
	//A uniform could hide it.
	if(istype(w_uniform,/obj/item/clothing))
		var/obj/item/clothing/under = w_uniform
		if(under.hides_bulges)
			return FALSE

	//We return as soon as we find one, no need for 'else' really.
	if(istype(wear_suit,/obj/item/clothing))
		var/obj/item/clothing/suit = wear_suit
		if(suit.hides_bulges)
			return FALSE

	return ..()

//
// Clearly super important. Obviously.
//
/mob/living/proc/lick(mob/living/tasted in living_mobs(1))
	set name = "Lick"
	set category = "IC"
	set desc = "Lick someone nearby!"
	set popup_menu = FALSE // Stop licking by accident!

	if(!istype(tasted))
		return

	if(!canClick() || incapacitated(INCAPACITATION_ALL))
		return

	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	visible_message("<span class='warning'>[src] licks [tasted]!</span>","<span class='notice'>You lick [tasted]. They taste rather like [tasted.get_taste_message()].</span>","<b>Slurp!</b>")


/mob/living/proc/get_taste_message(allow_generic = 1)
	if(!vore_taste && !allow_generic)
		return FALSE

	var/taste_message = ""
	if(vore_taste && (vore_taste != ""))
		taste_message += "[vore_taste]"
	else
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			taste_message += "a normal [H.custom_species ? H.custom_species : H.species.name]"
		else
			taste_message += "a plain old normal [src]"

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.touching.reagent_list.len) //Just the first one otherwise I'll go insane.
			var/datum/reagent/R = H.touching.reagent_list[1]
			taste_message += " You also get the flavor of [R.taste_description] from something on them"
	return taste_message
//
// OOC Escape code for pref-breaking or AFK preds
//
/mob/living/proc/escapeOOC()
	set name = "OOC Escape"
	set category = "OOC"

	//You're in a belly!
	if(isbelly(loc))
		var/obj/belly/B = loc
		var/confirm = alert(src, "You're in a mob. Don't use this as a trick to get out of hostile animals. This is for escaping from preference-breaking and if you're otherwise unable to escape from endo (pred AFK for a long time).", "Confirmation", "Okay", "Cancel")
		if(!confirm == "Okay" || loc != B)
			return
		//Actual escaping
		absorbed = 0	//Make sure we're not absorbed
		muffled = 0		//Removes Muffling
		forceMove(get_turf(src)) //Just move me up to the turf, let's not cascade through bellies, there's been a problem, let's just leave.
		for(var/mob/living/simple_mob/SA in range(10))
			SA.prey_excludes[src] = world.time
		log_and_message_admins("[key_name(src)] used the OOC escape button to get out of [key_name(B.owner)] ([B.owner ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[B.owner.x];Y=[B.owner.y];Z=[B.owner.z]'>JMP</a>" : "null"])")

		if(!ishuman(B.owner))
			B.owner.update_icons()

	//You're in a dogborg!
	else if(istype(loc, /obj/item/device/dogborg/sleeper))
		var/mob/living/silicon/pred = loc.loc //Thing holding the belly!
		var/obj/item/device/dogborg/sleeper/belly = loc //The belly!

		var/confirm = alert(src, "You're in a dogborg sleeper. This is for escaping from preference-breaking or if your predator disconnects/AFKs. If your preferences were being broken, please admin-help as well.", "Confirmation", "Okay", "Cancel")
		if(!confirm == "Okay" || loc != belly)
			return
		//Actual escaping
		log_and_message_admins("[key_name(src)] used the OOC escape button to get out of [key_name(pred)] (BORG) ([pred ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[pred.x];Y=[pred.y];Z=[pred.z]'>JMP</a>" : "null"])")
		belly.go_out(src) //Just force-ejects from the borg as if they'd clicked the eject button.

	//You're in an AI hologram!
	else if(istype(loc, /obj/effect/overlay/aiholo))
		var/obj/effect/overlay/aiholo/holo = loc
		holo.drop_prey() //Easiest way
		log_and_message_admins("[key_name(src)] used the OOC escape button to get out of [key_name(holo.master)] (AI HOLO) ([holo ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[holo.x];Y=[holo.y];Z=[holo.z]'>JMP</a>" : "null"])")

	//Don't appear to be in a vore situation
	else
		to_chat(src,"<span class='alert'>You aren't inside anyone, though, is the thing.</span>")

//
// Eating procs depending on who clicked what
//
/mob/living/proc/feed_grabbed_to_self(mob/living/user, mob/living/prey)
	var/belly = user.vore_selected
	return perform_the_nom(user, prey, user, belly)

/mob/living/proc/eat_held_mob(mob/living/user, mob/living/prey, mob/living/pred)
	var/belly
	if(user != pred)
		belly = input("Choose Belly") in pred.vore_organs
	else
		belly = pred.vore_selected
	return perform_the_nom(user, prey, pred, belly)

/mob/living/proc/feed_self_to_grabbed(mob/living/user, mob/living/pred)
	var/belly = input("Choose Belly") in pred.vore_organs
	return perform_the_nom(user, user, pred, belly)

/mob/living/proc/feed_grabbed_to_other(mob/living/user, mob/living/prey, mob/living/pred)
	var/belly = input("Choose Belly") in pred.vore_organs
	return perform_the_nom(user, prey, pred, belly)

//
// Master vore proc that actually does vore procedures
//
/mob/living/proc/perform_the_nom(mob/living/user, mob/living/prey, mob/living/pred, obj/belly/belly, delay)
	//Sanity
	if(!user || !prey || !pred || !istype(belly) || !(belly in pred.vore_organs))
		log_debug("[user] attempted to feed [prey] to [pred], via [belly ? lowertext(belly.name) : "*null*"] but it went wrong.")
		return

	// The belly selected at the time of noms
	var/attempt_msg = "ERROR: Vore message couldn't be created. Notify a dev. (at)"
	var/success_msg = "ERROR: Vore message couldn't be created. Notify a dev. (sc)"

	//Final distance check. Time has passed, menus have come and gone. Can't use do_after adjacent because doesn't behave for held micros
	var/user_to_pred = get_dist(get_turf(user),get_turf(pred))
	var/user_to_prey = get_dist(get_turf(user),get_turf(prey))

	if(user_to_pred > 1 || user_to_prey > 1)
		return FALSE

	// Prepare messages
	if(user == pred) //Feeding someone to yourself
		attempt_msg = "<span class='warning'>[pred] is attempting to [lowertext(belly.vore_verb)] [prey] into their [lowertext(belly.name)]!</span>"
		success_msg = "<span class='warning'>[pred] manages to [lowertext(belly.vore_verb)] [prey] into their [lowertext(belly.name)]!</span>"
	else //Feeding someone to another person
		attempt_msg = "<span class='warning'>[user] is attempting to make [pred] [lowertext(belly.vore_verb)] [prey] into their [lowertext(belly.name)]!</span>"
		success_msg = "<span class='warning'>[user] manages to make [pred] [lowertext(belly.vore_verb)] [prey] into their [lowertext(belly.name)]!</span>"

	// Announce that we start the attempt!
	user.visible_message(attempt_msg)

	// Now give the prey time to escape... return if they did
	var/swallow_time
	if(delay)
		swallow_time = delay
	else
		swallow_time = istype(prey, /mob/living/carbon/human) ? belly.human_prey_swallow_time : belly.nonhuman_prey_swallow_time

	//Timer and progress bar
	if(!do_after(user, swallow_time, prey))
		return FALSE // Prey escpaed (or user disabled) before timer expired.

	// If we got this far, nom successful! Announce it!
	user.visible_message(success_msg)

	// Actually shove prey into the belly.
	belly.nom_mob(prey, user)
	if(!ishuman(user))
		user.update_icons()

	// Flavor handling
	if(belly.can_taste && prey.get_taste_message(FALSE))
		to_chat(belly.owner, "<span class='notice'>[prey] tastes of [prey.get_taste_message(FALSE)].</span>")

	// Inform Admins
	if(pred == user)
		add_attack_logs(pred, prey, "Eaten via [belly.name]")
	else
		add_attack_logs(user, pred, "Forced to eat [key_name(prey)]")
	return TRUE

//
// Magical pred-air breathing for inside preds
// overrides a proc defined on atom called by breathe.dm
//
/obj/belly/return_air()
	return return_air_for_internal_lifeform()

/obj/belly/return_air_for_internal_lifeform()
	//Free air until someone wants to code processing it for reals from predbreaths
	var/datum/gas_mixture/belly_air/air = new(1000)
	return air

// This is about 0.896m^3 of atmosphere
/datum/gas_mixture/belly_air
    volume = 2500
    temperature = 293.150
    total_moles = 104

/datum/gas_mixture/belly_air/New()
    . = ..()
    gas = list(
        "oxygen" = 21,
        "nitrogen" = 79)

// Procs for micros stuffed into boots and the like to escape from them
/mob/living/proc/escape_clothes(obj/item/clothing/C)
	ASSERT(loc == C)

	if(ishuman(C.loc)) //In a /mob/living/carbon/human
		var/mob/living/carbon/human/H = C.loc
		if(H.shoes == C) //Being worn
			to_chat(src,"<font color='blue'> You start to climb around the larger creature's feet and ankles!</font>")
			to_chat(H,"<font color='red'>Something is trying to climb out of your [C]!</font>")
			var/original_loc = H.loc
			for(var/escape_time = 100,escape_time > 0,escape_time--)
				if(H.loc != original_loc)
					to_chat(src,"<font color='red'>You're pinned back underfoot!</font>")
					to_chat(H,"<font color='blue'>You pin the escapee back underfoot!</font>")
					return
				if(loc != C)
					return
				sleep(1)

			to_chat(src,"<font color='blue'>You manage to escape \the [C]!</font>")
			to_chat(H,"<font color='red'>Somone has climbed out of your [C]!</font>")
			forceMove(H.loc)

		else //Being held by a human
			to_chat(src,"<font color='blue'>You start to climb out of \the [C]!</font>")
			to_chat(H,"<font color='red'>Something is trying to climb out of your [C]!</font>")
			for(var/escape_time = 60,escape_time > 0,escape_time--)
				if(H.shoes == C)
					to_chat(src,"<font color='red'>You're pinned underfoot!</font>")
					to_chat(H,"<font color='blue'>You pin the escapee underfoot!</font>")
					return
				if(loc != C)
					return
				sleep(1)
			to_chat(src,"<font color='blue'>You manage to escape \the [C]!</font>")
			to_chat(H,"<font color='red'>Somone has climbed out of your [C]!</font>")
			forceMove(H.loc)

	to_chat(src,"<font color='blue'>You start to climb out of \the [C]!</font>")
	sleep(50)
	if(loc == C)
		to_chat(src,"<font color='blue'>You climb out of \the [C]!</font>")
		forceMove(C.loc)
	return

/mob/living/proc/feed_grabbed_to_self_falling_nom(var/mob/living/user, var/mob/living/prey)
	var/belly = user.vore_selected
	return perform_the_nom(user, prey, user, belly, delay = 1) //1/10th of a second is probably fine.

/mob/living/proc/glow_toggle()
	set name = "Glow (Toggle)"
	set category = "Abilities"
	set desc = "Toggle your glowing on/off!"

	//I don't really see a point to any sort of checking here.
	//If they're passed out, the light won't help them. Same with buckled. Really, I think it's fine to do this whenever.
	glow_toggle = !glow_toggle

	to_chat(src,"<span class='notice'>You <b>[glow_toggle ? "en" : "dis"]</b>able your body's glow.</span>")

/mob/living/proc/glow_color()
	set name = "Glow (Set Color)"
	set category = "Abilities"
	set desc = "Pick a color for your body's glow."

	//Again, no real need for a check on this. I'm unsure how it could be somehow abused.
	//Even if they open the box 900 times, who cares, they get the wrong color and do it again.
	var/new_color = input(src,"Select a new color","Body Glow",glow_color) as color
	if(new_color)
		glow_color = new_color

/mob/living/proc/eat_trash()
	set name = "Eat Trash"
	set category = "Abilities"
	set desc = "Consume held garbage."

	if(!vore_selected)
		to_chat(src,"<span class='warning'>You either don't have a belly selected, or don't have a belly!</span>")
		return

	var/obj/item/I = get_active_hand()
	if(!I)
		to_chat(src, "<span class='notice'>You are not holding anything.</span>")
		return

	if(is_type_in_list(I,item_vore_blacklist))
		to_chat(src, "<span class='warning'>You are not allowed to eat this.</span>")
		return

	if(is_type_in_list(I,edible_trash) | adminbus_trash)
		if(I.hidden_uplink)
			to_chat(src, "<span class='warning'>You really should not be eating this.</span>")
			message_admins("[key_name(src)] has attempted to ingest an uplink item. ([src ? ADMIN_JMP(src) : "null"])")
			return
		if(istype(I,/obj/item/device/pda))
			var/obj/item/device/pda/P = I
			if(P.owner)
				var/watching = FALSE
				for(var/mob/living/carbon/human/H in view(src))
					if(H.real_name == P.owner && H.client)
						watching = TRUE
						break
				if(!watching)
					return
				else
					visible_message("<span class='warning'>[src] is threatening to make [P] disappear!</span>")
					if(P.id)
						var/confirm = alert(src, "The PDA you're holding contains a vulnerable ID card. Will you risk it?", "Confirmation", "Definitely", "Cancel")
						if(confirm != "Definitely")
							return
					if(!do_after(src, 100, P))
						return
					visible_message("<span class='warning'>[src] successfully makes [P] disappear!</span>")
			to_chat(src, "<span class='notice'>You can taste the sweet flavor of delicious technology.</span>")
			drop_item()
			I.forceMove(vore_selected)
			updateVRPanel()
			return
		if(istype(I,/obj/item/clothing/shoes))
			var/obj/item/clothing/shoes/S = I
			if(S.holding)
				to_chat(src, "<span class='warning'>There's something inside!</span>")
				return

		drop_item()
		I.forceMove(vore_selected)
		updateVRPanel()

		log_admin("VORE: [src] used Eat Trash to swallow [I].")

		if(istype(I,/obj/item/device/flashlight/flare) || istype(I,/obj/item/weapon/flame/match) || istype(I,/obj/item/weapon/storage/box/matches))
			to_chat(src, "<span class='notice'>You can taste the flavor of spicy cardboard.</span>")
		else if(istype(I,/obj/item/device/flashlight/glowstick))
			to_chat(src, "<span class='notice'>You found out the glowy juice only tastes like regret.</span>")
		else if(istype(I,/obj/item/weapon/cigbutt))
			to_chat(src, "<span class='notice'>You can taste the flavor of bitter ash. Classy.</span>")
		else if(istype(I,/obj/item/clothing/mask/smokable))
			var/obj/item/clothing/mask/smokable/C = I
			if(C.lit)
				to_chat(src, "<span class='notice'>You can taste the flavor of burning ash. Spicy!</span>")
			else
				to_chat(src, "<span class='notice'>You can taste the flavor of aromatic rolling paper and funny looks.</span>")
		else if(istype(I,/obj/item/weapon/paper))
			to_chat(src, "<span class='notice'>You can taste the dry flavor of bureaucracy.</span>")
		else if(istype(I,/obj/item/weapon/dice))
			to_chat(src, "<span class='notice'>You can taste the bitter flavor of cheating.</span>")
		else if(istype(I,/obj/item/weapon/lipstick))
			to_chat(src, "<span class='notice'>You can taste the flavor of couture and style. Toddler at the make-up bag style.</span>")
		else if(istype(I,/obj/item/weapon/soap))
			to_chat(src, "<span class='notice'>You can taste the bitter flavor of verbal purification.</span>")
		else if(istype(I,/obj/item/weapon/spacecash) || istype(I,/obj/item/weapon/storage/wallet))
			to_chat(src, "<span class='notice'>You can taste the flavor of wealth and reckless waste.</span>")
		else if(istype(I,/obj/item/weapon/broken_bottle) || istype(I,/obj/item/weapon/material/shard))
			to_chat(src, "<span class='notice'>You can taste the flavor of pain. This can't possibly be healthy for your guts.</span>")
		else if(istype(I,/obj/item/weapon/light))
			var/obj/item/weapon/light/L = I
			if(L.status == LIGHT_BROKEN)
				to_chat(src, "<span class='notice'>You can taste the flavor of pain. This can't possibly be healthy for your guts.</span>")
			else
				to_chat(src, "<span class='notice'>You can taste the flavor of really bad ideas.</span>")
		else if(istype(I,/obj/item/toy))
			visible_message("<span class='warning'>[src] demonstrates their voracious capabilities by swallowing [I] whole!</span>")
		else if(istype(I,/obj/item/device/paicard) || istype(I,/obj/item/device/mmi/digital/posibrain) || istype(I,/obj/item/device/aicard))
			visible_message("<span class='warning'>[src] demonstrates their voracious capabilities by swallowing [I] whole!</span>")
			to_chat(src, "<span class='notice'>You can taste the sweet flavor of digital friendship. Or maybe it is something else.</span>")
		else if(istype(I,/obj/item/weapon/reagent_containers/food))
			var/obj/item/weapon/reagent_containers/food/F = I
			if(!F.reagents.total_volume)
				to_chat(src, "<span class='notice'>You can taste the flavor of garbage and leftovers. Delicious?</span>")
			else
				to_chat(src, "<span class='notice'>You can taste the flavor of gluttonous waste of food.</span>")
		//TFF 10/7/19 - Add custom flavour for collars for trash can trait.
		else if (istype(I,/obj/item/clothing/accessory/collar))
			visible_message("<span class='warning'>[src] demonstrates their voracious capabilities by swallowing [I] whole!</span>")
			to_chat(src, "<span class='notice'>You can taste the submissiveness in the wearer of [I]!</span>")
		else
			to_chat(src, "<span class='notice'>You can taste the flavor of garbage. Delicious.</span>")
		return
	to_chat(src, "<span class='notice'>This item is not appropriate for ethical consumption.</span>")
	return

/mob/living/proc/switch_scaling()
	set name = "Switch scaling mode"
	set category = "Preferences"
	set desc = "Switch sharp/fuzzy scaling for current mob."
	appearance_flags ^= PIXEL_SCALE

/mob/living/examine(mob/user, distance, infix, suffix)
	. = ..(user, distance, infix, suffix)
	if(showvoreprefs)
		to_chat(user, "<span class='deptradio'><a href='?src=\ref[src];vore_prefs=1'>\[Mechanical Vore Preferences\]</a></span>")

/mob/living/Topic(href, href_list)	//Can't find any instances of Topic() being overridden by /mob/living in polaris' base code, even though /mob/living/carbon/human's Topic() has a ..() call
	if(href_list["vore_prefs"])
		display_voreprefs(usr)
	return ..()

/mob/living/proc/display_voreprefs(mob/user)	//Called by Topic() calls on instances of /mob/living (and subtypes) containing vore_prefs as an argument
	if(!user)
		CRASH("display_voreprefs() was called without an associated user.")
	var/dispvoreprefs = "<b>[src]'s vore preferences</b><br><br><br>"
	if(client && client.prefs)
		if("CHAT_OOC" in client.prefs.preferences_disabled)
			dispvoreprefs += "<font color='red'><b>OOC DISABLED</b></font><br>"
		if("CHAT_LOOC" in client.prefs.preferences_disabled)
			dispvoreprefs += "<font color='red'><b>LOOC DISABLED</b></font><br>"
	dispvoreprefs += "<b>Digestable:</b> [digestable ? "Enabled" : "Disabled"]<br>"
	dispvoreprefs += "<b>Devourable:</b> [devourable ? "Enabled" : "Disabled"]<br>"
	dispvoreprefs += "<b>Feedable:</b> [feeding ? "Enabled" : "Disabled"]<br>"
	dispvoreprefs += "<b>Absorption Permission:</b> [absorbable ? "Allowed" : "Disallowed"]<br>"
	dispvoreprefs += "<b>Leaves Remains:</b> [digest_leave_remains ? "Enabled" : "Disabled"]<br>"
	dispvoreprefs += "<b>Mob Vore:</b> [allowmobvore ? "Enabled" : "Disabled"]<br>"
	dispvoreprefs += "<b>Healbelly permission:</b> [permit_healbelly ? "Allowed" : "Disallowed"]<br>"
	dispvoreprefs += "<b>Spontaneous vore prey:</b> [can_be_drop_prey ? "Enabled" : "Disabled"]<br>"
	dispvoreprefs += "<b>Spontaneous vore pred:</b> [can_be_drop_pred ? "Enabled" : "Disabled"]<br>"
	user << browse("<html><head><title>Vore prefs: [src]</title></head><body><center>[dispvoreprefs]</center></body></html>", "window=[name];size=200x300;can_resize=0;can_minimize=0")
	onclose(user, "[name]")
	return
