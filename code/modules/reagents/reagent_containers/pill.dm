////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/pill
	name = "pill"
	desc = "A pill."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

	var/base_state = "pill"

	possible_transfer_amounts = null
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	volume = 60

/obj/item/reagent_containers/pill/Initialize(mapload)
	. = ..()
	if(!icon_state)
		icon_state = "[base_state][rand(1, 4)]" //preset pills only use colour changing or unique icons

/obj/item/reagent_containers/pill/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.check_has_mouth())
				to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
				return
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				to_chat(user, span_warning("\The [blocked] is in the way!"))
				return

			to_chat(M, span_notice("You swallow \the [src]."))
			M.drop_from_inventory(src) //icon update
			if(reagents.total_volume)
				reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
			qdel(src)
			return 1

	else if(ishuman(M))

		var/mob/living/carbon/human/H = M
		if(!H.check_has_mouth())
			to_chat(user, "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!")
			return
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(user, span_warning("\The [blocked] is in the way!"))
			return

		user.visible_message(span_warning("[user] attempts to force [M] to swallow \the [src]."))

		user.setClickCooldown(user.get_attack_speed(src))
		if(!do_mob(user, M))
			return

		user.drop_from_inventory(src) //icon update
		user.visible_message(span_warning("[user] forces [M] to swallow \the [src]."))

		var/contained = reagentlist()
		add_attack_logs(user,M,"Fed a pill containing [contained]")

		if(reagents && reagents.total_volume)
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		qdel(src)

		return 1

	return 0

/obj/item/reagent_containers/pill/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(target.is_open_container() && target.reagents)
		if(!target.reagents.total_volume)
			to_chat(user, span_notice("[target] is empty. Can't dissolve \the [src]."))
			return
		to_chat(user, span_notice("You dissolve \the [src] in [target]."))

		add_attack_logs(user,null,"Spiked [target.name] with a pill containing [reagentlist()]")

		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in viewers(2, user))
			O.show_message(span_warning("[user] puts something in \the [target]."), 1)

		qdel(src)

	return

/obj/item/reagent_containers/pill/attackby(obj/item/W as obj, mob/user as mob)
	if(is_sharp(W))
		var/obj/item/reagent_containers/powder/J = new /obj/item/reagent_containers/powder(src.loc)
		user.visible_message(span_warning("[user] gently cuts up [src] with [W]!"))
		playsound(src.loc, 'sound/effects/chop.ogg', 50, 1)

		if(reagents)
			reagents.trans_to_obj(J, reagents.total_volume)
		J.get_appearance()
		qdel(src)

	if(istype(W, /obj/item/card/id))
		var/obj/item/reagent_containers/powder/J = new /obj/item/reagent_containers/powder(src.loc)
		user.visible_message(span_warning("[user] clumsily chops up [src] with [W]!"))
		playsound(src.loc, 'sound/effects/chop.ogg', 50, 1)

		if(reagents)
			reagents.trans_to_obj(J, reagents.total_volume)
		J.get_appearance()
		qdel(src)

	return ..()

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/reagent_containers/pill/antitox
	name = REAGENT_ANTITOXIN + " (30u)"
	desc = "Neutralizes many common toxins."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/antitox/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_ANTITOXIN, 30)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/tox
	name = "Toxins pill"
	desc = "Highly toxic."
	icon_state = "pill4"

/obj/item/reagent_containers/pill/tox/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_TOXIN, 50)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/cyanide
	name = "Strange pill"
	desc = "It's marked 'KCN'. Smells vaguely of almonds."
	icon_state = "pill9"

/obj/item/reagent_containers/pill/cyanide/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CYANIDE, 50)


/obj/item/reagent_containers/pill/adminordrazine
	name = REAGENT_ADMINORDRAZINE + " pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pillA"

/obj/item/reagent_containers/pill/adminordrazine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_ADMINORDRAZINE, 5)


/obj/item/reagent_containers/pill/stox
	name = REAGENT_STOXIN + " (15u)"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/stox/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_STOXIN, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/kelotane
	name = REAGENT_KELOTANE + " (20u)"
	desc = "Used to treat burns."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/kelotane/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_KELOTANE, 20)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/paracetamol
	name = REAGENT_PARACETAMOL + " (15u)"
	desc = REAGENT_PARACETAMOL + "! A painkiller for the ages. Chewables!"
	icon_state = "pill3"

/obj/item/reagent_containers/pill/paracetamol/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PARACETAMOL, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/tramadol
	name = REAGENT_TRAMADOL + " (15u)"
	desc = "A simple painkiller."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/tramadol/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_TRAMADOL, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/methylphenidate
	name = REAGENT_METHYLPHENIDATE + " (15u)"
	desc = "Improves the ability to concentrate."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/methylphenidate/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_METHYLPHENIDATE, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/citalopram
	name = REAGENT_CITALOPRAM + " (15u)"
	desc = "Mild anti-depressant."
	icon_state = "pill4"

/obj/item/reagent_containers/pill/citalopram/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CITALOPRAM, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/dexalin
	name = REAGENT_DEXALIN + " (7.5u)"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/dexalin/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_DEXALIN, 7.5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/dexalin_plus
	name = REAGENT_DEXALINP + " (15u)"
	desc = "Used to treat extreme oxygen deprivation."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/dexalin_plus/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_DEXALINP, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/dermaline
	name = REAGENT_DERMALINE + " (15u)"
	desc = "Used to treat burn wounds."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/dermaline/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_DERMALINE, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/dylovene
	name = REAGENT_ANTITOXIN + " (15u)"
	desc = "A broad-spectrum anti-toxin."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/dylovene/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_ANTITOXIN, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/inaprovaline
	name = REAGENT_INAPROVALINE + " (30u)"
	desc = "Used to stabilize patients."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/inaprovaline/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_INAPROVALINE, 30)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/bicaridine
	name = REAGENT_BICARIDINE + " (20u)"
	desc = "Used to treat physical injuries."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/bicaridine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_BICARIDINE, 20)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/spaceacillin
	name = REAGENT_SPACEACILLIN + " (15u)"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/spaceacillin/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SPACEACILLIN, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/carbon
	name = REAGENT_CARBON + " (30u)"
	desc = "Used to neutralise chemicals in the stomach."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/carbon/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CARBON, 30)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/iron
	name = REAGENT_IRON + " (30u)"
	desc = "Used to aid in blood regeneration after bleeding for red-blooded crew."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/iron/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_IRON, 30)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/copper
	name = REAGENT_COPPER + " (30u)"
	desc = "Used to aid in blood regeneration after bleeding for blue-blooded crew."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/copper/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_COPPER, 30)
	color = reagents.get_color()

//Not-quite-medicine
/obj/item/reagent_containers/pill/happy
	name = "Happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill4"

/obj/item/reagent_containers/pill/happy/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_BLISS, 15)
	reagents.add_reagent(REAGENT_ID_SUGAR, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/zoom
	name = "Zoom pill"
	desc = "Zoooom!"
	icon_state = "pill4"

/obj/item/reagent_containers/pill/zoom/Initialize(mapload)
	. = ..()
	if(prob(50))						//VOREStation edit begin: Zoom pill adjustments
		reagents.add_reagent(REAGENT_ID_MOLD, 2)	//Chance to be more dangerous
	reagents.add_reagent(REAGENT_ID_EXPIREDMEDICINE, 5)
	reagents.add_reagent(REAGENT_ID_STIMM, 5)	//VOREStation edit end: Zoom pill adjustments
	color = reagents.get_color()

/obj/item/reagent_containers/pill/diet
	name = "diet pill"
	desc = "Guaranteed to get you slim!"
	icon_state = "pill4"

/obj/item/reagent_containers/pill/diet/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_LIPOZINE, 15)
	color = reagents.get_color()

// DISPENSER PILLS!
// These are smaller variants of pills that the medical kiosk gives!
/obj/item/reagent_containers/pill/small_blood_restoration
	name = "blood restoration pill"
	desc = "Used to aid in blood regeneration after or during bleeding for crew with commonly found blood types."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/small_blood_restoration/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_IRON, 5)
	reagents.add_reagent(REAGENT_ID_COPPER, 5)
	reagents.add_reagent(REAGENT_ID_SILVER, 5)
	reagents.add_reagent(REAGENT_ID_GOLD, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/small_inaprovaline
	name = REAGENT_INAPROVALINE + " (5u)"
	desc = "Used to stabilize patients."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/small_inaprovaline/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_INAPROVALINE, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/small_prussian_blue
	name = REAGENT_PRUSSIANBLUE + " (5u)"
	desc = "Used for the temporary cessation of radiation effects."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/small_prussian_blue/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PRUSSIANBLUE, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/small_tramadol
	name = REAGENT_TRAMADOL + " (5u)"
	desc = "A reelatively moderate painkiller typically given for more severe injuries."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/small_tramadol/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_TRAMADOL, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/small_paracetamol
	name = REAGENT_PARACETAMOL + " (5u)"
	desc = "A rather weak painkiller typically given for minor injuries."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/small_paracetamol/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PARACETAMOL, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/small_dylovene
	name = REAGENT_ANTITOXIN + " (5u)"
	desc = "A broad-spectrum anti-toxin."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/small_dylovene/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_ANTITOXIN, 5)
	color = reagents.get_color()
