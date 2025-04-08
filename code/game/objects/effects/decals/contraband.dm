/*
//########################## CONTRABAND ;3333333333333333333 -Agouri ###################################################

/obj/item/contraband
	name = "contraband item"
	desc = "You probably shouldn't be holding this."
	icon = 'icons/obj/contraband_vr.dmi' //VOREStation Edit
	force = 0


/obj/item/contraband/poster
	name = "rolled-up poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	icon_state = "rolled_poster"
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'
	var/serial_number = null

	var/poster_type = /obj/structure/sign/poster

/obj/item/contraband/poster/Initialize(mapload, var/given_serial = 0)
	if(!serial_number)
		if(given_serial == 0)
			serial_number = rand(1, poster_designs.len)
		else
			serial_number = given_serial
	name += " - No. [serial_number]"
	. = ..()

//Places the poster on a wall
/obj/item/contraband/poster/afterattack(var/atom/A, var/mob/user, var/adjacent, var/clickparams)
	if (!adjacent)
		return

	//must place on a wall and user must not be inside a closet/mecha/whatever
	var/turf/W = A
	if (!iswall(W) || !isturf(user.loc))
		to_chat(user, span_warning("You can't place this here!"))
		return

	var/placement_dir = get_dir(user, W)
	if (!(placement_dir in cardinal))
		to_chat(user, span_warning("You must stand directly in front of the wall you wish to place that on."))
		return

	//just check if there is a poster on or adjacent to the wall
	var/stuff_on_wall = 0
	if (locate(/obj/structure/sign/poster) in W)
		stuff_on_wall = 1

	//crude, but will cover most cases. We could do stuff like check pixel_x/y but it's not really worth it.
	for (var/dir in cardinal)
		var/turf/T = get_step(W, dir)
		if (locate(/obj/structure/sign/poster) in T)
			stuff_on_wall = 1
			break

	if (stuff_on_wall)
		to_chat(user, span_notice("There is already a poster there!"))
		return

	to_chat(user, span_notice("You start placing the poster on the wall...")) //Looks like it's uncluttered enough. Place the poster.

	var/obj/structure/sign/poster/P = new poster_type(user.loc, placement_dir=get_dir(user, W), serial=serial_number, itemtype = src.type)

	flick("poster_being_set", P)
	//playsound(W, 'sound/items/poster_being_created.ogg', 100, 1) //why the hell does placing a poster make printer sounds?

	var/oldsrc = src //get a reference to src so we can delete it after detaching ourselves
	src = null
	spawn(17)
		if(!P) return

		if(iswall(W) && user && P.loc == user.loc) //Let's check if everything is still there
			to_chat(user, span_notice("You place the poster!"))
		else
			P.roll_and_drop(P.loc)

	qdel(oldsrc)	//delete it now to cut down on sanity checks afterwards. Agouri's code supports rerolling it anyway

//NT subtype
/obj/item/contraband/poster/nanotrasen
	icon_state = "rolled_poster_nt"
	poster_type = /obj/structure/sign/poster/nanotrasen

/obj/item/contraband/poster/nanotrasen/Initialize(mapload, var/given_serial = 0)
	if(given_serial == 0)
		serial_number = rand(1, NT_poster_designs.len)
	else
		serial_number = given_serial
	. = ..()

//Selectable subtype
/obj/item/contraband/poster/custom
	name = "rolled-up poly-poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface. This one is made from some kind of e-paper, and could display almost anything!"
	poster_type = /obj/structure/sign/poster/custom

/obj/item/contraband/poster/custom/Initialize(mapload, var/given_serial = 0)
	if(given_serial == 0)
		serial_number = 1 //Decidedly unrandom
	else
		serial_number = given_serial
	. = ..()

/obj/item/contraband/poster/custom/verb/select_poster()
	set name = "Set Poster type"
	set category = "Object"
	set desc = "Click to choose a poster to display."

	var/mob/M = usr
	var/list/options = list()
	for(var/datum/poster/posteroption in poster_designs)
		options[posteroption.listing_name] = posteroption

	var/choice = tgui_input_list(M, "Choose a poster!", "Customize Poster", options)
	if(src && choice && !M.stat && in_range(M,src))
		var serial = poster_designs.Find(options[choice])
		serial_number = serial
		name = "rolled-up poly-poster - No.[serial]"
		to_chat(M, "The poster is now: [choice].")
		return 1



//############################## THE ACTUAL DECALS ###########################

/obj/structure/sign/poster
	name = "poster"
	desc = "A large piece of space-resistant printed paper. "
	icon = 'icons/obj/contraband_vr.dmi' //VOREStation Edit
	anchored = TRUE
	var/serial_number	//Will hold the value of src.loc if nobody initialises it
	var/poster_type		//So mappers can specify a desired poster
	var/ruined = 0

	var/roll_type
	var/poster_set = FALSE

/obj/structure/sign/poster/Initialize(mapload, var/placement_dir=null, var/serial=null, var/itemtype = /obj/item/contraband/poster)
	. = ..()

	if(!serial)
		serial = rand(1, poster_designs.len) //use a random serial if none is given

	if(!poster_set)
		serial_number = serial
		var/datum/poster/design = poster_designs[serial_number]
		set_poster(design)

	if(itemtype || !roll_type)
		roll_type = itemtype

	switch (placement_dir)
		if (NORTH)
			pixel_x = 0
			pixel_y = 32
		if (SOUTH)
			pixel_x = 0
			pixel_y = -32
		if (EAST)
			pixel_x = 32
			pixel_y = 0
		if (WEST)
			pixel_x = -32
			pixel_y = 0

/obj/structure/sign/poster/Initialize(mapload)
	. = ..()
	if (poster_type)
		var/path = text2path(poster_type)
		var/datum/poster/design = new path
		set_poster(design)

/obj/structure/sign/poster/proc/set_poster(var/datum/poster/design)
	name = "[initial(name)] - [design.name]"
	desc = "[initial(desc)] [design.desc]"
	icon_state = design.icon_state // poster[serial_number]

	poster_set = TRUE

/obj/structure/sign/poster/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WIRECUTTER))
		playsound(src, W.usesound, 100, 1)
		if(ruined)
			to_chat(user, span_notice("You remove the remnants of the poster."))
			qdel(src)
		else
			to_chat(user, span_notice("You carefully remove the poster from the wall."))
			roll_and_drop(user.loc)
		return

/obj/structure/sign/poster/attack_hand(mob/user as mob)

	if(ruined)
		return

	if(tgui_alert(user, "Do I want to rip the poster from the wall?","You think...",list("Yes","No")) == "Yes")

		if(ruined || !user.Adjacent(src))
			return

		visible_message(span_warning("[user] rips [src] in a single, decisive motion!") )
		playsound(src, 'sound/items/poster_ripped.ogg', 100, 1)
		ruined = 1
		icon_state = "poster_ripped"
		name = "ripped poster"
		desc = "You can't make out anything from the poster's original print. It's ruined."
		add_fingerprint(user)

/obj/structure/sign/poster/proc/roll_and_drop(turf/newloc)
	var/obj/item/contraband/poster/P = new roll_type(src, serial_number)
	P.loc = newloc
	src.loc = P
	qdel(src)

/datum/poster
	// Name suffix. Poster - [name]
	var/name=""
	// Description suffix
	var/desc=""
	var/icon_state=""
	var/listing_name=""

// NT poster subtype.
/obj/structure/sign/poster/nanotrasen
	roll_type = /obj/item/contraband/poster/nanotrasen

/obj/structure/sign/poster/nanotrasen/Initialize(mapload, var/placement_dir=null, var/serial=null, var/itemtype = /obj/item/contraband/poster/nanotrasen)
	if(!serial)
		serial = rand(1, NT_poster_designs.len)

	serial_number = serial
	var/datum/poster/design = NT_poster_designs[serial_number]
	set_poster(design)

	. = ..(mapload, placement_dir, serial, itemtype)

//Non-Random Posters

/obj/structure/sign/poster/custom
	roll_type = /obj/item/contraband/poster/custom
*/
/obj/item/contraband/package
	name = "contraband"
	desc = "A tightly sealed package. Dare to look inside?"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycrate5"
	item_state = "table_parts"
	w_class = ITEMSIZE_HUGE

/obj/item/contraband/package/attack_self(mob/user)
	var/contraband = pick(
		/obj/item/reagent_containers/glass/beaker/vial/macrocillin,
		/obj/item/reagent_containers/glass/beaker/vial/microcillin,
		/obj/item/gun/energy/sizegun,
		/obj/item/clothing/mask/muzzle,
		/obj/item/pda/clown,
		/obj/item/pda/mime,
		/obj/item/storage/fancy/cigar/havana,
		/obj/item/card/emag_broken,
		/obj/item/sleevemate,
		/obj/item/disk/nifsoft/compliance,
		/obj/item/seeds/ambrosiadeusseed,
		/obj/item/seeds/ambrosiavulgarisseed,
		/obj/item/bodysnatcher)

	user.put_in_hands(new contraband(user.loc))
	to_chat(user, span_notice("You unwrap the package."))
	qdel(src)
