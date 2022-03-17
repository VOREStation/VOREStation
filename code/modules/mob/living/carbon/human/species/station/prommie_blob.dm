// Prommies are slimes, lets make them a subtype of slimes.
/mob/living/simple_mob/slime/xenobio/promethean
	desc = "A promethean expressing their true form."
	//ai_holder_type = null
	color = null // Uses a special icon_state.
	slime_color = "rainbow"
	unity = TRUE
	water_resist = 100 // Lets not kill the prommies
	can_buckle = TRUE
	cores = 0
	movement_cooldown = 3
	appearance_flags = RADIATION_GLOWS
	shock_resist = 0 // Lets not be immune to zaps.
	is_adult = TRUE
	harmless = TRUE
	friendly = list("nuzzles", "glomps", "snuggles", "hugs") // lets be cute :3

	var/mob/living/carbon/human/humanform
	var/datum/modifier/healing

	var/obj/prev_left_hand
	var/obj/prev_right_hand
	var/human_brute = 0
	var/human_burn = 0

/mob/living/simple_mob/slime/xenobio/promethean/Initialize()
	//verbs -= /mob/living/proc/ventcrawl
	verbs += /mob/living/simple_mob/slime/xenobio/promethean/proc/prommie_blobform
	verbs += /mob/living/proc/set_size
	verbs += /mob/living/proc/hide
	verbs += /mob/living/simple_mob/proc/animal_nom
	verbs += /mob/living/proc/shred_limb
	update_mood()
	glow_color = color
	handle_light()
	update_icon()
	return ..()

/mob/living/simple_mob/slime/xenobio/promethean/Stat()
	..()
	if(humanform)
		humanform.species.Stat(humanform)

//Constructor allows passing the human to sync damages
/mob/living/simple_mob/slime/xenobio/promethean/New(var/newloc, var/mob/living/carbon/human/H)
	..()
	if(H)
		humanform = H
		updatehealth()

		verbs += /mob/living/proc/hide
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
	var/mob/living/simple_mob/slime/xenobio/promethean/blob = new(creation_spot,src)

	//Drop all our things
	var/list/things_to_drop = contents.Copy()
	var/list/things_to_not_drop = list(w_uniform,nif,l_store,r_store,wear_id,l_ear,r_ear,head) //And whatever else we decide for balancing.
	var/obj/item/clothing/head/new_hat
	things_to_drop -= things_to_not_drop //Crunch the lists
	things_to_drop -= organs //Mah armbs
	things_to_drop -= internal_organs //Mah sqeedily spooch

	for(var/obj/item/I in things_to_drop) //rip hoarders
		drop_from_inventory(I)
	for(var/obj/item/clothing/head/H in things_to_not_drop)
		new_hat = H

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
	if(new_hat)
		blob.hat = new_hat
		unEquip(new_hat)
		new_hat.forceMove(src)
	blob.ckey = ckey
	blob.name = name
	blob.color = rgb(r_skin, g_skin, b_skin)
	//blob.pacify()
	//blob.make_adult()
	blob.mood = ":3"


	blob.update_icon()
	blob.verbs -= /mob/living/proc/ventcrawl // Absolutely not.
	blob.verbs -= /mob/living/simple_mob/slime/xenobio/verb/evolve // We aren't really xenobio, so none of this.
	blob.verbs -= /mob/living/simple_mob/slime/xenobio/verb/reproduce
	blob.verbs -= /mob/living/simple_mob/proc/set_name // We already have a name.
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

mob/living/carbon/human/proc/prommie_outofblob(var/mob/living/simple_mob/slime/xenobio/promethean/blob, force)
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
	equip_to_slot_if_possible(blob.hat, slot_head)
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

/mob/living/simple_mob/slime/xenobio/promethean/updatehealth()
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
/mob/living/simple_mob/slime/xenobio/promethean/apply_effect(var/effect = 0, var/effecttype = STUN, var/blocked = 0, var/check_protection = 1)
	if(humanform)
		return humanform.apply_effect(effect, effecttype, blocked, check_protection)
	else
		return ..()

/mob/living/simple_mob/slime/xenobio/promethean/adjustBruteLoss(var/amount,var/include_robo)
	amount *= 0.75
	if(humanform)
		return humanform.adjustBruteLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/xenobio/promethean/adjustFireLoss(var/amount,var/include_robo)
	amount *= 2
	if(humanform)
		return humanform.adjustFireLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/xenobio/promethean/adjustToxLoss(amount)
	if(humanform)
		return humanform.adjustToxLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/xenobio/promethean/adjustOxyLoss(amount)
	if(humanform)
		return humanform.adjustOxyLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/xenobio/promethean/adjustHalLoss(amount)
	if(humanform)
		return humanform.adjustHalLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/xenobio/promethean/adjustCloneLoss(amount)
	if(humanform)
		return humanform.adjustCloneLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/xenobio/promethean/ex_act(severity)
	if(humanform)
		return humanform.ex_act(severity)
	else
		return ..()

/mob/living/simple_mob/slime/xenobio/promethean/rad_act(severity)
	if(humanform)
		return humanform.ex_act(severity)
	else
		return ..()

/mob/living/simple_mob/slime/xenobio/promethean/bullet_act(obj/item/projectile/P)
	if(humanform)
		return humanform.bullet_act(P)
	else
		return ..()

/mob/living/simple_mob/slime/xenobio/promethean/death(gibbed, deathmessage = "dissolves away, leaving only a few spare parts!")
	if(humanform)
		humanform.death(gibbed, deathmessage)
	else
		animate(src, alpha = 0, time = 2 SECONDS)
		sleep(2 SECONDS)

	if(!QDELETED(src)) // Human's handle death should have taken us, but maybe we were adminspawned or something without a human counterpart
		qdel(src)

/mob/living/simple_mob/slime/xenobio/promethean/Login()
	. = ..()
	copy_from_prefs_vr(bellies = FALSE)

/mob/living/simple_mob/slime/xenobio/promethean/proc/prommie_blobform()
	set name = "Toggle Blobform"
	set desc = "Switch between amorphous and humanoid forms."
	set category = "Abilities"
	set hidden = FALSE

	to_chat(src,"<span class='warning'>Blob form attepted to revert!</span>")
	var/atom/movable/to_locate = src
	if(!isturf(to_locate.loc))
		to_chat(src,"<span class='warning'>You need more space to perform this action!</span>")
		return

	//Blob form
	if(!ishuman(src))
		to_chat(src,"<span class='warning'>They are a blob!</span>")
		if(humanform.temporary_form.stat)
			to_chat(src,"<span class='warning'>You can only do this while not stunned.</span>")
		else
			to_chat(src,"<span class='warning'>Attempting to revert!</span>")
			humanform.prommie_outofblob(src)

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

/mob/living/simple_mob/slime/xenobio/promethean/get_description_interaction()
	return


/mob/living/simple_mob/slime/xenobio/promethean/get_description_info()
	return

/mob/living/simple_mob/slime/xenobio/promethean/examine(mob/user)
	. = ..()
	. -= "It appears to have been pacified."

/mob/living/simple_mob/slime/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/slimepotion))
		to_chat(user, "<span class='notice'>You can't feed this to a promethean!.</span>")
		return
	..()