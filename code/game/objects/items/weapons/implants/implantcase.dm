//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implantcase
	name = "glass case"
	desc = "A case containing an implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-0"
	item_state = "implantcase"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_TINY
	var/obj/item/implant/imp = null

/obj/item/implantcase/proc/update()
	if (imp)
		icon_state = text("implantcase-[]", imp.implant_color)
	else
		icon_state = "implantcase-0"
	return

/obj/item/implantcase/attackby(obj/item/I as obj, mob/user as mob)
	..()
	if (istype(I, /obj/item/pen))
		var/t = tgui_input_text(user, "What would you like the label to be?", text("[]", name), null, MAX_NAME_LEN)
		if (user.get_active_hand() != I)
			return
		if((!in_range(src, user) && loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			name = text("Glass Case - '[]'", t)
		else
			name = "Glass Case"
	else if(istype(I, /obj/item/reagent_containers/syringe))
		if(!imp)	return
		if(!imp.allow_reagents)	return
		if(imp.reagents.total_volume >= imp.reagents.maximum_volume)
			to_chat(user, span_warning("\The [src] is full."))
		else
			spawn(5)
				I.reagents.trans_to_obj(imp, 5)
				to_chat(user, span_notice("You inject 5 units of the solution. The syringe now contains [I.reagents.total_volume] units."))
	else if (istype(I, /obj/item/implanter))
		var/obj/item/implanter/M = I
		if (M.imp)
			if ((imp || M.imp.implanted))
				return
			M.imp.loc = src
			imp = M.imp
			M.imp = null
			update()
			M.update()
		else
			if (imp)
				if (M.imp)
					return
				imp.loc = M
				M.imp = imp
				imp = null
				update()
			M.update()
	return


/obj/item/implantcase/tracking
	name = "glass case - 'tracking'"
	desc = "A case containing a tracking implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/tracking/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/tracking(src)


/obj/item/implantcase/explosive
	name = "glass case - 'explosive'"
	desc = "A case containing an explosive implant."
	icon_state = "implantcase-r"

/obj/item/implantcase/explosive/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/explosive(src)


/obj/item/implantcase/chem
	name = "glass case - 'chem'"
	desc = "A case containing a chemical implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/chem/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/chem(src)


/obj/item/implantcase/loyalty
	name = "glass case - 'loyalty'"
	desc = "A case containing a loyalty implant."
	icon_state = "implantcase-r"

/obj/item/implantcase/loyalty/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/loyalty(src)


/obj/item/implantcase/death_alarm
	name = "glass case - 'death alarm'"
	desc = "A case containing a death alarm implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/death_alarm/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/death_alarm(src)


/obj/item/implantcase/freedom
	name = "glass case - 'freedom'"
	desc = "A case containing a freedom implant."
	icon_state = "implantcase-r"

/obj/item/implantcase/freedom/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/freedom(src)


/obj/item/implantcase/adrenalin
	name = "glass case - 'adrenalin'"
	desc = "A case containing an adrenalin implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/adrenalin/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/adrenalin(src)


/obj/item/implantcase/dexplosive
	name = "glass case - 'explosive'"
	desc = "A case containing an explosive."
	icon_state = "implantcase-r"

/obj/item/implantcase/dexplosive/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/dexplosive(src)


/obj/item/implantcase/health
	name = "glass case - 'health'"
	desc = "A case containing a health tracking implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/health/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/health(src)

/obj/item/implantcase/language
	name = "glass case - 'GalCom'"
	desc = "A case containing a GalCom language implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/language/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/language(src)

/obj/item/implantcase/language/eal
	name = "glass case - 'EAL'"
	desc = "A case containing an Encoded Audio Language implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/language/eal/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/language/eal(src)

/obj/item/implantcase/shades
	name = "glass case - 'Integrated Shades'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/shades/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/organ(src)

/obj/item/implantcase/taser
	name = "glass case - 'Taser'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/taser/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/organ/limbaugment(src)

/obj/item/implantcase/laser
	name = "glass case - 'Laser'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/laser/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/organ/limbaugment/laser(src)

/obj/item/implantcase/dart
	name = "glass case - 'Dart'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/dart/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/organ/limbaugment/dart(src)

/obj/item/implantcase/toolkit
	name = "glass case - 'Toolkit'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/toolkit/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/organ/limbaugment/upperarm(src)

/obj/item/implantcase/medkit
	name = "glass case - 'Toolkit'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/medkit/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/organ/limbaugment/upperarm/medkit(src)

/obj/item/implantcase/surge
	name = "glass case - 'Muscle Overclocker'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/surge/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/organ/limbaugment/upperarm/surge(src)

/obj/item/implantcase/analyzer
	name = "glass case - 'Scanner'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/analyzer/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/organ/limbaugment/wrist(src)

/obj/item/implantcase/sword
	name = "glass case - 'Scanner'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/sword/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/organ/limbaugment/wrist/sword(src)

/obj/item/implantcase/sprinter
	name = "glass case - 'Sprinter'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/sprinter/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/organ/pelvic(src)

/obj/item/implantcase/armblade
	name = "glass case - 'Armblade'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/armblade/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/organ/limbaugment/upperarm/blade(src)

/obj/item/implantcase/handblade
	name = "glass case - 'Handblade'"
	desc = "A case containing a nanite fabricator implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/handblade/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/organ/limbaugment/wrist/blade(src)

/obj/item/implantcase/restrainingbolt
	name = "glass case - 'Restraining Bolt'"
	desc = "A case containing a restraining bolt."
	icon_state = "implantcase-b"

/obj/item/implantcase/restrainingbolt/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/restrainingbolt(src)
