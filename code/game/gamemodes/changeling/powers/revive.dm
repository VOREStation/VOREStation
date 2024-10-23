//Revive from revival stasis
/mob/proc/changeling_revive()
	set category = "Changeling"
	set name = "Revive"
	set desc = "We are ready to revive ourselves on command."

	var/datum/changeling/changeling = changeling_power(0,0,100,DEAD)
	if(!changeling)
		return 0

	if(changeling.max_geneticpoints < 0) //Absorbed by another ling
		to_chat(src, span_danger("You have no genomes, not even your own, and cannot revive."))
		return 0

	if(src.stat == DEAD)
		dead_mob_list -= src
		living_mob_list += src
	var/mob/living/carbon/C = src

	C.tod = null
	C.setToxLoss(0)
	C.setOxyLoss(0)
	C.setCloneLoss(0)
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.radiation = 0
	C.heal_overall_damage(C.getBruteLoss(), C.getFireLoss())
	C.reagents.clear_reagents()
	if(ishuman(C))
		var/mob/living/carbon/human/H = src
		H.species.create_organs(H)
		H.restore_all_organs(ignore_prosthetic_prefs=1) //Covers things like fractures and other things not covered by the above.
		H.restore_blood()
		H.mutations.Remove(HUSK)
		H.status_flags &= ~DISFIGURED
		H.update_icons_body()
		for(var/limb in H.organs_by_name)
			var/obj/item/organ/external/current_limb = H.organs_by_name[limb]
			if(current_limb)
				current_limb.relocate()
				current_limb.open = 0

		BITSET(H.hud_updateflag, HEALTH_HUD)
		BITSET(H.hud_updateflag, STATUS_HUD)
		BITSET(H.hud_updateflag, LIFE_HUD)

		if(H.handcuffed)
			var/obj/item/W = H.handcuffed
			H.handcuffed = null
			if(H.buckled && H.buckled.buckle_require_restraints)
				H.buckled.unbuckle_mob()
			H.update_handcuffed()
			if (H.client)
				H.client.screen -= W
			W.forceMove(H.loc)
			W.dropped(H)
			if(W)
				W.layer = initial(W.layer)
		if(H.legcuffed)
			var/obj/item/W = H.legcuffed
			H.legcuffed = null
			H.update_inv_legcuffed()
			if(H.client)
				H.client.screen -= W
			W.forceMove(H.loc)
			W.dropped(H)
			if(W)
				W.layer = initial(W.layer)
		if(istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket))
			var/obj/item/clothing/suit/straight_jacket/SJ = H.wear_suit
			SJ.forceMove(H.loc)
			SJ.dropped(H)
			H.wear_suit = null

	C.halloss = 0
	C.shock_stage = 0 //Pain
	to_chat(C, span_notice("We have regenerated."))
	C.update_canmove()
	C.mind.changeling.purchased_powers -= C
	feedback_add_details("changeling_powers","CR")
	C.set_stat(CONSCIOUS)
	C.forbid_seeing_deadchat = FALSE
	C.timeofdeath = null
	remove_verb(src, /mob/proc/changeling_revive)
	// re-add our changeling powers
	C.make_changeling()

	return 1

//Revive from revival stasis, but one level removed, as the tab refuses to update. Placed in its own tab to avoid hyper-exploding the original tab through the same name being used.

/obj/changeling_revive_holder
	name = "strange object"
	desc = "Please report this object's existence to the dev team! You shouldn't see it."
	mouse_opacity = FALSE
	alpha = 1

/obj/changeling_revive_holder/verb/ling_revive()
	set src = usr.contents
	set category = "Regenerate"
	set name = "Revive"
	set desc = "We are ready to revive ourselves on command."

	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.changeling_revive()

	qdel(src)
