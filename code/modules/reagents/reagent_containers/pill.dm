////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/pill
	name = "pill"
	desc = "A pill."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"
	possible_transfer_amounts = null
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	volume = 60

/obj/item/weapon/reagent_containers/pill/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "pill[rand(1, 20)]"

/obj/item/weapon/reagent_containers/pill/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(!H.check_has_mouth())
				to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
				return
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
				return

			to_chat(M, "<span class='notice'>You swallow \the [src].</span>")
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
			to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
			return

		user.visible_message("<span class='warning'>[user] attempts to force [M] to swallow \the [src].</span>")

		user.setClickCooldown(user.get_attack_speed(src))
		if(!do_mob(user, M))
			return

		user.drop_from_inventory(src) //icon update
		user.visible_message("<span class='warning'>[user] forces [M] to swallow \the [src].</span>")

		var/contained = reagentlist()
		add_attack_logs(user,M,"Fed a pill containing [contained]")

		if(reagents && reagents.total_volume)
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		qdel(src)

		return 1

	return 0

/obj/item/weapon/reagent_containers/pill/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(target.is_open_container() && target.reagents)
		if(!target.reagents.total_volume)
			to_chat(user, "<span class='notice'>[target] is empty. Can't dissolve \the [src].</span>")
			return
		to_chat(user, "<span class='notice'>You dissolve \the [src] in [target].</span>")

		add_attack_logs(user,null,"Spiked [target.name] with a pill containing [reagentlist()]")

		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in viewers(2, user))
			O.show_message("<span class='warning'>[user] puts something in \the [target].</span>", 1)

		qdel(src)

	return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/weapon/reagent_containers/pill/antitox
	name = "Anti-toxins pill"
	desc = "Neutralizes many common toxins. Contains 25 units of Dylovene."
	icon_state = "pill17"

/obj/item/weapon/reagent_containers/pill/antitox/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 25)

/obj/item/weapon/reagent_containers/pill/tox
	name = "Toxins pill"
	desc = "Highly toxic." //this is cooler without "contains 50u toxin"
	icon_state = "pill5"

/obj/item/weapon/reagent_containers/pill/tox/Initialize()
	. = ..()
	reagents.add_reagent("toxin", 50)

/obj/item/weapon/reagent_containers/pill/cyanide
	name = "Cyanide pill"
	desc = "Don't swallow this." //this is cooler without "contains 50u cyanide"
	icon_state = "pill5"

/obj/item/weapon/reagent_containers/pill/cyanide/Initialize()
	. = ..()
	reagents.add_reagent("cyanide", 50)


/obj/item/weapon/reagent_containers/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's magic. We don't have to explain it." //it's space magic you don't need the quantity
	icon_state = "pill16"

/obj/item/weapon/reagent_containers/pill/adminordrazine/Initialize()
	. = ..()
	reagents.add_reagent("adminordrazine", 50)

/obj/item/weapon/reagent_containers/pill/stox
	name = "Sleeping pill"
	desc = "Commonly used to treat insomnia. Contains 15 units of Soporific."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/stox/Initialize()
	. = ..()
	reagents.add_reagent("stoxin", 15)


/obj/item/weapon/reagent_containers/pill/kelotane
	name = "Kelotane pill"
	desc = "Used to treat burns. Contains 15 units of Kelotane."
	icon_state = "pill11"

/obj/item/weapon/reagent_containers/pill/kelotane/Initialize()
	. = ..()
	reagents.add_reagent("kelotane", 15)


/obj/item/weapon/reagent_containers/pill/paracetamol
	name = "Paracetamol pill"
	desc = "Paracetamol! A painkiller for the ages. Chewables! Contains 15 units of Paracetamol."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/paracetamol/Initialize()
	. = ..()
	reagents.add_reagent("paracetamol", 15)


/obj/item/weapon/reagent_containers/pill/tramadol
	name = "Tramadol pill"
	desc = "A simple painkiller. Contains 15 units of Tramadol."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/tramadol/Initialize()
	. = ..()
	reagents.add_reagent("tramadol", 15)


/obj/item/weapon/reagent_containers/pill/methylphenidate
	name = "Methylphenidate pill"
	desc = "Improves the ability to concentrate. Contains 15 units of Methylphenidate."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/methylphenidate/Initialize()
	. = ..()
	reagents.add_reagent("methylphenidate", 15)


/obj/item/weapon/reagent_containers/pill/citalopram
	name = "Citalopram pill"
	desc = "Mild anti-depressant. Contains 15 units of Citalopram."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/citalopram/Initialize()
	. = ..()
	reagents.add_reagent("citalopram", 15)

/obj/item/weapon/reagent_containers/pill/dexalin
	name = "Dexalin pill"
	desc = "Used to treat oxygen deprivation. Contains 15 units of Dexalin."
	icon_state = "pill16"

/obj/item/weapon/reagent_containers/pill/dexalin/Initialize()
	. = ..()
	reagents.add_reagent("dexalin", 15)


/obj/item/weapon/reagent_containers/pill/dexalin_plus
	name = "Dexalin Plus pill"
	desc = "Used to treat extreme oxygen deprivation. Contains 15 units of Dexalin Plus."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/dexalin_plus/Initialize()
	. = ..()
	reagents.add_reagent("dexalinp", 15)

/obj/item/weapon/reagent_containers/pill/dermaline
	name = "Dermaline pill"
	desc = "Used to treat burn wounds. Contains 15 units of Dermaline."
	icon_state = "pill12"

/obj/item/weapon/reagent_containers/pill/dermaline/Initialize()
	. = ..()
	reagents.add_reagent("dermaline", 15)

/obj/item/weapon/reagent_containers/pill/dylovene
	name = "Dylovene pill"
	desc = "A broad-spectrum anti-toxin. Contains 15 units of Dylovene."
	icon_state = "pill13"

/obj/item/weapon/reagent_containers/pill/dylovene/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 15)

/obj/item/weapon/reagent_containers/pill/inaprovaline
	name = "Inaprovaline pill"
	desc = "Used to stabilize patients. Contains 30 units of Inaprovaline."
	icon_state = "pill20"

/obj/item/weapon/reagent_containers/pill/inaprovaline/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 30)


/obj/item/weapon/reagent_containers/pill/bicaridine
	name = "Bicaridine pill"
	desc = "Used to treat physical injuries. Contains 20 units of Bicaridine."
	icon_state = "pill18"

/obj/item/weapon/reagent_containers/pill/bicaridine/Initialize()
	. = ..()
	reagents.add_reagent("bicaridine", 20)


/obj/item/weapon/reagent_containers/pill/spaceacillin
	name = "Spaceacillin pill"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space. Contains 15 units of Spaceacillin."
	icon_state = "pill19"

/obj/item/weapon/reagent_containers/pill/spaceacillin/Initialize()
	. = ..()
	reagents.add_reagent("spaceacillin", 15)


/obj/item/weapon/reagent_containers/pill/carbon
	name = "Carbon pill"
	desc = "Used to neutralise chemicals in the stomach. Contains 15 units of Carbon."
	icon_state = "pill7"

/obj/item/weapon/reagent_containers/pill/carbon/Initialize()
	. = ..()
	reagents.add_reagent("carbon", 15)


/obj/item/weapon/reagent_containers/pill/iron
	name = "Iron pill"
	desc = "Used to aid in blood regeneration after bleeding. Contains 15 units of Iron."
	icon_state = "pill4"

/obj/item/weapon/reagent_containers/pill/iron/Initialize()
	. = ..()
	reagents.add_reagent("iron", 15)

//Not-quite-medicine
/obj/item/weapon/reagent_containers/pill/happy
	name = "Happy pill"
	desc = "Happy happy joy joy!" //we're not giving quantities for shady maint drugs
	icon_state = "pill18"

/obj/item/weapon/reagent_containers/pill/happy/Initialize()
	. = ..()
	reagents.add_reagent("space_drugs", 15)
	reagents.add_reagent("sugar", 15)


/obj/item/weapon/reagent_containers/pill/zoom
	name = "Zoom pill"
	desc = "Zoooom!"
	icon_state = "pill18"

/obj/item/weapon/reagent_containers/pill/zoom/Initialize()
	. = ..()
	reagents.add_reagent("impedrezene", 10)
	reagents.add_reagent("synaptizine", 5)
	reagents.add_reagent("hyperzine", 5)

/obj/item/weapon/reagent_containers/pill/diet
	name = "diet pill"
	desc = "Guaranteed to get you slim!"
	icon_state = "pill9"

<<<<<<< HEAD
/obj/item/weapon/reagent_containers/pill/diet/New()
	..()
	reagents.add_reagent("lipozine", 15) //VOREStation Edit
=======
/obj/item/weapon/reagent_containers/pill/diet/Initialize()
	. = ..()
	reagents.add_reagent("lipozine", 2)
>>>>>>> 46c79c7... [READY]Makes a bunch of processes subsystems instead (#5814
