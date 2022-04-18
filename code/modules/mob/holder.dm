var/list/holder_mob_icon_cache = list()

//Helper object for picking dionaea (and other creatures) up.
/obj/item/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/objects.dmi'
	randpixel = 0
	center_of_mass = null
	slot_flags = SLOT_HEAD | SLOT_HOLSTER
	show_messages = 1

	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/head/mob_teshari.dmi',
		SPECIES_VOX = 'icons/inventory/head/mob_vox.dmi'
		)

	origin_tech = null
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_holder.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_holder.dmi',
		)
	pixel_y = 8
	var/mob/living/held_mob
	var/matrix/original_transform
	var/original_vis_flags = NONE

<<<<<<< HEAD
/obj/item/weapon/holder/Initialize(mapload, mob/held)
	ASSERT(ismob(held))
=======
/obj/item/holder/Initialize()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	. = ..()
	held.forceMove(src)
	START_PROCESSING(SSobj, src)

<<<<<<< HEAD
/obj/item/weapon/holder/Entered(mob/held, atom/OldLoc)
=======
/obj/item/holder/throw_at(atom/target, range, speed, thrower)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	if(held_mob)
		held.forceMove(get_turf(src))
		return
	ASSERT(ismob(held))
	. = ..()
	held_mob = held
	original_vis_flags = held.vis_flags
	held.vis_flags = VIS_INHERIT_ID|VIS_INHERIT_LAYER|VIS_INHERIT_PLANE
	vis_contents += held
	name = held.name
	original_transform = held.transform
	held.transform = null

/obj/item/weapon/holder/Exited(atom/movable/thing, atom/OldLoc)
	if(thing == held_mob)
		held_mob.transform = original_transform
		held_mob.vis_flags = original_vis_flags
		held_mob = null
	..()

/obj/item/holder/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(held_mob)
		dump_mob()
	if(ismob(loc))
		var/mob/M = loc
		M.drop_from_inventory(src, get_turf(src))
	return ..()

<<<<<<< HEAD
/obj/item/weapon/holder/process()
	if(held_mob?.loc != src || isturf(loc))
		qdel(src)

/obj/item/weapon/holder/proc/dump_mob()
	if(!held_mob)
		return
	held_mob.transform = original_transform
	held_mob.vis_flags = original_vis_flags
	held_mob.forceMove(get_turf(src))
	held_mob = null

/obj/item/weapon/holder/throw_at(atom/target, range, speed, thrower)
	if(held_mob)
		var/mob/localref = held_mob
		dump_mob()
		var/thrower_mob_size = 1
		if(ismob(thrower))
			var/mob/M = thrower
			thrower_mob_size = M.mob_size
		var/mob_range = round(range * min(thrower_mob_size / localref.mob_size, 1))
		localref.throw_at(target, mob_range, speed, thrower)

/obj/item/weapon/holder/GetID()
	return held_mob?.GetIdCard()
=======
/obj/item/holder/process()
	update_state()
	drop_items()

/obj/item/holder/dropped()
	..()
	spawn(1)
		update_state()

/obj/item/holder/proc/update_state()
	if(!(contents.len))
		qdel(src)
	else if(isturf(loc))
		drop_items()
		if(held_mob)
			held_mob.forceMove(loc)
			held_mob = null
		qdel(src)

/obj/item/holder/proc/drop_items()
	for(var/atom/movable/M in contents)
		if(M == held_mob)
			continue
		M.forceMove(get_turf(src))

/obj/item/holder/onDropInto(var/atom/movable/AM)
	if(ismob(loc))   // Bypass our holding mob and drop directly to its loc
		return loc.loc
	return ..()

/obj/item/holder/GetID()
	for(var/mob/M in contents)
		var/obj/item/I = M.GetIdCard()
		if(I)
			return I
	return null
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/obj/item/holder/GetAccess()
	var/obj/item/I = GetID()
<<<<<<< HEAD
	return I?.GetAccess() || ..()

/obj/item/weapon/holder/container_resist(mob/living/held)
	if(ismob(loc))
		var/mob/M = loc
		M.drop_from_inventory(src) // If it's another item, we can just continue existing, or if it's a turf we'll qdel() in Moved()
=======
	return I ? I.GetAccess() : ..()

/obj/item/holder/proc/sync(var/mob/living/M)
	dir = 2
	overlays.Cut()
	icon = M.icon
	icon_state = M.icon_state
	item_state = M.item_state
	color = M.color
	name = M.name
	desc = M.desc
	overlays |= M.overlays
	var/mob/living/carbon/human/H = loc
	if(istype(H))
		if(H.l_hand == src)
			H.update_inv_l_hand()
		else if(H.r_hand == src)
			H.update_inv_r_hand()

/obj/item/holder/container_resist(mob/living/held)
	var/mob/M = loc
	if(istype(M))
		M.drop_from_inventory(src)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
		to_chat(M, "<span class='warning'>\The [held] wriggles out of your grip!</span>")
		to_chat(held, "<span class='warning'>You wiggle out of [M]'s grip!</span>")
	else if(istype(loc, /obj/item/clothing/accessory/holster))
		var/obj/item/clothing/accessory/holster/holster = loc
		if(holster.holstered == src)
			holster.clear_holster()
		to_chat(held, "<span class='warning'>You extricate yourself from [holster].</span>")
		forceMove(get_turf(src))
	else if(isitem(loc))
		to_chat(held, "<span class='warning'>You struggle free of [loc].</span>")
		forceMove(get_turf(src))

//Mob specific holders.
/obj/item/holder/diona
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 5)
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING | SLOT_HOLSTER
	item_state = "diona"

/obj/item/holder/drone
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 5)
	item_state = "repairbot"

/obj/item/holder/drone/swarm
	origin_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 7, TECH_PRECURSOR = 2, TECH_ARCANE = 1)
	item_state = "constructiondrone"

/obj/item/holder/pai
	origin_tech = list(TECH_DATA = 2)

<<<<<<< HEAD
/obj/item/weapon/holder/pai/Initialize(mapload, mob/held)
	. = ..()
	item_state = held.icon_state

/obj/item/weapon/holder/mouse
	name = "mouse"
	desc = "It's a small rodent."
	item_state = "mouse_gray"
	slot_flags = SLOT_EARS | SLOT_HEAD | SLOT_ID
	origin_tech = list(TECH_BIO = 2)
	w_class = ITEMSIZE_TINY

/obj/item/weapon/holder/mouse/white
	item_state = "mouse_white"

/obj/item/weapon/holder/mouse/gray
	item_state = "mouse_gray"

/obj/item/weapon/holder/mouse/brown
	item_state = "mouse_brown"

/obj/item/weapon/holder/mouse/black
	item_state = "mouse_black"

/obj/item/weapon/holder/mouse/operative
	item_state = "mouse_operative"

/obj/item/weapon/holder/mouse/rat
	item_state = "mouse_rat"

/obj/item/weapon/holder/possum
=======
/obj/item/holder/mouse
	w_class = ITEMSIZE_TINY

/obj/item/holder/possum
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	origin_tech = list(TECH_BIO = 2)
	item_state = "possum"

/obj/item/holder/possum/poppy
	origin_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 4)
	item_state = "poppy"

/obj/item/holder/cat
	origin_tech = list(TECH_BIO = 2)
	item_state = "cat"

/obj/item/holder/cat/runtime
	origin_tech = list(TECH_BIO = 2, TECH_DATA = 4)

<<<<<<< HEAD
/obj/item/weapon/holder/cat/cak
	origin_tech = list(TECH_BIO = 2)
	item_state = "cak"

/obj/item/weapon/holder/cat/bluespace
	origin_tech = list(TECH_BIO = 2, TECH_BLUESPACE = 6)
	item_state = "bscat"

/obj/item/weapon/holder/cat/spacecat
	origin_tech = list(TECH_BIO = 2, TECH_MATERIAL = 4)
	item_state = "spacecat"

/obj/item/weapon/holder/cat/original
	origin_tech = list(TECH_BIO = 2, TECH_BLUESPACE = 4)
	item_state = "original"

/obj/item/weapon/holder/cat/breadcat
	origin_tech = list(TECH_BIO = 2)
	item_state = "breadcat"

/obj/item/weapon/holder/corgi
	origin_tech = list(TECH_BIO = 2)
	item_state = "corgi"

/obj/item/weapon/holder/lisa
	origin_tech = list(TECH_BIO = 2)
	item_state = "lisa"

/obj/item/weapon/holder/old_corgi
	origin_tech = list(TECH_BIO = 2)
	item_state = "old_corgi"

/obj/item/weapon/holder/void_puppy
	origin_tech = list(TECH_BIO = 2, TECH_BLUESPACE = 3)
	item_state = "void_puppy"

/obj/item/weapon/holder/narsian
	origin_tech = list(TECH_BIO = 2, TECH_ILLEGAL = 3)
	item_state = "narsian"

/obj/item/weapon/holder/bullterrier
	origin_tech = list(TECH_BIO = 2)
	item_state = "bullterrier"

/obj/item/weapon/holder/fox
	origin_tech = list(TECH_BIO = 2)
	item_state = "fox"

/obj/item/weapon/holder/pug
	origin_tech = list(TECH_BIO = 2)
	item_state = "pug"

/obj/item/weapon/holder/sloth
	origin_tech = list(TECH_BIO = 2)
	item_state = "sloth"

/obj/item/weapon/holder/borer
=======
/obj/item/holder/borer
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	origin_tech = list(TECH_BIO = 6)
	item_state = "brainslug"

/obj/item/holder/leech
	color = "#003366"
	origin_tech = list(TECH_BIO = 5, TECH_PHORON = 2)

<<<<<<< HEAD
/obj/item/weapon/holder/cat/fluff/tabiranth
	name = "Spirit"
	desc = "A small, inquisitive feline, who constantly seems to investigate his surroundings."
	gender = MALE
	icon_state = "kitten"
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/holder/cat/kitten
	icon_state = "kitten"
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/holder/cat/fluff/bones
	name = "Bones"
	desc = "It's Bones! Meow."
	gender = MALE
	icon_state = "cat3"

/obj/item/weapon/holder/bird
	name = "bird"
	desc = "It's a bird!"
	icon_state = null
	item_icons = null
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/holder/bird/Initialize()
	. = ..()
	held_mob?.lay_down()

/obj/item/weapon/holder/fish
=======
/obj/item/holder/fish
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	attack_verb = list("fished", "disrespected", "smacked", "smackereled")
	hitsound = 'sound/effects/slime_squish.ogg'
	slot_flags = SLOT_HOLSTER
	origin_tech = list(TECH_BIO = 3)

/obj/item/holder/fish/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target)
		return
	if(!proximity)
		return
	if(isliving(target))
		var/mob/living/L = target
		if(prob(10))
			L.Stun(2)

/obj/item/holder/attackby(obj/item/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

//Mob procs and vars for scooping up
/mob/living/var/holder_type

/mob/living/MouseDrop(var/atom/over_object)
	var/mob/living/carbon/human/H = over_object
	if(holder_type && issmall(src) && istype(H) && !H.lying && Adjacent(H) && (src.a_intent == I_HELP && H.a_intent == I_HELP)) //VOREStation Edit
		if(!issmall(H) || !istype(src, /mob/living/carbon/human))
			get_scooped(H, (usr == src))
		return
	return ..()

/mob/living/proc/get_scooped(var/mob/living/carbon/grabber, var/self_grab)

	if(!holder_type || buckled || pinned.len)
		return

	if(self_grab)
		if(src.incapacitated()) return
	else
		if(grabber.incapacitated()) return

<<<<<<< HEAD
	var/obj/item/weapon/holder/H = new holder_type(get_turf(src), src)
=======
	var/obj/item/holder/H = new holder_type(get_turf(src))
	H.held_mob = src
	src.forceMove(H)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	grabber.put_in_hands(H)

	if(self_grab)
		to_chat(grabber, "<span class='notice'>\The [src] clambers onto you!</span>")
		to_chat(src, "<span class='notice'>You climb up onto \the [grabber]!</span>")
		grabber.equip_to_slot_if_possible(H, slot_back, 0, 1)
	else
		to_chat(grabber, "<span class='notice'>You scoop up \the [src]!</span>")
		to_chat(src, "<span class='notice'>\The [grabber] scoops you up!</span>")

	add_attack_logs(grabber, H.held_mob, "Scooped up", FALSE) // Not important enough to notify admins, but still helpful.
	return H

/obj/item/holder/human
	icon = 'icons/mob/holder_complex.dmi'
	var/list/generate_for_slots = list(slot_l_hand_str, slot_r_hand_str, slot_back_str)
	slot_flags = SLOT_BACK
<<<<<<< HEAD
=======

/obj/item/holder/human/sync(var/mob/living/M)

	// Generate appropriate on-mob icons.
	var/mob/living/carbon/human/owner = M
	if(istype(owner) && owner.species)

		var/skin_colour = rgb(owner.r_skin, owner.g_skin, owner.b_skin)
		var/hair_colour = rgb(owner.r_hair, owner.g_hair, owner.b_hair)
		var/eye_colour =  rgb(owner.r_eyes, owner.g_eyes, owner.b_eyes)
		var/species_name = lowertext(owner.species.get_bodytype(owner))

		for(var/cache_entry in generate_for_slots)
			var/cache_key = "[owner.species]-[cache_entry]-[skin_colour]-[hair_colour]"
			if(!holder_mob_icon_cache[cache_key])

				// Generate individual icons.
				var/icon/mob_icon = icon(icon, "[species_name]_holder_[cache_entry]_base")
				mob_icon.Blend(skin_colour, ICON_ADD)
				var/icon/hair_icon = icon(icon, "[species_name]_holder_[cache_entry]_hair")
				hair_icon.Blend(hair_colour, ICON_ADD)
				var/icon/eyes_icon = icon(icon, "[species_name]_holder_[cache_entry]_eyes")
				eyes_icon.Blend(eye_colour, ICON_ADD)

				// Blend them together.
				mob_icon.Blend(eyes_icon, ICON_OVERLAY)
				mob_icon.Blend(hair_icon, ICON_OVERLAY)

				// Add to the cache.
				holder_mob_icon_cache[cache_key] = mob_icon
			item_icons[cache_entry] = holder_mob_icon_cache[cache_key]

	// Handle the rest of sync().
	..(M)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
