/mob/living/carbon/human/gib()

	if(vr_holder)
		exit_vr()
		// Delete the link, because this mob won't be around much longer
		vr_holder.vr_link = null

	if(vr_link)
		vr_link.exit_vr()
		vr_link.vr_holder = null
		vr_link = null

	for(var/obj/item/organ/I in internal_organs)
		I.removed()
		if(isturf(I?.loc)) // Some organs qdel themselves or other things when removed
			I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

	for(var/obj/item/organ/external/E in src.organs)
		E.droplimb(0,DROPLIMB_EDGE,1)

	sleep(1)

	for(var/obj/item/I in src)
		drop_from_inventory(I)
		I.throw_at(get_edge_target_turf(src,pick(alldirs)), rand(1,3), round(30/I.w_class))

	..(species.gibbed_anim) // uses the default mob.dmi file for these, so we only need to specify the first argument
	gibs(loc, dna, null, species.get_flesh_colour(src), species.get_blood_colour(src))

/mob/living/carbon/human/dust()
	if(species)
		..(species.dusted_anim, species.remains_type)
	else
		..()

/mob/living/carbon/human/ash()
	if(species)
		..(species.dusted_anim)
	else
		..()

/mob/living/carbon/human/death(gibbed)

	if(stat == DEAD) return

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)

	//Handle species-specific deaths.
	species.handle_death(src)
	animate_tail_stop()
	stop_flying() //VOREStation Edit.

	//Handle snowflake ling stuff.
	if(mind && mind.changeling)
		// If the ling is capable of revival, don't allow them to see deadchat.
		if(mind.changeling.chem_charges >= CHANGELING_STASIS_COST)
			if(mind.changeling.max_geneticpoints >= 0) // Absorbed lings don't count, as they can't revive.
				forbid_seeing_deadchat = TRUE

	//Handle brain slugs.
	var/obj/item/organ/external/Hd = get_organ(BP_HEAD)
	var/mob/living/simple_mob/animal/borer/B

	if(Hd)
		for(var/I in Hd.implants)
			if(istype(I,/mob/living/simple_mob/animal/borer))
				B = I
	if(B)
		if(!B.ckey && ckey && B.controlling)
			B.ckey = ckey
			B.controlling = 0
		if(B.host_brain.ckey)
			ckey = B.host_brain.ckey
			B.host_brain.ckey = null
			B.host_brain.name = "host brain"
			B.host_brain.real_name = "host brain"

		verbs -= /mob/living/carbon/proc/release_control

	callHook("death", list(src, gibbed))

	if(mind)
		// SSgame_master.adjust_danger(gibbed ? 40 : 20)  // VOREStation Edit - We don't use SSgame_master yet.
		for(var/mob/observer/dead/O in mob_list)
			if(O.client?.prefs?.read_preference(/datum/preference/toggle/show_dsay))
				to_chat(O, "<span class='deadsay'><b>[src]</b> has died in <b>[get_area(src)]</b>. [ghost_follow_link(src, O)] </span>")

	if(!gibbed && species.death_sound)
		playsound(src, species.death_sound, 80, 1, 1)

	if(ticker && ticker.mode)
		sql_report_death(src)
		ticker.mode.check_win()

	if(wearing_rig)
		wearing_rig.notify_ai("<span class='danger'>Warning: user death event. Mobility control passed to integrated intelligence system.</span>")

	// If the body is in VR, move the mind back to the real world
	if(vr_holder)
		src.exit_vr()
		src.vr_holder.vr_link = null
		for(var/obj/item/W in src)
			src.drop_from_inventory(W)

	// If our mind is in VR, bring it back to the real world so it can die with its body
	if(vr_link)
		vr_link.exit_vr()
		vr_link.vr_holder = null
		vr_link = null
		to_chat(src, "<span class='danger'>Everything abruptly stops.</span>")

	return ..(gibbed,species.get_death_message(src))

/mob/living/carbon/human/proc/ChangeToHusk()
	if(HUSK in mutations)	return

	if(f_style)
		f_style = "Shaved"		//we only change the icon_state of the hair datum, so it doesn't mess up their UI/UE
	if(h_style)
		h_style = "Bald"
	update_hair(0)

	mutations.Add(HUSK)
	status_flags |= DISFIGURED	//makes them unknown without fucking up other stuff like admintools
	update_icons_body()
	return

/mob/living/carbon/human/proc/Drain()
	ChangeToHusk()
	mutations |= HUSK
	return

/mob/living/carbon/human/proc/ChangeToSkeleton()
	if(SKELETON in src.mutations)	return

	if(f_style)
		f_style = "Shaved"
	if(h_style)
		h_style = "Bald"
	update_hair(0)

	mutations.Add(SKELETON)
	status_flags |= DISFIGURED
	update_icons_body()
	return
