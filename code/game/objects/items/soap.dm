/obj/item/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/soap.dmi'
	icon_state = "soap"
	flags = NOCONDUCT | NOBLUDGEON
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_HOLSTER
	throwforce = 0
	throw_speed = 4
	throw_range = 20

	var/randomize = TRUE
	var/square_chance = 10
	var/cleanspeed = 35
	var/bites = 0

/obj/item/soap/Initialize(mapload)
	if(randomize && prob(square_chance))
		icon_state = "[icon_state]-alt"
	create_reagents(5)
	. = ..()

/obj/item/soap/proc/wet(var/cleaner = FALSE)
	if(cleaner)
		reagents.add_reagent(REAGENT_ID_CLEANER, 5)
	else
		reagents.add_reagent(REAGENT_ID_WATER, 5) //full of wet...

/obj/item/soap/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(isliving(AM))
		var/mob/living/M =	AM
		M.slip("\the [src.name]",3)

/obj/item/soap/afterattack(atom/target, mob/user as mob, proximity)
	. = ..()
	if(!proximity)
		return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		to_chat(user, span_warning("You need to take that [target] off before cleaning it."))
	else if(istype(target,/obj/effect/decal/cleanable))
		user.visible_message("[user] begins to scrub \the [target] out with [src].", span_warning("You begin to scrub \the [target] out with [src]..."))
		if(do_after(user, src.cleanspeed, target = target))
			to_chat(user, span_notice("You scrub \the [target] out."))
			qdel(target)
	else if(istype(target,/turf))
		if(reagents.has_reagent(REAGENT_ID_WATER, 1) || reagents.has_reagent(REAGENT_ID_CLEANER, 1))
			user.visible_message("[user] effortlessly scrubs \the [target] out with wet [src]", span_notice("You effortlessly scrub \the [target]"))
			var/turf/T = target
			T.wash(CLEAN_SCRUB)
			reagents.trans_to_turf(T, 1, 10)
			return
		user.visible_message("[user] begins to scrub \the [target] out with [src].", span_warning("You begin to scrub \the [target] out with [src]..."))
		if(do_after(user, src.cleanspeed, target = target))
			to_chat(user, span_notice("You scrub \the [target] clean."))
			var/turf/T = target
			T.wash(CLEAN_SCRUB)
			reagents.trans_to_turf(T, 1, 10)
	else if(ishuman(target) && user.zone_sel.selecting == O_MOUTH)
		if(target == user)
			var/mob/living/carbon/C = user
			user.visible_message(span_notice("[user] takes a bite out of [src]!"), span_notice("You gnaw on [src]! This can't be good for you..."))
			playsound(get_turf(C), 'sound/items/eatfood.ogg', 25, 0)
			C.ingested.add_reagent(/datum/reagent/toxin, 0.5) //normally formaldehyde, and 2 units of it. Toxin is being subsituted and is 4 times as toxic, hence a quarter of the normal amount.
			C.ingested.add_reagent(/datum/reagent/chloralhydrate, 3)
			reagents.trans_to_holder(C.ingested, 1)
			bites++
			if(bites >= 5)
				qdel(src)
		else
			user.visible_message(span_danger("\The [user] washes \the [target]'s mouth out with \the [src]!"))
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	else
		user.visible_message("[user] begins to clean \the [target.name] with [src]...", span_notice("You begin to clean \the [target.name] with [src]..."))
		if(do_after(user, src.cleanspeed, target = target))
			target.wash(CLEAN_SCRUB)
	return

/obj/item/soap/nanotrasen
	desc = ""
	icon_state = "soapnt" //janitor gets this
	cleanspeed = 28

/obj/item/soap/nanotrasen/examine(mob/user)
	. = ..()
	if(prob(1)) // Mandela effect
		. += "A heavy duty bar of Nanotrasen brand soap. Smells of plasma, a years-old marketing gimmick."
	else
		. += "A heavy duty bar of Nanotrasen brand soap. Smells of phoron, a years-old marketing gimmick."

/obj/item/soap/homemade
	desc = "A homemade bar of soap. Smells of...not much."
	icon_state = "soapgibs"
	cleanspeed = 30 // faster to reward chemists for going to the effort
	randomize = FALSE //No square sprite for it.

/obj/item/soap/deluxe
	desc =  "A deluxe Waffle Co. brand bar of soap. Smells of high-class luxury."
	icon_state = "soapdeluxe"
	cleanspeed = 20 //captain gets one of these

/obj/item/soap/syndie
	desc = "An untrustworthy bar of soap made of strong chemical agents that dissolve blood faster. Smells of fear."
	icon_state = "soapsyndie"
	cleanspeed = 5 //faster than mop so it is useful for traitors who want to clean crime scenes

/obj/item/soap/space_soap
	desc = "A space-like bar of soap. Smells like hot metal and walnuts."
	icon_state = "space_soap"

/obj/item/soap/water_soap
	desc = "A watery bar of soap. Smells like chlorine."
	icon_state = "water_soap"

/obj/item/soap/fire_soap
	desc = "A firey bar of soap. Smells like a campfire."
	icon_state = "fire_soap"

/obj/item/soap/rainbow_soap
	desc = "A rainbow bar of soap. Smells sickly sweet."
	icon_state = "rainbow_soap"

/obj/item/soap/diamond_soap
	desc = "A diamond-like bar of soap. Smells like saffron and vanilla."
	icon_state = "diamond_soap"

/obj/item/soap/uranium_soap
	desc = "An irradiated bar of soap. Smells not great... Not terrible."
	icon_state = "uranium_soap"

/obj/item/soap/silver_soap
	desc = "A silvery bar of soap. Smells like birch and amaranth."
	icon_state = "silver_soap"

/obj/item/soap/brown_soap
	desc = "A brown bar of soap. Smells like cinnamon and cognac."
	icon_state = "brown_soap"

/obj/item/soap/white_soap
	desc = "A white bar of soap. Smells like nutmeg and oats."
	icon_state = "white_soap"

/obj/item/soap/grey_soap
	desc = "A grey bar of soap. Smells like bergamot and lilies."
	icon_state = "grey_soap"

/obj/item/soap/pink_soap
	desc = "A pink bar of soap. Smells like bubblegum."
	icon_state = "pink_soap"

/obj/item/soap/purple_soap
	desc = "A purple bar of soap. Smells like lavender."
	icon_state = "purple_soap"

/obj/item/soap/blue_soap
	desc = "A blue bar of soap. Smells like cardamom."
	icon_state = "blue_soap"

/obj/item/soap/cyan_soap
	desc = "A cyan bar of soap. Smells like bluebells and peaches."
	icon_state = "cyan_soap"

/obj/item/soap/green_soap
	desc = "A green bar of soap. Smells like a freshly mowed lawn."
	icon_state = "green_soap"

/obj/item/soap/yellow_soap
	desc = "A yellow bar of soap. Smells like citron and ginger."
	icon_state = "yellow_soap"

/obj/item/soap/orange_soap
	desc = "An orange bar of soap. Smells like oranges and dark chocolate."
	icon_state = "orange_soap"

/obj/item/soap/red_soap
	desc = "A red bar of soap. Smells like cherries."
	icon_state = "red_soap"

/obj/item/soap/golden_soap
	desc = "A golden bar of soap. Smells like honey."
	icon_state = "golden_soap"
