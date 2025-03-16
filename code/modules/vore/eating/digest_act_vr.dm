//Please make sure to:
//return FALSE: You are not going away, stop asking me to digest.
//return non-negative integer: Amount of nutrition/charge gained (scaled to nutrition, other end can multiply for charge scale).

// Ye default implementation.
/obj/item/proc/digest_act(atom/movable/item_storage = null, touchable_amount, splashing = 0)
	if(!digestable)
		return FALSE
	if(istype(item_storage, /obj/item/dogborg/sleeper))
		if(istype(src, /obj/item/pda))
			var/obj/item/pda/P = src
			if(P.id)
				P.id = null

		for(var/mob/living/voice/V in possessed_voice) // Delete voices.
			V.ghostize(0) // Prevent Reenter Corpse sending observers to the shadow realm
			V.stat = DEAD // Helps with autosleeving
			if(V.mind) V.mind.vore_death = 1 // Digested item TFs get vore_death timer
			qdel(V)
		for(var/mob/living/M in contents)//Drop mobs from objects(shoes) before deletion
			M.forceMove(item_storage)
		for(var/obj/item/O in contents)
			if(istype(O, /obj/item/storage/internal)) //Dump contents from dummy pockets.
				for(var/obj/item/SO in O)
					if(item_storage)
						SO.forceMove(item_storage)
					qdel(O)
			else if(item_storage)
				O.forceMove(item_storage)
		GLOB.items_digested_roundstat++
		qdel(src)
		return w_class

	var/g_damage = 1
	if(digest_stage == null)
		digest_stage = w_class

	var/obj/belly/B
	if(isbelly(item_storage))
		B = item_storage
	if(!touchable_amount)
		touchable_amount = 1
	if(splashing > 0)
		g_damage = 0.25 * splashing
	else if(istype(B))
		g_damage = 0.25 * (B.digest_brute + B.digest_burn) / touchable_amount
	if(g_damage <= 0)
		return FALSE
	if(g_damage > digest_stage)
		g_damage = digest_stage
		digest_stage = 0 //Don't bother with further math for 1 hit kills.
	if(digest_stage > 0)
		if(g_damage > digest_stage)
			g_damage = digest_stage
		digest_stage -= g_damage
		d_mult = round(1 / w_class * digest_stage, 0.25)
		if(d_mult < d_mult_old)
			d_mult_old = d_mult
			var/d_stage_name
			switch(d_mult)
				if(0.75)
					d_stage_name = "blemished"
				if(0.5)
					d_stage_name = "disfigured"
				if(0.25)
					d_stage_name = "deteriorating"
				if(0)
					d_stage_name = "ruined"
			if(d_stage_name)
				if(!oldname)
					oldname = cleanname ? cleanname : name
				cleanname = "[d_stage_name] [oldname]"
				decontaminate()
				if(istype(B))
					gurgled_color = B.contamination_color //Apply the correct color setting so uncontaminable things can still have the right overlay.
					gurgle_contaminate(B, B.contamination_flavor, B.contamination_color)
	if(digest_stage <= 0)
		if(istype(src, /obj/item/pda))
			var/obj/item/pda/P = src
			if(P.id)
				P.id = null
		for(var/mob/living/M in contents)//Drop mobs from objects(shoes) before deletion
			if(item_storage)
				M.forceMove(item_storage)
			else
				M.forceMove(src.loc)
		for(var/obj/item/O in contents)
			if(istype(O,/obj/item/storage/internal)) //Dump contents from dummy pockets.
				for(var/obj/item/SO in O)
					if(item_storage)
						SO.forceMove(item_storage)
					qdel(O)
			else if(item_storage)
				O.forceMove(item_storage)
			else
				O.forceMove(src.loc)
		GLOB.items_digested_roundstat++
		var/g_sound_volume = 100
		var/noise_freq = 42500
		if(istype(B))
			g_sound_volume = B.sound_volume
			noise_freq = B.noise_freq
		var/soundfile
		if(w_class >= 4)
			soundfile = pick('sound/vore/shortgurgles/gurgle_L1.ogg', 'sound/vore/shortgurgles/gurgle_L2.ogg', 'sound/vore/shortgurgles/gurgle_L3.ogg')
		else if(w_class >= 3)
			soundfile = pick('sound/vore/shortgurgles/gurgle_M1.ogg', 'sound/vore/shortgurgles/gurgle_M2.ogg', 'sound/vore/shortgurgles/gurgle_M3.ogg')
		else
			soundfile = pick('sound/vore/shortgurgles/gurgle_S1.ogg', 'sound/vore/shortgurgles/gurgle_S2.ogg', 'sound/vore/shortgurgles/gurgle_S3.ogg')
		playsound(src, soundfile, vol = g_sound_volume, vary = 1, falloff = VORE_SOUND_FALLOFF, frequency = noise_freq, preference = /datum/preference/toggle/eating_noises, volume_channel = VOLUME_CHANNEL_VORE)
		//Allow those turned into items to become the recycled item
		var/recycled = B?.recycle(src)
		if(!recycled)
			for(var/mob/living/voice/V in possessed_voice) // Delete voices.
				V.ghostize(0) //Prevent Reenter Corpse sending observers to the shadow realm
				V.stat = DEAD //Helps with autosleeving
				if(V.mind) V.mind.vore_death = 1 //Digested item TFs get vore_death timer
				qdel(V) //Destroy the voice.
		if(istype(B) && recycled)
			g_damage = w_class / 2
			if(B.item_digest_logs)
				to_chat(B.owner,span_notice("[src] was digested inside your [lowertext(B.name)]."))
			qdel(src)
		else if(istype(src,/obj/item/stack))
			var/obj/item/stack/S = src
			if(S.get_amount() <= 1)
				qdel(src)
			else
				S.use(1)
				digest_stage = w_class
		else
			if(istype(src, /obj/item/reagent_containers/food))
				if(ishuman(B.owner) && reagents)
					var/mob/living/carbon/human/H = B.owner
					reagents.trans_to_holder(H.ingested, (reagents.total_volume), B.nutrition_percent / 100, 0)
				else if(isliving(B.owner))
					B.owner.nutrition += 15 * w_class * B.nutrition_percent / 100
				if(istype(src,/obj/item/reagent_containers/food/snacks))
					var/obj/item/reagent_containers/food/snacks/goodmeal = src //What a typecast
					//Drop the leftover garbage when the food melts
					if(goodmeal.package_trash)
						new goodmeal.package_trash(src)
					if(goodmeal.trash)
						new goodmeal.trash(src)
			if(B.item_digest_logs)
				to_chat(B.owner,span_notice("[src] was digested inside your [lowertext(B.name)]."))
			qdel(src)
	if(g_damage > w_class)
		return w_class
	return g_damage

/////////////
// Some indigestible stuff
/////////////
/obj/item/hand_tele/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/aicard/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/paicard/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/gun/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/pinpointer/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/areaeditor/blueprints/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/disk/nuclear/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/perfect_tele_beacon/digest_act(var/atom/movable/item_storage = null)
	return FALSE //Sorta important to not digest your own beacons.
/obj/item/organ/internal/brain/slime/digest_act(var/atom/movable/item_storage = null)
	return FALSE //so prometheans can be recovered

/////////////
// Some special treatment
/////////////

/obj/item/card/id/digest_act(atom/movable/item_storage = null)
	desc = "A partially digested card that has seen better days. The damage appears to be only cosmetic."
	if(!sprite_stack || !istype(sprite_stack) || !(sprite_stack.len))
		icon = 'icons/obj/card_vr.dmi'
		icon_state = "[initial(icon_state)]_digested"
	else
		if(!sprite_stack.Find("digested"))
			sprite_stack += "digested"
	update_icon()
	return FALSE

/obj/item/holder/digest_act(atom/movable/item_storage = null)
	for(var/mob/living/M in contents)
		if(item_storage)
			M.forceMove(item_storage)
	held_mob = null

	. = ..()

/obj/item/organ/digest_act(atom/movable/item_storage = null)
	if((. = ..()))
		if(isbelly(item_storage))
			. *= 3
		else
			. += 30 //Organs give a little more

/obj/item/storage/digest_act(atom/movable/item_storage = null)
	for(var/obj/item/I in contents)
		I.screen_loc = null

	. = ..()

/obj/item/debris_pack/digested/digest_act(atom/movable/item_storage = null)
	if(isbelly(item_storage))
		var/obj/belly/B = item_storage
		if(istype(B) && B.recycling)
			return FALSE
	. = ..()

/obj/item/ore_chunk/digest_act(atom/movable/item_storage = null)
	if(isbelly(item_storage))
		var/obj/belly/B = item_storage
		if(istype(B) && B.recycling)
			return FALSE
	. = ..()

/obj/item/reagent_containers/food/rawnutrition/digest_act(atom/movable/item_storage = null)
	if(isbelly(item_storage))
		var/obj/belly/B = item_storage
		if(istype(B) && B.storing_nutrition)
			return FALSE
		else if(isliving(B.owner))
			B.owner.nutrition += stored_nutrition * (B.nutrition_percent / 100)
			stored_nutrition = 0
			qdel(src)
			return w_class
	. = ..()

/////////////
// Some more complicated stuff
/////////////
/obj/item/mmi/digital/posibrain/digest_act(atom/movable/item_storage = null)
	//Replace this with a VORE setting so all types of posibrains can/can't be digested on a whim
	return FALSE

//moved prot organ digest to their appropriate file

// Gradual damage measurement
/obj/item
	var/digest_stage = null
	var/d_mult_old = 1 //digest stage descriptions
	var/d_mult = 1 //digest stage descriptions
	var/d_stage_overlay //digest stage effects
