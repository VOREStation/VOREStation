/obj/item/analyzer
	name = "gas analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter = list(MAT_STEEL = 30,MAT_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

/obj/item/analyzer/atmosanalyze(var/mob/user)
	var/air = user.return_air()
	if (!air)
		return

	return atmosanalyzer_scan(src, air, user)

/obj/item/analyzer/attack_self(mob/user as mob)
	if (user.stat)
		return
	if (!user.IsAdvancedToolUser())
		to_chat(usr, span_warning("You don't have the dexterity to do this!"))
		return

	analyze_gases(src, user)
	return

/obj/item/analyzer/afterattack(var/obj/O, var/mob/user, var/proximity)
	if(proximity)
		analyze_gases(O, user)
	return
