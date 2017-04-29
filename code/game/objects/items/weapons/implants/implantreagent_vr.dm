/obj/item/weapon/implant/reagent_generator
	name = "reagent generator implant"
	desc = "This is an implant that has attached storage and generates a reagent."
	implant_color = "r"
	var/obj/item/weapon/reagent_containers/glass/beaker/large/internal_storage
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

/obj/item/weapon/implant/reagent_generator/New()
	..()
	internal_storage = new /obj/item/weapon/reagent_containers/glass/beaker/large (src)
	internal_storage.volume = usable_volume
	internal_storage.reagents.maximum_volume = usable_volume

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
	source.verbs |= assigned_proc
	return 1

/obj/item/weapon/implant/reagent_generator/process()
	var/before_gen
	if(imp_in && generated_reagent)
		before_gen = internal_storage.reagents.total_volume
		if(internal_storage.reagents.total_volume < internal_storage.volume)
			if(imp_in.nutrition >= gen_cost)
				do_generation()
		else
			return
	else
		imp_in.verbs -= assigned_proc
		return

	if(internal_storage)
		if(internal_storage.reagents.total_volume == internal_storage.volume * 0.05)
			to_chat(imp_in, "<span class='notice'>[pick(empty_message)]</span>")
		else if(internal_storage.reagents.total_volume == internal_storage.volume && before_gen < internal_storage.volume)
			to_chat(imp_in, "<span class='warning'>[pick(full_message)]</span>")

/obj/item/weapon/implant/reagent_generator/proc/do_generation()
	imp_in.nutrition -= gen_cost
	internal_storage.reagents.add_reagent(generated_reagent, gen_amount)

/mob/living/carbon/human/proc/use_reagent_implant()
	set name = "Transfer From Reagent Implant"
	set desc = "Remove reagents from am internal reagent into a container."
	set category = "Object"
	set src in view(1)

	do_reagent_implant()

/mob/living/carbon/human/proc/do_reagent_implant()
	if(!isliving(usr) || !usr.canClick())
		return

	if(usr.stat == 1 || (usr.restrained()))
		return

	var/mob/S = src
	var/mob/U = usr
	var/self
	if(S == U)
		self = 1

	var/mob/living/carbon/human/user = null
	if(self)
		user = src
	else
		user = usr

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
			if(rimplant.internal_storage.reagents.trans_to(container, amount = rimplant.transfer_amount))
				user.visible_message("<span class='notice'>[usr] [pick(rimplant.emote_descriptor)] into \the [container_name].</span>",
									"<span class='notice'>You [pick(rimplant.self_emote_descriptor)] some [rimplant.generated_reagent] into \the [container_name].</span>")
				if(prob(5))
					src.visible_message("<span class='notice'>[src] [pick(rimplant.random_emote)].</span>") // M-mlem.
			if(rimplant.internal_storage.reagents.total_volume == rimplant.internal_storage.volume * 0.05)
				to_chat(src, "<span class='notice'>[pick(rimplant.empty_message)]</span>")

