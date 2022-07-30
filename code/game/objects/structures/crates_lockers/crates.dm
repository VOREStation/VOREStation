//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/closets/bases/crate.dmi'
	closet_appearance = /decl/closet_appearance/crate
	climbable = TRUE
	dir = 4 //Spawn facing 'forward' by default.
	var/points_per_crate = 5
	var/rigged = 0

	open_sound = 'sound/effects/crate_open.ogg'
	close_sound = 'sound/effects/crate_close.ogg'

/obj/structure/closet/crate/can_open()
	return 1

/obj/structure/closet/crate/can_close()
	return 1

/obj/structure/closet/crate/open()
	if(src.opened)
		return 0
	if(!src.can_open())
		return 0

	if(rigged && locate(/obj/item/radio/electropack) in src)
		if(isliving(usr))
			var/mob/living/L = usr
			if(L.electrocute_act(17, src))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				if(usr.stunned)
					return 2

	playsound(src, open_sound, 50, 1, -3)
	for(var/obj/O in src)
		O.forceMove(get_turf(src))
	src.opened = 1

	if(climbable)
		structure_shaken()
	update_icon()
	return 1

/obj/structure/closet/crate/close()
	if(!src.opened)
		return 0
	if(!src.can_close())
		return 0

	playsound(src, close_sound, 50, 1, -3)
	var/itemcount = 0
	for(var/obj/O in get_turf(src))
		if(itemcount >= storage_capacity)
			break
		if(O.density || O.anchored || istype(O,/obj/structure/closet))
			continue
		if(istype(O, /obj/structure/bed)) //This is only necessary because of rollerbeds and swivel chairs.
			var/obj/structure/bed/B = O
			if(B.has_buckled_mobs())
				continue
		O.forceMove(src)
		itemcount++

	src.opened = 0
	update_icon()
	return 1

/obj/structure/closet/crate/verb/rotate_clockwise()
	set name = "Rotate Crate Clockwise"
	set category = "Object"
	set src in oview(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, 270))

/obj/structure/closet/crate/verb/rotate_counterclockwise()
	set category = "Object"
	set name = "Rotate Crate Counterclockwise"
	set src in view(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, 90))

/obj/structure/closet/crate/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench() && istype(src,/obj/structure/closet/crate/bin))
		return ..()
	else if(opened)
		if(isrobot(user))
			return
		if(W.loc != user) // This should stop mounted modules ending up outside the module.
			return
		user.drop_item()
		if(W)
			W.forceMove(src.loc)
	else if(istype(W, /obj/item/packageWrap))
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(rigged)
			to_chat(user, "<span class='notice'>[src] is already rigged!</span>")
			return
		if (C.use(1))
			to_chat(user , "<span class='notice'>You rig [src].</span>")
			rigged = 1
			return
	else if(istype(W, /obj/item/radio/electropack))
		if(rigged)
			to_chat(user , "<span class='notice'>You attach [W] to [src].</span>")
			user.drop_item()
			W.forceMove(src)
			return
	else if(W.is_wirecutter())
		if(rigged)
			to_chat(user , "<span class='notice'>You cut away the wiring.</span>")
			playsound(src, W.usesound, 100, 1)
			rigged = 0
			return
	else return attack_hand(user)

/obj/structure/closet/crate/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/obj/O in src.contents)
				qdel(O)
			qdel(src)
			return
		if(2.0)
			for(var/obj/O in src.contents)
				if(prob(50))
					qdel(O)
			qdel(src)
			return
		if(3.0)
			if (prob(50))
				qdel(src)
			return
		else
	return

/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "Secure crate"
	closet_appearance = /decl/closet_appearance/crate/secure
	var/broken = 0
	var/locked = 1

/obj/structure/closet/crate/secure/can_open()
	return !locked

/obj/structure/closet/crate/secure/update_icon()
	if(opened)
		icon_state = "open"
	else
		if(broken)
			icon_state = "closed_emagged[sealed ? "_welded" : ""]"
		else
			if(locked)
				icon_state = "closed_locked[sealed ? "_welded" : ""]"
			else
				icon_state = "closed_unlocked[sealed ? "_welded" : ""]"

/obj/structure/closet/crate/secure/proc/togglelock(mob/user as mob)
	if(src.opened)
		to_chat(user, "<span class='notice'>Close the crate first.</span>")
		return
	if(src.broken)
		to_chat(user, "<span class='warning'>The crate appears to be broken.</span>")
		return
	if(src.allowed(user))
		set_locked(!locked, user)
	else
		to_chat(user, "<span class='notice'>Access Denied</span>")

/obj/structure/closet/crate/secure/proc/set_locked(var/newlocked, mob/user = null)
	if(locked == newlocked) return

	locked = newlocked
	if(user)
		for(var/mob/O in viewers(user, 3))
			O.show_message( "<span class='notice'>The crate has been [locked ? null : "un"]locked by [user].</span>", 1)
	update_icon()

/obj/structure/closet/crate/secure/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr) || isrobot(usr))
		src.add_fingerprint(usr)
		src.togglelock(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

/obj/structure/closet/crate/secure/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(locked)
		src.togglelock(user)
	else
		src.toggle(user)

/obj/structure/closet/crate/secure/attackby(obj/item/W as obj, mob/user as mob)
	if(is_type_in_list(W, list(/obj/item/packageWrap, /obj/item/stack/cable_coil, /obj/item/radio/electropack, /obj/item/tool/wirecutters)))
		return ..()
	if(istype(W, /obj/item/melee/energy/blade))
		emag_act(INFINITY, user)
	if(!opened)
		src.togglelock(user)
		return
	return ..()

/obj/structure/closet/crate/secure/emag_act(var/remaining_charges, var/mob/user)
	if(!broken)
		playsound(src, "sparks", 60, 1)
		locked = 0
		broken = 1
		to_chat(user, "<span class='notice'>You unlock \the [src].</span>")
		update_icon()
		return 1

/obj/structure/closet/crate/secure/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && !opened  && prob(50/severity))
		if(!locked)
			locked = 1
		else
			playsound(src, 'sound/effects/sparks4.ogg', 75, 1)
			locked = 0
	if(!opened && prob(20/severity))
		if(!locked)
			open()
		else
			req_access = list()
			req_access += pick(get_all_station_access())
	update_icon()
	..()

/obj/structure/closet/crate/plastic
	name = "plastic crate"
	desc = "A rectangular plastic crate."
	closet_appearance = /decl/closet_appearance/crate/plastic
	points_per_crate = 1	//5 crates per ordered crate, +5 for the crate it comes in.

/obj/structure/closet/crate/internals
	name = "internals crate"
	desc = "A internals crate."

/obj/structure/closet/crate/trashcart
	name = "trash cart"
	desc = "A heavy, metal trashcart with wheels."
	closet_appearance = /decl/closet_appearance/cart/trash

/*these aren't needed anymore
/obj/structure/closet/crate/hat
	desc = "A crate filled with Valuable Collector's Hats!."
	name = "Hat Crate"

/obj/structure/closet/crate/contraband
	name = "Poster crate"
	desc = "A random assortment of posters manufactured by providers NOT listed under NanoTrasen's whitelist."
*/

/obj/structure/closet/crate/medical
	name = "medical crate"
	desc = "A medical crate."
	closet_appearance = /decl/closet_appearance/crate/medical

/obj/structure/closet/crate/rcd
	name = "\improper RCD crate"
	desc = "A crate with rapid construction device."

	starts_with = list(
		/obj/item/rcd_ammo = 3,
		/obj/item/rcd)

/obj/structure/closet/crate/solar
	name = "solar pack crate"

	starts_with = list(
		/obj/item/solar_assembly = 21,
		/obj/item/circuitboard/solar_control,
		/obj/item/tracker_electronics,
		/obj/item/paper/solar)

/obj/structure/closet/crate/freezer
	name = "freezer"
	desc = "A freezer."
	closet_appearance = /decl/closet_appearance/crate/freezer
	var/target_temp = T0C - 40
	var/cooling_power = 40

/obj/structure/closet/crate/freezer/centauri
	desc = "A freezer stamped with the logo of Centauri Provisions."
	closet_appearance = /decl/closet_appearance/crate/freezer/centauri

/obj/structure/closet/crate/freezer/nanotrasen
	desc = "A freezer stamped with the logo of NanoTrasen."
	closet_appearance = /decl/closet_appearance/crate/freezer/nanotrasen

/obj/structure/closet/crate/freezer/return_air()
	var/datum/gas_mixture/gas = (..())
	if(!gas)	return null
	var/datum/gas_mixture/newgas = new/datum/gas_mixture()
	newgas.copy_from(gas)
	if(newgas.temperature <= target_temp)	return

	if((newgas.temperature - cooling_power) > target_temp)
		newgas.temperature -= cooling_power
	else
		newgas.temperature = target_temp
	return newgas

/obj/structure/closet/crate/freezer/Entered(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 1
		for(var/obj/item/organ/organ in O)
			organ.preserved = 1
	..()

/obj/structure/closet/crate/freezer/Exited(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 0
		for(var/obj/item/organ/organ in O)
			organ.preserved = 0
	..()

/obj/structure/closet/crate/weapon
	name = "weapons crate"
	desc = "A barely secured weapons crate."
	closet_appearance = /decl/closet_appearance/crate/secure/weapon

/obj/structure/closet/crate/freezer/rations //Fpr use in the escape shuttle
	name = "emergency rations"
	desc = "A crate of emergency rations."

	starts_with = list(
		/obj/random/mre = 6)

/obj/structure/closet/crate/bin
	name = "large bin"
	desc = "A large bin."
	closet_appearance = null
	icon = 'icons/obj/closets/largebin.dmi'

/obj/structure/closet/crate/radiation
	name = "radioactive gear crate"
	desc = "A crate with a radiation sign on it."
	closet_appearance = /decl/closet_appearance/crate/radiation

	starts_with = list(
		/obj/item/clothing/suit/radiation = 4,
		/obj/item/clothing/head/radiation = 4)

//TSCs

/obj/structure/closet/crate/aether
	desc = "A crate painted in the colours of Aether Atmospherics and Recycling."
	closet_appearance = /decl/closet_appearance/crate/aether

/obj/structure/closet/crate/centauri
	desc = "A crate decorated with the logo of Centauri Provisions."
	closet_appearance = /decl/closet_appearance/crate/centauri

/obj/structure/closet/crate/einstein
	desc = "A crate labelled with an Einstein Engines sticker."
	closet_appearance = /decl/closet_appearance/crate/einstein

/obj/structure/closet/crate/focalpoint
	desc = "A crate marked with the decal of Focal Point Energistics."
	closet_appearance = /decl/closet_appearance/crate/focalpoint

/obj/structure/closet/crate/gilthari
	desc = "A crate embossed with the logo of Gilthari Exports."
	closet_appearance = /decl/closet_appearance/crate/gilthari

/obj/structure/closet/crate/grayson
	desc = "A bare metal crate spraypainted with Grayson Manufactories decals."
	closet_appearance = /decl/closet_appearance/crate/grayson

/obj/structure/closet/crate/heph
	desc = "A sturdy crate marked with the logo of Hephaestus Industries."
	closet_appearance = /decl/closet_appearance/crate/heph

/obj/structure/closet/crate/morpheus
	desc = "A crate crudely imprinted with 'MORPHEUS CYBERKINETICS'."
	closet_appearance = /decl/closet_appearance/crate/morpheus

/obj/structure/closet/crate/nanotrasen
	desc = "A crate emblazoned with the standard NanoTrasen livery."
	closet_appearance = /decl/closet_appearance/crate/nanotrasen

/obj/structure/closet/crate/nanothreads
	desc = "A crate emblazoned with the NanoThreads Garments livery, a subsidary of the NanoTrasen Corporation."
	closet_appearance = /decl/closet_appearance/crate/nanotrasenclothing

/obj/structure/closet/crate/nanomed
	desc = "A crate emblazoned with the NanoMed Medical livery, a subsidary of the NanoTrasen Corporation."
	closet_appearance = /decl/closet_appearance/crate/nanotrasenmedical

/obj/structure/closet/crate/oculum
	desc = "A crate minimally decorated with the logo of media giant Oculum Broadcast."
	closet_appearance = /decl/closet_appearance/crate/oculum

/obj/structure/closet/crate/veymed
	desc = "A sterile crate extensively detailed in Veymed colours."
	closet_appearance = /decl/closet_appearance/crate/veymed

/obj/structure/closet/crate/ward
	desc = "A crate decaled with the logo of Ward-Takahashi."
	closet_appearance = /decl/closet_appearance/crate/ward

/obj/structure/closet/crate/xion
	desc = "A crate painted in Xion Manufacturing Group orange."
	closet_appearance = /decl/closet_appearance/crate/xion

/obj/structure/closet/crate/zenghu
	desc = "A sterile crate marked with the logo of Zeng-Hu Pharmaceuticals."
	closet_appearance = /decl/closet_appearance/crate/zenghu

// Brands/subsidiaries

/obj/structure/closet/crate/allico
	desc = "A crate painted in the distinctive cheerful colours of AlliCo. Ltd."
	closet_appearance = /decl/closet_appearance/crate/allico

/obj/structure/closet/crate/carp
	desc = "A crate painted with the garish livery of Consolidated Agricultural Resources Plc."
	closet_appearance = /decl/closet_appearance/crate/carp

/obj/structure/closet/crate/hedberg
	name = "weapons crate"
	desc = "A weapons crate stamped with the logo of Hedberg-Hammarstrom and the lock conspicuously absent."
	closet_appearance = /decl/closet_appearance/crate/secure/hedberg

/obj/structure/closet/crate/galaksi
	desc = "A crate printed with the markings of Ward-Takahashi's Galaksi Appliance branding."
	closet_appearance = /decl/closet_appearance/crate/galaksi

/obj/structure/closet/crate/thinktronic
	desc = "A crate printed with the markings of Thinktronic Systems."
	closet_appearance = /decl/closet_appearance/crate/thinktronic

/obj/structure/closet/crate/ummarcar
	desc = "A flimsy crate marked labelled 'UmMarcar Office Supply'."
	closet_appearance = /decl/closet_appearance/crate/ummarcar

/obj/structure/closet/crate/unathi
	name = "import crate"
	desc = "A crate painted with the markings of Moghes Imported Sissalik Jerky."
	closet_appearance = /decl/closet_appearance/crate/unathiimport


// Secure Crates

/obj/structure/closet/crate/secure/weapon
	name = "weapons crate"
	desc = "A secure weapons crate."
	closet_appearance = /decl/closet_appearance/crate/secure/weapon

/obj/structure/closet/crate/secure/aether
	desc = "A secure crate painted in the colours of Aether Atmospherics and Recycling."
	closet_appearance = /decl/closet_appearance/crate/secure/aether

/obj/structure/closet/crate/secure/bishop
	desc = "A secure crate finely decorated with the emblem of Bishop Cybernetics."
	closet_appearance = /decl/closet_appearance/crate/secure/bishop

/obj/structure/closet/crate/secure/cybersolutions
	desc = "An unadorned secure metal crate labelled 'Cyber Solutions'."
	closet_appearance = /decl/closet_appearance/crate/secure/cybersolutions

/obj/structure/closet/crate/secure/einstein
	desc = "A secure crate labelled with an Einstein Engines sticker."
	closet_appearance = /decl/closet_appearance/crate/secure/einstein

/obj/structure/closet/crate/secure/focalpoint
	desc = "A secure crate marked with the decal of Focal Point Energistics."
	closet_appearance = /decl/closet_appearance/crate/secure/focalpoint

/obj/structure/closet/crate/secure/gilthari
	desc = "A secure crate embossed with the logo of Gilthari Exports."
	closet_appearance = /decl/closet_appearance/crate/secure/gilthari

/obj/structure/closet/crate/secure/grayson
	desc = "A secure bare metal crate spraypainted with Grayson Manufactories decals."
	closet_appearance = /decl/closet_appearance/crate/secure/grayson

/obj/structure/closet/crate/secure/hedberg
	name = "weapons crate"
	desc = "A secure weapons crate stamped with the logo of Hedberg-Hammarstrom."
	closet_appearance = /decl/closet_appearance/crate/secure/hedberg

/obj/structure/closet/crate/secure/heph
	name = "weapons crate"
	desc = "A secure weapons crate marked with the logo of Hephaestus Industries."
	closet_appearance = /decl/closet_appearance/crate/secure/heph

/obj/structure/closet/crate/secure/lawson
	name = "weapons crate"
	desc = "A secure weapons crate marked with the logo of Lawson Arms."
	closet_appearance = /decl/closet_appearance/crate/secure/lawson

/obj/structure/closet/crate/secure/morpheus
	desc = "A secure crate crudely imprinted with 'MORPHEUS CYBERKINETICS'."
	closet_appearance = /decl/closet_appearance/crate/secure/morpheus

/obj/structure/closet/crate/secure/nanotrasen
	desc = "A secure crate emblazoned with the standard NanoTrasen livery."
	closet_appearance = /decl/closet_appearance/crate/secure/nanotrasen

/obj/structure/closet/crate/secure/nanomed
	desc = "A secure crate emblazoned with the NanoMed Medical livery, a subsidary of the NanoTrasen Corporation."
	closet_appearance = /decl/closet_appearance/crate/secure/nanotrasenmedical

/obj/structure/closet/crate/secure/scg
	name = "weapons crate"
	desc = "A secure crate in the official colours of the Solar Confederate Government."
	closet_appearance = /decl/closet_appearance/crate/secure/solgov

/obj/structure/closet/crate/secure/saare
	name = "weapons crate"
	desc = "A secure weapons crate plainly stamped with the logo of Stealth Assault Enterprises."
	closet_appearance = /decl/closet_appearance/crate/secure/saare

/obj/structure/closet/crate/secure/veymed
	desc = "A secure sterile crate extensively detailed in Veymed colours."
	closet_appearance = /decl/closet_appearance/crate/secure/veymed

/obj/structure/closet/crate/secure/ward
	desc = "A secure crate decaled with the logo of Ward-Takahashi."
	closet_appearance = /decl/closet_appearance/crate/secure/ward

/obj/structure/closet/crate/secure/xion
	desc = "A secure crate painted in Xion Manufacturing Group orange."
	closet_appearance = /decl/closet_appearance/crate/secure/xion

/obj/structure/closet/crate/secure/zenghu
	desc = "A secure sterile crate marked with the logo of Zeng-Hu Pharmaceuticals."
	closet_appearance = /decl/closet_appearance/crate/secure/zenghu

/obj/structure/closet/crate/secure/phoron
	name = "phoron crate"
	desc = "A secure phoron crate painted in standard NanoTrasen livery."
	closet_appearance = /decl/closet_appearance/crate/secure/hazard

/obj/structure/closet/crate/secure/gear
	name = "gear crate"
	desc = "A secure gear crate."
	closet_appearance = /decl/closet_appearance/crate/secure/weapon

/obj/structure/closet/crate/secure/hydrosec
	name = "secure hydroponics crate"
	desc = "A crate with a lock on it, painted in the scheme of the station's botanists."
	closet_appearance = /decl/closet_appearance/crate/secure/hydroponics

/obj/structure/closet/crate/secure/engineering
	desc = "A crate with a lock on it, painted in the scheme of the station's engineers."
	name = "secure engineering crate"

/obj/structure/closet/crate/secure/science
	name = "secure science crate"
	desc = "A crate with a lock on it, painted in the scheme of the station's scientists."

/obj/structure/closet/crate/secure/bin
	name = "secure bin"
	desc = "A secure bin."

// Large crates

/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty metal crate."
	icon = 'icons/obj/closets/bases/large_crate.dmi'
	closet_appearance = /decl/closet_appearance/large_crate

/obj/structure/closet/crate/large/close()
	. = ..()
	if (.)//we can hold up to one large item
		var/found = 0
		for(var/obj/structure/S in src.loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in src.loc)
				if(!M.anchored)
					M.forceMove(src)
					break
	return

/obj/structure/closet/crate/large/critter
	name = "animal crate"
	desc = "A hefty crate for hauling animals."
	closet_appearance = /decl/closet_appearance/large_crate/critter

/obj/structure/closet/crate/large/aether
	name = "large atmospherics crate"
	desc = "A hefty metal crate, painted in Aether Atmospherics and Recycling colours."
	closet_appearance = /decl/closet_appearance/large_crate/aether

/obj/structure/closet/crate/large/einstein
	name = "large crate"
	desc = "A hefty metal crate, painted in Einstein Engines colours."
	closet_appearance = /decl/closet_appearance/large_crate/einstein

/obj/structure/closet/crate/large/nanotrasen
	name = "large crate"
	desc = "A hefty metal crate, painted in standard NanoTrasen livery."
	closet_appearance = /decl/closet_appearance/large_crate/nanotrasen

/obj/structure/closet/crate/large/xion
	name = "large crate"
	desc = "A hefty metal crate, painted in Xion Manufacturing Group orange."
	closet_appearance = /decl/closet_appearance/large_crate/xion

/obj/structure/closet/crate/secure/large
	name = "large crate"
	desc = "A hefty metal crate with an electronic locking system."
	icon = 'icons/obj/closets/bases/large_crate.dmi'
	closet_appearance = /decl/closet_appearance/large_crate/secure


/obj/structure/closet/crate/secure/large/close()
	. = ..()
	if (.)//we can hold up to one large item
		var/found = 0
		for(var/obj/structure/S in src.loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in src.loc)
				if(!M.anchored)
					M.forceMove(src)
					break
	return


/obj/structure/closet/crate/secure/large/reinforced
	desc = "A hefty, reinforced metal crate with an electronic locking system."

/obj/structure/closet/crate/secure/large/aether
	name = "secure atmospherics crate"
	desc = "A hefty metal crate with an electronic locking system, painted in Aether Atmospherics and Recycling colours."
	closet_appearance = /decl/closet_appearance/large_crate/secure/aether

/obj/structure/closet/crate/secure/large/einstein
	desc = "A hefty metal crate with an electronic locking system, painted in Einstein Engines colours."
	closet_appearance = /decl/closet_appearance/large_crate/secure/einstein

/obj/structure/closet/crate/large/secure/heph
	desc = "A hefty metal crate with an electronic locking system, marked with Hephaestus Industries colours."
	closet_appearance = /decl/closet_appearance/large_crate/secure/heph

/obj/structure/closet/crate/secure/large/nanotrasen
	desc = "A hefty metal crate with an electronic locking system, painted in standard NanoTrasen livery."
	closet_appearance = /decl/closet_appearance/large_crate/secure/hazard

/obj/structure/closet/crate/large/secure/xion
	desc = "A hefty metal crate with an electronic locking system, painted in Xion Manufacturing Group orange."
	closet_appearance = /decl/closet_appearance/large_crate/secure/xion

/obj/structure/closet/crate/engineering
	name = "engineering crate"

/obj/structure/closet/crate/engineering/electrical

/obj/structure/closet/crate/science
	name = "science crate"

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	closet_appearance = /decl/closet_appearance/crate/hydroponics


/obj/structure/closet/crate/hydroponics/prespawned
	starts_with = list(
		/obj/item/reagent_containers/spray/plantbgone = 2,
		/obj/item/material/minihoe)

//Laundry Cart
/obj/structure/closet/crate/laundry
	name = "Laundry Cart"
	desc = "A cart with a large fabric bin on it used for transporting large amounts of clothes."
	icon = 'icons/obj/closets/laundry.dmi'
	closet_appearance = null
	open_sound = 'sound/effects/rustle1.ogg'
	close_sound = 'sound/effects/rustle2.ogg'

//Wooden Crate
/obj/structure/closet/crate/wooden
	name = "wooden crate"
	desc = "A crate made from wood and lined with straw. Cheapest form of storage."
	icon = 'icons/obj/closets/wooden.dmi'
	closet_appearance = null
	open_sound = 'sound/effects/wooden_closet_open.ogg'
	close_sound = 'sound/effects/wooden_closet_close.ogg'

//Mining Cart
/obj/structure/closet/crate/miningcar
	name = "mining cart"
	desc = "A mining car. This one doesn't work on rails, but has to be dragged."
	icon = 'icons/obj/closets/miningcar.dmi'
	closet_appearance = null
	open_sound = 'sound/effects/wooden_closet_open.ogg'
	close_sound = 'sound/effects/wooden_closet_close.ogg'
