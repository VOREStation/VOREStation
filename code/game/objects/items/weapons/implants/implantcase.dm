//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/weapon/implantcase
	name = "glass case"
	desc = "A case containing an implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-0"
	item_state = "implantcase"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_TINY
	var/obj/item/weapon/implant/imp = null

/obj/item/weapon/implantcase/proc/update()
	if (src.imp)
		src.icon_state = text("implantcase-[]", src.imp.implant_color)
	else
		src.icon_state = "implantcase-0"
	return

/obj/item/weapon/implantcase/attackby(obj/item/weapon/I as obj, mob/user as mob)
	..()
	if (istype(I, /obj/item/weapon/pen))
		var/t = tgui_input_text(user, "What would you like the label to be?", text("[]", src.name), null)
		if (user.get_active_hand() != I)
			return
		if((!in_range(src, usr) && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			src.name = text("Glass Case - '[]'", t)
		else
			src.name = "Glass Case"
	else if(istype(I, /obj/item/weapon/reagent_containers/syringe))
		if(!src.imp)	return
		if(!src.imp.allow_reagents)	return
		if(src.imp.reagents.total_volume >= src.imp.reagents.maximum_volume)
			to_chat(user, "<span class='warning'>\The [src] is full.</span>")
		else
			spawn(5)
				I.reagents.trans_to_obj(src.imp, 5)
				to_chat(user, "<span class='notice'>You inject 5 units of the solution. The syringe now contains [I.reagents.total_volume] units.</span>")
	else if (istype(I, /obj/item/weapon/implanter))
		var/obj/item/weapon/implanter/M = I
		if (M.imp)
			if ((src.imp || M.imp.implanted))
				return
			M.imp.loc = src
			src.imp = M.imp
			M.imp = null
			src.update()
			M.update()
		else
			if (src.imp)
				if (M.imp)
					return
				src.imp.loc = M
				M.imp = src.imp
				src.imp = null
				update()
			M.update()
	return


/obj/item/weapon/implantcase/tracking
	name = "glass case - 'tracking'"
	desc = "A case containing a tracking implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/tracking/New()
	src.imp = new /obj/item/weapon/implant/tracking( src )
	..()
	return


/obj/item/weapon/implantcase/explosive
	name = "glass case - 'explosive'"
	desc = "A case containing an explosive implant."
	icon_state = "implantcase-r"

/obj/item/weapon/implantcase/explosive/New()
	src.imp = new /obj/item/weapon/implant/explosive( src )
	..()
	return


/obj/item/weapon/implantcase/chem
	name = "glass case - 'chem'"
	desc = "A case containing a chemical implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/chem/New()
	src.imp = new /obj/item/weapon/implant/chem( src )
	..()
	return


/obj/item/weapon/implantcase/loyalty
	name = "glass case - 'loyalty'"
	desc = "A case containing a loyalty implant."
	icon_state = "implantcase-r"

/obj/item/weapon/implantcase/loyalty/New()
	src.imp = new /obj/item/weapon/implant/loyalty( src )
	..()
	return


/obj/item/weapon/implantcase/death_alarm
	name = "glass case - 'death alarm'"
	desc = "A case containing a death alarm implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/death_alarm/New()
	src.imp = new /obj/item/weapon/implant/death_alarm( src )
	..()
	return


/obj/item/weapon/implantcase/freedom
	name = "glass case - 'freedom'"
	desc = "A case containing a freedom implant."
	icon_state = "implantcase-r"

/obj/item/weapon/implantcase/freedom/New()
	src.imp = new /obj/item/weapon/implant/freedom( src )
	..()
	return


/obj/item/weapon/implantcase/adrenalin
	name = "glass case - 'adrenalin'"
	desc = "A case containing an adrenalin implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/adrenalin/New()
	src.imp = new /obj/item/weapon/implant/adrenalin( src )
	..()
	return


/obj/item/weapon/implantcase/dexplosive
	name = "glass case - 'explosive'"
	desc = "A case containing an explosive."
	icon_state = "implantcase-r"

/obj/item/weapon/implantcase/dexplosive/New()
	src.imp = new /obj/item/weapon/implant/dexplosive( src )
	..()
	return


/obj/item/weapon/implantcase/health
	name = "glass case - 'health'"
	desc = "A case containing a health tracking implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/health/New()
	src.imp = new /obj/item/weapon/implant/health( src )
	..()
	return

/obj/item/weapon/implantcase/language
	name = "glass case - 'GalCom'"
	desc = "A case containing a GalCom language implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/language/New()
	src.imp = new /obj/item/weapon/implant/language( src )
	..()
	return

/obj/item/weapon/implantcase/language/eal
	name = "glass case - 'EAL'"
	desc = "A case containing an Encoded Audio Language implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/language/eal/New()
	src.imp = new /obj/item/weapon/implant/language/eal( src )
	..()
	return

/obj/item/weapon/implantcase/shades
	name = "glass case - 'Integrated Shades'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/shades/New()
	src.imp = new /obj/item/weapon/implant/organ( src )
	..()
	return

/obj/item/weapon/implantcase/taser
	name = "glass case - 'Taser'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/taser/New()
	src.imp = new /obj/item/weapon/implant/organ/limbaugment( src )
	..()
	return

/obj/item/weapon/implantcase/laser
	name = "glass case - 'Laser'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/laser/New()
	src.imp = new /obj/item/weapon/implant/organ/limbaugment/laser( src )
	..()
	return

/obj/item/weapon/implantcase/dart
	name = "glass case - 'Dart'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/dart/New()
	src.imp = new /obj/item/weapon/implant/organ/limbaugment/dart( src )
	..()
	return

/obj/item/weapon/implantcase/toolkit
	name = "glass case - 'Toolkit'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/toolkit/New()
	src.imp = new /obj/item/weapon/implant/organ/limbaugment/upperarm( src )
	..()
	return

/obj/item/weapon/implantcase/medkit
	name = "glass case - 'Toolkit'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/medkit/New()
	src.imp = new /obj/item/weapon/implant/organ/limbaugment/upperarm/medkit( src )
	..()
	return

/obj/item/weapon/implantcase/surge
	name = "glass case - 'Muscle Overclocker'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/surge/New()
	src.imp = new /obj/item/weapon/implant/organ/limbaugment/upperarm/surge( src )
	..()
	return

/obj/item/weapon/implantcase/analyzer
	name = "glass case - 'Scanner'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/analyzer/New()
	src.imp = new /obj/item/weapon/implant/organ/limbaugment/wrist( src )
	..()
	return

/obj/item/weapon/implantcase/sword
	name = "glass case - 'Scanner'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/sword/New()
	src.imp = new /obj/item/weapon/implant/organ/limbaugment/wrist/sword( src )
	..()
	return

/obj/item/weapon/implantcase/sprinter
	name = "glass case - 'Sprinter'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/sprinter/New()
	src.imp = new /obj/item/weapon/implant/organ/pelvic( src )
	..()
	return

/obj/item/weapon/implantcase/armblade
	name = "glass case - 'Armblade'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/armblade/New()
	src.imp = new /obj/item/weapon/implant/organ/limbaugment/upperarm/blade( src )
	..()
	return

/obj/item/weapon/implantcase/handblade
	name = "glass case - 'Handblade'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/handblade/New()
	src.imp = new /obj/item/weapon/implant/organ/limbaugment/wrist/blade( src )
	..()
	return

/obj/item/weapon/implantcase/restrainingbolt
	name = "glass case - 'Restraining Bolt'"
	desc = "A case containing a restraining bolt."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/restrainingbolt/New()
	src.imp = new /obj/item/weapon/implant/restrainingbolt( src )
	..()
	return
