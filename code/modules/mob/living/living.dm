/mob/living/New()
	..()

	//Prime this list if we need it.
	if(has_huds)
		add_overlay(backplane,TRUE) //Strap this on here, to block HUDs from appearing in rightclick menus: http://www.byond.com/forum/?post=2336679
		hud_list = list()
		hud_list.len = TOTAL_HUDS
		make_hud_overlays()

	//I'll just hang my coat up over here
	dsoverlay = image('icons/mob/darksight.dmi',global_hud.darksight) //This is a secret overlay! Go look at the file, you'll see.
	var/mutable_appearance/dsma = new(dsoverlay) //Changing like ten things, might as well.
	dsma.alpha = 0
	dsma.plane = PLANE_LIGHTING
	dsma.blend_mode = BLEND_ADD
	dsoverlay.appearance = dsma

	selected_image = image(icon = buildmode_hud, loc = src, icon_state = "ai_sel")

/mob/living/Destroy()
	if(dsoverlay)
		dsoverlay.loc = null //I'll take my coat with me
		dsoverlay = null
	if(nest) //Ew.
		if(istype(nest, /obj/structure/prop/nest))
			var/obj/structure/prop/nest/N = nest
			N.remove_creature(src)
		if(istype(nest, /obj/structure/blob/factory))
			var/obj/structure/blob/factory/F = nest
			F.spores -= src
		nest = null
	if(buckled)
		buckled.unbuckle_mob(src, TRUE)
	//VOREStation Addition Start
	if(tf_mob_holder && tf_mob_holder.loc == src)
		tf_mob_holder.ckey = ckey
		if(isbelly(loc))
			tf_mob_holder.loc = loc
			tf_mob_holder.forceMove(loc)
		else
			var/turf/get_dat_turf = get_turf(src)
			tf_mob_holder.loc = get_dat_turf
			tf_mob_holder.forceMove(get_dat_turf)
		QDEL_LIST_NULL(tf_mob_holder.vore_organs)
		tf_mob_holder.vore_organs = list()
		for(var/obj/belly/B as anything in vore_organs)
			B.loc = tf_mob_holder
			B.forceMove(tf_mob_holder)
			B.owner = tf_mob_holder
			tf_mob_holder.vore_organs |= B
			vore_organs -= B

	if(tf_mob_holder)
		tf_mob_holder = null
	//VOREStation Addition End

	qdel(selected_image)
	QDEL_NULL(vorePanel) //VOREStation Add
	QDEL_LIST_NULL(vore_organs) //VOREStation Add
	temp_language_sources = null //VOREStation Add
	temp_languages = null //VOREStation Add

	if(LAZYLEN(organs))
		organs_by_name.Cut()
		while(organs.len)
			var/obj/item/OR = organs[1]
			organs -= OR
			qdel(OR)

	if(LAZYLEN(internal_organs) && !istype(src, /mob/living/simple_mob/animal))
		internal_organs_by_name.Cut()
		while(internal_organs.len)
			var/obj/item/OR = internal_organs[1]
			internal_organs -= OR
			qdel(OR)

	return ..()

//mob verbs are faster than object verbs. See mob/verb/examine.
/mob/living/verb/pulled(atom/movable/AM as mob|obj in oview(1))
	set name = "Pull"
	set category = "Object"

	if(AM.Adjacent(src))
		src.start_pulling(AM)

	return

//mob verbs are faster than object verbs. See above.
/mob/living/pointed(atom/A as mob|obj|turf in view())
	if(src.stat || src.restrained())
		return 0
	if(src.status_flags & FAKEDEATH)
		return 0
	if(!..())
		return 0

	usr.visible_message("<b>[src]</b> points to [A]")
	return 1

/mob/living/verb/succumb()
	set name = "Succumb to death"
	set category = "IC"
	set desc = "Press this button if you are in crit and wish to die. Use this sparingly (ending a scene, no medical, etc.)"
	var/confirm1 = tgui_alert(usr, "Pressing this button will kill you instantenously! Are you sure you wish to proceed?", "Confirm wish to succumb", list("No","Yes"))
	var/confirm2 = "No"
	if(confirm1 == "Yes")
		confirm2 = tgui_alert(usr, "Pressing this buttom will really kill you, no going back", "Are you sure?", list("Yes", "No")) //Swapped answers to protect from accidental double clicks.
	if (src.health < 0 && stat != DEAD && confirm1 == "Yes" && confirm2 == "Yes") // Checking both confirm1 and confirm2 for good measure. I don't trust TGUI.
		src.death()
		to_chat(src, "<font color='blue'>You have given up life and succumbed to death.</font>")
	else
		if(stat == DEAD)
			to_chat(src, "<font color='blue'>As much as you'd like, you can't die when already dead</font>")
		else if(confirm1 == "No" || confirm2 == "No")
			to_chat(src, "<font color='blue'>You chose to live another day.</font>")
		else
			to_chat(src, "<font color='blue'>You are not injured enough to succumb to death!</font>")

/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = getMaxHealth() - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss

//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(var/pressure)
	return


//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/living/proc/burn_skin(burn_amount)
	if(istype(src, /mob/living/carbon/human))
		//to_world("DEBUG: burn_skin(), mutations=[mutations]")
		if(mShock in src.mutations) //shockproof
			return 0
		if (COLD_RESISTANCE in src.mutations) //fireproof
			return 0
		var/mob/living/carbon/human/H = src	//make this damage method divide the damage to be done among all the body parts, then burn each body part for that much damage. will have better effect then just randomly picking a body part
		var/divided_damage = (burn_amount)/(H.organs.len)
		var/extradam = 0	//added to when organ is at max dam
		for(var/obj/item/organ/external/affecting in H.organs)
			if(!affecting)	continue
			if(affecting.take_damage(0, divided_damage+extradam))	//TODO: fix the extradam stuff. Or, ebtter yet...rewrite this entire proc ~Carn
				H.UpdateDamageIcon()
		H.updatehealth()
		return 1
	else if(istype(src, /mob/living/silicon/ai))
		return 0

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual-desired)	//get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
//	if(istype(src, /mob/living/carbon/human))
//		to_world("[src] ~ [src.bodytemperature] ~ [temperature]")
	return temperature


// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn
// I touched them without asking... I'm soooo edgy ~Erro (added nodamage checks)

/mob/living/proc/getBruteLoss()
	return bruteloss

/mob/living/proc/getShockBruteLoss()	//Only checks for things that'll actually hurt (not robolimbs)
	return bruteloss

/mob/living/proc/getActualBruteLoss()	// Mostly for humans with robolimbs.
	return getBruteLoss()

//'include_robo' only applies to healing, for legacy purposes, as all damage typically hurts both types of organs
/mob/living/proc/adjustBruteLoss(var/amount,var/include_robo)
	if(status_flags & GODMODE)	return 0	//godmode

	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				if(M.energy_based)
					M.energy_source.use(M.damage_cost*amount)
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_brute_damage_percent))
				if(M.energy_based)
					M.energy_source.use(M.damage_cost*amount)
				amount *= M.incoming_brute_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	//VOREStation Additon Start
	if(tf_mob_holder && tf_mob_holder.loc == src)
		var/dmgmultiplier = tf_mob_holder.maxHealth / maxHealth
		dmgmultiplier *= amount
		tf_mob_holder.adjustBruteLoss(dmgmultiplier)
	//VOREStation Additon End

	bruteloss = min(max(bruteloss + amount, 0),(getMaxHealth()*2))
	updatehealth()

/mob/living/proc/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode

	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				if(M.energy_based)
					M.energy_source.use(M.damage_cost*amount)
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_oxy_damage_percent))
				if(M.energy_based)
					M.energy_source.use(M.damage_cost*amount)
				amount *= M.incoming_oxy_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	oxyloss = min(max(oxyloss + amount, 0),(getMaxHealth()*2))
	updatehealth()

/mob/living/proc/setOxyLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	oxyloss = amount

/mob/living/proc/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode

	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				if(M.energy_based)
					M.energy_source.use(M.damage_cost*amount)
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_tox_damage_percent))
				if(M.energy_based)
					M.energy_source.use(M.damage_cost*amount)
				amount *= M.incoming_tox_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	toxloss = min(max(toxloss + amount, 0),(getMaxHealth()*2))
	updatehealth()

/mob/living/proc/setToxLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	toxloss = amount

/mob/living/proc/getFireLoss()
	return fireloss

/mob/living/proc/getShockFireLoss()	//Only checks for things that'll actually hurt (not robolimbs)
	return fireloss

/mob/living/proc/getActualFireLoss()	// Mostly for humans with robolimbs.
	return getFireLoss()

//'include_robo' only applies to healing, for legacy purposes, as all damage typically hurts both types of organs
/mob/living/proc/adjustFireLoss(var/amount,var/include_robo)
	if(status_flags & GODMODE)	return 0	//godmode
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				if(M.energy_based)
					M.energy_source.use(M.damage_cost*amount)
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_fire_damage_percent))
				if(M.energy_based)
					M.energy_source.use(M.damage_cost*amount)
				amount *= M.incoming_fire_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent
	//VOREStation Additon Start
	if(tf_mob_holder && tf_mob_holder.loc == src)
		var/dmgmultiplier = tf_mob_holder.maxHealth / maxHealth
		dmgmultiplier *= amount
		tf_mob_holder.adjustFireLoss(dmgmultiplier)
	//VOREStation Additon End
	fireloss = min(max(fireloss + amount, 0),(getMaxHealth()*2))
	updatehealth()

/mob/living/proc/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode

	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				if(M.energy_based)
					M.energy_source.use(M.damage_cost*amount)
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_clone_damage_percent))
				if(M.energy_based)
					M.energy_source.use(M.damage_cost*amount)
				amount *= M.incoming_clone_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	cloneloss = min(max(cloneloss + amount, 0),(getMaxHealth()*2))
	updatehealth()

/mob/living/proc/setCloneLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	cloneloss = amount

/mob/living/proc/getBrainLoss()
	return brainloss

/mob/living/proc/adjustBrainLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	brainloss = min(max(brainloss + amount, 0),(getMaxHealth()*2))

/mob/living/proc/setBrainLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	brainloss = amount

/mob/living/proc/getHalLoss()
	return halloss

/mob/living/proc/adjustHalLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(M.energy_based && (!isnull(M.incoming_hal_damage_percent) || !isnull(M.disable_duration_percent)))
				M.energy_source.use(M.damage_cost*amount) // Cost of the Damage absorbed.
				M.energy_source.use(M.energy_cost) // Cost of the Effect absorbed.
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_hal_damage_percent))
				amount *= M.incoming_hal_damage_percent
			if(!isnull(M.disable_duration_percent))
				amount *= M.disable_duration_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent
	halloss = min(max(halloss + amount, 0),(getMaxHealth()*2))
	updatehealth()

/mob/living/proc/setHalLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	halloss = amount

// Use this to get a mob's max health whenever possible.  Reading maxHealth directly will give inaccurate results if any modifiers exist.
/mob/living/proc/getMaxHealth()
	var/result = maxHealth
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.max_health_flat))
			result += M.max_health_flat
	// Second loop is so we can get all the flat adjustments first before multiplying, otherwise the result will be different.
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.max_health_percent))
			result *= M.max_health_percent
	return result

/mob/living/proc/setMaxHealth(var/newMaxHealth)
	health = (health/maxHealth) * (newMaxHealth) //VOREStation Add - Adjust existing health
	maxHealth = newMaxHealth

/mob/living/Stun(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(stunned > 0)
		add_status_indicator("stunned")

/mob/living/SetStunned(amount)
	..()
	if(stunned <= 0)
		remove_status_indicator("stunned")
	else
		add_status_indicator("stunned")

/mob/living/AdjustStunned(amount)
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.disable_duration_percent))
				amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(stunned <= 0)
		remove_status_indicator("stunned")
	else
		add_status_indicator("stunned")

/mob/living/Weaken(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(weakened > 0)
		add_status_indicator("weakened")

/mob/living/SetWeakened(amount)
	..()
	if(weakened <= 0)
		remove_status_indicator("weakened")
	else
		add_status_indicator("weakened")

/mob/living/AdjustWeakened(amount)
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.disable_duration_percent))
				amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(weakened <= 0)
		remove_status_indicator("weakened")
	else
		add_status_indicator("weakened")

/mob/living/Paralyse(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(paralysis > 0)
		add_status_indicator("paralysis")

/mob/living/SetParalysis(amount)
	..()
	if(paralysis <= 0)
		remove_status_indicator("paralysis")
	else
		add_status_indicator("paralysis")

/mob/living/AdjustParalysis(amount)
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.disable_duration_percent))
				amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(paralysis <= 0)
		remove_status_indicator("paralysis")
	else
		add_status_indicator("paralysis")

/mob/living/Sleeping(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(sleeping > 0)
		add_status_indicator("sleeping")

/mob/living/SetSleeping(amount)
	..()
	if(sleeping <= 0)
		remove_status_indicator("sleeping")
	else
		add_status_indicator("sleeping")

/mob/living/AdjustSleeping(amount)
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.disable_duration_percent))
				amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(sleeping <= 0)
		remove_status_indicator("sleeping")
	else
		add_status_indicator("sleeping")

/mob/living/Confuse(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(confused > 0)
		add_status_indicator("confused")

/mob/living/SetConfused(amount)
	..()
	if(confused <= 0)
		remove_status_indicator("confused")
	else
		add_status_indicator("confused")

/mob/living/AdjustConfused(amount)
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.disable_duration_percent))
				amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(confused <= 0)
		remove_status_indicator("confused")
	else
		add_status_indicator("confused")

/mob/living/Blind(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(eye_blind > 0)
		add_status_indicator("blinded")

/mob/living/SetBlinded(amount)
	..()
	if(eye_blind <= 0)
		remove_status_indicator("blinded")
	else
		add_status_indicator("blinded")

/mob/living/AdjustBlinded(amount)
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.disable_duration_percent))
				amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(eye_blind <= 0)
		remove_status_indicator("blinded")
	else
		add_status_indicator("blinded")

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/proc/get_contents()


//Recursive function to find everything a mob is holding.
/mob/living/get_contents(var/obj/item/weapon/storage/Storage = null)
	var/list/L = list()

	if(Storage) //If it called itself
		L += Storage.return_inv()

		//Leave this commented out, it will cause storage items to exponentially add duplicate to the list
		//for(var/obj/item/weapon/storage/S in Storage.return_inv()) //Check for storage items
		//	L += get_contents(S)

		for(var/obj/item/weapon/gift/G in Storage.return_inv()) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/weapon/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in Storage.return_inv()) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/weapon/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

	else

		L += src.contents
		for(var/obj/item/weapon/storage/S in src.contents)	//Check for storage items
			L += get_contents(S)

		for(var/obj/item/weapon/gift/G in src.contents) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/weapon/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in src.contents) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/weapon/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

/mob/living/proc/check_contents_for(A)
	var/list/L = src.get_contents()

	for(var/obj/B in L)
		if(B.type == A)
			return 1
	return 0

/mob/living/proc/revive()
	rejuvenate()
	if(buckled)
		buckled.unbuckle_mob()
	if(iscarbon(src))
		var/mob/living/carbon/C = src

		if (C.handcuffed && !initial(C.handcuffed))
			C.drop_from_inventory(C.handcuffed)
		C.handcuffed = initial(C.handcuffed)

		if (C.legcuffed && !initial(C.legcuffed))
			C.drop_from_inventory(C.legcuffed)
		C.legcuffed = initial(C.legcuffed)
	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)
	ExtinguishMob()
	fire_stacks = 0
	if(ai_holder) // AI gets told to sleep when killed. Since they're not dead anymore, wake it up.
		ai_holder.go_wake()

/mob/living/proc/rejuvenate()
	if(reagents)
		reagents.clear_reagents()

	// shut down various types of badness
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	SetParalysis(0)
	SetStunned(0)
	SetWeakened(0)

	// undo various death related conveniences
	sight = initial(sight)
	see_in_dark = initial(see_in_dark)
	see_invisible = initial(see_invisible)

	// shut down ongoing problems
	radiation = 0
	nutrition = 400
	bodytemperature = T20C
	sdisabilities = 0
	disabilities = 0
	resting = FALSE

	// fix blindness and deafness
	blinded = 0
	SetBlinded(0)
	eye_blurry = 0
	ear_deaf = 0
	ear_damage = 0
	heal_overall_damage(getBruteLoss(), getFireLoss())

	// fix all of our organs
	restore_all_organs()

	// remove the character from the list of the dead
	if(stat == DEAD)
		dead_mob_list -= src
		living_mob_list += src
		tod = null
		timeofdeath = 0

	// restore us to conciousness
	set_stat(CONSCIOUS)

	// make the icons look correct
	regenerate_icons()

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)

	failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	reload_fullscreen()

	return

/mob/living/proc/UpdateDamageIcon()
	return


/mob/living/proc/Examine_OOC()
	set name = "Examine Meta-Info (OOC)"
	set category = "OOC"
	set src in view()
	//VOREStation Edit Start - Making it so SSD people have prefs with fallback to original style.
	if(config.allow_Metadata)
		if(ooc_notes)
			to_chat(usr, "[src]'s Metainfo:<br>[ooc_notes]")
		else if(client)
			to_chat(usr, "[src]'s Metainfo:<br>[client.prefs.metadata]")
		else
			to_chat(usr, "[src] does not have any stored infomation!")
	else
		to_chat(usr, "OOC Metadata is not supported by this server!")
	//VOREStation Edit End - Making it so SSD people have prefs with fallback to original style.

	return

/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!incapacitated(INCAPACITATION_KNOCKOUT) && (last_resist_time + RESIST_COOLDOWN < world.time))
		last_resist_time = world.time
		resist_grab()
		if(!weakened)
			process_resist()
		else if(absorbed && isbelly(loc))			// Allow absorbed resistance
			var/obj/belly/B = loc
			B.relay_absorbed_resist(src)

/mob/living/proc/process_resist()

	if(istype(src.loc, /mob/living/silicon/robot/platform))
		var/mob/living/silicon/robot/platform/R = src.loc
		R.drop_stored_atom(src, src)
		return TRUE

	//unbuckling yourself
	if(buckled)
		resist_buckle()
		return TRUE

	if(isobj(loc))
		var/obj/C = loc
		C.container_resist(src)
		return TRUE

	else if(canmove)
		if(on_fire)
			resist_fire() //stop, drop, and roll
		else
			resist_restraints()

	if(attempt_vr(src,"vore_process_resist",args)) return TRUE //VOREStation Code

/mob/living/proc/resist_buckle()
	if(buckled)
		if(istype(buckled, /obj/vehicle))
			var/obj/vehicle/vehicle = buckled
			vehicle.unload()
		else
			buckled.user_unbuckle_mob(src, src)

/mob/living/proc/resist_grab()
	var/resisting = 0
	for(var/obj/item/weapon/grab/G in grabbed_by)
		resisting++
		G.handle_resist()
	if(resisting)
		visible_message("<span class='danger'>[src] resists!</span>")

/mob/living/proc/resist_fire()
	return

/mob/living/proc/resist_restraints()
	return

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = !resting
	to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"]</span>")
	update_canmove()

//called when the mob receives a bright flash
/mob/living/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(override_blindness_check || !(disabilities & BLIND))
		overlay_fullscreen("flash", type)
		spawn(25)
			if(src)
				clear_fullscreen("flash", 25)
		return 1

/mob/living/proc/cannot_use_vents()
	if(mob_size > MOB_SMALL)
		return "You can't fit into that vent."
	return null

/mob/living/proc/has_brain()
	return 1

/mob/living/proc/has_eyes()
	return 1

/mob/living/proc/get_restraining_bolt()
	var/obj/item/weapon/implant/restrainingbolt/RB = locate() in src
	if(RB)
		if(!RB.malfunction)
			return TRUE

	return FALSE

/mob/living/proc/slip(var/slipped_on,stun_duration=8)
	return 0

/mob/living/carbon/drop_from_inventory(var/obj/item/W, var/atom/Target = null)
	if(W in internal_organs)
		return 0
	return ..()

/mob/living/touch_map_edge()

	//check for nuke disks
	if(client && stat != DEAD) //if they are clientless and dead don't bother, the parent will treat them as any other container
		if(ticker && istype(ticker.mode, /datum/game_mode/nuclear)) //only really care if the game mode is nuclear
			var/datum/game_mode/nuclear/G = ticker.mode
			if(G.check_mob(src))
				if(x <= TRANSITIONEDGE)
					inertia_dir = 4
				else if(x >= world.maxx -TRANSITIONEDGE)
					inertia_dir = 8
				else if(y <= TRANSITIONEDGE)
					inertia_dir = 1
				else if(y >= world.maxy -TRANSITIONEDGE)
					inertia_dir = 2
				to_chat(src, "<span class='warning'>Something you are carrying is preventing you from leaving.</span>")
				return

	..()

//damage/heal the mob ears and adjust the deaf amount
/mob/living/adjustEarDamage(var/damage, var/deaf)
	ear_damage = max(0, ear_damage + damage)
	ear_deaf = max(0, ear_deaf + deaf)

//pass a negative argument to skip one of the variable
/mob/living/setEarDamage(var/damage, var/deaf)
	if(damage >= 0)
		ear_damage = damage
	if(deaf >= 0)
		ear_deaf = deaf

/mob/living/proc/vomit(var/skip_wait, var/blood_vomit)
	if(!check_has_mouth())
		return

	if(!lastpuke)
		lastpuke = 1
		if(isSynthetic())
			to_chat(src, "<span class='danger'>A sudden, dizzying wave of internal feedback rushes over you!</span>")
			src.Weaken(5)
		else
			if (nutrition <= 100)
				to_chat(src, "<span class='danger'>You gag as you want to throw up, but there's nothing in your stomach!</span>")
				src.Weaken(10)
			else
				to_chat(src, "<span class='warning'>You feel nauseous...</span>")

				if(ishuman(src))
					var/mob/living/carbon/human/Hu = src
					if(CE_ANTACID in Hu.chem_effects)
						if(prob(min(90, Hu.chem_effects[CE_ANTACID] * 15)))
							spawn(rand(30 SECONDS, 2 MINUTES))
								lastpuke = FALSE
							return

				spawn()
					if(!skip_wait)
						sleep(150)	//15 seconds until second warning
						to_chat(src, "<span class='warning'>You feel like you are about to throw up!</span>")
						sleep(100)	//and you have 10 more for mad dash to the bucket

					//Damaged livers cause you to vomit blood.
					if(!blood_vomit)
						if(ishuman(src))
							var/mob/living/carbon/human/H = src
							if(!H.isSynthetic())
								var/obj/item/organ/internal/liver/L = H.internal_organs_by_name["liver"]
								if(!L || L.is_broken())
									blood_vomit = 1

					Stun(5)
					src.visible_message("<span class='warning'>[src] throws up!</span>","<span class='warning'>You throw up!</span>")
					playsound(src, 'sound/effects/splat.ogg', 50, 1)

					var/turf/simulated/T = get_turf(src)	//TODO: Make add_blood_floor remove blood from human mobs
					if(istype(T))
						if(blood_vomit)
							T.add_blood_floor(src)
						else
							T.add_vomit_floor(src, 1)

					if(blood_vomit)
						if(getBruteLoss() < 50)
							adjustBruteLoss(3)
					else
						adjust_nutrition(-40)
						adjustToxLoss(-3)

		spawn(350)
			lastpuke = 0

/mob/living/update_canmove()
	if(!resting && cannot_stand() && can_stand_overridden())
		lying = 0
		canmove = 1
	else
		if(istype(buckled, /obj/vehicle))
			var/obj/vehicle/V = buckled
			if(is_physically_disabled())
				lying = 0
				canmove = 1
				if(!V.riding_datum) // If it has a riding datum, the datum handles moving the pixel_ vars.
					pixel_y = V.mob_offset_y - 5
			else
				if(buckled.buckle_lying != -1)
					lying = buckled.buckle_lying
				canmove = 1
				if(!V.riding_datum) // If it has a riding datum, the datum handles moving the pixel_ vars.
					pixel_y = V.mob_offset_y
		else if(buckled)
			anchored = TRUE
			canmove = 1 //The line above already makes the chair not swooce away if the sitter presses a button. No need to incapacitate them as a criminally large amount of mechanics read this var as a type of stun.
			if(istype(buckled))
				if(buckled.buckle_lying != -1)
					lying = buckled.buckle_lying
					canmove = buckled.buckle_movable
				if(buckled.buckle_movable)
					anchored = FALSE
					canmove = 1
		else
			lying = incapacitated(INCAPACITATION_KNOCKDOWN)
			canmove = !incapacitated(INCAPACITATION_DISABLED)

	if(lying)
		density = FALSE
		if(l_hand)
			unEquip(l_hand)
		if(r_hand)
			unEquip(r_hand)
		for(var/obj/item/weapon/holder/holder in get_mob_riding_slots())
			unEquip(holder)
		update_water() // Submerges the mob.
	else
		density = initial(density)

	for(var/obj/item/weapon/grab/G in grabbed_by)
		if(G.state >= GRAB_AGGRESSIVE)
			canmove = 0
			break

	if(lying != lying_prev)
		lying_prev = lying
		update_transform()
		//VOREStation Add
		if(lying && LAZYLEN(buckled_mobs))
			for(var/mob/living/L as anything in buckled_mobs)
				if(buckled_mobs[L] != "riding")
					continue // Only boot off riders
				if(riding_datum)
					riding_datum.force_dismount(L)
				else
					unbuckle_mob(L)
				L.Stun(5)
		//VOREStation Add End

	return canmove

// Mob holders in these slots will be spilled if the mob goes prone.
/mob/living/proc/get_mob_riding_slots()
	return list(back)

// Adds overlays for specific modifiers.
// You'll have to add your own implementation for non-humans currently, just override this proc.
/mob/living/proc/update_modifier_visuals()
	return

/mob/living/proc/update_water() // Involves overlays for humans.  Maybe we'll get submerged sprites for borgs in the future?
	return

/mob/living/proc/can_feel_pain(var/check_organ)
	if(isSynthetic())
		return FALSE
	return TRUE

// Gets the correct icon_state for being on fire. See OnFire.dmi for the icons.
/mob/living/proc/get_fire_icon_state()
	return "generic"

// Called by job_controller.
/mob/living/proc/equip_post_job()
	return

// Used to check if something is capable of thought, in the traditional sense.
/mob/living/proc/is_sentient()
	return TRUE

/mob/living/get_icon_scale_x()
	. = ..()
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.icon_scale_x_percent))
			. *= M.icon_scale_x_percent

/mob/living/get_icon_scale_y()
	. = ..()
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.icon_scale_y_percent))
			. *= M.icon_scale_y_percent

/mob/living/update_transform()
	// First, get the correct size.
	var/desired_scale_x = size_multiplier * icon_scale_x //VOREStation edit
	var/desired_scale_y = size_multiplier * icon_scale_y //VOREStation edit

	// Now for the regular stuff.
	var/matrix/M = matrix()
	M.Scale(desired_scale_x, desired_scale_y)
	M.Translate(0, (vis_height/2)*(desired_scale_y-1)) //VOREStation edit
	src.transform = M //VOREStation edit
	handle_status_indicators()

// This handles setting the client's color variable, which makes everything look a specific color.
// This proc is here so it can be called without needing to check if the client exists, or if the client relogs.
/mob/living/update_client_color()
	if(!client)
		return

	var/list/colors_to_blend = list()
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.client_color))
			if(islist(M.client_color)) //It's a color matrix! Forget it. Just use that one.
				animate(client, color = M.client_color, time = 10)
				return
			colors_to_blend += M.client_color

	if(colors_to_blend.len)
		var/final_color
		if(colors_to_blend.len == 1) // If it's just one color we can skip all of this work.
			final_color = colors_to_blend[1]

		else // Otherwise we need to do some messy additive blending.
			var/R = 0
			var/G = 0
			var/B = 0

			for(var/C in colors_to_blend)
				var/RGB = hex2rgb(C)
				R = between(0, R + RGB[1], 255)
				G = between(0, G + RGB[2], 255)
				B = between(0, B + RGB[3], 255)
			final_color = rgb(R,G,B)

		if(final_color)
			var/old_color = client.color // Don't know if BYOND has an internal optimization to not care about animate() calls that effectively do nothing.
			if(final_color != old_color) // Gonna do a check just incase.
				animate(client, color = final_color, time = 10)

	else // No colors, so remove the client's color.
		animate(client, color = null, time = 10)

/mob/living/swap_hand()
	src.hand = !( src.hand )
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "l_hand_active"
			hud_used.r_hand_hud_object.icon_state = "r_hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "l_hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "r_hand_active"

	// We just swapped hands, so the thing in our inactive hand will notice it's not the focus
	var/obj/item/I = get_inactive_hand()
	if(I)
		if(I.zoom)
			I.zoom()
		I.in_inactive_hand(src)	//This'll do specific things, determined by the item
	return

/mob/living/proc/activate_hand(var/selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()

/mob/living/throw_item(atom/target)
	if(incapacitated() || !target || istype(target, /obj/screen))
		return FALSE

	var/atom/movable/item = src.get_active_hand()

	if(!item)
		return FALSE

	var/throw_range = item.throw_range
	if (istype(item, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = item
		item = G.throw_held() //throw the person instead of the grab
		if(ismob(item))
			var/mob/M = item

			//limit throw range by relative mob size
			throw_range = round(M.throw_range * min(src.mob_size/M.mob_size, 1))

			var/turf/end_T = get_turf(target)
			if(end_T)
				add_attack_logs(src,M,"Thrown via grab to [end_T.x],[end_T.y],[end_T.z]")
			if(ishuman(M))
				var/mob/living/carbon/human/N = M
				if((N.health + N.halloss) < config.health_threshold_crit || N.stat == DEAD)
					N.adjustBruteLoss(rand(10,30))
			src.drop_from_inventory(G)

			src.visible_message("<span class='warning'>[src] has thrown [item].</span>")

			if((isspace(src.loc)) || (src.lastarea?.has_gravity == 0))
				src.inertia_dir = get_dir(target, src)
				step(src, inertia_dir)
			item.throw_at(target, throw_range, item.throw_speed, src)
			item.throwing = 1 //Small edit so thrown interactions actually work!
			return TRUE
		else
			return FALSE

	if(!item)
		return FALSE //Grab processing has a chance of returning null

	if(a_intent == I_HELP && Adjacent(target) && isitem(item) && ishuman(target))
		var/obj/item/I = item
		var/mob/living/carbon/human/H = target
		if(H.in_throw_mode && H.a_intent == I_HELP && unEquip(I))
			H.put_in_hands(I) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
			visible_message("<b>[src]</b> hands \the [H] \a [I].", SPAN_NOTICE("You give \the [target] \a [I]."))
		else
			to_chat(src, SPAN_NOTICE("You offer \the [I] to \the [target]."))
			do_give(H)
		return TRUE

	drop_from_inventory(item)

	if(!item || QDELETED(item))
		return TRUE //It may not have thrown, but it sure as hell left your hand successfully.

	//actually throw it!
	src.visible_message("<span class='warning'>[src] has thrown [item].</span>")

	if((isspace(src.loc)) || (src.lastarea?.has_gravity == 0))
		src.inertia_dir = get_dir(target, src)
		step(src, inertia_dir)

	if(istype(item,/obj/item))
		var/obj/item/W = item
		W.randpixel_xy()

/*
	if(istype(src.loc, /turf/space) || (src.flags & NOGRAV)) //they're in space, move em one space in the opposite direction
		src.inertia_dir = get_dir(target, src)
		step(src, inertia_dir)
*/


	item.throw_at(target, throw_range, item.throw_speed, src)
	return TRUE

/mob/living/get_sound_env(var/pressure_factor)
	if (hallucination)
		return SOUND_ENVIRONMENT_PSYCHOTIC
	else if (druggy)
		return SOUND_ENVIRONMENT_DRUGGED
	else if (drowsyness)
		return SOUND_ENVIRONMENT_DIZZY
	else if (confused)
		return SOUND_ENVIRONMENT_DIZZY
	else if (sleeping)
		return SOUND_ENVIRONMENT_UNDERWATER
	else
		return ..()

//Add an entry to overlays, assuming it exists
/mob/living/proc/apply_hud(cache_index, var/image/I)
	hud_list[cache_index] = I
	if((. = hud_list[cache_index]))
		//underlays += .
		add_overlay(.)

//Remove an entry from overlays, and from the list
/mob/living/proc/grab_hud(cache_index)
	var/I = hud_list[cache_index]
	if(I)
		//underlays -= I
		cut_overlay(I)
		hud_list[cache_index] = null
		return I

/mob/living/proc/make_hud_overlays()
	return


/mob/living/proc/has_vision()
	return !(eye_blind || (disabilities & BLIND) || stat || blinded)


/mob/living/proc/dirties_floor()	// If we ever decide to add fancy conditionals for making dirty floors (floating, etc), here's the proc.
	return makes_dirt

/mob/living/proc/needs_to_breathe()
	return !isSynthetic()

/mob/living/proc/adjust_nutrition(amount)
	nutrition = between(0, nutrition + amount, max_nutrition)

/mob/living/vv_get_header()
	. = ..()
	. += {"
		<a href='?_src_=vars;[HrefToken()];rename=\ref[src]'><b>[src]</b></a><font size='1'>
		<br><a href='?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=ckey'>[ckey ? ckey : "No ckey"]</a> / <a href='?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=real_name'>[real_name ? real_name : "No real name"]</a>
		<br>
		BRUTE:<a href='?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=brute'>[getBruteLoss()]</a>
		FIRE:<a href='?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=fire'>[getFireLoss()]</a>
		TOXIN:<a href='?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=toxin'>[getToxLoss()]</a>
		OXY:<a href='?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=oxygen'>[getOxyLoss()]</a>
		CLONE:<a href='?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=clone'>[getCloneLoss()]</a>
		BRAIN:<a href='?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=brain'>[getBrainLoss()]</a>
		</font>
		"}

/mob/living/update_gravity(has_gravity)
	if(!ticker)
		return
	if(has_gravity)
		clear_alert("weightless")
	else
		throw_alert("weightless", /obj/screen/alert/weightless)

// Tries to turn off things that let you see through walls, like mesons.
// Each mob does vision a bit differently so this is just for inheritence and also so overrided procs can make the vision apply instantly if they call `..()`.
/mob/living/proc/disable_spoiler_vision()
	handle_vision()

/**
 * Small helper component to manage the character setup HUD icon
 */
/datum/component/character_setup
	var/obj/screen/character_setup/screen_icon

/datum/component/character_setup/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()

/datum/component/character_setup/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN, .proc/create_mob_button)
	var/mob/owner = parent
	if(owner.client)
		create_mob_button(parent)

/datum/component/character_setup/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN)
	var/mob/owner = parent
	if(screen_icon)
		owner?.client?.screen -= screen_icon
		UnregisterSignal(screen_icon, COMSIG_CLICK)
		qdel_null(screen_icon)

/datum/component/character_setup/proc/create_mob_button(mob/user)
	var/datum/hud/HUD = user.hud_used
	if(!screen_icon)
		screen_icon = new()
		RegisterSignal(screen_icon, COMSIG_CLICK, .proc/character_setup_click)
	if(ispAI(user))
		screen_icon.icon = 'icons/mob/pai_hud.dmi'
		screen_icon.screen_loc = ui_acti
	else
		screen_icon.icon = HUD.ui_style
		screen_icon.color = HUD.ui_color
		screen_icon.alpha = HUD.ui_alpha
	LAZYADD(HUD.other_important, screen_icon)
	user.client?.screen += screen_icon

/datum/component/character_setup/proc/character_setup_click(source, location, control, params, user)
	var/mob/owner = user
	if(owner.client?.prefs)
		INVOKE_ASYNC(owner.client.prefs, /datum/preferences/proc/ShowChoices, owner)

/**
 * Screen object for vore panel
 */
/obj/screen/character_setup
	name = "character setup"
	icon = 'icons/mob/screen/midnight.dmi'
	icon_state = "character"
	screen_loc = ui_smallquad
