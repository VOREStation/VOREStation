/obj/item/weapon/implant/reagent_generator
	name = "reagent generator implant"
	desc = "This is an implant that has attached storage and generates a reagent."
	implant_color = "r"
	var/datum/reagent/generated_reagent = null
	var/gen_amount = 2 //amount of reagent generated per process tick
	var/gen_cost = 0.5 //amount of nutrient taken from the host per process tick
	var/transfer_amount = 30 //amount transferred when using verb
	var/usable_volume = 120

	var/list/empty_message = list("You feel as though your internal reagent implant is almost empty.")
	var/list/full_message = "You feel as though your internal reagent implant is full."
	var/list/emote_descriptor = list("tranfers something") //In format of [x] [emote_descriptor] into [container]
	var/list/self_emote_descriptor = list("transfer") //In format of You [self_emote_descriptor] some [generated_reagent] into [container]
	var/list/random_emote = list() //An emote the person with the implant may be forced to perform after a prob check, such as [X] meows.
	var/assigned_proc = /mob/living/carbon/human/proc/use_reagent_implant
	var/verb_name = "Transfer From Reagent Implant"
	var/verb_desc = "Remove reagents from am internal reagent into a container"

/obj/item/weapon/implant/reagent_generator/New()
	..()
	create_reagents(usable_volume)

/obj/item/weapon/implanter/reagent_generator
	var/implant_type = /obj/item/weapon/implant/reagent_generator

/obj/item/weapon/implanter/reagent_generator/New()
	..()
	imp = new implant_type(src)
	update()
	return

/obj/item/weapon/implant/reagent_generator/implanted(mob/living/carbon/source)
	processing_objects += src
	to_chat(source, "<span class='notice'>You implant [source] with \the [src].</span>")
	assigned_proc = new assigned_proc(source, verb_name, verb_desc)
	return 1

/obj/item/weapon/implant/reagent_generator/process()
	var/before_gen
	if(imp_in && generated_reagent)
		before_gen = reagents.total_volume
		if(reagents.total_volume < reagents.maximum_volume)
			if(imp_in.nutrition >= gen_cost)
				do_generation()
		else
			return
	else
		imp_in.verbs -= assigned_proc
		return

	if(reagents)
		if(reagents.total_volume == reagents.maximum_volume * 0.05)
			to_chat(imp_in, "<span class='notice'>[pick(empty_message)]</span>")
		else if(reagents.total_volume == reagents.maximum_volume && before_gen < reagents.maximum_volume)
			to_chat(imp_in, "<span class='warning'>[pick(full_message)]</span>")

/obj/item/weapon/implant/reagent_generator/proc/do_generation()
	imp_in.nutrition -= gen_cost
	reagents.add_reagent(generated_reagent, gen_amount)

/mob/living/carbon/human/proc/use_reagent_implant()
	set name = "Transfer From Reagent Implant"
	set desc = "Remove reagents from am internal reagent into a container."
	set category = "Object"
	set src in view(1)

	do_reagent_implant(usr)

/mob/living/carbon/human/proc/do_reagent_implant(var/mob/living/carbon/human/user = usr)
	if(!isliving(user) || !user.canClick())
		return

	if(user.incapacitated() || user.stat > CONSCIOUS)
		return

	var/obj/item/weapon/reagent_containers/container = user.get_active_hand()
	if(!container)
		to_chat(user,"<span class='notice'>You need an open container to do this!</span>")
		return


	var/obj/item/weapon/implant/reagent_generator/rimplant
	for(var/I in src.contents)
		if(istype(I, /obj/item/weapon/implant/reagent_generator))
			rimplant = I
			break
	if(rimplant)
		if(container.reagents.total_volume < container.volume)
			var/container_name = container.name
			if(rimplant.reagents.trans_to(container, amount = rimplant.transfer_amount))
				user.visible_message("<span class='notice'>[usr] [pick(rimplant.emote_descriptor)] into \the [container_name].</span>",
									"<span class='notice'>You [pick(rimplant.self_emote_descriptor)] some [rimplant.generated_reagent] into \the [container_name].</span>")
				if(prob(5))
					src.visible_message("<span class='notice'>[src] [pick(rimplant.random_emote)].</span>") // M-mlem.
			if(rimplant.reagents.total_volume == rimplant.reagents.maximum_volume * 0.05)
				to_chat(src, "<span class='notice'>[pick(rimplant.empty_message)]</span>")



/obj/item/weapon/implant/reagent_generator/scannable
	name = "scannable reagent generator implant"
	desc = "This is an implant that has attached storage and generates a scanned reagent."
	gen_amount = 0.2 //This is extremely powerful and, as such, has a long time to create reagents
	gen_cost = 10 //And an extremely high cost to make reagents. 1000 nutrition to go from nothing from full in 100 ticks.
	transfer_amount = 20
	usable_volume = 20 //Can't hold much, either.
	generated_reagent = "water" //Placeholder reagent until the person selects a new reagent.
	var/assigned_proc2 = /mob/living/carbon/human/proc/scan_reagent_with_implant
	var/verb_name2 = "Scan reagent with implant"
	var/verb_desc2 = "Scans a reagent in a container and begins to synthetsise it."


/obj/item/weapon/implant/reagent_generator/scannable/implanted(mob/living/carbon/source)
	processing_objects += src
	to_chat(source, "<span class='notice'>You implant [source] with \the [src].</span>")
	assigned_proc = new assigned_proc(source, verb_name, verb_desc)
	assigned_proc2 = new assigned_proc2(source, verb_name2, verb_desc2)
	return 1

/obj/item/weapon/implant/reagent_generator/scannable/process()
	var/before_gen
	if(imp_in && generated_reagent)
		before_gen = reagents.total_volume
		if(reagents.total_volume < reagents.maximum_volume)
			if(imp_in.nutrition >= gen_cost)
				do_generation()
		else
			return
	else
		imp_in.verbs -= assigned_proc
		imp_in.verbs -= assigned_proc2
		return

	if(reagents)
		if(reagents.total_volume == reagents.maximum_volume * 0.05)
			to_chat(imp_in, "<span class='notice'>[pick(empty_message)]</span>")
		else if(reagents.total_volume == reagents.maximum_volume && before_gen < reagents.maximum_volume)
			to_chat(imp_in, "<span class='warning'>[pick(full_message)]</span>")

/mob/living/carbon/human/proc/scan_reagent_with_implant()
	set name = "Scan reagent and begin synthesis"
	set desc = "Scan a container and begin internal synthesis of the reagent that is the majority of the container."
	set category = "Object"
	set src in view(1)

	do_reagent_scan(usr)



/mob/living/carbon/human/proc/do_reagent_scan(var/mob/living/carbon/human/user = usr)
	if(!isliving(user) || !user.canClick())
		return

	if(user.incapacitated() || user.stat > CONSCIOUS)
		return

	var/obj/item/weapon/reagent_containers/container = user.get_active_hand()
	if(!container)
		to_chat(user,"<span class='notice'>You need an open container in your hand to do this!</span>")
		return


	var/obj/item/weapon/implant/reagent_generator/scannable/rimplant
	for(var/I in src.contents)
		if(istype(I, /obj/item/weapon/implant/reagent_generator/scannable))
			rimplant = I
			break
	if(rimplant)
		if(!container.reagents) //This should only apply to things that can't hold reagents.
			to_chat(user,"<span class='notice'>The container must have one single, pure, liquid reagent inside of it to scan.</span>")
			return
		var/datum/reagent/R = container.reagents.get_master_reagent()
		if(R.reagent_state != 2)
			to_chat(user,"<span class='notice'>The reagent inside the beaker must be a liquid.</span>")
			return
		var/datum/reagent/R_ID = container.reagents.get_master_reagent_id()
		var/datum/reagent/R_NAME = container.reagents.get_master_reagent_name()
		rimplant.reagents.clear_reagents() //Clear out the reagents list, first.
		rimplant.generated_reagent = R_ID
		to_chat(user,"<span class='notice'>You scan the reagent inside the container. You will now begin synthesising [R_NAME].</span>")
		rimplant.reagents.total_volume = 0 //Let's reset the reagents current volume.

/obj/item/weapon/implanter/reagent_generator/scannable
	implant_type = /obj/item/weapon/implant/reagent_generator/scannable