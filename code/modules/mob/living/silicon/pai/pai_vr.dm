/mob/living/silicon/pai
	var/people_eaten = 0
	icon = 'icons/mob/pai_vr.dmi'
	softfall = TRUE
	var/eye_glow = TRUE
	var/image/eye_layer = null		// Holds the eye overlay.
	var/eye_color = "#00ff0d"
	var/global/list/wide_chassis = list(
		"rat",
		"panther",
		"teppi"
		)
	var/global/list/flying_chassis = list(
		"pai-parrot",
		"pai-bat",
		"pai-butterfly",
		"pai-hawk",
		"cyberelf"
		)

	//Sure I could spend all day making wacky overlays for all of the different forms
	//but quite simply most of these sprites aren't made for that, and I'd rather just make new ones
	//the birds especially! Just naw. If someone else wants to mess with 12x4 frames of animation where
	//most of the pixels are different kinds of green and tastefully translate that to whitescale
	//they can have fun with that! I not doing it!
	var/global/list/allows_eye_color = list(
		"pai-repairbot",
		"pai-typezero",
		"pai-bat",
		"pai-butterfly",
		"pai-mouse",
		"pai-monkey",
		"pai-raccoon",
		"pai-cat",
		"rat",
		"panther",
		"pai-bear",
		"pai-fen",
		"cyberelf",
		"teppi",
		"catslug"
		)

/mob/living/silicon/pai/Initialize()
	. = ..()
	
	verbs |= /mob/living/proc/hide
	verbs |= /mob/proc/dominate_predator
	verbs |= /mob/living/proc/dominate_prey
	verbs |= /mob/living/proc/set_size
	verbs |= /mob/living/proc/shred_limb

/mob/living/silicon/pai/proc/pai_nom(var/mob/living/T in oview(1))
	set name = "pAI Nom"
	set category = "pAI Commands"
	set desc = "Allows you to eat someone while unfolded. Can't be used while in card form."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/mob/living/silicon/pai/proc/update_fullness_pai() //Determines if they have something in their stomach. Copied and slightly modified.
	var/new_people_eaten = 0
	for(var/obj/belly/B as anything in vore_organs)
		for(var/mob/living/M in B)
			new_people_eaten += M.size_multiplier
	people_eaten = min(1, new_people_eaten)

/mob/living/silicon/pai/update_icon() //Some functions cause this to occur, such as resting
	..()
	update_fullness_pai()

	if(!people_eaten && !resting)
		icon_state = "[chassis]" //Using icon_state here resulted in quite a few bugs. Chassis is much less buggy.
	else if(!people_eaten && resting)
		icon_state = "[chassis]_rest"

	// Unfortunately not all these states exist, ugh.
	else if(people_eaten && !resting)
		if("[chassis]_full" in cached_icon_states(icon))
			icon_state = "[chassis]_full"
		else
			icon_state = "[chassis]"
	else if(people_eaten && resting)
		if("[chassis]_rest_full" in cached_icon_states(icon))
			icon_state = "[chassis]_rest_full"
		else
			icon_state = "[chassis]_rest"
	if(chassis in wide_chassis)
		pixel_x = -16
		default_pixel_x = -16
	else
		pixel_x = 0
		default_pixel_x = 0
	add_eyes()

/mob/living/silicon/pai/update_icons() //And other functions cause this to occur, such as digesting someone.
	..()
	update_fullness_pai()
	if(!people_eaten && !resting)
		icon_state = "[chassis]"
	else if(!people_eaten && resting)
		icon_state = "[chassis]_rest"
	else if(people_eaten && !resting)
		icon_state = "[chassis]_full"
	else if(people_eaten && resting)
		icon_state = "[chassis]_rest_full"
	if(chassis in wide_chassis)
		pixel_x = -16
		default_pixel_x = -16
	else
		pixel_x = 0
		default_pixel_x = 0
	add_eyes()

//proc override to avoid pAI players being invisible while the chassis selection window is open
/mob/living/silicon/pai/proc/choose_chassis()
	set category = "pAI Commands"
	set name = "Choose Chassis"
	var/choice

	choice = tgui_input_list(usr, "What would you like to use for your mobile chassis icon?", "Chassis Choice", possible_chassis)
	if(!choice) return
	var/oursize = size_multiplier
	resize(1, FALSE, TRUE, TRUE, FALSE)		//We resize ourselves to normal here for a moment to let the vis_height get reset 
	chassis = possible_chassis[choice]
	if(chassis in wide_chassis)
		icon = 'icons/mob/pai_vr64x64.dmi'
		vis_height = 64
	else
		icon = 'icons/mob/pai_vr.dmi'
		vis_height = 32
	resize(oursize, FALSE, TRUE, TRUE, FALSE)	//And then back again now that we're sure the vis_height is correct.

	if(chassis in flying_chassis)
		hovering = TRUE
	else
		hovering = FALSE
		if(isopenspace(loc))
			fall()

	update_icon()

/mob/living/silicon/pai/verb/toggle_eyeglow()
	set category = "pAI Commands"
	set name = "Toggle Eye Glow"
	if(chassis in allows_eye_color)
		if(eye_glow)
			eye_glow = FALSE
		else
			eye_glow = TRUE
		update_icon()
	else
		to_chat(src, "Your selected chassis cannot modify its eye glow!")
		return


/mob/living/silicon/pai/verb/pick_eye_color()
	set category = "pAI Commands"
	set name = "Pick Eye Color"
	if(chassis in allows_eye_color)
	else
		to_chat(src, "<span class='warning'>Your selected chassis eye color can not be modified. The color you pick will only apply to supporting chassis and your card screen.</span>")

	var/new_eye_color = input(src, "Choose your character's eye color:", "Eye Color") as color|null
	if(new_eye_color)
		eye_color = new_eye_color
		update_icon()
		card.setEmotion(card.current_emotion)

// Release belly contents before being gc'd!
/mob/living/silicon/pai/Destroy()
	release_vore_contents()
	return ..()

/mob/living/silicon/pai/proc/add_eyes()
	remove_eyes()
	if(chassis in allows_eye_color)
		if(!eye_layer)
			eye_layer = image(icon, "[icon_state]-eyes")
		eye_layer.appearance_flags = appearance_flags
		eye_layer.color = eye_color
		if(eye_glow)
			eye_layer.plane = PLANE_LIGHTING_ABOVE
		add_overlay(eye_layer)

/mob/living/silicon/pai/proc/remove_eyes()
	cut_overlay(eye_layer)
	qdel(eye_layer)
	eye_layer = null

/mob/living/silicon/pai/UnarmedAttack(atom/A, proximity_flag)
	. = ..()

	if(!ismob(A) || A == src)
		return

	switch(a_intent)
		if(I_HELP)
			if(isliving(A))
				hug(src, A)
		if(I_GRAB)
			pai_nom(A)

/mob/living/silicon/pai/proc/hug(var/mob/living/silicon/pai/H, var/mob/living/target)

	var/t_him = "them"
	if(ishuman(target))
		var/mob/living/carbon/human/T = target
		switch(T.identifying_gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"
			if(NEUTER)
				t_him = "it"
			if(HERM)
				t_him = "hir"
			else
				t_him = "them"
	else	
		switch(target.gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"
			if(NEUTER)
				t_him = "it"
			if(HERM)
				t_him = "hir"
			else
				t_him = "them"

	if(H.zone_sel.selecting == "head")
		H.visible_message( \
			"<span class='notice'>[H] pats [target] on the head.</span>", \
			"<span class='notice'>You pat [target] on the head.</span>", )
	else if(H.zone_sel.selecting == "r_hand" || H.zone_sel.selecting == "l_hand")
		H.visible_message( \
			"<span class='notice'>[H] shakes [target]'s hand.</span>", \
			"<span class='notice'>You shake [target]'s hand.</span>", )
	else if(H.zone_sel.selecting == "mouth")
		H.visible_message( \
			"<span class='notice'>[H] boops [target]'s nose.</span>", \
			"<span class='notice'>You boop [target] on the nose.</span>", )
	else
		H.visible_message("<span class='notice'>[H] hugs [target] to make [t_him] feel better!</span>", \
						"<span class='notice'>You hug [target] to make [t_him] feel better!</span>")
	playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/mob/living/silicon/pai/proc/savefile_path(mob/user)
	return "data/player_saves/[copytext(user.ckey, 1, 2)]/[user.ckey]/pai.sav"

/mob/living/silicon/pai/proc/savefile_save(mob/user)
	if(IsGuestKey(user.key))
		return 0

	var/savefile/F = new /savefile(src.savefile_path(user))


	F["name"] << src.name
	F["description"] << src.flavor_text
	F["eyecolor"] << src.eye_color
	F["chassis"] << src.chassis
	F["emotion"] << src.card.current_emotion
	F["gender"] << src.gender
	F["version"] << 1

	return 1

/mob/living/silicon/pai/proc/savefile_load(mob/user, var/silent = 1)
	if (IsGuestKey(user.key))
		return 0

	var/path = savefile_path(user)

	if (!fexists(path))
		return 0

	var/savefile/F = new /savefile(path)

	if(!F) return //Not everyone has a pai savefile.

	var/version = null
	F["version"] >> version

	if (isnull(version) || version != 1)
		fdel(path)
		if (!silent)
			tgui_alert_async(user, "Your savefile was incompatible with this version and was deleted.")
		return 0
	var/ourname
	var/ouremotion
	F["name"] >> ourname
	SetName(ourname)
	F["description"] >> flavor_text
	F["eyecolor"] >> eye_color
	F["chassis"] >> chassis
	F["emotion"] >> ouremotion
	F["gender"] >> gender
	card.screen_color = eye_color
	if(ouremotion)
		card.setEmotion(ouremotion)
	update_icon()
	return 1

/mob/living/silicon/pai/verb/save_pai_to_slot()
	set category = "pAI Commands"
	set name = "Save Configuration"
	savefile_save(src)
	to_chat(src, "[name] configuration saved to global pAI settings.")

/mob/living/silicon/pai/a_intent_change(input as text)
	. = ..()
	
	switch(a_intent)
		if(I_HELP)
			hud_used.help_intent.icon_state = "intent_help-s"
			hud_used.disarm_intent.icon_state = "intent_disarm-n"
			hud_used.grab_intent.icon_state = "intent_grab-n"
			hud_used.hurt_intent.icon_state = "intent_harm-n"

		if(I_DISARM)
			hud_used.help_intent.icon_state = "intent_help-n"
			hud_used.disarm_intent.icon_state = "intent_disarm-s"
			hud_used.grab_intent.icon_state = "intent_grab-n"
			hud_used.hurt_intent.icon_state = "intent_harm-n"

		if(I_GRAB)
			hud_used.help_intent.icon_state = "intent_help-n"
			hud_used.disarm_intent.icon_state = "intent_disarm-n"
			hud_used.grab_intent.icon_state = "intent_grab-s"
			hud_used.hurt_intent.icon_state = "intent_harm-n"

		if(I_HURT)
			hud_used.help_intent.icon_state = "intent_help-n"
			hud_used.disarm_intent.icon_state = "intent_disarm-n"
			hud_used.grab_intent.icon_state = "intent_grab-n"
			hud_used.hurt_intent.icon_state = "intent_harm-s"

/mob/living/silicon/pai/verb/toggle_gender_identity_vr()
	set name = "Set Gender Identity"
	set desc = "Sets the pronouns when examined and performing an emote."
	set category = "IC"
	var/new_gender_identity = tgui_input_list(usr, "Please select a gender Identity:", "Set Gender Identity", list(FEMALE, MALE, NEUTER, PLURAL, HERM))
	if(!new_gender_identity)
		return 0
	gender = new_gender_identity
	return 1
