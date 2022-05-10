/obj/item/device/paicard/sleevecard
	name = "sleevecard"
	desc = "This KHI-upgraded pAI module has enough capacity to run a whole mind of human-level intelligence."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi,
						/datum/category_item/catalogue/technology/resleeving)

	//icon = 'icons/obj/pda.dmi'
	//icon_state = "pai"
	//item_state = "electronic"

	//w_class = ITEMSIZE_SMALL
	//slot_flags = SLOT_BELT
	origin_tech = list(TECH_DATA = 2)
	show_messages = 0
	var/mob/living/silicon/pai/infomorph/infomorph
	//var/obj/item/device/radio/sleevecard/radio
	//var/mob/living/silicon/infomorph/infomorph
	//var/current_emotion = 1

	matter = list(MAT_STEEL = 4000, MAT_GLASS = 4000)

/obj/item/device/paicard/attack_ghost(mob/user as mob)
	return

/obj/item/device/paicard/sleevecard/attackby(var/obj/item/device/sleevemate/I as obj, mob/user as mob)
	if(istype(I))
		if(I.stored_mind)
			var/datum/mind/M = I.stored_mind
			var/datum/transcore_db/db = SStranscore.db_by_mind_name(M.name)
			if(db)
				to_chat(user, span_notice("You begin uploading [M.name] into \the [src]."))
				if(do_after(user,8 SECONDS,src))
					var/datum/transhuman/mind_record/record = db.backed_up[M.name]
					to_chat(user, span_notice("You have successfully uploaded [M.name] into \the [src]"))
					sleeveInto(record)
					I.clear_mind()
			else
				to_chat(user, span_notice("Your sleevemate flashes an error, apparently this mind doesn't have a backup."))

/obj/item/device/paicard/sleevecard/proc/sleeveInto(var/datum/transhuman/mind_record/MR, var/db_key)
	infomorph = new(src,MR.mindname,db_key=db_key)

	for(var/datum/language/L in MR.languages)
		infomorph.add_language(L.name)
	MR.mind_ref.active = 1 //Well, it's about to be.
	MR.mind_ref.transfer_to(infomorph) //Does mind+ckey+client.
	infomorph.ooc_notes = MR.mind_oocnotes
	infomorph.apply_vore_prefs() //Cheap hack for now to give them SOME bellies.

	//Don't set 'real_name' because then we get a nice (as sleevecard) thing.
	infomorph.name = "[initial(infomorph.name)] ([MR.mindname])"
	name = "[initial(name)] ([MR.mindname])"
	//var/emoname = pai_emotions[1]
	//setEmotion(1)

	if(infomorph.client)
		pai = infomorph
		setEmotion(1)
		return 1

	return 0

/obj/item/device/paicard/sleevecard/setPersonality(mob/living/silicon/pai/infomorph/personality)
	src.infomorph = personality
	if(pai != infomorph)
		pai = infomorph
	add_overlay("pai-happy")
/*
//This is a 'hard' proc, it does no permission checking, do that on the computer
/obj/item/device/paicard/sleevecard/proc/sleeveInto(var/datum/transhuman/mind_record/MR, var/db_key)
	infomorph = new(src,MR.mindname,db_key=db_key)

	for(var/datum/language/L in MR.languages)
		infomorph.add_language(L.name)
	MR.mind_ref.active = 1 //Well, it's about to be.
	MR.mind_ref.transfer_to(pai) //Does mind+ckey+client.
	infomorph.ooc_notes = MR.mind_oocnotes
	infomorph.apply_vore_prefs() //Cheap hack for now to give them SOME bellies.

	//Don't set 'real_name' because then we get a nice (as sleevecard) thing.
	infomorph.name = "[initial(infomorph.name)] ([MR.mindname])"
	name = "[initial(name)] ([MR.mindname])"
	var/emoname = pai_emotions[1]
	setEmotion(pai_emotions[emoname])
	pai = infomorph
	if(infomorph.client)
		return 1

	return 0
*/
/obj/item/device/paicard/sleevecard/attack_self(mob/user)
	add_fingerprint(user)

	if(!pai)
		to_chat(user,"<span class='warning'>\The [src] does not have a mind in it!</span>")
	else
		to_chat(user,"<span class='notice'>\The [src] displays the name '[pai]'.</span>")

/mob/living/silicon/pai/infomorph
	name = "sleevecard" //Has the same name as the card for consistency, but this is the MOB in the card.
	icon = 'icons/mob/pai_vr.dmi' //Changed to the virgo icon, giving more sprite options.
	icon_state = "pai-repairbot"

	ram = 30

/mob/living/silicon/pai/infomorph/New(var/obj/item/device/paicard/sleevecard/SC, var/name = "Unknown", var/db_key)
	..()

	//ASSERT(SC)
	name = "[initial(name)] ([name])"
	//src.forceMove(SC)
	//card = SC
	//sradio = new(src)
	//translator = new(src)
	//communicator = new(src)
	//if(!card.radio)
	//	card.radio = new (card)
	//radio = card.radio

	//src.db_key = db_key

	//Default languages without universal translator software
	//add_language(LANGUAGE_EAL, 1)
	//add_language(LANGUAGE_SIGN, 0)
	/*
	verbs += /mob/living/silicon/infomorph/proc/choose_verbs
	verbs += /mob/living/proc/hide
	verbs += /mob/living/silicon/infomorph/proc/fold_out
	verbs += /mob/living/silicon/infomorph/proc/fold_in
	*/
	//software = default_infomorph_software.Copy()

	//PDA
	pda.ownjob = "Sleevecard"
	pda.owner = text("[]", src)
	pda.name = pda.owner + " (" + pda.ownjob + ")"

	var/datum/data/pda/app/messenger/M = pda.find_program(/datum/data/pda/app/messenger)
	if(M)
		M.toff = TRUE


/mob/living/silicon/pai/infomorph/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	// Software we have bought
	var/list/bought_software = list()
	// Software we have not bought
	var/list/not_bought_software = list()

	for(var/key in pai_software_by_key)
		var/datum/pai_software/S = pai_software_by_key[key]
		var/software_data[0]
		if(istype(S, /datum/pai_software/directives))
			continue
		software_data["name"] = S.name
		software_data["id"] = S.id
		if(key in software)
			software_data["on"] = S.is_active(src)
			bought_software.Add(list(software_data))
		else
			software_data["ram"] = S.ram_cost
			not_bought_software.Add(list(software_data))

	data["bought"] = bought_software
	data["not_bought"] = not_bought_software
	data["available_ram"] = ram

	// Emotions
	var/list/emotions = list()
	for(var/name in pai_emotions)
		var/list/emote = list()
		emote["name"] = name
		emote["id"] = pai_emotions[name]
		emotions.Add(list(emote))

	data["emotions"] = emotions
	data["current_emotion"] = card.current_emotion

	return data