// Prommies are slimes, lets make them a subtype of slimes.
/mob/living/simple_mob/slime/promethean
	desc = "This slime changes colors constantly."
	color = null // Uses a special icon_state.
	slime_color = "rainbow"
	unity = TRUE
	water_resist = 100 // Lets not kill the prommies
	can_buckle = TRUE
	cores = 0

	description_info = "It's a little squisher! Lil' Blurble! Small wurble! It's a flowing blob of goop, with a spark of intelligence!"

	var/mob/living/carbon/human/humanform
	var/datum/modifier/healing

	var/obj/prev_left_hand
	var/obj/prev_right_hand

/mob/living/simple_mob/slime/promethean/Initialize()
	verbs |= /mob/living/proc/ventcrawl
	verbs += /mob/living/carbon/human/proc/prommie_blobform
	verbs += /mob/living/proc/set_size
	verbs += /mob/living/proc/hide
	update_mood()
	glow_color = color
	handle_light()
	update_icon()
	return ..()

/mob/living/simple_mob/slime/promethean/Stat()
	..()
	if(humanform)
		humanform.species.Stat(humanform)

//Constructor allows passing the human to sync damages
/mob/living/simple_mob/slime/promethean/New(var/newloc, var/mob/living/carbon/human/H)
	..()
	if(H)
		humanform = H
		updatehealth()

		verbs |= /mob/living/proc/hide
	else
		update_icon()

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

	things_to_drop -= things_to_not_drop //Crunch the lists
	things_to_drop -= organs //Mah armbs
	things_to_drop -= internal_organs //Mah sqeedily spooch

	for(var/obj/item/I in things_to_drop) //rip hoarders
		drop_from_inventory(I)

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
	blob.ckey = ckey
	blob.name = name
	blob.color = rgb(r_skin, g_skin, b_skin)
	blob.mood = ":3"
	temporary_form = blob

	//Mail them to nullspace
	moveToNullspace()

	//Message
	blob.visible_message("<b>[src.name]</b> collapses into a gooey blob!")

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

	//Stop healing if we are
	if(blob.healing)
		blob.healing.expire()

	//Message
	blob.visible_message("<b>[src.name]</b> reshapes into a humanoid appearance!")

	//Record where they should go
	var/atom/reform_spot = blob.drop_location()

	//Size update
	resize(blob.size_multiplier, FALSE, ignore_prefs = TRUE)

	//Move them back where the blob was
	forceMove(reform_spot)

	//Put our owner in it (don't transfer var/mind)
	ckey = blob.ckey
	color = blob.color
	temporary_form = null

	//Transfer vore organs
	vore_selected = blob.vore_selected
	for(var/obj/belly/B as anything in blob.vore_organs)
		B.forceMove(src)
		B.owner = src

	if(blob.prev_left_hand) put_in_l_hand(blob.prev_left_hand) //The restore for when reforming.
	if(blob.prev_right_hand) put_in_r_hand(blob.prev_right_hand)

	Life(1) //Fix my blindness right meow //Has to be moved up here, there exists a circumstance where blob could be deleted without vore organs moving right.

	//Get rid of friend blob
	qdel(blob)

	//Return ourselves in case someone wants it
	return src