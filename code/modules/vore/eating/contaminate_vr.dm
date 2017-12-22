var/image/gurgled_overlay = image('icons/effects/sludgeoverlay_vr.dmi')

/obj/item
	var/gurgled = 0
	var/cleanname
	var/cleandesc

/obj/item/proc/gurglecontaminate()
	if(!can_gurgle())
		return
	else
		if(istype(src,/obj/item/weapon/cell)) //Drain powercells without contaminating.
			var/obj/item/weapon/cell/C = src
			C.charge = 0
		else if(src.gurgled == 0)
			gurgled = 1
			overlays += gurgled_overlay
			var/gurgleflavor = pick("soggy","soaked","dirty","nasty","slimy","drenched","sloppy")
			cleanname = src.name
			cleandesc = src.desc
			name = "[gurgleflavor] [cleanname]"
			desc = "[cleandesc] It seems to be covered in ominously foul residue and needs a wash."
			if(istype(src,/obj/item/weapon/storage/box))
				name = "soggy [cleanname]"
				desc = "This soggy box is about to fall apart any time."
			if(istype(src,/obj/item/device/pda))
				desc = "This device seems completely unresponsive while drenched with sludge. Perhaps you could still wash it."


/obj/item/proc/can_gurgle()
	if(flags & PHORONGUARD)
		return 0
	else if(phoronproof == 1)
		return 0
	else if(unacidable)
		return 0
	else
		return 1

/obj/item/decontaminate() //Decontaminate the sogginess as well.
	..()
	gurgled = 0
	overlays -= gurgled_overlay
	if(cleanname)
		name = cleanname
	if(cleandesc)
		desc = cleandesc

/obj/item/clean_blood() //Make this type of contamination sink washable as well.
	..()
	if(gurgled == 1)
		decontaminate()

/obj/item/device/pda/can_use() //Get your rice bowl ready.
	if(src.gurgled == 1)
		return 0
	else
		return ..()

/obj/structure/sink/attackby(obj/item/O as obj, mob/user as mob) //Wash the soggy item before it can interact with the sink.
	if(O.gurgled == 1)
		var/turf/location = user.loc
		if(!isturf(location)) return

		var/obj/item/I = O
		if(!I || !istype(I,/obj/item)) return

		to_chat(usr, "<span class='notice'>You start washing \the [I].</span>")

		busy = 1
		sleep(40)
		busy = 0

		if(user.loc != location) return				//User has moved
		if(!I) return 								//Item's been destroyed while washing
		if(user.get_active_hand() != I) return		//Person has switched hands or the item in their hands

		O.clean_blood()
		user.visible_message( \
			"<span class='notice'>[user] washes \a [I] using \the [src].</span>", \
			"<span class='notice'>You wash \a [I] using \the [src].</span>")
	else
		..()

/obj/item/weapon/storage/box/open(mob/user as mob)
	if(src.gurgled == 1)
		usr << "The soggy box falls apart in your hands."
		var/turf/T = get_turf(src)
		for(var/obj/item/I in contents)
			remove_from_storage(I, T)
		new/obj/effect/decal/cleanable/molten_item(T)
		qdel()
		return
	..()