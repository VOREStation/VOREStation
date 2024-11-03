// Simple animal nanogoopeyness
/mob/living/simple_mob/protean_blob
	name = "protean blob"
	desc = "Some sort of big viscous pool of jelly."
	tt_desc = "Animated nanogoop"
	icon = 'modular_chomp/icons/mob/species/protean/protean.dmi'
	icon_state = "to_puddle"
	icon_living = "puddle0-eyes"	//Null icon, since we're made of overlays now.
	icon_rest = "puddle0-eyes"
	icon_dead = "puddle0-eyes"

	faction = "neutral"
	maxHealth = 200
	health = 200
	say_list_type = /datum/say_list/protean_blob

	show_stat_health = FALSE //We will do it ourselves

	response_help = "pets the"
	response_disarm = "gently pushes aside the "
	response_harm = "hits the"

	harm_intent_damage = 3
	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = list("slashed")
	see_in_dark = 10

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 1100
	movement_cooldown = 0
	hunger_rate = 0

	var/mob/living/carbon/human/humanform
	var/obj/item/organ/internal/nano/refactory/refactory
	var/datum/modifier/healing

	var/human_brute = 0
	var/human_burn = 0

	player_msg = "In this form, your health will regenerate as long as you have metal in you."

	can_buckle = 1
	buckle_lying = 1
	mount_offset_x = 0
	mount_offset_y = 0
	has_hands = 1
	shock_resist = 1
	nameset = 1
	holder_type = /obj/item/holder/protoblob
	var/hiding = 0
	vore_icons = 1
	vore_active = 1

	plane = ABOVE_MOB_PLANE	//Necessary for overlay based icons

/datum/say_list/protean_blob
	speak = list("Blrb?","Sqrsh.","Glrsh!")
	emote_hear = list("squishes softly","spluts quietly","makes wet noises")
	emote_see = list("shifts wetly","undulates placidly")

//Constructor allows passing the human to sync damages
/mob/living/simple_mob/protean_blob/New(var/newloc, var/mob/living/carbon/human/H)
	..()
	if(H)
		humanform = H
		updatehealth()
		refactory = locate() in humanform.internal_organs
		add_verb(src,/mob/living/proc/usehardsuit) //CHOMPEdit TGPanel
		add_verb(src,/mob/living/simple_mob/protean_blob/proc/nano_partswap) //CHOMPEdit TGPanel
		add_verb(src,/mob/living/simple_mob/protean_blob/proc/nano_regenerate) //CHOMPEdit TGPanel
		add_verb(src,/mob/living/simple_mob/protean_blob/proc/nano_metalnom) //CHOMPEdit TGPanel
		add_verb(src,/mob/living/simple_mob/protean_blob/proc/nano_blobform) //CHOMPEdit TGPanel
		add_verb(src,/mob/living/simple_mob/protean_blob/proc/nano_rig_transform) //CHOMPEdit TGPanel
		add_verb(src,/mob/living/simple_mob/protean_blob/proc/appearance_switch) //CHOMPEdit TGPanel
		add_verb(src,/mob/living/simple_mob/protean_blob/proc/nano_latch) //CHOMPEdit TGPanel
		remove_verb(src,/mob/living/simple_mob/proc/nutrition_heal) //CHOMPEdit TGPanel
	else
		update_icon()
	add_verb(src,/mob/living/simple_mob/proc/animal_mount) //CHOMPEdit TGPanel
	add_verb(src,/mob/living/proc/toggle_rider_reins) //CHOMPEdit TGPanel

//Hidden verbs for macro hotkeying
/mob/living/simple_mob/protean_blob/proc/nano_partswap()
	set name = "Ref - Single Limb"
	set desc = "Allows you to replace and reshape your limbs as you see fit."
	//set category = "Abilities.Protean"
	set hidden = 1
	humanform.nano_partswap()

/mob/living/simple_mob/protean_blob/proc/nano_regenerate()
	set name = "Total Reassembly (wip)"
	set desc = "Completely reassemble yourself from whatever save slot you have loaded in preferences. Assuming you meet the requirements."
	//set category = "Abilities.Protean"
	set hidden = 1
	humanform.nano_regenerate()

/mob/living/simple_mob/protean_blob/proc/nano_blobform()
	set name = "Toggle Blobform"
	set desc = "Switch between amorphous and humanoid forms."
	//set category = "Abilities.Protean"
	set hidden = 1
	humanform.nano_blobform()

/mob/living/simple_mob/protean_blob/proc/nano_metalnom()
	set name = "Ref - Store Metals"
	set desc = "If you're holding a stack of material, you can consume some and store it for later."
	//set category = "Abilities.Protean"
	set hidden = 1
	humanform.nano_metalnom()

/mob/living/simple_mob/protean_blob/proc/nano_rig_transform()
	set name = "Modify Form - Hardsuit"
	set desc = "Allows a protean to retract its mass into its hardsuit module at will."
	//set category = "Abilities.Protean"
	set hidden = 1
	humanform.nano_rig_transform()

/mob/living/simple_mob/protean_blob/proc/appearance_switch()
	set name = "Switch Blob Appearance"
	set desc = "Allows a protean blob to switch its outwards appearance."
	//set category = "Abilities.Protean"
	set hidden = 1
	humanform.appearance_switch()

/mob/living/simple_mob/protean_blob/proc/nano_latch()
	set name = "Latch/Unlatch host"
	set desc = "Allows a protean to forcibly latch or unlatch from a host."
	//set category = "Abilities.Protean"
	set hidden = 1
	humanform.nano_latch()

/mob/living/simple_mob/protean_blob/Login()
	..()
	plane_holder.set_vis(VIS_AUGMENTED, 1)
	plane_holder.set_vis(VIS_CH_HEALTH_VR, 1)
	plane_holder.set_vis(VIS_CH_ID, 1)
	plane_holder.set_vis(VIS_CH_STATUS_R, 1)
	plane_holder.set_vis(VIS_CH_BACKUP, 1)	//Gonna need these so we can see the status of our host. Could probably write it so this only happens when worn, but eeehhh
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob/protean_blob(src)

/datum/riding/simple_mob/protean_blob/handle_vehicle_layer()
	ridden.layer = OBJ_LAYER

/mob/living/simple_mob/protean_blob/MouseDrop_T()
	return

/mob/living/simple_mob/protean_blob/runechat_y_offset(width, height)
	return (..()) - (20*size_multiplier)

/mob/living/simple_mob/protean_blob/Destroy()
	humanform = null
	refactory = null
	vore_organs = null
	vore_selected = null
	if(healing)
		healing.expire()
	return ..()

/mob/living/simple_mob/protean_blob/say_understands(var/mob/other, var/datum/language/speaking = null)
	// The parent of this proc and its parent are SHAMS and should be rewritten, but I'm not up to it right now.
	if(!speaking)
		return TRUE // can understand common, they're like, a normal person thing
	return ..()

/mob/living/simple_mob/protean_blob/speech_bubble_appearance()
	return "synthetic"

/mob/living/simple_mob/protean_blob/init_vore()
	return //Don't make a random belly, don't waste your time

/mob/living/simple_mob/protean_blob/isSynthetic()
	return TRUE // yup

/mob/living/simple_mob/protean_blob/get_available_emotes()
	var/list/fulllist = global._robot_default_emotes.Copy()
	fulllist |= global._human_default_emotes //they're living nanites, they can make whatever sounds they want
	return fulllist

/mob/living/simple_mob/protean_blob/update_misc_tabs()
	. = ..()
	if(humanform)
		humanform.species.update_misc_tabs(src)

/mob/living/simple_mob/protean_blob/updatehealth()
	if(humanform.nano_dead_check(src))
		return
	if(!humanform)
		return ..()

	//Set the max
	maxHealth = humanform.getMaxHealth()*2 //HUMANS, and their 'double health', bleh.
	human_brute = humanform.getActualBruteLoss()
	human_burn = humanform.getActualFireLoss()
	health = maxHealth - humanform.getOxyLoss() - humanform.getToxLoss() - humanform.getCloneLoss() - humanform.getBruteLoss() - humanform.getFireLoss()

	//Alive, becoming dead
	if((stat < DEAD) && (health <= 0))
		humanform.death()

	nutrition = humanform.nutrition

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

// All the damage and such to the blob translates to the human
/mob/living/simple_mob/protean_blob/apply_effect(var/effect = 0, var/effecttype = STUN, var/blocked = 0, var/check_protection = 1)
	if(humanform)
		return humanform.apply_effect(effect, effecttype, blocked, check_protection)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjustBruteLoss(var/amount,var/include_robo)
	if(humanform)
		return humanform.adjustBruteLoss(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjustFireLoss(var/amount,var/include_robo)
	if(humanform)
		return humanform.adjustFireLoss(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjustToxLoss(amount)
	if(humanform)
		return humanform.adjustToxLoss(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjustOxyLoss(amount)
	if(humanform)
		return humanform.adjustOxyLoss(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjustHalLoss(amount)
	if(humanform)
		return humanform.adjustHalLoss(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjustCloneLoss(amount)
	if(humanform)
		return humanform.adjustCloneLoss(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjust_nutrition(amount)
	if(humanform)
		return humanform.adjust_nutrition(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/emp_act(severity)
	if(humanform)
		return humanform.emp_act(severity)
	else
		return ..()

/mob/living/simple_mob/protean_blob/ex_act(severity)
	if(humanform)
		return humanform.ex_act(severity)
	else
		return ..()

/mob/living/simple_mob/protean_blob/rad_act(severity)
	if(istype(loc, /obj/item/rig))
		return	//Don't irradiate us while we're in rig mode
	if(humanform)
		return humanform.rad_act(severity)
	else
		return ..()

/mob/living/simple_mob/protean_blob/bullet_act(obj/item/projectile/P)
	if(humanform)
		return humanform.bullet_act(P)
	else
		return ..()

/mob/living/simple_mob/protean_blob/death(gibbed, deathmessage = "Coalesces inwards, retreating into their core componants")
	if(humanform)
		humanform.death(gibbed, deathmessage)
	else
		animate(src, alpha = 0, time = 2 SECONDS)
		sleep(2 SECONDS)

/mob/living/simple_mob/protean_blob/Life()
	. = ..()
	if(!humanform.nano_dead_check(src))
		if(. && istype(refactory) && humanform)
			if(!healing && (human_brute || human_burn) && refactory.get_stored_material(MAT_STEEL) >= 100)
				healing = humanform.add_modifier(/datum/modifier/protean/steel, origin = refactory)
			else if(healing && !(human_brute || human_burn))
				healing.expire()
				healing = null
	else
		if(healing)
			healing.expire()
			healing = null

/mob/living/simple_mob/protean_blob/lay_down()
	var/obj/item/rig/rig = src.get_rig()
	if(rig)
		rig.force_rest(src)
		return
	..()

/mob/living/simple_mob/protean_blob/verb/prot_hide()
	set name = "Hide Self"
	set desc = "Disperses your mass into a thin veil, making a trap to snatch prey with, or simply hide."
	set category = "Abilities.Protean"

	if(!hiding)
		cut_overlays()
		icon = 'modular_chomp/icons/mob/species/protean/protean.dmi'
		icon_state = "hide"
		sleep(7)
		mouse_opacity = 0
		plane = ABOVE_OBJ_PLANE
		hiding = 1
	else
		icon = 'modular_chomp/icons/mob/species/protean/protean.dmi'
		mouse_opacity = 1
		icon_state = "wake"
		plane = initial(plane)
		sleep(7)
		update_icon()
		hiding = 0
		//Potential glob noms
		if(can_be_drop_pred) //Toggleable in vore panel
			var/list/potentials = living_mobs(0)
			if(potentials.len)
				var/mob/living/target = pick(potentials)
				if(istype(target) && target.devourable && target.can_be_drop_prey && vore_selected)
					if(target.buckled)
						target.buckled.unbuckle_mob(target, force = TRUE)
					target.forceMove(vore_selected)
					to_chat(target,span_warning("\The [src] quickly engulfs you, [vore_selected.vore_verb]ing you into their [vore_selected.name]!"))
	update_canmove()

/mob/living/simple_mob/protean_blob/update_canmove()
	if(hiding)
		canmove = 0
		return canmove
	else
		..()


/*	Don't need this block anymore since our Prots have hands
/mob/living/simple_mob/protean_blob/attack_target(var/atom/A)
	if(refactory && istype(A,/obj/item/stack/material))
		var/obj/item/stack/material/S = A
		var/substance = S.material.name
		var allowed = FALSE
		for(var/material in PROTEAN_EDIBLE_MATERIALS)
			if(material == substance) allowed = TRUE
		if(!allowed)
			return
		if(refactory.add_stored_material(S.material.name,1*S.perunit) && S.use(1))
			visible_message(span_infoplain(span_bold("[name]") + " gloms over some of \the [S], absorbing it."))
	else if(isitem(A) && a_intent == "grab") //CHOMP Add all this block, down to I.forceMove.
		var/obj/item/I = A
		if(!vore_selected)
			to_chat(src,span_warning("You either don't have a belly selected, or don't have a belly!"))
			return FALSE
		if(is_type_in_list(I,item_vore_blacklist) || I.anchored)
			to_chat(src, span_warning("You can't eat this."))
			return

		if(is_type_in_list(I,edible_trash) | adminbus_trash)
			if(I.hidden_uplink)
				to_chat(src, span_warning("You really should not be eating this."))
				message_admins("[key_name(src)] has attempted to ingest an uplink item. ([src ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>" : "null"])")
				return
		visible_message(span_infoplain(span_bold("[name]") + " stretches itself over the [I], engulfing it whole!"))
		I.forceMove(vore_selected)
	else
		return ..()
*/

/mob/living/simple_mob/protean_blob/attackby(var/obj/item/O, var/mob/user)
	if(refactory && istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/S = O
		var/substance = S.material.name
		var allowed = FALSE
		for(var/material in PROTEAN_EDIBLE_MATERIALS)
			if(material == substance) allowed = TRUE
		if(!allowed)
			return
		if(refactory.add_stored_material(S.material.name,1*S.perunit) && S.use(1))
			visible_message(span_infoplain(span_bold("[name]") + " gloms over some of \the [S], absorbing it."))
	else
		return ..()

/mob/living/simple_mob/protean_blob/attack_hand(mob/living/L)
	if(L.get_effective_size() >= (src.get_effective_size() + 0.5) )
		src.get_scooped(L)
	else
		..()

/mob/living/simple_mob/protean_blob/MouseDrop(var/atom/over_object)
	if(ishuman(over_object) && usr == src && src.Adjacent(over_object))
		var/mob/living/carbon/human/H = over_object
		get_scooped(H, TRUE)
	else
		return ..()

/mob/living/simple_mob/protean_blob/MouseEntered(location,control,params)
	if(resting)
		return
	..()

/mob/living/simple_mob/protean_blob/character_directory_species()
	if (humanform)
		return "[humanform.custom_species ? humanform.custom_species : (humanform.species ? humanform.species.name : "Protean")]"
	return "Protean"

// Helpers - Unsafe, WILL perform change.
/mob/living/carbon/human/proc/nano_intoblob(force)
	if(!force && !isturf(loc) && !loc == /obj/item/rig/protean)
		to_chat(src,span_warning("You can't change forms while inside something."))
		return
	to_chat(src, span_notice("You rapidly disassociate your form."))
	if(force || do_after(src,20,exclusive = TASK_ALL_EXCLUSIVE))
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

		var/client/C = client

		//Record where they should go
		var/atom/creation_spot = drop_location()

		//Create our new blob
		var/mob/living/simple_mob/protean_blob/blob = new(creation_spot,src)

		//Size update
		blob.transform = matrix()*size_multiplier
		blob.size_multiplier = size_multiplier

		//dir update
		blob.dir = dir

		if(l_hand) drop_l_hand()
		if(r_hand) drop_r_hand()

		//Put our owner in it (don't transfer var/mind)
		blob.ckey = ckey
		blob.ooc_notes = ooc_notes
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
			blob.myid = wear_id
			wear_id.forceMove(blob)

		//Mail them to nullspace
		moveToNullspace()

		//Message
		blob.visible_message(span_infoplain(span_bold("[src.name]") + " collapses into a gooey blob!"))

		//Duration of the to_puddle iconstate that the blob starts with
		sleep(13)
		blob.update_icon() //Will remove the collapse anim

		//Transfer vore organs
		blob.vore_organs = vore_organs.Copy()
		blob.vore_selected = vore_selected
		for(var/obj/belly/B as anything in vore_organs)
			B.forceMove(blob)
			B.owner = blob
		vore_organs.Cut()

		soulgem.owner = blob

		//We can still speak our languages!
		blob.languages = languages.Copy()
		blob.name = real_name
		blob.real_name = real_name
		blob.voice_name = name

		blob.update_icon(1)

		//Flip them to the protean panel
		addtimer(CALLBACK(src, PROC_REF(nano_set_panel), C), 4)

		//Return our blob in case someone wants it
		return blob
	else
		to_chat(src, span_warning("You must remain still to blobform!"))

//For some reason, there's no way to force drop all the mobs grabbed. This ought to fix that. And be moved elsewhere. Call with caution, doesn't handle cycles.
/proc/remove_micros(var/src, var/mob/root)
	for(var/obj/item/I in src)
		remove_micros(I, root) //Recursion. I'm honestly depending on there being no containment loop, but at the cost of performance that can be fixed too.
		if(istype(I, /obj/item/holder))
			root.remove_from_mob(I)

/mob/living/proc/usehardsuit()
	set name = "Utilize Hardsuit Interface"
	set desc = "Allows a protean blob to open hardsuit interface."
	set category = "Abilities.Protean"

	if(istype(loc, /obj/item/rig/protean))
		var/obj/item/rig/protean/prig = loc
		to_chat(src, "You attempt to interface with the [prig].")
		prig.tgui_interact(src)
	else
		to_chat(src, "You are not in RIG form.")

/mob/living/carbon/human/proc/nano_outofblob(var/mob/living/simple_mob/protean_blob/blob, force)
	if(!istype(blob))
		return
	if(blob.loc == /obj/item/rig/protean)
		return
	if(!force && !isturf(blob.loc))
		to_chat(blob,span_warning("You can't change forms while inside something."))
		return
	to_chat(src, span_notice("You rapidly reassemble your form."))
	if(force || do_after(blob,20,exclusive = TASK_ALL_EXCLUSIVE))
		if(buckled)
			buckled.unbuckle_mob()
		if(LAZYLEN(buckled_mobs))
			for(var/buckledmob in buckled_mobs)
				riding_datum.force_dismount(buckledmob)
		if(pulledby)
			pulledby.stop_pulling()
		stop_pulling()

		var/client/C = blob.client

		//Stop healing if we are
		if(blob.healing)
			blob.healing.expire()

		if(blob.mob_radio)
			blob.mob_radio.forceMove(src)
			blob.mob_radio = null
		if(blob.myid)
			blob.myid.forceMove(src)
			blob.myid = null

		//Play the animation
		blob.icon_state = "from_puddle"

		//Message
		blob.visible_message(span_infoplain(span_bold("[src.name]") + " reshapes into a humanoid appearance!"))

		//Size update
		resize(blob.size_multiplier, FALSE, TRUE, ignore_prefs = TRUE)

		//Duration of above animation
		sleep(8)

		//Record where they should go
		var/atom/reform_spot = blob.drop_location()

		//dir update
		dir = blob.dir

		//Move them back where the blob was
		forceMove(reform_spot)

		if(blob.l_hand) blob.drop_l_hand()
		if(blob.r_hand) blob.drop_r_hand()

		//Put our owner in it (don't transfer var/mind)
		ckey = blob.ckey
		ooc_notes = blob.ooc_notes // Lets give the protean any updated notes from blob form.
		temporary_form = null

		//Transfer vore organs
		vore_organs = blob.vore_organs.Copy()
		vore_selected = blob.vore_selected
		for(var/obj/belly/B as anything in blob.vore_organs)
			B.forceMove(src)
			B.owner = src
		languages = blob.languages.Copy()

		soulgem.owner = src

		Life(1) //Fix my blindness right meow //Has to be moved up here, there exists a circumstance where blob could be deleted without vore organs moving right.

		//Get rid of friend blob
		qdel(blob)

		//Flip them to the protean panel
		addtimer(CALLBACK(src, PROC_REF(nano_set_panel), C), 4)

		//Return ourselves in case someone wants it
		return src
	else
		to_chat(src, span_warning("You must remain still to reshape yourself!"))

/mob/living/carbon/human/proc/nano_set_panel(var/client/C)
	if(C)
		C.statpanel = "Protean"

/mob/living/simple_mob/protean_blob/ClickOn(var/atom/A, var/params)
	if(istype(loc, /obj/item/rig/protean))
		HardsuitClickOn(A)
	..()

/mob/living/simple_mob/protean_blob/can_use_rig()
	return 1

/mob/living/simple_mob/protean_blob/HardsuitClickOn(var/atom/A, var/alert_ai = 0)
	if(istype(loc, /obj/item/rig/protean))
		var/obj/item/rig/protean/prig = loc
		if(istype(prig) && !prig.offline && prig.selected_module)
			if(!prig.ai_can_move_suit(src))
				return 0
			prig.selected_module.engage(A, alert_ai)
			if(ismob(A)) // No instant mob attacking - though modules have their own cooldowns
				setClickCooldown(get_attack_speed())
			return 1
	return 0

//Don't eat yourself, idiot
/mob/living/simple_mob/protean_blob/CanStumbleVore(mob/living/target)
	if(target == humanform)
		return FALSE
	return ..()

/mob/living/carbon/human/CanStumbleVore(mob/living/target)
	if(istype(target, /mob/living/simple_mob/protean_blob))
		var/mob/living/simple_mob/protean_blob/PB = target
		if(PB.humanform == src)
			return FALSE
	return ..()

/mob/living/simple_mob/protean_blob/handle_mutations_and_radiation()
	humanform.handle_mutations_and_radiation()

/mob/living/simple_mob/protean_blob/update_icon()
	..()
	if(humanform)
		vis_height = 32
		cut_overlays()
		var/list/wide_icons = list(
		"lizard",
		"rat",
		"wolf"
		)
		var/list/tall_icons = list(
		"drake",
		"teppi",
		"panther"
		)
		var/list/big_icons = list(
		"robodrgn"
		)
		var/datum/species/protean/S = humanform.species
		icon = 'modular_chomp/icons/mob/species/protean/protean.dmi'
		default_pixel_x = 0
		pixel_x = 0
		vore_capacity = 1
		if(S.blob_appearance == "dragon")
			vore_capacity = 2
			icon = 'icons/mob/vore128x64.dmi'
			mount_offset_y = 32
			mount_offset_x = -16
			var/image/I = image(icon, "[S.dragon_overlays[1]][resting? "-rest" : (vore_fullness? "-[vore_fullness]" : null)]", pixel_x = -48)
			I.color = S.dragon_overlays[S.dragon_overlays[1]]
			I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
			I.plane = MOB_PLANE
			I.layer = MOB_LAYER
			add_overlay(I)
			qdel(I)

			I = image(icon, "[S.dragon_overlays[2]][resting? "-rest" : null]", pixel_x = -48)
			I.color = S.dragon_overlays[S.dragon_overlays[2]]
			I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
			I.plane = MOB_PLANE
			I.layer = MOB_LAYER
			add_overlay(I)
			qdel(I)

			I = image(icon, "[S.dragon_overlays[3]][resting? "-rest" : null]", pixel_x = -48)
			I.color = S.dragon_overlays[S.dragon_overlays[3]]
			I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
			I.plane = MOB_PLANE
			I.layer = MOB_LAYER
			add_overlay(I)
			qdel(I)

			I = image(icon, "[S.dragon_overlays[4]][resting? "-rest" : null]", pixel_x = -48)
			I.color = S.dragon_overlays[S.dragon_overlays[4]]
			I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
			I.plane = MOB_PLANE
			I.layer = MOB_LAYER
			add_overlay(I)
			qdel(I)

			I = image(icon, "[S.dragon_overlays[5]][resting? "-rest" : null]", pixel_x = -48)
			I.color = S.dragon_overlays[S.dragon_overlays[5]]
			I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
			I.plane = MOB_PLANE
			I.layer = MOB_LAYER
			add_overlay(I)
			qdel(I)

			I = image(icon, "[S.dragon_overlays[6]][resting? "-rest" : null]", pixel_x = -48)
			I.color = S.dragon_overlays[S.dragon_overlays[6]]
			I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
			I.plane = PLANE_LIGHTING_ABOVE
			add_overlay(I)
			qdel(I)

		//You know technically I could just put all the icons into the 128x64.dmi file and off-set them to fit..
		if(S.blob_appearance in wide_icons)
			icon = 'modular_chomp/icons/mob/species/protean/protean64x32.dmi'
			default_pixel_x = -16
			pixel_x = -16
		if(S.blob_appearance in tall_icons)
			icon = 'modular_chomp/icons/mob/species/protean/protean64x64.dmi'
			default_pixel_x = -16
			pixel_x = -16
			vis_height = 64
		if(S.blob_appearance in big_icons)
			icon = 'modular_chomp/icons/mob/species/protean/protean128x64.dmi'
			default_pixel_x = -48
			pixel_x = -48
			vis_height = 64
		var/image/I = image(icon, S.blob_appearance+"[resting? "_rest":null][vore_fullness? "-[vore_fullness]" : null]")
		I.color = S.blob_color_1
		I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
		I.plane = MOB_PLANE
		I.layer = MOB_LAYER
		add_overlay(I)
		qdel(I)
		eye_layer = image(icon, "[S.blob_appearance][resting? "_rest" : null]-eyes")
		eye_layer.appearance_flags = appearance_flags
		eye_layer.color = S.blob_color_2
		eye_layer.plane = PLANE_LIGHTING_ABOVE
		add_overlay(eye_layer)
		qdel(eye_layer)
