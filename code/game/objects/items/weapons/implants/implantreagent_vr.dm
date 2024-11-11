/obj/item/implant/reagent_generator
	name = "reagent generator implant"
	desc = "This is an implant that has attached storage and generates a reagent."
	implant_color = "r"
	var/list/generated_reagents = list("water" = 2) //Any number of reagents, the associated value is how many units are generated per process()
	var/reagent_name = "water" //What is shown when reagents are removed, doesn't need to be an actual reagent
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
	var/verb_desc = "Remove reagents from an internal reagent into a container"

/obj/item/implant/reagent_generator/New()
	..()
	create_reagents(usable_volume)

/obj/item/implanter/reagent_generator
	var/implant_type = /obj/item/implant/reagent_generator

/obj/item/implanter/reagent_generator/New()
	..()
	imp = new implant_type(src)
	update()
	return

/obj/item/implant/reagent_generator/post_implant(mob/living/carbon/source)
	START_PROCESSING(SSobj, src)
	to_chat(source, span_notice("You implant [source] with \the [src]."))
	assigned_proc = new assigned_proc(source, verb_name, verb_desc)
	return 1

/obj/item/implant/reagent_generator/process()
	var/before_gen
	if(isliving(imp_in) && generated_reagents)
		before_gen = reagents.total_volume
		var/mob/living/L = imp_in
		if(reagents.total_volume < reagents.maximum_volume)
			if(L.nutrition >= gen_cost)
				do_generation(L)
		else
			return
	else
		remove_verb(imp_in, assigned_proc)
		return

	if(reagents)
		if(reagents.total_volume == reagents.maximum_volume * 0.05)
			to_chat(imp_in, span_notice("[pick(empty_message)]"))
		else if(reagents.total_volume == reagents.maximum_volume && before_gen < reagents.maximum_volume)
			to_chat(imp_in, span_warning("[pick(full_message)]"))

/obj/item/implant/reagent_generator/proc/do_generation(var/mob/living/L)
	L.adjust_nutrition(-gen_cost)
	for(var/reagent in generated_reagents)
		reagents.add_reagent(reagent, generated_reagents[reagent])

/mob/living/carbon/human/proc/use_reagent_implant()
	set name = "Transfer From Reagent Implant"
	set desc = "Remove reagents from am internal reagent into a container."
	set category = "Object"
	set src in view(1)

	do_reagent_implant(usr)

/mob/living/carbon/human/proc/do_reagent_implant(var/mob/living/carbon/human/user = usr)
	if(!isliving(user) || !user.checkClickCooldown())
		return

	if(user.incapacitated() || user.stat > CONSCIOUS)
		return

	var/obj/item/reagent_containers/container = user.get_active_hand()
	if(!container)
		to_chat(user,span_notice("You need an open container to do this!"))
		return


	var/obj/item/implant/reagent_generator/rimplant
	for(var/obj/item/organ/external/E in organs)
		for(var/obj/item/implant/I in E.implants)
			if(istype(I, /obj/item/implant/reagent_generator))
				rimplant = I
				break
	if(rimplant)
		if(container.reagents.total_volume < container.volume)
			var/container_name = container.name
			if(rimplant.reagents.trans_to(container, amount = rimplant.transfer_amount))
				user.visible_message(span_notice("[user] [pick(rimplant.emote_descriptor)] into \the [container_name]."),
									span_notice("You [pick(rimplant.self_emote_descriptor)] some [rimplant.reagent_name] into \the [container_name]."))
				if(prob(5))
					src.visible_message(span_notice("[src] [pick(rimplant.random_emote)].")) // M-mlem.
			if(rimplant.reagents.total_volume == rimplant.reagents.maximum_volume * 0.05)
				to_chat(src, span_notice("[pick(rimplant.empty_message)]"))
