/mob/living/carbon/human/examine(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	// . = ..() //Note that we don't call parent. We build the list by ourselves.

	var/skip_gear = 0
	var/skip_body = 0

	if(alpha <= EFFECTIVE_INVIS)
		return src.loc.examine(user) // Returns messages as if they examined wherever the human was

	var/looks_synth = looksSynthetic()

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		if(wear_suit.flags_inv & HIDESUITSTORAGE)
			skip_gear |= EXAMINE_SKIPSUITSTORAGE

		if(wear_suit.flags_inv & HIDEJUMPSUIT)
			skip_body |= EXAMINE_SKIPARMS | EXAMINE_SKIPLEGS | EXAMINE_SKIPBODY | EXAMINE_SKIPGROIN
			skip_gear |= EXAMINE_SKIPJUMPSUIT | EXAMINE_SKIPTIE | EXAMINE_SKIPHOLSTER

		else if(wear_suit.flags_inv & HIDETIE)
			skip_gear |= EXAMINE_SKIPTIE | EXAMINE_SKIPHOLSTER

		else if(wear_suit.flags_inv & HIDEHOLSTER)
			skip_gear |= EXAMINE_SKIPHOLSTER

		if(wear_suit.flags_inv & HIDESHOES)
			skip_gear |= EXAMINE_SKIPSHOES
			skip_body |= EXAMINE_SKIPFEET

		if(wear_suit.flags_inv & HIDEGLOVES)
			skip_gear |= EXAMINE_SKIPGLOVES
			skip_body |= EXAMINE_SKIPHANDS

	if(w_uniform)
		if(w_uniform.body_parts_covered & LEGS)
			skip_body |= EXAMINE_SKIPLEGS
		if(w_uniform.body_parts_covered & ARMS)
			skip_body |= EXAMINE_SKIPARMS
		if(w_uniform.body_parts_covered & UPPER_TORSO)
			skip_body |= EXAMINE_SKIPBODY
		if(w_uniform.body_parts_covered & LOWER_TORSO)
			skip_body |= EXAMINE_SKIPGROIN

	if(gloves && (gloves.body_parts_covered & HANDS))
		skip_body |= EXAMINE_SKIPHANDS

	if(shoes && (shoes.body_parts_covered & FEET))
		skip_body |= EXAMINE_SKIPFEET

	if(head)
		if(head.flags_inv & HIDEMASK)
			skip_gear |= EXAMINE_SKIPMASK
		if(head.flags_inv & HIDEEYES)
			skip_gear |= EXAMINE_SKIPEYEWEAR
			skip_body |= EXAMINE_SKIPEYES
		if(head.flags_inv & HIDEEARS)
			skip_gear |= EXAMINE_SKIPEARS
		if(head.flags_inv & HIDEFACE)
			skip_body |= EXAMINE_SKIPFACE

	if(wear_mask && (wear_mask.flags_inv & HIDEFACE))
		skip_body |= EXAMINE_SKIPFACE

	//This is what hides what
	var/list/hidden = list(
		BP_GROIN = skip_body & EXAMINE_SKIPGROIN,
		BP_TORSO = skip_body & EXAMINE_SKIPBODY,
		BP_HEAD  = skip_body & EXAMINE_SKIPHEAD,
		BP_L_ARM = skip_body & EXAMINE_SKIPARMS,
		BP_R_ARM = skip_body & EXAMINE_SKIPARMS,
		BP_L_HAND= skip_body & EXAMINE_SKIPHANDS,
		BP_R_HAND= skip_body & EXAMINE_SKIPHANDS,
		BP_L_FOOT= skip_body & EXAMINE_SKIPFEET,
		BP_R_FOOT= skip_body & EXAMINE_SKIPFEET,
		BP_L_LEG = skip_body & EXAMINE_SKIPLEGS,
		BP_R_LEG = skip_body & EXAMINE_SKIPLEGS)


	var/gender_hidden = (skip_gear & EXAMINE_SKIPJUMPSUIT) && (skip_body & EXAMINE_SKIPFACE)
	var/gender_key = get_visible_gender(user, gender_hidden)
	var/datum/gender/T = GLOB.gender_datums[gender_key]
	if (!T)
		CRASH({"Null gender datum on examine: mob="[src]",hidden="[gender_hidden]",key="[gender_key]",bio="[gender]",id="[identifying_gender]""})

	var/name_ender = ""
	if(!((skip_gear & EXAMINE_SKIPJUMPSUIT) && (skip_body & EXAMINE_SKIPFACE)))
		//VOREStation Add Start
		if(custom_species)
			name_ender = ", a " + span_bold("[src.custom_species]")
		else if(looks_synth)
		//VOREStation Add End
			var/use_gender = "a synthetic"
			if(gender == MALE)
				use_gender = "an android"
			else if(gender == FEMALE)
				use_gender = "a gynoid"

			name_ender = ", " + span_bold(span_gray("[use_gender]!")) + "[species.get_additional_examine_text(src)]"

		else if(species.name != "Human")
			name_ender = ", " + span_bold("<font color='[species.get_flesh_colour(src)]'>\a [species.get_examine_name()]!</font>") + "[species.get_additional_examine_text(src)]"

	var/list/msg = list("This is [icon2html(src, user.client)] <EM>[src.name]</EM>[name_ender]")

	//uniform
	if(w_uniform && !(skip_gear & EXAMINE_SKIPJUMPSUIT) && w_uniform.show_examine)
		//Ties
		var/tie_msg
		if(istype(w_uniform,/obj/item/clothing/under) && !(skip_gear & EXAMINE_SKIPTIE))
			var/obj/item/clothing/under/U = w_uniform
			if(LAZYLEN(U.accessories))
				tie_msg += ". Attached to it is"
				var/list/accessory_descs = list()
				if(skip_gear & EXAMINE_SKIPHOLSTER)
					for(var/obj/item/clothing/accessory/A in U.accessories)
						if(A.show_examine && !istype(A, /obj/item/clothing/accessory/holster)) // If we're supposed to skip holsters, actually skip them
							accessory_descs += "\a [A]"
				else
					for(var/obj/item/clothing/accessory/A in U.accessories)
						if(A.concealed_holster == 0 && A.show_examine)
							accessory_descs += "<a href='byond://?src=\ref[src];lookitem_desc_only=\ref[A]'>\a [A]</a>"

				tie_msg += " [lowertext(english_list(accessory_descs))]."
		if(w_uniform.blood_DNA)
			msg += span_warning("[T.He] [T.is] wearing [icon2html(w_uniform,user.client)] [w_uniform.gender==PLURAL?"some":"a"] [(w_uniform.blood_color != "#030303") ? "blood" : "oil"]-stained <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[w_uniform]'>[w_uniform.name]</a>![tie_msg]")
		else
			msg += "[T.He] [T.is] wearing [icon2html(w_uniform,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[w_uniform]'>\a [w_uniform]</a>.[tie_msg]"

	//head
	if(head && !(skip_gear & EXAMINE_SKIPHELMET) && head.show_examine)
		if(head.blood_DNA)
			msg += span_warning("[T.He] [T.is] wearing [icon2html(head,user.client)] [head.gender==PLURAL?"some":"a"] [(head.blood_color != "#030303") ? "blood" : "oil"]-stained <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[head]'>[head.name]</a> on [T.his] head!")
		else
			msg += "[T.He] [T.is] wearing [icon2html(head,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[head]'>\a [head]</a> on [T.his] head."

	//suit/armour
	if(wear_suit)
		var/tie_msg
		if(istype(wear_suit,/obj/item/clothing/suit))
			var/obj/item/clothing/suit/U = wear_suit
			if(LAZYLEN(U.accessories))
				tie_msg += ". Attached to it is"
				var/list/accessory_descs = list()
				for(var/accessory in U.accessories)
					accessory_descs += "<a href='byond://?src=\ref[src];lookitem_desc_only=\ref[accessory]'>\a [accessory]</a>"
				tie_msg += " [lowertext(english_list(accessory_descs))]."

		if(wear_suit.blood_DNA)
			msg += span_warning("[T.He] [T.is] wearing [icon2html(wear_suit,user.client)] [wear_suit.gender==PLURAL?"some":"a"] [(wear_suit.blood_color != "#030303") ? "blood" : "oil"]-stained <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[wear_suit]'>[wear_suit.name]</a>![tie_msg]")
		else
			msg += "[T.He] [T.is] wearing [icon2html(wear_suit,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[wear_suit]'>\a [wear_suit]</a>.[tie_msg]"

		//suit/armour storage
		if(s_store && !(skip_gear & EXAMINE_SKIPSUITSTORAGE) && s_store.show_examine)
			if(s_store.blood_DNA)
				msg += span_warning("[T.He] [T.is] carrying [icon2html(s_store,user.client)] [s_store.gender==PLURAL?"some":"a"] [(s_store.blood_color != "#030303") ? "blood" : "oil"]-stained <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[s_store]'>[s_store.name]</a> on [T.his] [wear_suit.name]!")
			else
				msg += "[T.He] [T.is] carrying [icon2html(s_store,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[s_store]'>\a [s_store]</a> on [T.his] [wear_suit.name]."

	//back
	if(back && !(skip_gear & EXAMINE_SKIPBACKPACK) && back.show_examine)
		if(back.blood_DNA)
			msg += span_warning("[T.He] [T.has] [icon2html(back,user.client)] [back.gender==PLURAL?"some":"a"] [(back.blood_color != "#030303") ? "blood" : "oil"]-stained <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[back]'>[back]</a> on [T.his] back.")
		else
			msg += "[T.He] [T.has] [icon2html(back,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[back]'>\a [back]</a> on [T.his] back."

	//left hand
	if(l_hand && l_hand.show_examine)
		if(l_hand.blood_DNA)
			msg += span_warning("[T.He] [T.is] holding [icon2html(l_hand,user.client)] [l_hand.gender==PLURAL?"some":"a"] [(l_hand.blood_color != "#030303") ? "blood" : "oil"]-stained <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[l_hand]'>[l_hand.name]</a> in [T.his] left hand!")
		else
			msg += "[T.He] [T.is] holding [icon2html(l_hand,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[l_hand]'>\a [l_hand]</a> in [T.his] left hand."

	//right hand
	if(r_hand && r_hand.show_examine)
		if(r_hand.blood_DNA)
			msg += span_warning("[T.He] [T.is] holding [icon2html(r_hand,user.client)] [r_hand.gender==PLURAL?"some":"a"] [(r_hand.blood_color != "#030303") ? "blood" : "oil"]-stained <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[r_hand]'>[r_hand.name]</a> in [T.his] right hand!")
		else
			msg += "[T.He] [T.is] holding [icon2html(r_hand,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[r_hand]'>\a [r_hand]</a> in [T.his] right hand."

	//gloves
	if(gloves && !(skip_gear & EXAMINE_SKIPGLOVES) && gloves.show_examine)
		var/gloves_acc_msg
		if(istype(gloves,/obj/item/clothing/gloves))
			var/obj/item/clothing/gloves/G = gloves
			if(LAZYLEN(G.accessories))
				gloves_acc_msg += ". Attached to it is"
				var/list/accessory_descs = list()
				for(var/obj/item/clothing/accessory/A in G.accessories)
					accessory_descs += "<a href='byond://?src=\ref[src];lookitem_desc_only=\ref[A]'>\a [A]</a>"

				gloves_acc_msg += " [lowertext(english_list(accessory_descs))]."
		if(gloves.blood_DNA)
			msg += span_warning("[T.He] [T.has] [icon2html(gloves,user.client)] [gloves.gender==PLURAL?"some":"a"] [(gloves.blood_color != "#030303") ? "blood" : "oil"]-stained <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[gloves]'>[gloves.name]</a> on [T.his] hands![gloves_acc_msg]")
		else
			msg += "[T.He] [T.has] [icon2html(gloves,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[gloves]'>\a [gloves]</a> on [T.his] hands.[gloves_acc_msg]"

	else if(blood_DNA && !(skip_body & EXAMINE_SKIPHANDS))
		msg += span_warning("[T.He] [T.has] [(hand_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained hands!")

	//handcuffed?
	if(handcuffed && handcuffed.show_examine)
		if(istype(handcuffed, /obj/item/handcuffs/cable))
			msg += span_warning("[T.He] [T.is] [icon2html(handcuffed,user.client)] restrained with cable!")
		else
			msg += span_warning("[T.He] [T.is] [icon2html(handcuffed,user.client)] handcuffed!")

	//buckled
	if(buckled)
		msg += span_warning("[T.He] [T.is] [icon2html(buckled,user.client)] buckled to [buckled]!")

	//belt
	if(belt && !(skip_gear & EXAMINE_SKIPBELT) && belt.show_examine)
		if(belt.blood_DNA)
			msg += span_warning("[T.He] [T.has] [icon2html(belt,user.client)] [belt.gender==PLURAL?"some":"a"] [(belt.blood_color != "#030303") ? "blood" : "oil"]-stained <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[belt]'>[belt.name]</a> about [T.his] waist!")
		else
			msg += "[T.He] [T.has] [icon2html(belt,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[belt]'>\a [belt]</a> about [T.his] waist."

	//shoes
	if(shoes && !(skip_gear & EXAMINE_SKIPSHOES) && shoes.show_examine)
		if(shoes.blood_DNA)
			msg += span_warning("[T.He] [T.is] wearing [icon2html(shoes,user.client)] [shoes.gender==PLURAL?"some":"a"] [(shoes.blood_color != "#030303") ? "blood" : "oil"]-stained <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[shoes]'>[shoes.name]</a> on [T.his] feet!")
		else
			msg += "[T.He] [T.is] wearing [icon2html(shoes,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[shoes]'>\a [shoes]</a> on [T.his] feet."
	else if(feet_blood_DNA && !(skip_body & EXAMINE_SKIPHANDS))
		msg += span_warning("[T.He] [T.has] [(feet_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained feet!")

	//mask
	if(wear_mask && !(skip_gear & EXAMINE_SKIPMASK) && wear_mask.show_examine)
		var/descriptor = "on [T.his] face"
		if(istype(wear_mask, /obj/item/grenade) && check_has_mouth())
			descriptor = "in [T.his] mouth"

		if(wear_mask.blood_DNA)
			msg += span_warning("[T.He] [T.has] [icon2html(wear_mask,user.client)] [wear_mask.gender==PLURAL?"some":"a"] [(wear_mask.blood_color != "#030303") ? "blood" : "oil"]-stained <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[wear_mask]'>[wear_mask.name]</a> [descriptor]!")
		else
			msg += "[T.He] [T.has] [icon2html(wear_mask,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[wear_mask]'>\a [wear_mask]</a> [descriptor]."

	//eyes
	if(glasses && !(skip_gear & EXAMINE_SKIPEYEWEAR) && glasses.show_examine)
		if(glasses.blood_DNA)
			msg += span_warning("[T.He] [T.has] [icon2html(glasses,user.client)] [glasses.gender==PLURAL?"some":"a"] [(glasses.blood_color != "#030303") ? "blood" : "oil"]-stained <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[glasses]'>[glasses]</a> covering [T.his] eyes!")
		else
			msg += "[T.He] [T.has] [icon2html(glasses,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[glasses]'>\a [glasses]</a> covering [T.his] eyes."

	//left ear
	if(l_ear && !(skip_gear & EXAMINE_SKIPEARS) && l_ear.show_examine)
		msg += "[T.He] [T.has] [icon2html(l_ear,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[l_ear]'>\a [l_ear]</a> on [T.his] left ear."

	//right ear
	if(r_ear && !(skip_gear & EXAMINE_SKIPEARS) && r_ear.show_examine)
		msg += "[T.He] [T.has] [icon2html(r_ear,user.client)] <a href='byond://?src=\ref[src];lookitem_desc_only=\ref[r_ear]'>\a [r_ear]</a> on [T.his] right ear."

	//ID
	if(wear_id && wear_id.show_examine)
		msg += "[T.He] [T.is] wearing [icon2html(wear_id,user.client)]<a href='byond://?src=\ref[src];lookitem_desc_only=\ref[wear_id]'>\a [wear_id]</a>."

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += span_boldwarning("[T.He] [T.is] convulsing violently!")
		else if(jitteriness >= 200)
			msg += span_warning("[T.He] [T.is] extremely jittery.")
		else if(jitteriness >= 100)
			msg += span_warning("[T.He] [T.is] twitching ever so slightly.")

	//splints
	for(var/organ in BP_ALL)
		var/obj/item/organ/external/o = get_organ(organ)
		if(o && o.splinted && o.splinted.loc == o)
			msg += span_warning("[T.He] [T.has] \a [o.splinted] on [T.his] [o.name]!")

	if(suiciding)
		msg += span_warning("[T.He] appears to have commited suicide... there is no hope of recovery.")

	//VOREStation Add
	var/list/vorestrings = list()
	vorestrings += examine_weight()
	vorestrings += examine_nutrition()
	vorestrings += examine_reagent_bellies() // reagent bellies
	vorestrings += examine_bellies()
	vorestrings += examine_pickup_size()
	vorestrings += examine_step_size()
	vorestrings += examine_nif()
	vorestrings += examine_chimera()
	for(var/entry in vorestrings)
		if(entry == "" || entry == null)
			vorestrings -= entry
	msg += vorestrings
	//VOREStation Add End

	if(mSmallsize in mutations)
		msg += "[T.He] [T.is] very short!"

	if (src.stat)
		msg += span_warning("[T.He] [T.is]n't responding to anything around [T.him] and seems to be asleep.")
		if((stat == 2 || src.losebreath) && get_dist(user, src) <= 3)
			msg += span_warning("[T.He] [T.does] not appear to be breathing.")
		if(ishuman(user) && !user.stat && Adjacent(user))
			user.visible_message(span_infoplain(span_bold("[user]") + " checks [src]'s pulse."), span_infoplain("You check [src]'s pulse."))
		spawn(15)
			if(isobserver(user) || (Adjacent(user) && !user.stat)) // If you're a corpse then you can't exactly check their pulse, but ghosts can see anything
				if(pulse == PULSE_NONE)
					to_chat(user, span_deadsay("[T.He] [T.has] no pulse[src.client ? "" : " and [T.his] soul has departed"]..."))
				else
					to_chat(user, span_deadsay("[T.He] [T.has] a pulse!"))

	if(fire_stacks)
		msg += "[T.He] [T.is] covered in some liquid."
	if(on_fire)
		msg += span_warning("[T.He] [T.is] on fire!.")

	var/ssd_msg = species.get_ssd(src)
	if(ssd_msg && (!should_have_organ(O_BRAIN) || has_brain()) && stat != DEAD)
		if(!key)
			msg += span_deadsay("[T.He] [T.is] [ssd_msg]. It doesn't look like [T.he] [T.is] waking up anytime soon.")
		else if(!client)
			msg += span_deadsay("[T.He] [T.is] [ssd_msg].")
		//VOREStation Add Start
		if(client && away_from_keyboard && manual_afk)
			msg += "\[Away From Keyboard for [round((client.inactivity/10)/60)] minutes\]"
		else if(client && ((client.inactivity / 10) / 60 > 10)) //10 Minutes
			msg += "\[Inactive for [round((client.inactivity/10)/60)] minutes\]"
		else if(disconnect_time)
			msg += "\[Disconnected/ghosted [round(((world.realtime - disconnect_time)/10)/60)] minutes ago\]"
		//VOREStation Add End

	var/list/wound_flavor_text = list()
	var/list/is_bleeding = list()
	var/applying_pressure = ""

	for(var/organ_tag in species.has_limbs)

		var/list/organ_data = species.has_limbs[organ_tag]
		var/organ_descriptor = organ_data["descriptor"]

		var/obj/item/organ/external/E = organs_by_name[organ_tag]
		if(!E)
			wound_flavor_text["[organ_descriptor]"] = span_boldwarning("[T.He] [T.is] missing [T.his] [organ_descriptor].")
		else if(E.is_stump())
			wound_flavor_text["[organ_descriptor]"] = span_boldwarning("[T.He] [T.has] a stump where [T.his] [organ_descriptor] should be.")
		else
			continue

	for(var/obj/item/organ/external/temp in organs)
		if(temp)
			if((temp.organ_tag in hidden) && hidden[temp.organ_tag])
				continue //Organ is hidden, don't talk about it
			if(temp.status & ORGAN_DESTROYED)
				wound_flavor_text["[temp.name]"] = span_boldwarning("[T.He] [T.is] missing [T.his] [temp.name].")
				continue

			if(!looks_synth && temp.robotic == ORGAN_ROBOT)
				if(!(temp.brute_dam + temp.burn_dam))
					wound_flavor_text["[temp.name]"] = "[T.He] [T.has] a [temp.name]."
				else
					wound_flavor_text["[temp.name]"] = span_warning("[T.He] [T.has] a [temp.name] with [temp.get_wounds_desc()]!")
				continue
			else if(temp.wounds.len > 0 || temp.open)
				if(temp.is_stump() && temp.parent_organ && organs_by_name[temp.parent_organ])
					var/obj/item/organ/external/parent = organs_by_name[temp.parent_organ]
					wound_flavor_text["[temp.name]"] = span_warning("[T.He] [T.has] [temp.get_wounds_desc()] on [T.his] [parent.name].")
				else
					wound_flavor_text["[temp.name]"] = span_warning("[T.He] [T.has] [temp.get_wounds_desc()] on [T.his] [temp.name].")
			else
				wound_flavor_text["[temp.name]"] = ""
			if(temp.dislocated == 1) //VOREStation Edit Bugfix
				wound_flavor_text["[temp.name]"] += span_warning("[T.His] [temp.joint] is dislocated!")
			if(temp.brute_dam > temp.min_broken_damage || (temp.status & (ORGAN_BROKEN | ORGAN_MUTATED)))
				wound_flavor_text["[temp.name]"] += span_warning("[T.His] [temp.name] is dented and swollen!")

			if(temp.germ_level > INFECTION_LEVEL_TWO && !(temp.status & ORGAN_DEAD))
				wound_flavor_text["[temp.name]"] += span_warning("[T.His] [temp.name] looks very infected!")
			else if(temp.status & ORGAN_DEAD)
				wound_flavor_text["[temp.name]"] += span_warning("[T.His] [temp.name] looks rotten!")

			if(temp.status & ORGAN_BLEEDING)
				is_bleeding["[temp.name]"] += span_danger("[T.His] [temp.name] is bleeding!")

			if(temp.applied_pressure == src)
				applying_pressure = span_info("[T.He] is applying pressure to [T.his] [temp.name].")

	for(var/limb in wound_flavor_text)
		var/flavor = wound_flavor_text[limb]
		if(flavor)
			msg += flavor
	for(var/limb in is_bleeding)
		var/blood = is_bleeding[limb]
		if(blood)
			msg += blood
	for(var/implant in get_visible_implants(0))
		msg += span_danger("[src] [T.has] \a [implant] sticking out of [T.his] flesh!")
	if(digitalcamo)
		msg += "[T.He] [T.is] repulsively uncanny!"

	if(hasHUD(user,"security"))
		var/perpname = name
		var/criminal = "None"

		if(wear_id)
			if(istype(wear_id, /obj/item/card/id))
				var/obj/item/card/id/I = wear_id
				perpname = I.registered_name
			else if(istype(wear_id, /obj/item/pda))
				var/obj/item/pda/P = wear_id
				perpname = P.owner

		for (var/datum/data/record/R in GLOB.data_core.security)
			if(R.fields["name"] == perpname)
				criminal = R.fields["criminal"]

		msg += "Criminal status: <a href='byond://?src=\ref[src];criminal=1'>\[[criminal]\]</a>"
		msg += "Security records: <a href='byond://?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='byond://?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>"

	if(hasHUD(user,"medical"))
		var/perpname = name
		var/medical = "None"

		if(wear_id)
			if(istype(wear_id, /obj/item/card/id))
				var/obj/item/card/id/I = wear_id
				perpname = I.registered_name
			else if(istype(wear_id, /obj/item/pda))
				var/obj/item/pda/P = wear_id
				perpname = P.owner

		for (var/datum/data/record/R in GLOB.data_core.medical)
			if (R.fields["name"] == perpname)
				medical = R.fields["p_stat"]

		msg += "Physical status: <a href='byond://?src=\ref[src];medical=1'>\[[medical]\]</a>"
		msg += "Medical records: <a href='byond://?src=\ref[src];medrecord=`'>\[View\]</a> <a href='byond://?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>"

	if(hasHUD(user,"best"))
		msg += "Employment records: <a href='byond://?src=\ref[src];emprecord=`'>\[View\]</a> <a href='byond://?src=\ref[src];emprecordadd=`'>\[Add comment\]</a>"


	var/flavor_text = print_flavor_text()
	if(flavor_text)
		flavor_text = replacetext(flavor_text, "||", "")
		msg += "[flavor_text]"

	// VOREStation Start
	if(custom_link)
		msg += "Custom link: " + span_linkify("[custom_link]")

	if(ooc_notes)
		msg += "OOC Notes: <a href='byond://?src=\ref[src];ooc_notes=1'>\[View\]</a> - <a href='byond://?src=\ref[src];print_ooc_notes_chat=1'>\[Print\]</a>"
	msg += "<a href='byond://?src=\ref[src];vore_prefs=1'>\[Mechanical Vore Preferences\]</a>"
	// VOREStation End
	msg = list(span_info(jointext(msg, "<br>")))
	if(applying_pressure)
		msg += applying_pressure

	var/show_descs = show_descriptors_to(user)
	if(show_descs)
		msg += span_notice("[jointext(show_descs, "<br>")]")

	if(pose)
		if(!findtext(pose, regex("\[.?!]$"))) // Will be zero if the last character is not a member of [.?!]
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "<br>[T.He] [pose]" //<br> intentional, extra gap.

	return msg

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M as mob, hudtype)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(hasHUD_vr(H,hudtype)) return 1 //VOREStation Add - Added records access for certain modes of omni-hud glasses
		switch(hudtype)
			if("security")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(H.glasses, /obj/item/clothing/glasses/sunglasses/sechud)
			if("medical")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/health)
	else if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		return R.sensor_type //VOREStation Add - Borgo sensors are now binary so just have them on or off
