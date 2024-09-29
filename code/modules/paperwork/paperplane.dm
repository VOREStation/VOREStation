// Ported from TG. Known issue: Throw hit can possibly double-proc. Seems to be throw code.
/obj/item/paperplane
	name = "paper plane"
	desc = "Paper folded into the shape of a plane."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paperplane"
	throw_range = 7
	throw_speed = 1
	throwforce = 0
	w_class = ITEMSIZE_TINY

	var/obj/item/paper/internalPaper

/obj/item/paperplane/New(loc, obj/item/paper/newPaper)
	. = ..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)
	if(newPaper)
		internalPaper = newPaper
		flags = newPaper.flags
		color = newPaper.color
		if(isstorage(newPaper.loc))
			var/obj/item/storage/S = newPaper.loc
			S.remove_from_storage(newPaper, src)
		else
			newPaper.forceMove(src)
	else
		internalPaper = new /obj/item/paper(src)
	update_icon()

/obj/item/paperplane/Destroy()
	if(internalPaper)
		qdel(internalPaper)
		internalPaper = null
	return ..()

/obj/item/paperplane/update_icon()
	cut_overlays()
	var/list/stamped = internalPaper.stamped
	if(!stamped)
		stamped = new
	else if(stamped)
		for(var/obj/item/stamp/stamp as anything in stamped)
			var/image/stampoverlay = image('icons/obj/bureaucracy.dmi', "paperplane_[initial(stamp.icon_state)]")
			add_overlay(stampoverlay)

/obj/item/paperplane/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You unfold [src].</span>")
	var/atom/movable/internal_paper_tmp = internalPaper
	internal_paper_tmp.forceMove(loc)
	internalPaper = null
	qdel(src)
	user.put_in_hands(internal_paper_tmp)

/obj/item/paperplane/attackby(obj/item/P, mob/living/carbon/human/user, params)
	..()
	if(istype(P, /obj/item/pen))
		to_chat(user, "<span class='notice'>You should unfold [src] before changing it.</span>")
		return

	else if(istype(P, /obj/item/stamp)) 	//we don't randomize stamps on a paperplane
		internalPaper.attackby(P, user) //spoofed attack to update internal paper.
		update_icon()

	else if(is_hot(P))
		if(user.disabilities & CLUMSY && prob(10))
			user.visible_message("<span class='warning'>[user] accidentally ignites themselves!</span>", \
				"<span class='userdanger'>You miss the [src] and accidentally light yourself on fire!</span>")
			user.unEquip(P)
			user.adjust_fire_stacks(1)
			user.IgniteMob()
			return

		if(!(in_range(user, src))) //to prevent issues as a result of telepathically lighting a paper
			return
		user.unEquip(src)
		user.visible_message("<span class='danger'>[user] lights [src] ablaze with [P]!</span>", "<span class='danger'>You light [src] on fire!</span>")
		fire_act()

	add_fingerprint(user)

/obj/item/paperplane/throw_impact(atom/hit_atom)
	if(..() || !ishuman(hit_atom))//if the plane is caught or it hits a nonhuman
		return
	var/mob/living/carbon/human/H = hit_atom
	if(prob(2))
		if((H.head && H.head.body_parts_covered & EYES) || (H.wear_mask && H.wear_mask.body_parts_covered & EYES) || (H.glasses && H.glasses.body_parts_covered & EYES))
			return
		visible_message("<span class='danger'>\The [src] hits [H] in the eye!</span>")
		H.eye_blurry += 10
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
		if(E)
			E.damage += 2.5
		H.emote("scream")

/obj/item/paper/AltClick(mob/living/carbon/user, obj/item/I)
	if ( istype(user) )
		if( (!in_range(src, user)) || user.stat || user.restrained() )
			return
		to_chat(user, "<span class='notice'>You fold [src] into the shape of a plane!</span>")
		user.unEquip(src)
		I = new /obj/item/paperplane(user, src)
		user.put_in_hands(I)
	else
		to_chat(user, "<span class='notice'> You lack the dexterity to fold \the [src]. </span>")
