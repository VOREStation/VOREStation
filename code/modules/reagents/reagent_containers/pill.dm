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

/obj/item/reagent_containers/pill/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "[base_state][rand(1, 4)]" //preset pills only use colour changing or unique icons

/obj/item/reagent_containers/pill/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		if(istype(M, /mob/living/carbon/human))
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

	else if(istype(M, /mob/living/carbon/human))

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
	name = "Dylovene (30u)" //VOREStation Edit
	desc = "Neutralizes many common toxins."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/antitox/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 30) //VOREStation Edit
	color = reagents.get_color()

/obj/item/reagent_containers/pill/tox
	name = "Toxins pill"
	desc = "Highly toxic."
	icon_state = "pill4"

/obj/item/reagent_containers/pill/tox/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_TOXIN, 50)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/cyanide
	name = "Strange pill"
	desc = "It's marked 'KCN'. Smells vaguely of almonds."
	icon_state = "pill9"

/obj/item/reagent_containers/pill/cyanide/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_CYANIDE, 50)


/obj/item/reagent_containers/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pillA"

/obj/item/reagent_containers/pill/adminordrazine/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_ADMINORDRAZINE, 5)


/obj/item/reagent_containers/pill/stox
	name = "Soporific (15u)"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/stox/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_STOXIN, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/kelotane
	name = "Kelotane (20u)" //VOREStation Edit
	desc = "Used to treat burns."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/kelotane/Initialize()
	. = ..()
	reagents.add_reagent("kelotane", 20) //VOREStation Edit
	color = reagents.get_color()

/obj/item/reagent_containers/pill/paracetamol
	name = "Paracetamol (15u)"
	desc = "Paracetamol! A painkiller for the ages. Chewables!"
	icon_state = "pill3"

/obj/item/reagent_containers/pill/paracetamol/Initialize()
	. = ..()
	reagents.add_reagent("paracetamol", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/tramadol
	name = "Tramadol (15u)"
	desc = "A simple painkiller."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/tramadol/Initialize()
	. = ..()
	reagents.add_reagent("tramadol", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/methylphenidate
	name = "Methylphenidate (15u)"
	desc = "Improves the ability to concentrate."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/methylphenidate/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_METHYLPHENIDATE, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/citalopram
	name = "Citalopram (15u)"
	desc = "Mild anti-depressant."
	icon_state = "pill4"

/obj/item/reagent_containers/pill/citalopram/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_CITALOPRAM, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/dexalin
	name = "Dexalin (7.5u)" //VOREstation Edit
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/dexalin/Initialize()
	. = ..()
	reagents.add_reagent("dexalin", 7.5) //VOREStation Edit
	color = reagents.get_color()

/obj/item/reagent_containers/pill/dexalin_plus
	name = "Dexalin Plus (15u)"
	desc = "Used to treat extreme oxygen deprivation."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/dexalin_plus/Initialize()
	. = ..()
	reagents.add_reagent("dexalinp", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/dermaline
	name = "Dermaline (15u)"
	desc = "Used to treat burn wounds."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/dermaline/Initialize()
	. = ..()
	reagents.add_reagent("dermaline", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/dylovene
	name = "Dylovene (15u)"
	desc = "A broad-spectrum anti-toxin."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/dylovene/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/inaprovaline
	name = "Inaprovaline (30u)"
	desc = "Used to stabilize patients."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/inaprovaline/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 30)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/bicaridine
	name = "Bicaridine (20u)"
	desc = "Used to treat physical injuries."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/bicaridine/Initialize()
	. = ..()
	reagents.add_reagent("bicaridine", 20)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/spaceacillin
	name = "Spaceacillin (15u)" //VOREStation Edit
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/spaceacillin/Initialize()
	. = ..()
	reagents.add_reagent("spaceacillin", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/carbon
	name = "Carbon (30u)" //VOREStation Edit
	desc = "Used to neutralise chemicals in the stomach."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/carbon/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_CARBON, 30) //VOREStation Edit
	color = reagents.get_color()

/obj/item/reagent_containers/pill/iron
	name = "Iron (30u)" //VOREStation Edit
	desc = "Used to aid in blood regeneration after bleeding for red-blooded crew."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/iron/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_IRON, 30) //VOREStation Edit
	color = reagents.get_color()

/obj/item/reagent_containers/pill/copper
	name = "Copper (30u)"
	desc = "Used to aid in blood regeneration after bleeding for blue-blooded crew."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/copper/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_COPPER, 30)
	color = reagents.get_color()

//Not-quite-medicine
/obj/item/reagent_containers/pill/happy
	name = "Happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill4"

/obj/item/reagent_containers/pill/happy/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_BLISS, 15)
	reagents.add_reagent(REAGENT_ID_SUGAR, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/zoom
	name = "Zoom pill"
	desc = "Zoooom!"
	icon_state = "pill4"

/obj/item/reagent_containers/pill/zoom/Initialize()
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

/obj/item/reagent_containers/pill/diet/Initialize()
	. = ..()
	reagents.add_reagent("lipozine", 15) //VOREStation Edit
	color = reagents.get_color()
