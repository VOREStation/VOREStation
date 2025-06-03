/datum/category_item/catalogue/technology/janicart
	name = "Zoomboni Janipro"
	desc = "A ridable station cleaning cart. A janitorial luxury afforded only to the most affluent supply departments back in the early 2100s. Comes with fuzzy dice on the key fob. Welcome back old friend."
	value = CATALOGUER_REWARD_TRIVIAL

/obj/vehicle/train/engine/janicart
	name = "janicart"
	desc = "A ridable station cleaning cart. Has a large water tank to feed its floor scrubbers, the opening is big enough to fit a mop through to wet it. It also has a hook to hang a trashbag from. You're riding in style now!"
	icon_state = "pussywagon"
	on = 0
	powered = 1
	locked = 0

	load_item_visible = 1
	load_offset_x = 0
	mob_offset_y = 7
	flags = OPENCONTAINER

	var/scrubbing = FALSE //Floor cleaning enabled
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/mybag	= null
	var/callme = "janitor cart" //how do people refer to it?

	key_type = /obj/item/key/janicart

	catalogue_data = list(/datum/category_item/catalogue/technology/janicart)

/obj/item/key/janicart
	name = "key"
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = ITEMSIZE_TINY

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/engine/janicart/Initialize(mapload)
	. = ..()
	// apply speed
	move_delay = 0.5
	cell = new /obj/item/cell/high(src)
	key = new key_type(src)
	turn_off()	//so engine verbs are correctly set
	create_reagents(600)
	update_icon()
	verbs -= /obj/vehicle/train/verb/unlatch_v // Nothing to unlatch

	if(prob(20))
		callme = pick(list("pimpin' ride","thang","pussy wagon","janihound deflector","raunchy love mobile","sanitation stallion","magic carpet","crime mobile","get away car"))

/obj/vehicle/train/engine/janicart/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/mop))
		if(reagents.total_volume > 1)
			reagents.trans_to_obj(W, 2)
			to_chat(user, span_notice("You wet \the [W] in the [callme]."))
			playsound(src, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, span_notice("This [callme] is out of water!"))
		return
	if(istype(W, /obj/item/storage/bag/trash))
		to_chat(user, span_notice("You hook the trashbag onto the [callme]."))
		user.drop_item()
		W.forceMove(src)
		mybag = W
		return
	. = ..()

/obj/vehicle/train/engine/janicart/attack_hand(mob/user)
	if(mybag)
		mybag.forceMove(get_turf(user))
		user.put_in_hands(mybag)
		mybag = null
		return
	. = ..()

//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/train/engine/janicart/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "The power light is [on ? "on" : "off"].\nThere are[key ? "" : " no"] keys in the ignition."
		. += "The charge meter reads [cell? round(cell.percent(), 0.01) : 0]%"
		. += "This [callme] contains [reagents.total_volume] unit\s of water!"
		if(mybag)
			. += "\A [mybag] is hanging on the [callme]."

/obj/vehicle/train/engine/janicart/verb/toggle_brush()
	set name = "Toggle brushes"
	set category = "Object.Vehicle"
	set src in view(0)

	if(!ishuman(usr))
		return

	scrubbing = !scrubbing
	if (scrubbing)
		to_chat(usr, span_notice("You turn the [callme]'s brushes on."))
	else
		to_chat(usr, span_notice("You turn the [callme]'s brushes off."))

/obj/vehicle/train/engine/janicart/latch(obj/vehicle/train/T, mob/user)
	return // nothing latchs to this!

/obj/vehicle/train/engine/janicart/update_icon()
	..()
	cut_overlays()
	if(!open)
		var/image/O = image(icon = 'icons/obj/vehicles_vr.dmi', icon_state = "pussywagon_overlay", dir = src.dir)
		O.layer = FLY_LAYER
		O.plane = MOB_PLANE
		add_overlay(O)

/obj/vehicle/train/engine/janicart/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	var/turf/tile = get_turf(src)
	if(scrubbing)
		if(tile && reagents.total_volume > 0)
			if(reagents.has_reagent(REAGENT_ID_WATER) || reagents.has_reagent(REAGENT_ID_CLEANER))
				tile.wash(CLEAN_SCRUB)
			for(var/atom/movable/AM in tile.contents)
				if(istype(AM, /mob/living))
					var/mob/living/L = AM
					if(L.is_incorporeal() || L.buckled == src) // Don't scrub shadekin our our rider
						continue
					reagents.splash(L,5) // only 5u so it's not gamebreaking
			reagents.trans_to_turf(tile, 1, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.
		else
			scrubbing = FALSE
			if(ishuman(load))
				var/mob/living/carbon/human/D = load
				to_chat(D, span_notice("The [callme]'s brushes turn off, as it runs out of cleaner."))
