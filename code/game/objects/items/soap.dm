/obj/item/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/soap.dmi'
	icon_state = "soap"
	flags = NOCONDUCT
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_HOLSTER
	throwforce = 0
	throw_speed = 4
	throw_range = 20

	var/randomize = TRUE
	var/square_chance = 10
	var/cleanspeed = 35
	var/uses = 100

/obj/item/soap/Initialize(mapload)
	if(randomize && prob(square_chance))
		icon_state = "[icon_state]-alt"
	create_reagents(5)
	wet()
	. = ..()

/obj/item/soap/examine(mob/user)
	. = ..()
	var/max_uses = initial(uses)
	var/msg = "It looks like it just came out of the package."
	if(uses != max_uses)
		var/percentage_left = uses / max_uses
		switch(percentage_left)
			if(0 to 0.15)
				msg = "There's just a tiny bit left of what it used to be, you're not sure it'll last much longer."
			if(0.15 to 0.30)
				msg = "It's dissolved quite a bit, but there's still some life to it."
			if(0.30 to 0.50)
				msg = "It's past its prime, but it's definitely still good."
			if(0.50 to 0.75)
				msg = "It's started to get a little smaller than it used to be, but it'll definitely still last for a while."
			else
				msg = "It's seen some light use, but it's still pretty fresh."
	. += span_notice("[msg]")

/obj/item/soap/proc/wet()
	reagents.add_reagent(REAGENT_ID_CLEANER, 5)

/obj/item/soap/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(isliving(AM))
		var/mob/living/M =	AM
		M.slip("the [src.name]",3)

/obj/item/soap/afterattack(atom/target, mob/user as mob, proximity)
	. = ..()
	if(!proximity)
		return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		to_chat(user, span_warning("You need to take that [target.name] off before cleaning it."))
	else if(istype(target,/obj/effect/decal/cleanable))
		user.visible_message("[user] begins to scrub \the [target.name] out with [src].", span_warning("You begin to scrub \the [target.name] out with [src]..."))
		if(do_after(user, src.cleanspeed, target = target))
			to_chat(user, span_notice("You scrub \the [target.name] out."))
			qdel(target)
			decreaseUses(user)
	else if(istype(target,/turf))
		user.visible_message("[user] begins to scrub \the [target.name] out with [src].", span_warning("You begin to scrub \the [target.name] out with [src]..."))
		if(do_after(user, src.cleanspeed, target = target))
			to_chat(user, span_notice("You scrub \the [target.name] clean."))
			var/turf/T = target
			T.wash(CLEAN_SCRUB)
			reagents.trans_to_turf(T, 1, 10)
			decreaseUses(user)
	else if(ishuman(target) && user.zone_sel.selecting == O_MOUTH)
		if(target == user)
			var/mob/living/carbon/human/H = user
			to_chat(user, span_notice("You take a bite of \the [src] and swallow it."))
			reagents.trans_to_holder(H.ingested, 1)
		else
			user.visible_message(span_danger("\The [user] washes \the [target]'s mouth out with \the [src]!"))
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		decreaseUses(user, 5)
	else if(istype(target,/obj/structure/sink))
		to_chat(user, span_notice("You wet \the [src] in the sink."))
		wet()
	else
		user.visible_message("[user] begins to clean \the [target.name] with [src]...", span_notice("You begin to clean \the [target.name] with [src]..."))
		if(do_after(user, src.cleanspeed, target = target))
			target.wash(CLEAN_SCRUB)
			decreaseUses(user)
	return

/obj/item/soap/proc/decreaseUses(mob/user, var/used_up = 1)
	uses -= used_up
	if(uses <= 0)
		to_chat(user, span_warning("[src] crumbles into tiny bits!"))
		qdel(src)

/obj/item/soap/nanotrasen
	name = "Soap (Nanotrasen)"
	desc = "A NanoTrasen-brand bar of soap. Smells of phoron, a years-old marketing gimmick."
	icon_state = "soapnt"
	cleanspeed = 28
	uses = 300 // Good soap, good soap

/obj/item/soap/deluxe
	name = "Soap (Deluxe)"
	icon_state = "soapdeluxe"
	uses = 150 // Good soap
	cleanspeed = 20 // But fast too

/obj/item/soap/deluxe/Initialize(mapload)
	. = ..()
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of [pick("lavender", "vanilla", "strawberry", "chocolate" ,"space")]."

/obj/item/soap/syndie
	name = "Soap (Syndicate)"
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"
	cleanspeed = 5 // Nyoom soap

/obj/item/soap/space_soap
	name = "Soap (Space)"
	desc = "Smells like hot metal and walnuts."
	icon_state = "space_soap"

/obj/item/soap/water_soap
	name = "Soap (Pool)"
	desc = "Smells like chlorine."
	icon_state = "water_soap"

/obj/item/soap/fire_soap
	name = "Soap (Fire)"
	desc = "Smells like a campfire."
	icon_state = "fire_soap"

/obj/item/soap/rainbow_soap
	name = "Soap (Rainbow)"
	desc = "Smells sickly sweet."
	icon_state = "rainbow_soap"

/obj/item/soap/diamond_soap
	name = "Soap (Diamond)"
	desc = "Smells like saffron and vanilla."
	icon_state = "diamond_soap"

/obj/item/soap/uranium_soap
	name = "Soap (Uranium)"
	desc = "Smells not great... Not terrible."
	icon_state = "uranium_soap"

/obj/item/soap/silver_soap
	name = "Soap (Silver)"
	desc = "Smells like birch and amaranth."
	icon_state = "silver_soap"

/obj/item/soap/brown_soap
	name = "Soap (Brown)"
	desc = "Smells like cinnamon and cognac."
	icon_state = "brown_soap"

/obj/item/soap/white_soap
	name = "Soap (Nutty)"
	desc = "Smells like nutmeg and oats."
	icon_state = "white_soap"

/obj/item/soap/grey_soap
	name = "Soap (Grey)"
	desc = "Smells like bergamot and lilies."
	icon_state = "grey_soap"

/obj/item/soap/pink_soap
	name = "Soap (Gum)"
	desc = "Smells like bubblegum."
	icon_state = "pink_soap"

/obj/item/soap/purple_soap
	name = "Soap (Lavender)"
	desc = "Smells like lavender."
	icon_state = "purple_soap"

/obj/item/soap/blue_soap
	name = "Soap (Blue)"
	desc = "Smells like cardamom."
	icon_state = "blue_soap"

/obj/item/soap/cyan_soap
	name = "Soap (Berries)"
	desc = "Smells like bluebells and peaches."
	icon_state = "cyan_soap"

/obj/item/soap/green_soap
	name = "Soap (Grass)"
	desc = "Smells like a freshly mowed lawn."
	icon_state = "green_soap"

/obj/item/soap/yellow_soap
	name = "Soap (Lemon)"
	desc = "Smells like citron and ginger."
	icon_state = "yellow_soap"

/obj/item/soap/orange_soap
	name = "Soap (Orange)"
	desc = "Smells like oranges and dark chocolate."
	icon_state = "orange_soap"

/obj/item/soap/red_soap
	name = "Soap (Orange)"
	desc = "Smells like cherries."
	icon_state = "red_soap"

/obj/item/soap/golden_soap
	name = "Soap (Honey)"
	desc = "Smells like honey."
	icon_state = "golden_soap"
