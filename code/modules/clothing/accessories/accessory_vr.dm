//
// Collars and such like that
//

/obj/item/clothing/accessory/choker //A colorable, tagless choker
	name = "plain choker"
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	desc = "A simple, plain choker. Or maybe it's a collar?"
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	icon_state = "choker_cst"
	item_state = "choker_cst"
	overlay_state = "choker_cst"
	var/customized = 0
	var/icon_previous_override
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/accessory/mob_vr_teshari.dmi'
		)

//Forces different sprite sheet on equip
/obj/item/clothing/accessory/choker/New()
	..()
	icon_previous_override = icon_override

/obj/item/clothing/accessory/choker/equipped() //Solution for race-specific sprites for an accessory which is also a suit. Suit icons break if you don't use icon override which then also overrides race-specific sprites.
	..()
	setUniqueSpeciesSprite()

/obj/item/clothing/accessory/choker/proc/setUniqueSpeciesSprite()
	var/mob/living/carbon/human/H = loc
	if(!istype(H) && istype(has_suit) && ishuman(has_suit.loc))
		H = has_suit.loc
	if(sprite_sheets && istype(H) && H.species.get_bodytype(H) && (H.species.get_bodytype(H) in sprite_sheets))
		icon_override = sprite_sheets[H.species.get_bodytype(H)]
		update_clothing_icon()

/obj/item/clothing/accessory/choker/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	setUniqueSpeciesSprite()
	..(S, user)

/obj/item/clothing/accessory/choker/dropped()
	icon_override = icon_previous_override

/obj/item/clothing/accessory/collar
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	icon_state = "collar_blk"
	var/writtenon = 0
	var/icon_previous_override
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/accessory/mob_vr_teshari.dmi'
	)

//Forces different sprite sheet on equip
/obj/item/clothing/accessory/collar/New()
	..()
	icon_previous_override = icon_override

/obj/item/clothing/accessory/collar/equipped() //Solution for race-specific sprites for an accessory which is also a suit. Suit icons break if you don't use icon override which then also overrides race-specific sprites.
	..()
	setUniqueSpeciesSprite()

/obj/item/clothing/accessory/collar/proc/setUniqueSpeciesSprite()
	var/mob/living/carbon/human/H = loc
	if(!istype(H) && istype(has_suit) && ishuman(has_suit.loc))
		H = has_suit.loc
	if(sprite_sheets && istype(H) && H.species.get_bodytype(H) && (H.species.get_bodytype(H) in sprite_sheets))
		icon_override = sprite_sheets[H.species.get_bodytype(H)]
		update_clothing_icon()

/obj/item/clothing/accessory/collar/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	setUniqueSpeciesSprite()
	..(S, user)

/obj/item/clothing/accessory/collar/dropped()
	icon_override = icon_previous_override

/obj/item/clothing/accessory/collar/silver
	name = "Silver tag collar"
	desc = "A collar for your little pets... or the big ones."
	icon_state = "collar_blk"
	item_state = "collar_blk"
	overlay_state = "collar_blk"

/obj/item/clothing/accessory/collar/gold
	name = "Golden tag collar"
	desc = "A collar for your little pets... or the big ones."
	icon_state = "collar_gld"
	item_state = "collar_gld"
	overlay_state = "collar_gld"

/obj/item/clothing/accessory/collar/bell
	name = "Bell collar"
	desc = "A collar with a tiny bell hanging from it, purrfect furr kitties."
	icon_state = "collar_bell"
	item_state = "collar_bell"
	overlay_state = "collar_bell"
	var/jingled = 0

/obj/item/clothing/accessory/collar/bell/verb/jinglebell()
	set name = "Jingle Bell"
	set category = "Object"
	set src in usr
	if(!isliving(usr)) return
	if(usr.stat) return

	if(!jingled)
		usr.audible_message("[usr] jingles the [src]'s bell.", runemessage = "jingle")
		playsound(src, 'sound/items/pickup/ring.ogg', 50, 1)
		jingled = 1
		addtimer(CALLBACK(src, PROC_REF(jingledreset)), 50)
	return

/obj/item/clothing/accessory/collar/bell/proc/jingledreset()
		jingled = 0

/obj/item/clothing/accessory/collar/shock
	name = "Shock collar"
	desc = "A collar used to ease hungry predators."
	icon_state = "collar_shk0"
	item_state = "collar_shk"
	overlay_state = "collar_shk"
	var/on = FALSE // 0 for off, 1 for on, starts off to encourage people to set non-default frequencies and codes.
	var/frequency = 1449
	var/code = 2
	var/datum/radio_frequency/radio_connection

/obj/item/clothing/accessory/collar/shock/Initialize()
	. = ..()
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT) // Makes it so you don't need to change the frequency off of default for it to work.

/obj/item/clothing/accessory/collar/shock/Destroy() //Clean up your toys when you're done.
	radio_controller.remove_object(src, frequency)
	radio_connection = null //Don't delete this, this is a shared object.
	return ..()

/obj/item/clothing/accessory/collar/shock/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/clothing/accessory/collar/shock/attack_self(mob/user as mob, flag1)
	if(!ishuman(user))
		return
	tgui_interact(user)

/obj/item/clothing/accessory/collar/shock/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShockCollar", name)
		ui.open()

/obj/item/clothing/accessory/collar/shock/tgui_static_data(mob/user)
	var/list/data = ..()

	data["freq_min"] = PUBLIC_LOW_FREQ
	data["freq_max"] = PUBLIC_HIGH_FREQ

	data["code_min"] = 0
	data["code_max"] = 100

	return data

/obj/item/clothing/accessory/collar/shock/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["on"] = on
	data["frequency"] = frequency
	data["code"] = code

	return data

/obj/item/clothing/accessory/collar/shock/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("freq")
			var/new_freq = sanitize_frequency(params["freq"])
			set_frequency(new_freq)
			. = TRUE
		if("code")
			code = CLAMP(text2num(params["code"]), 1, 100)
			. = TRUE
		if("power")
			on = !on
			icon_state = "collar_shk[on]"
			. = TRUE
		if("tag")
			var/sanitized = tgui_input_text(ui.user, "Tag text?", "Set Tag", "", MAX_NAME_LEN, encode = TRUE)
			if(isnull(sanitized))
				return

			if(!length(sanitized))
				to_chat(ui.user, span_notice("[src]'s tag set to blank."))
				name = initial(name)
				desc = initial(desc)
			else
				to_chat(ui.user, span_notice("[src]'s tag set to '[sanitized]'."))
				name = initial(name) + " ([sanitized])"
				desc = initial(desc) + " The tag says \"[sanitized]\"."
			. = TRUE

/obj/item/clothing/accessory/collar/shock/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption != code)
		return

	if(on)
		var/mob/M = null
		if(ismob(loc))
			M = loc
		if(ismob(loc.loc))
			M = loc.loc // This is about as terse as I can make my solution to the whole 'collar won't work when attached as accessory' thing.
		to_chat(M,span_danger("You feel a sharp shock!"))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, M)
		s.start()
		M.Weaken(10)

/obj/item/clothing/accessory/collar/spike
	name = "Spiked collar"
	desc = "A collar with spikes that look as sharp as your teeth."
	icon_state = "collar_spik"
	item_state = "collar_spik"
	overlay_state = "collar_spik"

/obj/item/clothing/accessory/collar/pink
	name = "Pink collar"
	desc = "This collar will make your pets look FA-BU-LOUS."
	icon_state = "collar_pnk"
	item_state = "collar_pnk"
	overlay_state = "collar_pnk"

/obj/item/clothing/accessory/collar/cowbell
	name = "cowbell collar"
	desc = "A collar for your little pets... or the big ones."
	icon_state = "collar_cowbell"
	item_state = "collar_cowbell_overlay"
	overlay_state = "collar_cowbell_overlay"

/obj/item/clothing/accessory/collar/collarplanet_earth
	name = "planet collar"
	desc = "A collar featuring a surprisingly detailed replica of a earth-like planet surrounded by a weak battery powered force shield. There is a button to turn it off."
	icon_state = "collarplanet_earth"
	item_state = "collarplanet_earth"
	overlay_state = "collarplanet_earth"


/obj/item/clothing/accessory/collar/holo
	name = "Holo-collar"
	desc = "An expensive holo-collar for the modern day pet."
	icon_state = "collar_holo"
	item_state = "collar_holo"
	overlay_state = "collar_holo"
	matter = list(MAT_STEEL = 50)

/obj/item/clothing/accessory/collar/holo/indigestible
	desc = "A special variety of the holo-collar that seems to be made of a very durable fabric that fits around the neck."
//Make indigestible
/obj/item/clothing/accessory/collar/holo/indigestible/digest_act(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/clothing/accessory/collar/attack_self(mob/user as mob)
	if(istype(src,/obj/item/clothing/accessory/collar/holo))
		to_chat(user,span_notice("[name]'s interface is projected onto your hand."))
	else
		if(writtenon)
			to_chat(user,span_notice("You need a pen or a screwdriver to edit the tag on this collar."))
			return
		to_chat(user,span_notice("You adjust the [name]'s tag."))

	var/str = copytext(reject_bad_text(tgui_input_text(user,"Tag text?","Set tag","",MAX_NAME_LEN)),1,MAX_NAME_LEN)

	if(!str || !length(str))
		to_chat(user,span_notice("[name]'s tag set to be blank."))
		name = initial(name)
		desc = initial(desc)
	else
		to_chat(user,span_notice("You set the [name]'s tag to '[str]'."))
		initialize_tag(str)

/obj/item/clothing/accessory/collar/proc/initialize_tag(var/tag)
		name = initial(name) + " ([tag])"
		desc = initial(desc) + " \"[tag]\" has been engraved on the tag."
		writtenon = 1

/obj/item/clothing/accessory/collar/holo/initialize_tag(var/tag)
		..()
		desc = initial(desc) + " The tag says \"[tag]\"."

/obj/item/clothing/accessory/collar/attackby(obj/item/I, mob/user)
	if(istype(src,/obj/item/clothing/accessory/collar/holo))
		return

	if(istype(I,/obj/item/tool/screwdriver))
		update_collartag(user, I, "scratched out", "scratch out", "engraved")
		return

	if(istype(I,/obj/item/pen))
		update_collartag(user, I, "crossed out", "cross out", "written")
		return

	to_chat(user,span_notice("You need a pen or a screwdriver to edit the tag on this collar."))

/obj/item/clothing/accessory/collar/proc/update_collartag(mob/user, obj/item/I, var/erasemethod, var/erasing, var/writemethod)
	if(!(istype(user.get_active_hand(),I)) || !(istype(user.get_inactive_hand(),src)) || (user.stat))
		return

	var/str = copytext(reject_bad_text(tgui_input_text(user,"Tag text?","Set tag","",MAX_NAME_LEN)),1,MAX_NAME_LEN)

	if(!str || !length(str))
		if(!writtenon)
			to_chat(user,span_notice("You don't write anything."))
		else
			to_chat(user,span_notice("You [erasing] the words with the [I]."))
			name = initial(name)
			desc = initial(desc) + " The tag has had the words [erasemethod]."
	else
		if(!writtenon)
			to_chat(user,span_notice("You write '[str]' on the tag with the [I]."))
			name = initial(name) + " ([str])"
			desc = initial(desc) + " \"[str]\" has been [writemethod] on the tag."
			writtenon = 1
		else
			to_chat(user,span_notice("You [erasing] the words on the tag with the [I], and write '[str]'."))
			name = initial(name) + " ([str])"
			desc = initial(desc) + " Something has been [erasemethod] on the tag, and it now has \"[str]\" [writemethod] on it."

//Size collar remote

/obj/item/clothing/accessory/collar/shock/bluespace
	name = "Bluespace collar"
	desc = "A collar that can manipulate the size of the wearer, and can be modified when unequiped."
	icon_state = "collar_size"
	item_state = "collar_size"
	overlay_state = "collar_size"
	var/original_size
	var/last_activated
	var/target_size = 1
	on = 1

/obj/item/clothing/accessory/collar/shock/bluespace/tgui_static_data(mob/user)
	var/list/data = ..()
	data["target_size_min"] = RESIZE_MINIMUM_DORMS
	data["target_size_max"] = RESIZE_MAXIMUM_DORMS
	return data

/obj/item/clothing/accessory/collar/shock/bluespace/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["target_size"] = target_size
	return data

/obj/item/clothing/accessory/collar/shock/bluespace/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("size")
			target_size = clamp((params["size"]/100), RESIZE_MINIMUM_DORMS, RESIZE_MAXIMUM_DORMS)
			to_chat(ui.user, span_notice("You set the size to [target_size * 100]%"))
			if(target_size < RESIZE_MINIMUM || target_size > RESIZE_MAXIMUM)
				to_chat(ui.user, span_notice("Note: Resizing limited to 25-200% automatically while outside dormatory areas.")) //hint that we clamp it in resize
			. = TRUE

/obj/item/clothing/accessory/collar/shock/bluespace/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption != code)
		return

	if(on)
		var/mob/M = null
		if(ismob(loc))
			M = loc
		if(ismob(loc.loc))
			M = loc.loc // This is about as terse as I can make my solution to the whole 'collar won't work when attached as accessory' thing.
		var/mob/living/carbon/human/H = M
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		if(!H.resizable)
			H.visible_message(span_warning("The space around [H] compresses for a moment but then nothing happens."),span_notice("The space around you distorts but nothing happens to you."))
			return
		if(H.size_multiplier != target_size)
			if(!(world.time - last_activated > 10 SECONDS))
				to_chat(M, span_warning("\The [src] flickers. It seems to be recharging."))
				return
			last_activated = world.time
			original_size = H.size_multiplier
			H.resize(target_size, ignore_prefs = FALSE)		//In case someone else tries to put it on you.
			H.visible_message(span_warning("The space around [H] distorts as they change size!"),span_notice("The space around you distorts as you change size!"))
			log_admin("Admin [key_name(M)]'s size was altered by a bluespace collar.")
			s.set_up(3, 1, M)
			s.start()
		else if(H.size_multiplier == target_size)
			if(original_size == null)
				H.visible_message(span_warning("The space around [H] twists and turns for a moment but then nothing happens."),span_notice("The space around you distorts but stay the same size."))
				return
			last_activated = world.time
			H.resize(original_size, ignore_prefs = FALSE)
			original_size = null
			H.visible_message(span_warning("The space around [H] distorts as they return to their original size!"),span_notice("The space around you distorts as you return to your original size!"))
			log_admin("Admin [key_name(M)]'s size was altered by a bluespace collar.")
			to_chat(M, span_warning("\The [src] flickers. It is now recharging and will be ready again in ten  seconds."))
			s.set_up(3, 1, M)
			s.start()
	return

/obj/item/clothing/accessory/collar/shock/bluespace/relaymove(var/mob/living/user,var/direction)
	return //For some reason equipping this item was triggering this proc, putting the wearer inside of the collars belly for some reason.

/obj/item/clothing/accessory/collar/shock/bluespace/attackby(var/obj/item/component, mob/user as mob)
	if (component.has_tool_quality(TOOL_WRENCH))
		to_chat(user, span_notice("You crack the bluespace crystal [src]."))
		var/turf/T = get_turf(src)
		new /obj/item/clothing/accessory/collar/shock/bluespace/malfunctioning(T)
		user.drop_from_inventory(src)
		qdel(src)
		return
	if (!istype(component,/obj/item/assembly/signaler))
		..()
		return
	to_chat(user, span_notice("You wire the signaler into the [src]."))
	user.drop_item()
	qdel(component)
	var/turf/T = get_turf(src)
	new /obj/item/clothing/accessory/collar/shock/bluespace/modified(T)
	user.drop_from_inventory(src)
	qdel(src)
	return

// modified bluespace collar where the size is controlled by the signaller.

/obj/item/clothing/accessory/collar/shock/bluespace/modified
	name = "Bluespace collar"
	desc = "A collar that can manipulate the size of the wearer, and can be modified when unequiped. It has a little reciever attached."
	icon_state = "collar_size_mod"
	item_state = "collar_size"
	overlay_state = "collar_size"
	target_size = 1
	on = 1

/obj/item/clothing/accessory/collar/shock/bluespace/modified/attackby(var/obj/item/component, mob/user as mob)
	if (component.has_tool_quality(TOOL_WRENCH))
		to_chat(user, span_notice("You crack the bluespace crystal [src], the attached signaler disconnects."))
		var/turf/T = get_turf(src)
		new /obj/item/clothing/accessory/collar/shock/bluespace/malfunctioning(T)
		user.drop_from_inventory(src)
		qdel(src)
		return
	if (!istype(component,/obj/item/assembly/signaler))
		..()
		return
	to_chat(user, span_notice("There is already a signaler wired to the [src]."))
	return

/obj/item/clothing/accessory/collar/shock/bluespace/modified/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["target_size"] = "code"
	return data

/obj/item/clothing/accessory/collar/shock/bluespace/modified/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(action == "size")
		return // no modifying size
	. = ..()

/obj/item/clothing/accessory/collar/shock/bluespace/modified/receive_signal(datum/signal/signal)
	if(!signal)
		return
	target_size = (signal.encryption * 2)/100
	if(on)
		var/mob/M = null
		if(ismob(loc))
			M = loc
		if(ismob(loc.loc))
			M = loc.loc // This is about as terse as I can make my solution to the whole 'collar won't work when attached as accessory' thing.
		var/mob/living/carbon/human/H = M
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		if(!H.resizable)
			H.visible_message(span_warning("The space around [H] compresses for a moment but then nothing happens."),span_notice("The space around you distorts but nothing happens to you."))
			return
		if (target_size < 0.26)
			H.visible_message(span_warning("The collar on [H] flickers, but fizzles out."),span_notice("Your collar flickers, but is not powerful enough to shrink you that small."))
			return
		if(H.size_multiplier != target_size)
			if(!(world.time - last_activated > 10 SECONDS))
				to_chat(M, span_warning("\The [src] flickers. It seems to be recharging."))
				return
			last_activated = world.time
			original_size = H.size_multiplier
			H.resize(target_size, ignore_prefs = FALSE)		//In case someone else tries to put it on you.
			H.visible_message(span_warning("The space around [H] distorts as they change size!"),span_notice("The space around you distorts as you change size!"))
			log_admin("Admin [key_name(M)]'s size was altered by a bluespace collar.")
			s.set_up(3, 1, M)
			s.start()
		else if(H.size_multiplier == target_size)
			if(original_size == null)
				H.visible_message(span_warning("The space around [H] twists and turns for a moment but then nothing happens."),span_notice("The space around you distorts but stay the same size."))
				return
			last_activated = world.time
			H.resize(original_size, ignore_prefs = FALSE)
			original_size = null
			H.visible_message(span_warning("The space around [H] distorts as they return to their original size!"),span_notice("The space around you distorts as you return to your original size!"))
			log_admin("Admin [key_name(M)]'s size was altered by a bluespace collar.")
			to_chat(M, span_warning("\The [src] flickers. It is now recharging and will be ready again in ten  seconds."))
			s.set_up(3, 1, M)
			s.start()
	return

//bluespace collar malfunctioning (random size)

/obj/item/clothing/accessory/collar/shock/bluespace/malfunctioning
	name = "Bluespace collar"
	desc = "A collar that can manipulate the size of the wearer, and can be modified when unequiped. It has a crack on the crystal."
	icon_state = "collar_size_malf"
	item_state = "collar_size"
	overlay_state = "collar_size"
	target_size = 1
	on = 1
	var/currently_shrinking = 0

/obj/item/clothing/accessory/collar/shock/bluespace/malfunctioning/attackby(var/obj/item/component, mob/user as mob)
	if (!istype(component,/obj/item/assembly/signaler))
		..()
		return
	to_chat(user, span_notice("The signaler doesn't respond to the connection attempt [src]."))
	return

/obj/item/clothing/accessory/collar/shock/bluespace/malfunctioning/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["target_size"] = "locked"
	return data

/obj/item/clothing/accessory/collar/shock/bluespace/malfunctioning/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(action == "size")
		return // no modifying size
	. = ..()

/obj/item/clothing/accessory/collar/shock/bluespace/malfunctioning/receive_signal(datum/signal/signal)
	if(!signal)
		return
	target_size =  (rand(25,200)) /100
	if(on)
		var/mob/M = null
		if(ismob(loc))
			M = loc
		if(ismob(loc.loc))
			M = loc.loc // This is about as terse as I can make my solution to the whole 'collar won't work when attached as accessory' thing.
		var/mob/living/carbon/human/H = M
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		if(!H.resizable)
			H.visible_message(span_warning("The space around [H] compresses for a moment but then nothing happens."),span_notice("The space around you distorts but nothing happens to you."))
			return
		if (target_size < 0.25)
			H.visible_message(span_warning("The collar on [H] flickers, but fizzles out."),span_notice("Your collar flickers, but is not powerful enough to shrink you that small."))
			return
		if(currently_shrinking == 0)
			if(!(world.time - last_activated > 10 SECONDS))
				to_chat(M, span_warning("\The [src] flickers. It seems to be recharging."))
				return
			last_activated = world.time
			original_size = H.size_multiplier
			currently_shrinking = 1
			H.resize(target_size, ignore_prefs = FALSE)		//In case someone else tries to put it on you.
			H.visible_message(span_warning("The space around [H] distorts as they change size!"),span_notice("The space around you distorts as you change size!"))
			log_admin("Admin [key_name(M)]'s size was altered by a bluespace collar.")
			s.set_up(3, 1, M)
			s.start()
		else if(currently_shrinking == 1)
			if(original_size == null)
				H.visible_message(span_warning("The space around [H] twists and turns for a moment but then nothing happens."),span_notice("The space around you distorts but stay the same size."))
				return
			last_activated = world.time
			H.resize(original_size, ignore_prefs = FALSE)
			original_size = null
			currently_shrinking = 0
			H.visible_message(span_warning("The space around [H] distorts as they return to their original size!"),span_notice("The space around you distorts as you return to your original size!"))
			log_admin("Admin [key_name(M)]'s size was altered by a bluespace collar.")
			to_chat(M, span_warning("\The [src] flickers. It is now recharging and will be ready again in ten  seconds."))
			s.set_up(3, 1, M)
			s.start()
	return

//Machete Holsters
/obj/item/clothing/accessory/holster/machete
	name = "machete sheath"
	desc = "A handsome synthetic leather sheath with matching belt."
	icon_state = "holster_machete"
	slot = ACCESSORY_SLOT_WEAPON
	concealed_holster = 0
	can_hold = list(/obj/item/material/knife/machete, /obj/item/kinetic_crusher/machete)
	//sound_in = 'sound/effects/holster/sheathin.ogg'
	//sound_out = 'sound/effects/holster/sheathout.ogg'

//Medals

/obj/item/clothing/accessory/medal/silver/unity
	name = "medal of unity"
	desc = "A silver medal awarded to a group which has demonstrated exceptional teamwork to achieve a notable feat."

/obj/item/clothing/accessory/medal/silver/unity/tabiranth
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	icon_state = "silverthree"
	item_state = "silverthree"
	overlay_state = "silverthree"
	desc = "A silver medal awarded to a group which has demonstrated exceptional teamwork to achieve a notable feat. This one has three bronze service stars, denoting that it has been awarded four times."

/obj/item/clothing/accessory/talon
	name = "Talon pin"
	desc = "A collectable enamel pin that resembles ITV Talon's ship logo."
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	icon_state = "talon_pin"
	item_state = "talonpin"
	overlay_state = "talonpin"

//Casino Sentient Prize Collar

/obj/item/clothing/accessory/collar/casinosentientprize
	name = "disabled Sentient Prize Collar"
	desc = "A collar worn by sentient prizes registered to a SPASM. Although the red text on it shows its disconnected and nonfunctional."

	icon_state = "casinoslave"
	item_state = "casinoslave"
	overlay_state = "casinoslave"

	var/sentientprizename = null	//Name for system to put on collar description
	var/ownername = null	//Name for system to put on collar description
	var/sentientprizeckey = null	//Ckey for system to check who is the person and ensure no abuse of system or errors
	var/sentientprizeflavor = null	//Description to show on the SPASM
	var/sentientprizeooc = null		//OOC text to show on the SPASM

/obj/item/clothing/accessory/collar/casinosentientprize/attack_self(mob/user as mob)
	//keeping it blank so people don't tag and reset collar status

/obj/item/clothing/accessory/collar/casinosentientprize_fake
	name = "Sentient Prize Collar"
	desc = "A collar worn by sentient prizes registered to a SPASM. This one has been disconnected from the system and is now an accessory!"

	icon_state = "casinoslave_owned"
	item_state = "casinoslave_owned"
	overlay_state = "casinoslave_owned"

//The gold trim from one of the qipaos, separated to an accessory to preserve the color
/obj/item/clothing/accessory/qipaogold
	name = "gold trim"
	desc = "Gold trim belonging to a qipao. Why would you remove this?"
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	icon_state = "qipaogold"
	item_state = "qipaogold"
	overlay_state = "qipaogold"

//Antediluvian accessory set
/obj/item/clothing/accessory/antediluvian
	name = "antediluvian bracers"
	desc = "A pair of metal bracers with gold inlay. They're thin and light."
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	icon_state = "antediluvian"
	item_state = "antediluvian"
	overlay_state = "antediluvian"
	body_parts_covered = ARMS

/obj/item/clothing/accessory/antediluvian/loincloth
	name = "antediluvian loincloth"
	desc = "A lengthy loincloth that drapes over the loins, obviously. It's quite long."
	icon_state = "antediluvian_loin"
	item_state = "antediluvian_loin"
	overlay_state = "antediluvian_loin"
	body_parts_covered = LOWER_TORSO

//The cloaks below belong to this _vr file but their sprites are contained in non-_vr icon files due to
//the way the poncho/cloak equipped() proc works. Sorry for the inconvenience
/obj/item/clothing/accessory/poncho/roles/cloak/antediluvian
	name = "antediluvian cloak"
	desc = "A regal looking cloak of white with specks of gold woven into the fabric."
	icon_state = "antediluvian_cloak"
	item_state = "antediluvian_cloak"

//Other clothes that I'm too lazy to port to Polaris
/obj/item/clothing/accessory/poncho/roles/cloak/chapel
	name = "bishop's cloak"
	desc = "An elaborate white and gold cloak."
	icon_state = "bishopcloak"
	item_state = "bishopcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/chapel/alt
	name = "antibishop's cloak"
	desc = "An elaborate black and gold cloak. It looks just a little bit evil."
	icon_state = "blackbishopcloak"
	item_state = "blackbishopcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/half
	name = "rough half cloak"
	desc = "The latest fashion innovations by the Nanotrasen Uniform & Fashion Department have provided the brilliant invention of slicing a regular cloak in half! All the ponce, half the cost!"
	icon_state = "roughcloak"
	item_state = "roughcloak"
	actions_types = list(/datum/action/item_action/adjust_cloak)

/obj/item/clothing/accessory/poncho/roles/cloak/half/update_clothing_icon()
	. = ..()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()

/obj/item/clothing/accessory/poncho/roles/cloak/half/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]_open"
		src.item_state = "[item_state]_open"
		flags_inv = HIDETIE|HIDEHOLSTER
		to_chat(user, "You flip the cloak over your shoulder.")
	else
		src.icon_state = initial(icon_state)
		src.item_state = initial(item_state)
		flags_inv = HIDEHOLSTER
		to_chat(user, "You pull the cloak over your shoulder.")
	update_clothing_icon()

/obj/item/clothing/accessory/poncho/roles/cloak/shoulder
	name = "shoulder cloak"
	desc = "A small cape that primarily covers the left shoulder. Might help you stand out more, not necessarily for the right reasons."
	icon_state = "cape_left"
	item_state = "cape_left"

/obj/item/clothing/accessory/poncho/roles/cloak/shoulder/right
	desc = "A small cape that primarily covers the right shoulder. It might look a tad cooler if it was longer."
	icon_state = "cape_right"
	item_state = "cape_right"

//Mantles
/obj/item/clothing/accessory/poncho/roles/cloak/mantle
	name = "shoulder mantle"
	desc = "Not a cloak and not really a cape either, but a silky fabric that rests on the neck and shoulders alone."
	icon_state = "mantle"
	item_state = "mantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/cargo
	name = "cargo mantle"
	desc = "A shoulder mantle bearing the colors of the Supply department, with a gold lapel emblazoned upon the front."
	icon_state = "qmmantle"
	item_state = "qmmantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/security
	name = "security mantle"
	desc = "A shoulder mantle bearing the colors of the Security department, featuring rugged molding around the collar."
	icon_state = "hosmantle"
	item_state = "hosmantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/engineering
	name = "engineering mantle"
	desc = "A shoulder mantle bearing the colors of the Engineering department, accenting the pristine white fabric."
	icon_state = "cemantle"
	item_state = "cemantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/research
	name = "research mantle"
	desc = "A shoulder mantle bearing the colors of the Research department, the material slick and hydrophobic."
	icon_state = "rdmantle"
	item_state = "rdmantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/medical
	name = "medical mantle"
	desc = "A shoulder mantle bearing the general colors of the Medical department, dyed a sterile nitrile cyan."
	icon_state = "cmomantle"
	item_state = "cmomantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/hop
	name = "head of personnel mantle"
	desc = "A shoulder mantle bearing the colors of the " + JOB_HEAD_OF_PERSONNEL + "'s uniform, featuring the typical royal blue contrasted by authoritative red."
	icon_state = "hopmantle"
	item_state = "hopmantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/cap
	name = "site manager mantle"
	desc = "A shoulder mantle bearing the colors usually found on a " + JOB_SITE_MANAGER + ", a commanding blue with regal gold inlay."
	icon_state = "capmantle"
	item_state = "capmantle"

//Boat cloaks
/obj/item/clothing/accessory/poncho/roles/cloak/boat
	name = "boat cloak"
	desc = "A cloak that might've been worn on boats once or twice. It's just a flappy cape otherwise."
	icon_state = "boatcloak"
	item_state = "boatcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/boat/cap
	name = "site manager boat cloak"
	icon_state = "capboatcloak"
	item_state = "capboatcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/boat/hop
	name = "head of personnel boat cloak"
	icon_state = "hopboatcloak"
	item_state = "hopboatcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/boat/security
	name = "security boat cloak"
	icon_state = "secboatcloak"
	item_state = "secboatcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/boat/engineering
	name = "engineering boat cloak"
	icon_state = "engboatcloak"
	item_state = "engboatcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/boat/atmos
	name = "atmospherics boat cloak"
	icon_state = "atmosboatcloak"
	item_state = "atmosboatcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/boat/medical
	name = "medical boat cloak"
	icon_state = "medboatcloak"
	item_state = "medboatcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/boat/service
	name = "service boat cloak"
	icon_state = "botboatcloak"
	item_state = "botboatcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/boat/cargo
	name = "cargo boat cloak"
	icon_state = "supboatcloak"
	item_state = "supboatcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/boat/mining
	name = "mining boat cloak"
	icon_state = "minboatcloak"
	item_state = "minboatcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/boat/science
	name = "research boat cloak"
	icon_state = "sciboatcloak"
	item_state = "sciboatcloak"

//Shrouds
/obj/item/clothing/accessory/poncho/roles/cloak/shroud
	name = "shroud cape"
	desc = "A sharp looking cape that covers more of one side than the other. Just a bit edgy."
	icon_state = "shroud"
	item_state = "shroud"

/obj/item/clothing/accessory/poncho/roles/cloak/shroud/cap
	name = "site manager shroud"
	icon_state = "capshroud"
	item_state = "capshroud"

/obj/item/clothing/accessory/poncho/roles/cloak/shroud/hop
	name = "head of personnel shroud"
	icon_state = "hopshroud"
	item_state = "hopshroud"

/obj/item/clothing/accessory/poncho/roles/cloak/shroud/security
	name = "security shroud"
	icon_state = "secshroud"
	item_state = "secshroud"

/obj/item/clothing/accessory/poncho/roles/cloak/shroud/engineering
	name = "engineering shroud"
	icon_state = "engshroud"
	item_state = "engshroud"

/obj/item/clothing/accessory/poncho/roles/cloak/shroud/atmos
	name = "atmospherics shroud"
	icon_state = "atmosshroud"
	item_state = "atmosshroud"

/obj/item/clothing/accessory/poncho/roles/cloak/shroud/medical
	name = "medical shroud"
	icon_state = "medshroud"
	item_state = "medshroud"

/obj/item/clothing/accessory/poncho/roles/cloak/shroud/service
	name = "service shroud"
	icon_state = "botshroud"
	item_state = "botshroud"

/obj/item/clothing/accessory/poncho/roles/cloak/shroud/cargo
	name = "cargo shroud"
	icon_state = "supshroud"
	item_state = "supshroud"

/obj/item/clothing/accessory/poncho/roles/cloak/shroud/mining
	name = "mining shroud"
	icon_state = "minshroud"
	item_state = "minshroud"

/obj/item/clothing/accessory/poncho/roles/cloak/shroud/science
	name = "research shroud"
	icon_state = "scishroud"
	item_state = "scishroud"

//Crop Jackets
/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket
	name = "white crop jacket"
	desc = "A cut down jacket that looks like it's light enough to wear on top of some other clothes. This one's in plain white, more or less."
	icon_state = "cropjacket_white"
	item_state = "cropjacket_white"

/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/blue
	name = "blue crop jacket"
	desc = "A cut down jacket that looks like it's light enough to wear on top of some other clothes. Let everyone know who's in control of the situation around here."
	icon_state = "cropjacket_blue"
	item_state = "cropjacket_blue"

/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/red
	name = "red crop jacket"
	desc = "A cut down jacket that looks like it's light enough to wear on top of some other clothes. You could probably hide a holster under this without too much trouble."
	icon_state = "cropjacket_red"
	item_state = "cropjacket_red"

/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/green
	name = "green crop jacket"
	desc = "A cut down jacket that looks like it's light enough to wear on top of some other clothes. The faded green tones bring to mind the smell of antiseptics."
	icon_state = "cropjacket_green"
	item_state = "cropjacket_green"

/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/purple
	name = "purple crop jacket"
	desc = "A cut down jacket that looks like it's light enough to wear on top of some other clothes. This doesn't seem like very practical labwear."
	icon_state = "cropjacket_purple"
	item_state = "cropjacket_purple"

/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/orange
	name = "orange crop jacket"
	desc = "A cut down jacket that looks like it's light enough to wear on top of some other clothes. Perfect for keeping cool whilst showing off your gains from shifting crates."
	icon_state = "cropjacket_orange"
	item_state = "cropjacket_orange"

/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/charcoal
	name = "charcoal crop jacket"
	desc = "A cut down jacket that looks like it's light enough to wear on top of some other clothes. Dark and slightly edgy, just like its wearer."
	icon_state = "cropjacket_charcoal"
	item_state = "cropjacket_charcoal"

/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/marine
	name = "faded reflec crop jacket"
	desc = "A cut down jacket that looks like it's light enough to wear on top of some other clothes. Seems to be made of a semi-reflective material, like an EMT's jacket."
	icon_state = "cropjacket_marine"
	item_state = "cropjacket_marine"

/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/drab
	name = "drab crop jacket"
	desc = "A cut down jacket that looks like it's light enough to wear on top of some other clothes. This one's a sort of olive-drab kind of colour."
	icon_state = "cropjacket_drab"
	item_state = "cropjacket_drab"

//Replikant patch & jacket

/obj/item/clothing/accessory/sleekpatch
	name = "sleek uniform patch"
	desc = "A somewhat old-fashioned embroidered patch of Nanotrasen's logo."
	icon_state = "sleekpatch"
	item_state = "sleekpatch"

/obj/item/clothing/accessory/poncho/roles/cloak/custom/gestaltjacket
	name = "sleek uniform jacket"
	desc = "Barely more than a pair of long stirrup sleeves joined by a turtleneck. Has decorative red accents."
	icon_state = "gestaltjacket"
	item_state = "gestaltjacket"

//Neo Ranger Poncho

/obj/item/clothing/accessory/poncho/roles/neo_ranger
	name = "ranger poncho"
	desc = "Aim for the Heart, Ramon."
	icon_state = "neo_ranger"
	item_state = "neo_ranger"
	actions_types = list(/datum/action/item_action/adjust_poncho)

/obj/item/clothing/accessory/poncho/roles/neo_ranger/update_clothing_icon()
	. = ..()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()

/obj/item/clothing/accessory/poncho/roles/neo_ranger/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]_open"
		src.item_state = "[item_state]_open"
		flags_inv = HIDETIE|HIDEHOLSTER
		to_chat(user, "You adjust your poncho.")
	else
		src.icon_state = initial(icon_state)
		src.item_state = initial(item_state)
		flags_inv = HIDEHOLSTER
		to_chat(user, "You adjust your poncho.")
	update_clothing_icon()

/obj/item/clothing/accessory/belt
	name = "Thin Belt"
	desc = "A thin belt for holding your pants up."
	icon = 'icons/inventory/accessory/item.dmi'
	icon_override = 'icons/inventory/accessory/mob.dmi'
	icon_state = "belt_thin"
	item_state = "belt_thin"
	slot_flags = SLOT_TIE | SLOT_BELT
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/belt/thick
	name = "Thick Belt"
	desc = "A thick belt for holding your pants up."
	icon_state = "belt_thick"
	item_state = "belt_thick"

/obj/item/clothing/accessory/belt/strap
	name = "Strap Belt"
	desc = "A belt with no bucklet for holding your pants up."
	icon_state = "belt_strap"
	item_state = "belt_strap"

/obj/item/clothing/accessory/belt/studded
	name = "Studded Belt"
	desc = "A studded belt for holding your pants up and looking cool."
	icon_state = "belt_studded"
	item_state = "belt_studded"

/obj/item/clothing/accessory/bunny_tail
	name = "Bunny Tail"
	desc = "A little fluffy bunny tail to spice up your outfit."
	icon = 'icons/inventory/accessory/item.dmi'
	icon_override = 'icons/inventory/accessory/mob.dmi'
	icon_state = "bunny_tail"
	item_state = "bunny_tail"
	slot_flags = SLOT_TIE | SLOT_BELT
	slot = ACCESSORY_SLOT_DECOR
