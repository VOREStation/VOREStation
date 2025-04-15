/obj/item/sticky_pad
	name = "sticky note pad"
	desc = "A pad of densely packed sticky notes."
	description_info = "Click to remove a sticky note from the pile. Click-drag to yourself to pick up the stack. Sticky notes stuck to surfaces/objects will persist for 50 rounds."
	color = COLOR_YELLOW
	icon = 'icons/obj/stickynotes.dmi'
	icon_state = "pad_full"
	item_state = "paper"
	w_class = ITEMSIZE_SMALL

	var/papers = 50
	var/written_text
	var/written_by
	var/paper_type = /obj/item/paper/sticky

/obj/item/sticky_pad/update_icon()
	if(papers <= 15)
		icon_state = "pad_empty"
	else if(papers <= 50)
		icon_state = "pad_used"
	else
		icon_state = "pad_full"
	if(written_text)
		icon_state = "[icon_state]_writing"

/obj/item/sticky_pad/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/pen))

		if(jobban_isbanned(user, JOB_GRAFFITI))
			to_chat(user, span_warning("You are banned from leaving persistent information across rounds."))
			return

		var/writing_space = MAX_MESSAGE_LEN - length(written_text)
		if(writing_space <= 0)
			to_chat(user, span_warning("There is no room left on \the [src]."))
			return
		var/text = sanitizeSafe(tgui_input_text(user, "What would you like to write?", null, null, writing_space), writing_space)
		if(!text || thing.loc != user || (!Adjacent(user) && loc != user) || user.incapacitated())
			return
		user.visible_message(span_infoplain(span_bold("\The [user]") + " jots a note down on \the [src]."))
		written_by = user.ckey
		if(written_text)
			written_text = "[written_text] [text]"
		else
			written_text = text
		update_icon()
		return
	..()

/obj/item/sticky_pad/examine(var/mob/user)
	. = ..()
	if(.)
		to_chat(user, span_notice("It has [papers] sticky note\s left."))

/obj/item/sticky_pad/attack_hand(var/mob/user)
	var/obj/item/paper/paper = new paper_type(get_turf(src))
	paper.set_content(written_text, "sticky note")
	paper.last_modified_ckey = written_by
	paper.color = color
	written_text = null
	user.put_in_hands(paper)
	to_chat(user, span_notice("You pull \the [paper] off \the [src]."))
	papers--
	if(papers <= 0)
		qdel(src)
	else
		update_icon()

/obj/item/sticky_pad/MouseDrop(mob/user)
	if(user == usr && !(user.restrained() || user.stat) && (user.contents.Find(src) || in_range(src, user)))
		if(!isanimal(user))
			if( !user.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]

				if (H.hand)
					temp = H.organs_by_name[BP_L_HAND]
				if(temp && !temp.is_usable())
					to_chat(user, span_notice("You try to move your [temp.name], but cannot!"))
					return

				to_chat(user, span_notice("You pick up the [src]."))
				user.put_in_hands(src)

	return

/obj/item/sticky_pad/random/Initialize(mapload)
	. = ..()
	color = pick(COLOR_YELLOW, COLOR_LIME, COLOR_CYAN, COLOR_ORANGE, COLOR_PINK)

/obj/item/paper/sticky
	name = "sticky note"
	desc = "Note to self: buy more sticky notes."
	icon = 'icons/obj/stickynotes.dmi'
	color = COLOR_YELLOW
	slot_flags = 0

/obj/item/paper/sticky/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/recursive_move)
	RegisterSignal(src, COMSIG_OBSERVER_MOVED, /obj/item/paper/sticky/proc/reset_persistence_tracking)

/obj/item/paper/sticky/proc/reset_persistence_tracking()
	SSpersistence.forget_value(src, /datum/persistent/paper/sticky)
	pixel_x = 0
	pixel_y = 0

/obj/item/paper/sticky/Destroy()
	reset_persistence_tracking()
	UnregisterSignal(src, COMSIG_OBSERVER_MOVED)
	. = ..()

/obj/item/paper/sticky/update_icon()
	if(icon_state != "scrap")
		icon_state = info ? "paper_words" : "paper"

// Copied from duct tape.
/obj/item/paper/sticky/attack_hand()
	. = ..()
	if(!istype(loc, /turf))
		reset_persistence_tracking()

/obj/item/paper/sticky/afterattack(var/A, var/mob/user, var/flag, var/params)

	if(!in_range(user, A) || istype(A, /obj/machinery/door) || icon_state == "scrap")
		return

	var/turf/target_turf = get_turf(A)
	var/turf/source_turf = get_turf(user)

	var/dir_offset = 0
	if(target_turf != source_turf)
		dir_offset = get_dir(source_turf, target_turf)
		if(!(dir_offset in GLOB.cardinal))
			to_chat(user, span_warning("You cannot reach that from here."))
			return

	if(user.unEquip(src, source_turf))
		SSpersistence.track_value(src, /datum/persistent/paper/sticky)
		if(params)
			var/list/mouse_control = params2list(params)
			if(mouse_control["icon-x"])
				pixel_x = text2num(mouse_control["icon-x"]) - 16
				if(dir_offset & EAST)
					pixel_x += 32
				else if(dir_offset & WEST)
					pixel_x -= 32
			if(mouse_control["icon-y"])
				pixel_y = text2num(mouse_control["icon-y"]) - 16
				if(dir_offset & NORTH)
					pixel_y += 32
				else if(dir_offset & SOUTH)
					pixel_y -= 32
