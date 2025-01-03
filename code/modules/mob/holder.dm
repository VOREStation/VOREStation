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

/obj/item/holder/Initialize(mapload, mob/held)
	ASSERT(ismob(held))
	. = ..()
	held.forceMove(src)
	held.reset_view(src)
	START_PROCESSING(SSobj, src)

/mob/living/get_status_tab_items()
	. = ..()
	if(. && istype(loc, /obj/item/holder))
		var/location = ""
		var/obj/item/holder/H = loc
		if(ishuman(H.loc))
			var/mob/living/carbon/human/HH = H.loc
			if(HH.l_hand == H)
				location = "[HH]'s left hand"
			else if(HH.r_hand == H)
				location = "[HH]'s right hand"
			else if(HH.r_store == H || HH.l_store == H)
				location = "[HH]'s pocket"
			else if(HH.head == H)
				location = "[HH]'s head"
			else if(HH.shoes == H)
				location = "[HH]'s feet"
			else
				location = "[HH]"
		else if(ismob(H.loc))
			var/mob/living/M = H.loc
			if(M.l_hand == H)
				location = "[M]'s left hand"
			else if(M.r_hand == H)
				location = "[M]'s right hand"
			else
				location = "[M]"
		else if(ismob(H.loc.loc))
			location = "[H.loc.loc]'s [H.loc]"
		else
			location = "[H.loc]"
		if (location != "")
			. += ""
			. += "Location: [location]"

/obj/item/holder/Entered(mob/held, atom/OldLoc)
	if(held_mob)
		held.forceMove(get_turf(src))
		held.reset_view(null)
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

/obj/item/holder/Exited(atom/movable/thing, atom/OldLoc)
	if(thing == held_mob)
		held_mob.transform = original_transform
		held_mob.update_transform() //VOREStation edit
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

/obj/item/holder/process()
	if(held_mob?.loc != src || isturf(loc))
		qdel(src)

/obj/item/holder/proc/dump_mob()
	if(!held_mob)
		return
	if (held_mob.loc == src || isnull(held_mob.loc)) //VOREStation edit
		held_mob.transform = original_transform
		held_mob.update_transform() //VOREStation edit
		held_mob.vis_flags = original_vis_flags
		held_mob.forceMove(get_turf(src))
		held_mob.reset_view(null)
		held_mob = null
	invisibility = INVISIBILITY_ABSTRACT //VOREStation edit

/obj/item/holder/throw_at(atom/target, range, speed, thrower)
	if(held_mob)
		var/mob/localref = held_mob
		dump_mob()
		var/thrower_mob_size = 1
		if(ismob(thrower))
			var/mob/M = thrower
			thrower_mob_size = M.mob_size
		var/mob_range = round(range * min(thrower_mob_size / localref.mob_size, 1))
		localref.throw_at(target, mob_range, speed, thrower)

/obj/item/holder/GetID()
	return held_mob?.GetIdCard()

/obj/item/holder/GetAccess()
	var/obj/item/I = GetID()
	return I?.GetAccess() || ..()

/obj/item/holder/container_resist(mob/living/held)
	if(ismob(loc))
		var/mob/M = loc
		M.drop_from_inventory(src) // If it's another item, we can just continue existing, or if it's a turf we'll qdel() in Moved()
		to_chat(M, span_warning("\The [held] wriggles out of your grip!"))
		to_chat(held, span_warning("You wiggle out of [M]'s grip!"))
	else if(istype(loc, /obj/item/clothing/accessory/holster))
		var/obj/item/clothing/accessory/holster/holster = loc
		if(holster.holstered == src)
			holster.clear_holster()
		to_chat(held, span_warning("You extricate yourself from [holster]."))
		forceMove(get_turf(src))
		held.reset_view(null)
	else if(isitem(loc))
		var/obj/item/I = loc
		to_chat(held, span_warning("You struggle free of [loc]."))
		forceMove(get_turf(src))
		held.reset_view(null)
		if(istype(I))
			I.on_holder_escape(src)

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

/obj/item/holder/pai/Initialize(mapload, mob/held)
	. = ..()
	item_state = held.icon_state

/obj/item/holder/mouse
	name = "mouse"
	desc = "It's a small rodent."
	item_state = "mouse_gray"
	slot_flags = SLOT_EARS | SLOT_HEAD | SLOT_ID
	origin_tech = list(TECH_BIO = 2)
	w_class = ITEMSIZE_TINY

/obj/item/holder/mouse/white
	item_state = "mouse_white"

/obj/item/holder/mouse/gray
	item_state = "mouse_gray"

/obj/item/holder/mouse/brown
	item_state = "mouse_brown"

/obj/item/holder/mouse/black
	item_state = "mouse_black"

/obj/item/holder/mouse/operative
	item_state = "mouse_operative"

/obj/item/holder/mouse/rat
	item_state = "mouse_rat"

/obj/item/holder/possum
	origin_tech = list(TECH_BIO = 2)
	item_state = "possum"

/obj/item/holder/possum/poppy
	origin_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 4)
	item_state = "poppy"

/obj/item/holder/cat
	origin_tech = list(TECH_BIO = 2)
	item_state = "cat"

/obj/item/holder/cat/runtime

/obj/item/holder/fennec
	origin_tech = list(TECH_BIO = 2)

/obj/item/holder/cat/runtime

	origin_tech = list(TECH_BIO = 2, TECH_DATA = 4)

/obj/item/holder/cat/cak
	origin_tech = list(TECH_BIO = 2)
	item_state = "cak"

/obj/item/holder/cat/bluespace
	origin_tech = list(TECH_BIO = 2, TECH_BLUESPACE = 6)
	item_state = "bscat"

/obj/item/holder/cat/spacecat
	origin_tech = list(TECH_BIO = 2, TECH_MATERIAL = 4)
	item_state = "spacecat"

/obj/item/holder/cat/original
	origin_tech = list(TECH_BIO = 2, TECH_BLUESPACE = 4)
	item_state = "original"

/obj/item/holder/cat/breadcat
	origin_tech = list(TECH_BIO = 2)
	item_state = "breadcat"

/obj/item/holder/corgi
	origin_tech = list(TECH_BIO = 2)
	item_state = "corgi"

/obj/item/holder/lisa
	origin_tech = list(TECH_BIO = 2)
	item_state = "lisa"

/obj/item/holder/old_corgi
	origin_tech = list(TECH_BIO = 2)
	item_state = "old_corgi"

/obj/item/holder/void_puppy
	origin_tech = list(TECH_BIO = 2, TECH_BLUESPACE = 3)
	item_state = "void_puppy"

/obj/item/holder/narsian
	origin_tech = list(TECH_BIO = 2, TECH_ILLEGAL = 3)
	item_state = "narsian"

/obj/item/holder/bullterrier
	origin_tech = list(TECH_BIO = 2)
	item_state = "bullterrier"

/obj/item/holder/fox
	origin_tech = list(TECH_BIO = 2)
	item_state = "fox"

/obj/item/holder/pug
	origin_tech = list(TECH_BIO = 2)
	item_state = "pug"

/obj/item/holder/sloth
	origin_tech = list(TECH_BIO = 2)
	item_state = "sloth"

/obj/item/holder/borer
	origin_tech = list(TECH_BIO = 6)
	item_state = "brainslug"

/obj/item/holder/leech
	color = "#003366"
	origin_tech = list(TECH_BIO = 5, TECH_PHORON = 2)

/obj/item/holder/cat/fluff/tabiranth
	name = "Spirit"
	desc = "A small, inquisitive feline, who constantly seems to investigate his surroundings."
	gender = MALE
	icon_state = "kitten"
	w_class = ITEMSIZE_SMALL

/obj/item/holder/cat/kitten
	icon_state = "kitten"
	w_class = ITEMSIZE_SMALL

/obj/item/holder/cat/fluff/bones
	name = "Bones"
	desc = "It's Bones! Meow."
	gender = MALE
	icon_state = "cat3"

/obj/item/holder/bird
	name = "bird"
	desc = "It's a bird!"
	icon_state = null
	item_icons = null
	w_class = ITEMSIZE_SMALL

/obj/item/holder/bird/Initialize()
	. = ..()
	held_mob?.lay_down()

/obj/item/holder/fish
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
		if(!issmall(H) || !ishuman(src))
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

	var/obj/item/holder/H = new holder_type(get_turf(src), src)
	grabber.put_in_hands(H)

	if(self_grab)
		to_chat(grabber, span_notice("\The [src] clambers onto you!"))
		to_chat(src, span_notice("You climb up onto \the [grabber]!"))
		grabber.equip_to_slot_if_possible(H, slot_back, 0, 1)
	else
		to_chat(grabber, span_notice("You scoop up \the [src]!"))
		to_chat(src, span_notice("\The [grabber] scoops you up!"))

	add_attack_logs(grabber, H.held_mob, "Scooped up", FALSE) // Not important enough to notify admins, but still helpful.
	return H

/obj/item/holder/human
	icon = 'icons/mob/holder_complex.dmi'
	var/list/generate_for_slots = list(slot_l_hand_str, slot_r_hand_str, slot_back_str)
	slot_flags = SLOT_BACK

/obj/item/holder/proc/sync(var/mob/living/M)
	dir = 2
	overlays.Cut()
	if(M.item_state)
		item_state = M.item_state
	color = M.color
	name = M.name
	desc = M.desc
	overlays |= M.overlays

/obj/item/holder/protoblob
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING | SLOT_HOLSTER | SLOT_ICLOTHING | SLOT_ID | SLOT_EARS
	w_class = ITEMSIZE_TINY
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/melee/baton)
	item_icons = list(
		slot_l_hand_str = 'icons/mob/lefthand_holder.dmi',
		slot_r_hand_str = 'icons/mob/righthand_holder.dmi',
		slot_head_str = 'icons/mob/head.dmi',
		slot_w_uniform_str = 'icons/mob/uniform.dmi',
		slot_wear_suit_str = 'icons/mob/suit.dmi',
		slot_r_ear_str = 'icons/mob/ears.dmi',
		slot_l_ear_str = 'icons/mob/ears.dmi')
