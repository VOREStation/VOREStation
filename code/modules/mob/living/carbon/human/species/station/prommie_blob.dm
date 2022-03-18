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
	movement_cooldown = 3
	//appearance_flags = RADIATION_GLOWS
	shock_resist = 0 // Lets not be immune to zaps.
	friendly = list("nuzzles", "glomps", "snuggles", "cuddles", "squishes") // lets be cute :3
	melee_damage_upper = 0
	melee_damage_lower = 0
	player_msg = "You're a little squisher! Your cuteness level has increased tenfold."
	heat_damage_per_tick = 20 // Hot and cold are bad, but cold is AS bad for prommies as it is for slimes.
	cold_damage_per_tick = 20
	//glow_range = 0
	//glow_intensity = 0

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
	//verbs -= /mob/living/proc/ventcrawl
	verbs += /mob/living/simple_mob/slime/promethean/proc/prommie_blobform
	verbs += /mob/living/proc/set_size
	verbs += /mob/living/proc/hide
	verbs += /mob/living/simple_mob/proc/animal_nom
	verbs += /mob/living/proc/shred_limb
	verbs += /mob/living/simple_mob/slime/promethean/proc/toggle_expand
	verbs += /mob/living/simple_mob/slime/promethean/proc/prommie_select_colour
	verbs += /mob/living/simple_mob/slime/promethean/proc/toggle_shine
	update_mood()
	glow_color = color
	if(rad_glow)
		rad_glow = CLAMP(rad_glow,0,250)
		set_light(max(1,min(5,rad_glow/15)), max(1,min(10,rad_glow/25)), color)
	update_icon()
	return ..()

/mob/living/simple_mob/slime/promethean/update_icon()
	icon_living = "[icon_state_override ? "[icon_state_override] slime" : "slime"] [is_wide ? "adult" : "baby"][""]"
	//if(rad_glow)
	//	set_light(max(1,min(5,rad_glow/15)), max(1,min(10,rad_glow/25)), color)
	//else
	//	set_light(0)
	..()

/mob/living/simple_mob/slime/promethean/Destroy()
	humanform = null
	vore_organs = null
	vore_selected = null
	set_light(0)
	return ..()

/mob/living/simple_mob/slime/promethean/Stat()
	..()
	if(humanform)
		humanform.species.Stat(humanform)

/mob/living/simple_mob/slime/promethean/handle_special() // Should disable default slime healing, we'll use nutrition based heals instead.
	if(rad_glow)
		rad_glow = CLAMP(rad_glow,0,250)
		set_light(max(1,min(5,rad_glow/15)), max(1,min(10,rad_glow/25)), color)
	else
		set_light(0)
	return

//Constructor allows passing the human to sync damages
/mob/living/simple_mob/slime/promethean/New(var/newloc, var/mob/living/carbon/human/H)
	..()
	if(H)
		humanform = H
		updatehealth()

	else
		update_icon()

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
	if(rad_glow)
		set_light(max(1,min(5,rad_glow/15)), max(1,min(10,rad_glow/25)), color)

/mob/living/simple_mob/slime/promethean/bullet_act(obj/item/projectile/P)
	if(humanform)
		return humanform.bullet_act(P)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/death(gibbed, deathmessage = "rapidly loses cohesion, splattering across the ground...")
	if(humanform)
		humanform.death(gibbed, deathmessage)
	else
		animate(src, alpha = 0, time = 2 SECONDS)
		sleep(2 SECONDS)

	if(!QDELETED(src)) // Human's handle death should have taken us, but maybe we were adminspawned or something without a human counterpart
		qdel(src)

/mob/living/simple_mob/slime/promethean/Login()
	. = ..()
	copy_from_prefs_vr(bellies = FALSE)

/mob/living/simple_mob/slime/promethean/proc/prommie_blobform()
	set name = "Toggle Blobform"
	set desc = "Switch between amorphous and humanoid forms."
	set category = "Abilities"
	set hidden = FALSE

	var/atom/movable/to_locate = src
	if(!isturf(to_locate.loc))
		to_chat(src,"<span class='warning'>You need more space to perform this action!</span>")
		return

	//Blob form
	if(!ishuman(src))
		if(humanform.temporary_form.stat)
			to_chat(src,"<span class='warning'>You can only do this while not stunned.</span>")
		else
			humanform.prommie_outofblob(src)

/mob/living/simple_mob/slime/promethean/proc/toggle_expand()
	set name = "Toggle Width"
	set desc = "Switch between smole and lorge."
	set category = "Abilities"
	set hidden = FALSE

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	if(is_wide)
		is_wide = FALSE
		src.visible_message("<b>[src.name]</b> pulls together, compacting themselves into a small ball!")
		update_icon()
	else
		is_wide = TRUE
		src.visible_message("<b>[src.name]</b> flows outwards, their goop expanding!")
		update_icon()

/mob/living/simple_mob/slime/promethean/proc/toggle_shine()
	set name = "Toggle Shine"
	set desc = "Shine on you crazy diamond."
	set category = "Abilities"
	set hidden = FALSE

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	if(shiny)
		shiny = FALSE
		src.visible_message("<b>[src.name]</b> dulls their shine, becoming more translucent.")
		update_icon()
	else
		shiny = TRUE
		src.visible_message("<b>[src.name]</b> glistens and sparkles, shining brilliantly.")
		update_icon()

/mob/living/simple_mob/slime/promethean/proc/prommie_select_colour()

	set name = "Select Body Colour"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_skin = input(usr, "Please select a new body color.", "Shapeshifter Colour", color) as null|color
	if(!new_skin)
		return
	color = new_skin
	update_icon()

/mob/living/simple_mob/slime/promethean/get_description_interaction()
	return


/mob/living/simple_mob/slime/promethean/get_description_info()
	return
/*
/mob/living/simple_mob/slime/promethean/examine(mob/user)
	. = ..()
	. -= "It appears to have been pacified."

/mob/living/simple_mob/slime/promethean/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/slimepotion))
		to_chat(user, "<span class='notice'>You can't feed this to a promethean!.</span>")
		return
	..()
*/
/mob/living/simple_mob/slime/promethean/init_vore()
	return

/mob/living/simple_mob/slime/promethean/get_available_emotes()
	var/list/fulllist = _slime_default_emotes
	fulllist += default_emotes
	return fulllist