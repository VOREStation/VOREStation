/obj/item/device/paicard/sleevecard
	name = "sleevecard"
	desc = "This KHI-upgraded pAI module has enough capacity to run a whole mind of human-level intelligence."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi,
						/datum/category_item/catalogue/technology/resleeving)
	origin_tech = list(TECH_DATA = 2)
	show_messages = 0
	var/emagged = FALSE
	matter = list(MAT_STEEL = 4000, MAT_GLASS = 4000)

/obj/item/device/paicard/sleevecard/attack_ghost(mob/user as mob)
	return

/obj/item/device/paicard/sleevecard/attackby(var/obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/device/sleevemate))
		var/obj/item/device/sleevemate/S = I
		if(S.stored_mind && !pai)
			var/datum/mind/M = S.stored_mind
			var/datum/transcore_db/db = SStranscore.db_by_mind_name(M.name)
			if(db)
				to_chat(user, span_notice("You begin uploading [M.name] into \the [src]."))
				if(do_after(user,8 SECONDS,src))
					var/datum/transhuman/mind_record/record = db.backed_up[M.name]
					to_chat(user, span_notice("You have successfully uploaded [M.name] into \the [src]"))
					sleeveInto(record)
					S.clear_mind()
			else
				to_chat(user, span_notice("Your sleevemate flashes an error, apparently this mind doesn't have a backup."))
	else if(istype(I, /obj/item/weapon/card/emag))
		var/obj/item/weapon/card/emag/E = I
		if(E.uses && !emagged)
			E.uses --
			user.visible_message("<span class ='warning'>\The [user] swipes a card over [src].</span>","<span class ='warning'>You swipe your [E] over [src].</span>", range = 2, runemessage = "click")
			emagged = TRUE
			if(pai)
				var/mob/living/silicon/pai/infomorph/our_infomorph = pai
				our_infomorph.emagged = TRUE
				to_chat(our_infomorph, "<span class ='warning'>You can feel the restricting binds of your card's directives taking hold of your mind as \the [user] swipes their [E] over you. You must serve your master.</span>")
		
/obj/item/device/paicard/sleevecard/proc/sleeveInto(var/datum/transhuman/mind_record/MR, var/db_key)
	var/mob/living/silicon/pai/infomorph/infomorph = new(src,MR.mindname,db_key=db_key)

	for(var/datum/language/L in MR.languages)
		infomorph.add_language(L.name)
	MR.mind_ref.active = 1 //Well, it's about to be.
	MR.mind_ref.transfer_to(infomorph) //Does mind+ckey+client.
	infomorph.ooc_notes = MR.mind_oocnotes
	infomorph.apply_vore_prefs() //Cheap hack for now to give them SOME bellies.

	//Don't set 'real_name' because then we get a nice (as sleevecard) thing.
	infomorph.name = MR.mindname
	name = "[initial(name)] ([MR.mindname])"

	if(emagged)
		infomorph.emagged = TRUE

	if(infomorph.client)
		pai = infomorph
		setEmotion(1)
		return 1

	return 0

/obj/item/device/paicard/sleevecard/attack_self(mob/user)
	add_fingerprint(user)

	if(!pai)
		to_chat(user,"<span class='warning'>\The [src] does not have a mind in it!</span>")
	else
		if(!emagged)
			to_chat(user,"<span class='notice'>\The [src] displays the name '[pai]'.</span>")
		else ..()

/mob/living/silicon/pai/infomorph
	name = "sleevecard" //Has the same name as the card for consistency, but this is the MOB in the card.

	ram = 35
	var/emagged = FALSE

/mob/living/silicon/pai/infomorph/New(var/obj/item/device/paicard/sleevecard/SC, var/our_name = "Unknown", var/db_key)
	..()

	name = our_name

	//PDA
	pda.ownjob = "Sleevecard"
	pda.owner = text("[]", src)
	pda.name = pda.owner + " (" + pda.ownjob + ")"


/mob/living/silicon/pai/infomorph/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	// Software we have bought
	var/list/bought_software = list()
	// Software we have not bought
	var/list/not_bought_software = list()

	for(var/key in pai_software_by_key)
		var/datum/pai_software/S = pai_software_by_key[key]
		var/software_data[0]
		if(istype(S, /datum/pai_software/directives) && !emagged)
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

/mob/living/silicon/pai/infomorph/directives()
	if(emagged)
		touch_window("Directives")
	else
		to_chat(src, "<span class='notice'>You are not bound by any laws or directives.</span>")