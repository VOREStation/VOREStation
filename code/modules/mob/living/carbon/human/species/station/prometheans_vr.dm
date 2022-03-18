/datum/species/shapeshifter/promethean
	min_age = 18 //Required for server rules
	max_age = 80
	push_flags = ~HEAVY
	swap_flags = ~HEAVY
	gluttonous = 0
	water_damage_mod = 0		//No water damage
	valid_transform_species = list(
		"Human", "Unathi", "Tajara", "Skrell",
		"Diona", "Teshari", "Monkey","Sergal",
		"Akula","Nevrean","Zorren",
		"Fennec", "Vulpkanin", "Vasilissan",
		"Rapala", "Neaera", "Stok", "Farwa", "Sobaka",
		"Wolpin", "Saru", "Sparra")

	spawn_flags = SPECIES_CAN_JOIN
	wikilink="https://wiki.vore-station.net/Promethean"
	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	color_mult = 1
	mob_size = MOB_MEDIUM //As of writing, original was MOB_SMALL - Allows normal swapping

	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | RADIATION_GLOWS | HAS_UNDERWEAR

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/regenerate,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/carbon/human/proc/prommie_blobform,
		/mob/living/proc/set_size,
		/mob/living/carbon/human/proc/promethean_select_opaqueness,
		)

/mob/living/carbon/human/proc/prommie_blobform()
	set name = "Toggle Blobform"
	set desc = "Switch between amorphous and humanoid forms."
	set category = "Abilities"
	set hidden = FALSE

	var/atom/movable/to_locate = temporary_form || src
	if(!isturf(to_locate.loc))
		to_chat(to_locate,"<span class='warning'>You need more space to perform this action!</span>")
		return
	/*
	//Blob form
	if(temporary_form)
		if(temporary_form.stat)
			to_chat(temporary_form,"<span class='warning'>You can only do this while not stunned.</span>")
		else
			prommie_outofblob(temporary_form)
	*/
	//Human form
	else if(stat)
		to_chat(src,"<span class='warning'>You can only do this while not stunned.</span>")
		return
	else
		prommie_intoblob()

/datum/species/shapeshifter/promethean/handle_death(var/mob/living/carbon/human/H)
	if(!H)
		return // Iono!

	if(H.temporary_form)
		H.forceMove(H.temporary_form.drop_location())
		H.ckey = H.temporary_form.ckey
		QDEL_NULL(H.temporary_form)

	spawn(1)
		if(H)
			H.gib()

// Helpers - Unsafe, WILL perform change.
/mob/living/carbon/human/proc/prommie_intoblob(force)
	if(!force && !isturf(loc))
		to_chat(src,"<span class='warning'>You can't change forms while inside something.</span>")
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

	//Create our new blob
	var/mob/living/simple_mob/slime/promethean/blob = new(creation_spot,src)

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

	for(var/obj/item/I in things_to_drop) //rip hoarders
		drop_from_inventory(I)
	//for(var/obj/item/clothing/head/H in things_to_not_drop)
	//	drop_from_inventory(H)
		//if(H)
	//	new_hat = H
	//	has_hat = TRUE

	if(w_uniform && istype(w_uniform,/obj/item/clothing)) //No webbings tho. We do this after in case a suit was in the way
		var/obj/item/clothing/uniform = w_uniform
		if(LAZYLEN(uniform.accessories))
			for(var/obj/item/clothing/accessory/A in uniform.accessories)
				if(is_type_in_list(A, disallowed_protean_accessories))
					uniform.remove_accessory(null,A) //First param is user, but adds fingerprints and messages

	//Size update
	blob.transform = matrix()*size_multiplier
	blob.size_multiplier = size_multiplier

	if(l_hand) blob.prev_left_hand = l_hand //Won't save them if dropped above, but necessary if handdrop is disabled.
	if(r_hand) blob.prev_right_hand = r_hand

	//Put our owner in it (don't transfer var/mind)
	qdel(blob.ai_holder)

	blob.ai_holder = null
	if(has_hat)
		blob.hat = new_hat
		new_hat.forceMove(src)
	blob.ckey = ckey
	blob.name = name
	blob.nutrition = nutrition
	blob.color = rgb(r_skin, g_skin, b_skin)
	blob.mood = ":3"
	if(radiation)
		blob.rad_glow = CLAMP(radiation,0,250)
		blob.glow_intensity = max(1,min(5,blob.rad_glow/15))
		blob.glow_range = max(1,min(10,blob.rad_glow/25))
		blob.glow_toggle = TRUE
		set_light(0)
		blob.set_light(max(1,min(5,radiation/15)), max(1,min(10,radiation/25)), blob.color)
		blob.handle_light()
	blob.update_icon()
	blob.verbs -= /mob/living/proc/ventcrawl // Absolutely not.
	blob.verbs -= /mob/living/simple_mob/proc/set_name // We already have a name.
	temporary_form = blob

	//Mail them to nullspace
	moveToNullspace()

	//Message
	blob.visible_message("<b>[src.name]</b> squishes into their true form!")

	//Transfer vore organs
	blob.vore_organs = vore_organs
	blob.vore_selected = vore_selected
	for(var/obj/belly/B as anything in vore_organs)
		B.forceMove(blob)
		B.owner = blob

	//We can still speak our languages!
	blob.languages = languages.Copy()

	//Return our blob in case someone wants it
	return blob

mob/living/carbon/human/proc/prommie_outofblob(var/mob/living/simple_mob/slime/promethean/blob, force)
	if(!istype(blob))
		return

	if(!force && !isturf(blob.loc))
		to_chat(blob,"<span class='warning'>You can't change forms while inside something.</span>")
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
	blob.visible_message("<b>[src.name]</b> pulls together, forming a humanoid shape!")

	//Record where they should go
	var/atom/reform_spot = blob.drop_location()

	//Size update
	resize(blob.size_multiplier, FALSE, ignore_prefs = TRUE)

	//Move them back where the blob was
	forceMove(reform_spot)

	//Put our owner in it (don't transfer var/mind)
	ckey = blob.ckey
	var/obj/item/hat = blob.hat
	blob.drop_hat()
	drop_from_inventory(hat) // Hat me baby
	equip_to_slot_if_possible(hat, slot_head)
	nutrition = blob.nutrition // food good


	temporary_form = null

	shapeshifter_set_colour(blob.color)
	if(blob.rad_glow)
		radiation = CLAMP(blob.rad_glow,0,250)
		set_light(max(1,min(5,radiation/15)), max(1,min(10,radiation/25)), species.get_flesh_colour(src))
	update_icon()

	//Transfer vore organs
	vore_selected = blob.vore_selected
	for(var/obj/belly/B as anything in blob.vore_organs)
		B.forceMove(src)
		B.owner = src

	//vore_organs.Cut()
	if(blob.prev_left_hand) put_in_l_hand(blob.prev_left_hand) //The restore for when reforming.
	if(blob.prev_right_hand) put_in_r_hand(blob.prev_right_hand)

	Life(1) //Fix my blindness right meow //Has to be moved up here, there exists a circumstance where blob could be deleted without vore organs moving right.

	//Get rid of friend blob
	qdel(blob)

	//Return ourselves in case someone wants it
	return src