/obj/item/weapon/folder
	name = "folder"
	desc = "A folder."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	w_class = ITEMSIZE_SMALL
	pressure_resistance = 2
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

<<<<<<< HEAD
/obj/item/weapon/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"

/obj/item/weapon/folder/red
	desc = "A red folder."
	icon_state = "folder_red"

/obj/item/weapon/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"

/obj/item/weapon/folder/white
	desc = "A white folder."
	icon_state = "folder_white"

/obj/item/weapon/folder/blue_captain
	desc = "A blue folder with Site Manager markings."
	icon_state = "folder_captain"

/obj/item/weapon/folder/blue_hop
	desc = "A blue folder with HoP markings."
	icon_state = "folder_hop"

/obj/item/weapon/folder/white_cmo
	desc = "A white folder with CMO markings."
	icon_state = "folder_cmo"

/obj/item/weapon/folder/white_rd
	desc = "A white folder with RD markings."
	icon_state = "folder_rd"

/obj/item/weapon/folder/white_rd/New()
	//add some memos
	var/obj/item/weapon/paper/P = new()
	P.name = "Memo RE: proper analysis procedure"
	P.info = "<br>We keep test dummies in pens here for a reason"
	src.contents += P
	update_icon()

/obj/item/weapon/folder/yellow_ce
	desc = "A yellow folder with CE markings."
	icon_state = "folder_ce"

/obj/item/weapon/folder/red_hos
	desc = "A red folder with HoS markings."
	icon_state = "folder_hos"
=======
	/// The items that spawn inside this folder, if anything.
	var/list/obj/item/initial_contents


/obj/item/folder/Initialize()
	. = ..()
	if (length(initial_contents))
		for (var/obj/item/item as anything in initial_contents)
			new item (src)
		update_icon()

>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope

/obj/item/weapon/folder/update_icon()
	cut_overlays()
	if (length(contents))
		add_overlay("folder_paper")

<<<<<<< HEAD
/obj/item/weapon/folder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/paper) || istype(W, /obj/item/weapon/photo) || istype(W, /obj/item/weapon/paper_bundle))
		user.drop_item()
		W.loc = src
		to_chat(user, "<span class='notice'>You put the [W] into \the [src].</span>")
		update_icon()
	else if(istype(W, /obj/item/weapon/pen))
		var/n_name = sanitizeSafe(tgui_input_text(usr, "What would you like to label the folder?", "Folder Labelling", null, MAX_NAME_LEN), MAX_NAME_LEN)
		if((loc == usr && usr.stat == 0))
			name = "folder[(n_name ? text("- '[n_name]'") : null)]"
	return

/obj/item/weapon/folder/attack_self(mob/user as mob)
	var/dat = "<title>[name]</title>"

	for(var/obj/item/weapon/paper/P in src)
=======

/obj/item/folder/attackby(obj/item/item, mob/living/user)
	. = TRUE
	if (istype(item, /obj/item/paper) || istype(item, /obj/item/photo) || istype(item, /obj/item/paper_bundle))
		if (!user.unEquip(item, target = src))
			return
		user.visible_message(
			SPAN_ITALIC("\The [user] puts \a [item] into \a [src]."),
			SPAN_ITALIC("You put \the [item] into \the [src]."),
			range = 5
		)
		update_icon()
		return
	if (istype(item, /obj/item/pen))
		var/response = input(user, "Set new folder label:") as null | text
		if (isnull(response))
			return
		if (BlockInteraction(user))
			return
		if (!response)
			name = initial(name)
			return
		response = sanitizeSafe(response, MAX_NAME_LEN)
		if (!response)
			return
		name = "folder - `[response]`"
	return ..()


/obj/item/folder/attack_self(mob/living/user)
	var/dat = "<title>[name]</title>"
	for(var/obj/item/paper/P in src)
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
		dat += "<A href='?src=\ref[src];remove=\ref[P]'>Remove</A> <A href='?src=\ref[src];rename=\ref[P]'>Rename</A> - <A href='?src=\ref[src];read=\ref[P]'>[P.name]</A><BR>"
	for(var/obj/item/weapon/photo/Ph in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Ph]'>Remove</A> <A href='?src=\ref[src];rename=\ref[Ph]'>Rename</A> - <A href='?src=\ref[src];look=\ref[Ph]'>[Ph.name]</A><BR>"
	for(var/obj/item/weapon/paper_bundle/Pb in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Pb]'>Remove</A> <A href='?src=\ref[src];rename=\ref[Pb]'>Rename</A> - <A href='?src=\ref[src];browse=\ref[Pb]'>[Pb.name]</A><BR>"
	user << browse(dat, "window=folder")
	onclose(user, "folder")
	add_fingerprint(usr)
	return

<<<<<<< HEAD
/obj/item/weapon/folder/Topic(href, href_list)
=======

/obj/item/folder/Topic(href, list/href_list)
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	..()
	if((usr.stat || usr.restrained()))
		return
	if(src.loc == usr)
		if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if(P && (P.loc == src) && istype(P))
				P.loc = usr.loc
				usr.put_in_hands(P)
		else if(href_list["read"])
			var/obj/item/weapon/paper/P = locate(href_list["read"])
			if(P && (P.loc == src) && istype(P))
				if(!(istype(usr, /mob/living/carbon/human) || istype(usr, /mob/observer/dead) || istype(usr, /mob/living/silicon)))
					usr << browse("<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[stars(P.info)][P.stamps]</BODY></HTML>", "window=[P.name]")
					onclose(usr, "[P.name]")
				else
					usr << browse("<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.info][P.stamps]</BODY></HTML>", "window=[P.name]")
					onclose(usr, "[P.name]")
		else if(href_list["look"])
			var/obj/item/weapon/photo/P = locate(href_list["look"])
			if(P && (P.loc == src) && istype(P))
				P.show(usr)
		else if(href_list["browse"])
			var/obj/item/weapon/paper_bundle/P = locate(href_list["browse"])
			if(P && (P.loc == src) && istype(P))
				P.attack_self(usr)
				onclose(usr, "[P.name]")
		else if(href_list["rename"])
<<<<<<< HEAD
			var/obj/item/weapon/O = locate(href_list["rename"])

=======
			var/obj/item/O = locate(href_list["rename"])
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
			if(O && (O.loc == src))
				if(istype(O, /obj/item/weapon/paper))
					var/obj/item/weapon/paper/to_rename = O
					to_rename.rename()
<<<<<<< HEAD

				else if(istype(O, /obj/item/weapon/photo))
					var/obj/item/weapon/photo/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/weapon/paper_bundle))
					var/obj/item/weapon/paper_bundle/to_rename = O
=======
				else if(istype(O, /obj/item/photo))
					var/obj/item/photo/to_rename = O
					to_rename.rename()
				else if(istype(O, /obj/item/paper_bundle))
					var/obj/item/paper_bundle/to_rename = O
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
					to_rename.rename()
		attack_self(usr)
		update_icon()


/obj/item/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"


/obj/item/folder/red
	desc = "A red folder."
	icon_state = "folder_red"


/obj/item/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"


/obj/item/folder/white
	desc = "A white folder."
	icon_state = "folder_white"


/obj/item/folder/blue_captain
	desc = "A blue folder with Site Manager markings."
	icon_state = "folder_captain"


/obj/item/folder/blue_hop
	desc = "A blue folder with HoP markings."
	icon_state = "folder_hop"


/obj/item/folder/white_cmo
	desc = "A white folder with CMO markings."
	icon_state = "folder_cmo"


/obj/item/folder/yellow_ce
	desc = "A yellow folder with CE markings."
	icon_state = "folder_ce"


/obj/item/folder/red_hos
	desc = "A red folder with HoS markings."
	icon_state = "folder_hos"


/obj/item/folder/white_rd
	desc = "A white folder with RD markings."
	icon_state = "folder_rd"
	initial_contents = list(
		/obj/item/paper/white_rd_folder
	)


/obj/item/paper/white_rd_folder
	name = "Memo RE: proper analysis procedure"
	info = {"\
		<p>We keep test dummies in pens here for a reason.</p>\
	"}


/obj/item/folder/envelope
	abstract_type = /obj/item/folder/envelope
	name = "envelope"
	desc = "A thick envelope for holding documents securely."
	icon_state = "envelope_envelope_seal"

	// When falsy, the envelope can be opened. Otherwise, the seal name to show in examine.
	var/envelope_seal = "original"


/obj/item/folder/envelope/update_icon()
	if (envelope_seal)
		icon_state = "envelope_sealed"
	else if (length(contents))
		icon_state = "envelope_full"
	else
		icon_state = "envelope_empty"


/obj/item/folder/envelope/examine(mob/user)
	. = ..()
	if (get_dist(src, user) > 3 && !isobserver(user))
		return
	if (envelope_seal)
		. += "It has an [SPAN_NOTICE("intact [envelope_seal] seal")]."
	else
		. += "The seal is [SPAN_DANGER("broken")]."


/obj/item/folder/envelope/attack_self(mob/living/user)
	if (envelope_seal)
		ConfirmBreakSeal(user)
		return
	..()


/obj/item/folder/envelope/attackby(obj/item/item, mob/living/user)
	. = TRUE
	if (envelope_seal)
		if (!is_sharp(item))
			return ..()
		if (user.a_intent == I_HURT)
			user.visible_message(
				SPAN_WARNING("\The [user] slashes open \a [src] with \a [item]!"),
				SPAN_ITALIC("You slash open \the [src] with \the [item]!"),
				range = 5
			)
			SetSeal(FALSE)
			return
		ConfirmBreakSeal(user)
		return
	else if (istype(item, /obj/item/stamp))
		ConfirmCreateSeal(item, user)
		return
	return ..()


/obj/item/folder/envelope/proc/ConfirmCreateSeal(obj/item/stamp/stamp, mob/living/user)
	PROTECTED_PROC(TRUE)
	if (!istype(user))
		return
	if (envelope_seal)
		to_chat(user, SPAN_WARNING("\The [src] already has \a [envelope_seal] seal."))
		return
	if (BlockInteraction(user))
		return
	var/response = alert(user, "Create a new [stamp.name] seal?", "[src]", "Yes", "No")
	if (response != "Yes")
		return
	if (BlockInteraction(user))
		return
	if (envelope_seal)
		to_chat(user, SPAN_WARNING("\The [src] already has \a [envelope_seal] seal."))
		return
	user.visible_message(
		SPAN_WARNING("\The [user] uses \a [stamp] to seal \a [src]."),
		SPAN_ITALIC("You form a new seal on \the [src] with \the [stamp]."),
		range = 5
	)
	SetSeal(stamp.authority_name)


/obj/item/folder/envelope/proc/ConfirmBreakSeal(mob/living/user)
	PROTECTED_PROC(TRUE)
	if (!istype(user))
		return
	if (!envelope_seal)
		to_chat(user, SPAN_WARNING("\The [src] is already open."))
		return
	if (BlockInteraction(user))
		return
	var/response = alert(user, "Break the seal?", "[src]", "Yes", "No")
	if (response != "Yes")
		return
	if (BlockInteraction(user))
		return
	if (!envelope_seal)
		to_chat(user, SPAN_WARNING("\The [src] is already open."))
		return
	user.visible_message(
		SPAN_WARNING("\The [user] breaks the seal on \a [src]."),
		SPAN_ITALIC("You break the seal on \the [src]."),
		range = 5
	)
	SetSeal(FALSE)


/// Sets the seal name or breaks it, updating the envelope's icon.
/obj/item/folder/envelope/proc/SetSeal(value)
	PROTECTED_PROC(TRUE)
	envelope_seal = value
	update_icon()


// Implement at map level. This is only an example.
/obj/item/folder/envelope/example
	name = "exemplary envelope"
	initial_contents = list(
		/obj/item/paper/envelope_example
	)


/obj/item/paper/envelope_example
	info = {"\
		<h1>Hello World</h1>\
		<p>I am a demonstration paper for an envelope.</p>\
		<p>Am I not <b>cool</b> and <i>neat</i>?</p>\
	"}
