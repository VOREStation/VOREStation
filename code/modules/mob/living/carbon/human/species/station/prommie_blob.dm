// Prommies are slimes, lets make them a subtype of slimes.
/mob/living/simple_mob/slime/promethean
	name = "Promethean Blob"
	desc = "A promethean expressing their true form."
	//ai_holder_type = null
	color = null // Uses a special icon_state.
	slime_color = "rainbow"
	unity = TRUE
	water_resist = 100 // Lets not kill the prommies
	cores = 0
	movement_cooldown = 0
	//appearance_flags = RADIATION_GLOWS
	shock_resist = 0 // Lets not be immune to zaps.
	friendly = list("nuzzles", "glomps", "snuggles", "cuddles", "squishes") // lets be cute :3
	harm_intent_damage = 3
	melee_damage_lower = 5
	melee_damage_upper = 5
	player_msg = "You're a little squisher! Your cuteness level has increased tenfold."
	heat_damage_per_tick = 20 // Hot and cold are bad, but cold is AS bad for prommies as it is for slimes.
	cold_damage_per_tick = 20
	//glow_range = 0
	//glow_intensity = 0
	has_hands = 1  // brings in line with Proteans' own blob form.

	var/mob/living/carbon/human/humanform
	var/datum/modifier/healing

	var/obj/prev_left_hand
	var/obj/prev_right_hand
	var/human_brute = 0
	var/human_burn = 0
	var/is_wide = FALSE
	var/rad_glow = 0

	var/list/default_emotes = list(
		/decl/emote/audible/squish,
		/decl/emote/audible/chirp,
		/decl/emote/visible/bounce,
		/decl/emote/visible/jiggle,
		/decl/emote/visible/lightup,
		/decl/emote/visible/vibrate,
		/decl/emote/visible/flip,
		/decl/emote/visible/spin,
		/decl/emote/visible/floorspin
	)
/mob/living/simple_mob/slime/promethean/Initialize(mapload, null)
	add_verb(src, /mob/living/simple_mob/slime/promethean/proc/prommie_blobform)
	add_verb(src, /mob/living/proc/set_size)
	add_verb(src, /mob/living/proc/hide)
	add_verb(src, /mob/living/simple_mob/proc/animal_nom)
	add_verb(src, /mob/living/proc/shred_limb)
	add_verb(src, /mob/living/simple_mob/slime/promethean/proc/toggle_expand)
	add_verb(src, /mob/living/simple_mob/slime/promethean/proc/prommie_select_colour)
	add_verb(src, /mob/living/simple_mob/slime/promethean/proc/toggle_shine)
	update_mood()
	if(rad_glow)
		rad_glow = CLAMP(rad_glow,0,250)
		set_light(max(1,min(5,rad_glow/15)), max(1,min(10,rad_glow/25)), color)
	return ..()

/mob/living/simple_mob/slime/promethean/update_icon()
	icon_living = "[icon_state_override ? "[icon_state_override] slime" : "slime"] [is_wide ? "adult" : "baby"][""]"
	..()

/mob/living/simple_mob/slime/promethean/Destroy()
	humanform = null
	drop_l_hand()
	drop_r_hand()
	drop_from_inventory(mob_radio, loc)
	mob_radio = null
	drop_from_inventory(myid, loc)
	myid = null
	vore_organs = null
	vore_selected = null
	set_light(0)
	return ..()

/mob/living/simple_mob/slime/promethean/update_misc_tabs()
	. = ..()
	if(humanform)
		humanform.species.update_misc_tabs(src)

/mob/living/simple_mob/slime/promethean/handle_special() // Should disable default slime healing, we'll use nutrition based heals instead.
// They already heal from their carbon form while even in slime form, but this is for a small bonus healing for being unformed.
	adjustOxyLoss(-0.2)
	adjustToxLoss(-0.2)
	adjustFireLoss(-0.2)
	adjustCloneLoss(-0.2)
	adjustBruteLoss(-0.2)
	adjustHalLoss(-6) // HalLoss ticks down FAST
	if(rad_glow)
		rad_glow = CLAMP(rad_glow,0,250)
		set_light(max(1,min(5,rad_glow/15)), max(1,min(10,rad_glow/25)), color)
	else
		set_light(0)
	update_icon()

	if(!humanform) // If we somehow have a blob with no human, lets just clean up.
		log_debug("Cleaning up blob with no prommie!")
		qdel(src)
	return

//Constructor allows passing the human to sync damages
/mob/living/simple_mob/slime/promethean/Initialize(mapload, var/mob/living/carbon/human/H)
	. = ..()
	if(!H)
		return INITIALIZE_HINT_QDEL

	humanform = H
	updatehealth()

/mob/living/simple_mob/slime/promethean/updatehealth()
	if(!humanform)
		return ..()

	//Set the max
	maxHealth = humanform.getMaxHealth()*2 //HUMANS, and their 'double health', bleh.
	//Set us to their health, but, human health ignores robolimbs so we do it 'the hard way'
	human_brute = humanform.getActualBruteLoss()
	human_burn = humanform.getActualFireLoss()
	health = maxHealth - humanform.getOxyLoss() - humanform.getToxLoss() - humanform.getCloneLoss() - human_brute - human_burn

	//Alive, becoming dead
	if((stat < DEAD) && (health <= 0))
		death()

	//Overhealth
	if(health > getMaxHealth())
		health = getMaxHealth()

	//Grab any other interesting values
	confused = humanform.confused
	radiation = humanform.radiation
	paralysis = humanform.paralysis

	//Update our hud if we have one
	if(healths)
		if(stat != DEAD)
			var/heal_per = (health / getMaxHealth()) * 100
			switch(heal_per)
				if(100 to INFINITY)
					healths.icon_state = "health0"
				if(80 to 100)
					healths.icon_state = "health1"
				if(60 to 80)
					healths.icon_state = "health2"
				if(40 to 60)
					healths.icon_state = "health3"
				if(20 to 40)
					healths.icon_state = "health4"
				if(0 to 20)
					healths.icon_state = "health5"
				else
					healths.icon_state = "health6"
		else
			healths.icon_state = "health7"

// All the damage and such to the blob translates to the human
/mob/living/simple_mob/slime/promethean/apply_effect(var/effect = 0, var/effecttype = STUN, var/blocked = 0, var/check_protection = 1)
	if(humanform)
		return humanform.apply_effect(effect, effecttype, blocked, check_protection)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/adjustBruteLoss(var/amount,var/include_robo)
	amount *= 0.75
	if(humanform)
		return humanform.adjustBruteLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/adjustFireLoss(var/amount,var/include_robo)
	amount *= 2
	if(humanform)
		return humanform.adjustFireLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/adjustToxLoss(amount)
	if(humanform)
		return humanform.adjustToxLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/adjustOxyLoss(amount)
	if(humanform)
		return humanform.adjustOxyLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/adjustHalLoss(amount)
	if(humanform)
		return humanform.adjustHalLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/adjustCloneLoss(amount)
	if(humanform)
		return humanform.adjustCloneLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/ex_act(severity)
	if(humanform)
		return humanform.ex_act(severity)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/rad_act(severity)
	rad_glow += severity
	rad_glow = CLAMP(rad_glow,0,250)
	if(rad_glow > 1)
		set_light(max(1,min(5,rad_glow/15)), max(1,min(10,rad_glow/25)), color)
		update_icon()

/mob/living/simple_mob/slime/promethean/bullet_act(obj/item/projectile/P)
	if(humanform)
		return humanform.bullet_act(P)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/death(gibbed, deathmessage = "rapidly loses cohesion, splattering across the ground...")
	humanform.death(gibbed, deathmessage)

	if(!QDELETED(src)) // Human's handle death should have taken us, but maybe we were adminspawned or something without a human counterpart
		qdel(src)

/mob/living/simple_mob/slime/promethean/Login()
	. = ..()
	copy_from_prefs_vr(bellies = FALSE)

/mob/living/simple_mob/slime/promethean/proc/prommie_blobform()
	set name = "Toggle Blobform"
	set desc = "Switch between amorphous and humanoid forms."
	set category = "Abilities.Promethean"
	set hidden = FALSE

	var/atom/movable/to_locate = src
	if(!isturf(to_locate.loc))
		to_chat(src,span_warning("You need more space to perform this action!"))
		return

	//Blob form
	if(!ishuman(src))
		if(humanform.temporary_form.stat || paralysis || stunned || weakened || restrained())
			to_chat(src,span_warning("You can only do this while not stunned."))
		else
			humanform.prommie_outofblob(src)

/mob/living/simple_mob/slime/promethean/proc/toggle_expand()
	set name = "Toggle Width"
	set desc = "Switch between smole and lorge."
	set category = "Abilities.Promethean"
	set hidden = FALSE

	if(stat || world.time < last_special)
		return

	last_special = world.time + 25

	if(is_wide)
		is_wide = FALSE
		src.visible_message(span_infoplain(span_bold("[src.name]") + " pulls together, compacting themselves into a small ball!"))
		update_icon()
	else
		is_wide = TRUE
		src.visible_message(span_infoplain(span_bold("[src.name]") + " flows outwards, their goop expanding!"))
		update_icon()

/mob/living/simple_mob/slime/promethean/proc/toggle_shine()
	set name = "Toggle Shine"
	set desc = "Shine on you crazy diamond."
	set category = "Abilities.Promethean"
	set hidden = FALSE

	if(stat || world.time < last_special)
		return

	last_special = world.time + 25

	if(shiny)
		shiny = FALSE
		src.visible_message(span_infoplain(span_bold("[src.name]") + " dulls their shine, becoming more translucent."))
		update_icon()
	else
		shiny = TRUE
		src.visible_message(span_infoplain(span_bold("[src.name]") + " glistens and sparkles, shining brilliantly."))
		update_icon()

/mob/living/simple_mob/slime/promethean/proc/prommie_select_colour()

	set name = "Select Body Colour"
	set category = "Abilities.Promethean"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 25

	var/new_skin = tgui_color_picker(src, "Please select a new body color.", "Shapeshifter Colour", color)
	if(!new_skin)
		return
	color = new_skin
	update_icon()

/mob/living/simple_mob/slime/promethean/get_description_interaction()
	return


/mob/living/simple_mob/slime/promethean/get_description_info()
	return

/mob/living/simple_mob/slime/promethean/init_vore()
	return

/mob/living/simple_mob/slime/promethean/get_available_emotes()
	var/list/fulllist = global._slime_default_emotes.Copy()
	fulllist += default_emotes
	return fulllist
/mob/living/carbon/human
	var/mob/living/simple_mob/slime/promethean/stored_blob = null
// Helpers - Unsafe, WILL perform change.
/mob/living/carbon/human/proc/prommie_intoblob(force)
	if(!force && !isturf(loc))
		to_chat(src,span_warning("You can't change forms while inside something."))
		return

	handle_grasp() //It's possible to blob out before some key parts of the life loop. This results in things getting dropped at null. TODO: Fix the code so this can be done better.
	remove_micros(src, src) //Living things don't fare well in roblobs.
	if(buckled)
		buckled.unbuckle_mob()
	if(LAZYLEN(buckled_mobs))
		for(var/buckledmob in buckled_mobs)
			riding_datum.force_dismount(buckledmob)
	if(pulledby)
		pulledby.stop_pulling()
	stop_pulling()

	//Record where they should go
	var/atom/creation_spot = drop_location()
	var/mob/living/simple_mob/slime/promethean/blob = null
	//Create our new blob
	if(!stored_blob)
		blob = new(creation_spot,src)
		blob.mood = ":3"
		qdel(blob.ai_holder)
		blob.ai_holder = null
	else
		blob = stored_blob
		blob.forceMove(creation_spot)

	//Drop all our things
	var/list/things_to_drop = contents.Copy()
	var/list/things_to_not_drop = list(w_uniform,nif,l_store,r_store,wear_id,l_ear,r_ear) //And whatever else we decide for balancing.
	var/obj/item/clothing/head/new_hat
	var/has_hat = FALSE
	things_to_drop -= things_to_not_drop //Crunch the lists
	things_to_drop -= organs //Mah armbs
	things_to_drop -= internal_organs //Mah sqeedily spooch

	for(var/obj/item/clothing/head/H in things_to_drop)
		if(H)
			new_hat = H
			has_hat = TRUE
			drop_from_inventory(H)
			things_to_drop -= H

	//Size update
	blob.transform = matrix()*size_multiplier
	blob.size_multiplier = size_multiplier

	if(l_hand) drop_from_inventory(l_hand)
	if(r_hand) drop_from_inventory(r_hand)

	//Put our owner in it (don't transfer var/mind)
	blob.transforming = TRUE
	blob.ckey = ckey
	blob.ooc_notes = ooc_notes
	blob.ooc_notes_likes = ooc_notes_likes
	blob.ooc_notes_dislikes = ooc_notes_dislikes
	blob.transforming = FALSE
	blob.name = name
	blob.real_name = real_name
	blob.nutrition = nutrition
	blob.color = rgb(r_skin, g_skin, b_skin)
	playsound(src.loc, "sound/effects/slime_squish.ogg", 15)
	if(radiation > 0)
		blob.rad_glow = CLAMP(radiation,0,250)
		set_light(0)
		blob.set_light(max(1,min(5,radiation/15)), max(1,min(10,radiation/25)), blob.color)
	else
		blob.set_light(0)
	if(has_hat)
		blob.hat = new_hat
		new_hat.forceMove(src)

	blob.update_icon()
	remove_verb(blob, /mob/living/proc/ventcrawl) // Absolutely not.
	remove_verb(blob, /mob/living/simple_mob/proc/set_name) // We already have a name.
	temporary_form = blob

	var/obj/item/radio/R = null
	if(isradio(l_ear))
		R = l_ear
	if(isradio(r_ear))
		R = r_ear
	if(R)
		blob.mob_radio = R
		R.forceMove(blob)
	if(wear_id)
		blob.myid = wear_id.GetID()

	//Mail them to nullspace
	moveToNullspace()

	//Message
	blob.visible_message(span_infoplain(span_bold("[src.name]") + " squishes into their true form!"))

	//Transfer vore organs
	blob.vore_organs = vore_organs
	blob.vore_selected = vore_selected
	for(var/obj/belly/B as anything in vore_organs)
		B.forceMove(blob)
		B.owner = blob

	soulgem.owner = blob

	//We can still speak our languages!
	blob.languages = languages.Copy()

	//Return our blob in case someone wants it
	return blob

/mob/living/carbon/human/proc/prommie_outofblob(var/mob/living/simple_mob/slime/promethean/blob, force)
	if(!istype(blob))
		return

	if(!force && !isturf(blob.loc))
		to_chat(blob,span_warning("You can't change forms while inside something."))
		return

	if(buckled)
		buckled.unbuckle_mob()
	if(LAZYLEN(buckled_mobs))
		for(var/buckledmob in buckled_mobs)
			riding_datum.force_dismount(buckledmob)
	if(pulledby)
		pulledby.stop_pulling()
	stop_pulling()

	//Message
	blob.visible_message(span_infoplain(span_bold("[src.name]") + " pulls together, forming a humanoid shape!"))

	//Record where they should go
	var/atom/reform_spot = blob.drop_location()

	//Size update
	resize(blob.size_multiplier, FALSE, ignore_prefs = TRUE)

	//Move them back where the blob was
	forceMove(reform_spot)

	//Put our owner in it (don't transfer var/mind)
	playsound(src.loc, "sound/effects/slime_squish.ogg", 15)
	transforming = TRUE
	ckey = blob.ckey
	ooc_notes = blob.ooc_notes // Updating notes incase they change them in blob form.
	ooc_notes_likes = blob.ooc_notes_likes
	ooc_notes_dislikes = blob.ooc_notes_dislikes
	transforming = FALSE
	blob.name = "Promethean Blob"
	var/obj/item/hat = blob.hat
	blob.drop_hat()
	drop_from_inventory(hat) // Hat me baby
	equip_to_slot_if_possible(hat, slot_head)
	nutrition = blob.nutrition // food good


	temporary_form = null
	var/blob_color = blob.color
	if(!blob_color)
		blob_color = rgb(255, 255, 255)
	shapeshifter_set_colour(blob_color)
	if(blob.rad_glow > 0)
		radiation = CLAMP(blob.rad_glow,0,250)
		set_light(max(1,min(5,radiation/15)), max(1,min(10,radiation/25)), species.get_flesh_colour(src))
	update_icon()

	//Transfer vore organs
	vore_selected = blob.vore_selected
	for(var/obj/belly/B as anything in blob.vore_organs)
		B.forceMove(src)
		B.owner = src

	soulgem.owner = src

	//vore_organs.Cut()

	if(blob.l_hand) blob.drop_from_inventory(blob.l_hand)
	if(blob.r_hand) blob.drop_from_inventory(blob.r_hand)

	if(blob.mob_radio)
		blob.mob_radio.forceMove(src)
		blob.mob_radio = null
	if(blob.myid)
		blob.myid = null

	Life(1) //Fix my blindness right meow //Has to be moved up here, there exists a circumstance where blob could be deleted without vore organs moving right.

	//Get rid of friend blob
	stored_blob = blob
	blob.set_light(0)
	blob.moveToNullspace()
	//qdel(blob)

	//Return ourselves in case someone wants it
	return src

/mob/living/simple_mob/slime/promethean/examine(mob/user)
	. = ..()
	if(hat)
		. += "They are wearing \a [hat]."

/mob/living/simple_mob/slime/promethean/say_understands(var/mob/other, var/datum/language/speaking = null)
	if(speaking?.name == LANGUAGE_PROMETHEAN)	//Promethean and sign are both nonverbal, so won't work with the same trick as below, so let's check for them
		return TRUE
	else if(speaking?.name == LANGUAGE_SIGN)
		for(var/datum/language/L in humanform.languages)
			if(L.name == LANGUAGE_SIGN)
				return TRUE
	else if(humanform.say_understands(other, speaking))		//So they're speaking something other than promethean or sign, let's just ask our original mob if it understands
		return TRUE
	else return FALSE

/mob/living/simple_mob/slime/promethean/character_directory_species()
	if (humanform)
		return "[humanform.custom_species ? humanform.custom_species : (humanform.species ? humanform.species.name : "Promethean Blob")]"
	return "Promethean Blob"
