// Simple animal nanogoopeyness
/mob/living/simple_animal/protean_blob
	name = "protean blob"
	desc = "Some sort of big viscous pool of jelly."
	tt_desc = "Animated nanogoop"
	icon = 'icons/mob/species/protean/protean.dmi'
	icon_state = "to_puddle"
	icon_living = "puddle2"
	icon_rest = "rest"
	icon_dead = "puddle"

	faction = "neutral"
	maxHealth = 200
	health = 200

	ai_inactive = TRUE //Always off
	show_stat_health = FALSE //We will do it ourselves

	response_help = "pats the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 2
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = list("slashed")

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 900

	speak_chance = 1
	speak = list("Blrb?","Sqrsh.","Glrsh!")
	emote_hear = list("squishes softly","spluts quietly","makes wet noises")
	emote_see = list("shifts wetly","undulates placidly")

	var/mob/living/carbon/human/humanform
	var/obj/item/organ/internal/nano/refactory/refactory
	var/datum/modifier/healing

	player_msg = "In this form, you can move a little faster, your health will regenerate as long as you have metal in you, and you can ventcrawl!"

	can_buckle = TRUE //Blobsurfing

//Constructor allows passing the human to sync damages
/mob/living/simple_animal/protean_blob/New(var/newloc, var/mob/living/carbon/human/H)
	..()
	if(H)
		humanform = H
		updatehealth()
		refactory = locate() in humanform.internal_organs
		verbs |= /mob/living/proc/ventcrawl
		verbs |= /mob/living/proc/hide
	else
		update_icon()

/mob/living/simple_animal/protean_blob/Destroy()
	humanform = null
	refactory = null
	vore_organs = null
	vore_selected = null
	if(healing)
		healing.expire()
	return ..()

/mob/living/simple_animal/protean_blob/init_vore()
	return //Don't make a random belly, don't waste your time

/mob/living/simple_animal/protean_blob/Stat()
	..()
	if(humanform)
		humanform.species.Stat(humanform)

/mob/living/simple_animal/protean_blob/update_icon()
	if(humanform)
		//Still have a refactory
		if(istype(refactory))
			icon_living = "puddle2"

		//Else missing one
		else
			icon_living = "puddle1"

	//Not human-based
	else
		icon_living = "puddle0"

	..()

/mob/living/simple_animal/protean_blob/updatehealth()
	if(humanform)
		//Set the max
		maxHealth = humanform.getMaxHealth()*2 //HUMANS, and their 'double health', bleh.
		//Set us to their health, but, human health ignores robolimbs so we do it 'the hard way'
		health = maxHealth - humanform.getOxyLoss() - humanform.getToxLoss() - humanform.getCloneLoss() - humanform.getActualFireLoss() - humanform.getActualBruteLoss()

		//Alive, becoming dead
		if((stat < DEAD) && (health <= 0))
			death()

		//Overhealth
		if(health > getMaxHealth())
			health = getMaxHealth()

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
	else
		..()

/mob/living/simple_animal/protean_blob/adjustBruteLoss(var/amount)
	if(humanform)
		humanform.adjustBruteLoss(amount)
	else
		..()

/mob/living/simple_animal/protean_blob/adjustFireLoss(var/amount)
	if(humanform)
		humanform.adjustFireLoss(amount)
	else
		..()

/mob/living/simple_animal/protean_blob/death(gibbed, deathmessage = "dissolves away, leaving only a few spare parts!")
	if(humanform)
		humanform.death(gibbed = gibbed)
		for(var/organ in humanform.internal_organs)
			var/obj/item/organ/internal/O = organ
			O.removed()
			O.forceMove(drop_location())
		qdel_null(humanform) //Don't leave it just sitting in nullspace
	animate(src,alpha = 0,time = 2 SECONDS)
	sleep(2 SECONDS)
	qdel(src)

	..()

/mob/living/simple_animal/protean_blob/Life()
	. = ..()
	if(. && istype(refactory) && humanform)
		if(!healing && health < maxHealth && refactory.get_stored_material(DEFAULT_WALL_MATERIAL) >= 100)
			healing = humanform.add_modifier(/datum/modifier/protean/steel, origin = refactory)
		else if(healing && health == maxHealth)
			healing.expire()
			healing = null

/mob/living/simple_animal/protean_blob/lay_down()
	..()
	if(resting)
		animate(src,alpha = 40,time = 1 SECOND)
		mouse_opacity = 0
	else
		mouse_opacity = 1
		icon_state = "wake"
		animate(src,alpha = 255,time = 1 SECOND)
		sleep(7)
		update_icon()
		//Potential glob noms
		if(can_be_drop_pred) //Toggleable in vore panel
			var/list/potentials = living_mobs(0)
			if(potentials.len)
				var/mob/living/target = pick(potentials)
				if(istype(target) && vore_selected)
					if(target.buckled)
						target.buckled.unbuckle_mob(target, force = TRUE)
					target.forceMove(vore_selected)
					to_chat(target,"<span class='warning'>\The [src] quickly engulfs you, [vore_selected.vore_verb]ing you into their [vore_selected.name]!</span>")

/mob/living/simple_animal/protean_blob/DoPunch(var/atom/A)
	if(refactory && istype(A,/obj/item/stack/material))
		var/obj/item/stack/material/S = A
		if(refactory.add_stored_material(S.material.name,1*S.perunit) && S.use(1))
			visible_message("<b>[name]</b> gloms over some of \the [S], absorbing it.")
	else
		return ..()

/mob/living/simple_animal/protean_blob/attackby(var/obj/item/O, var/mob/user)
	if(refactory && istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/S = O
		if(refactory.add_stored_material(S.material.name,1*S.perunit) && S.use(1))
			visible_message("<b>[name]</b> gloms over some of \the [S], absorbing it.")
	else
		return ..()

/mob/living/simple_animal/protean_blob/MouseEntered(location,control,params)
	if(resting)
		return
	..()

// Helpers - Unsafe, WILL perform change.
/mob/living/carbon/human/proc/nano_intoblob()
	if(buckled)
		buckled.unbuckle_mob()
	if(LAZYLEN(buckled_mobs))
		for(var/buckledmob in buckled_mobs)
			unbuckle_mob(buckledmob, force = TRUE)
	if(pulledby)
		pulledby.stop_pulling()
	stop_pulling()

	//Record where they should go
	var/atom/creation_spot = drop_location()

	//Create our new blob
	var/mob/living/simple_animal/protean_blob/blob = new(creation_spot,src)

	//Size update
	blob.transform = matrix()*size_multiplier
	blob.size_multiplier = size_multiplier

	//Put our owner in it (don't transfer var/mind)
	blob.ckey = ckey
	temporary_form = blob

	//Mail them to nullspace
	forceMove(null)

	//Message
	blob.visible_message("<b>[src.name]</b> collapses into a gooey blob!")
	
	//Duration of the to_puddle iconstate that the blob starts with
	sleep(13)
	blob.update_icon() //Will remove the collapse anim

	//Transfer vore organs
	blob.vore_organs = vore_organs
	blob.vore_selected = vore_selected
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		B.forceMove(blob)
		B.owner = blob

	//Return our blob in case someone wants it
	return blob

/mob/living/carbon/human/proc/nano_outofblob(var/mob/living/simple_animal/protean_blob/blob)
	if(!istype(blob))
		return
	if(buckled)
		buckled.unbuckle_mob()
	if(LAZYLEN(buckled_mobs))
		for(var/buckledmob in buckled_mobs)
			unbuckle_mob(buckledmob, force = TRUE)
	if(pulledby)
		pulledby.stop_pulling()
	stop_pulling()
	
	//Stop healing if we are
	if(blob.healing)
		blob.healing.expire()

	//Play the animation
	blob.icon_state = "from_puddle"

	//Message
	blob.visible_message("<b>[src.name]</b> reshapes into a humanoid appearance!")
	
	//Duration of above animation
	sleep(8)

	//Record where they should go
	var/atom/reform_spot = blob.drop_location()

	//Size update
	transform = matrix()*blob.size_multiplier
	size_multiplier = blob.size_multiplier

	//Move them back where the blob was
	forceMove(reform_spot)

	//Put our owner in it (don't transfer var/mind)
	ckey = blob.ckey
	temporary_form = null
	Life(1) //Fix my blindness right meow

	//Transfer vore organs
	vore_selected = blob.vore_selected
	for(var/belly in blob.vore_organs)
		var/obj/belly/B = belly
		B.forceMove(src)
		B.owner = src
	
	//Get rid of friend blob
	qdel(blob)

	//Return ourselves in case someone wants it
	return src
