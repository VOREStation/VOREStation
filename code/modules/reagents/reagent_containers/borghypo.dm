/obj/item/reagent_containers/borghypo
	name = "cyborg hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "borghypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null

	var/mode = 1
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in seconds)
	var/bypass_protection = FALSE // If true, can inject through things like spacesuits and armor.

	var/list/reagent_ids = list("tricordrazine", "inaprovaline", "anti_toxin", "tramadol", "dexalin" ,"spaceacillin")
	var/list/reagent_volumes = list()
	var/list/reagent_names = list()

/obj/item/reagent_containers/borghypo/surgeon
	reagent_ids = list("inaprovaline", "dexalin", "tricordrazine", "spaceacillin", "oxycodone")

/obj/item/reagent_containers/borghypo/crisis
	reagent_ids = list("inaprovaline", "bicaridine", "kelotane", "anti_toxin", "dexalin", "tricordrazine", "spaceacillin", "tramadol")

/obj/item/reagent_containers/borghypo/lost
	reagent_ids = list("tricordrazine", "bicaridine", "dexalin", "anti_toxin", "tramadol", "spaceacillin")

/obj/item/reagent_containers/borghypo/merc
	name = "advanced cyborg hypospray"
	desc = "An advanced nanite and chemical synthesizer and injection system, designed for heavy-duty medical equipment.  This type is capable of safely bypassing \
	thick materials that other hyposprays would struggle with."
	bypass_protection = TRUE // Because mercs tend to be in spacesuits.
	reagent_ids = list("healing_nanites", "hyperzine", "tramadol", "oxycodone", "spaceacillin", "peridaxon", "osteodaxon", "myelamine", "synthblood")

/obj/item/reagent_containers/borghypo/Initialize()
	. = ..()

	for(var/T in reagent_ids)
		reagent_volumes[T] = volume
		var/datum/reagent/R = SSchemistry.chemical_reagents[T]
		reagent_names += R.name

	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/borghypo/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/reagent_containers/borghypo/process() //Every [recharge_time] seconds, recharge some reagents for the cyborg+
	if(++charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R && R.cell)
			for(var/T in reagent_ids)
				if(reagent_volumes[T] < volume)
					R.cell.use(charge_cost)
					reagent_volumes[T] = min(reagent_volumes[T] + 5, volume)
	return 1

/obj/item/reagent_containers/borghypo/attack(var/mob/living/M, var/mob/user)
	if(!istype(M))
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, span_warning("The injector is empty."))
		return

	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
		if(!affected)
			to_chat(user, span_danger("\The [H] is missing that limb!"))
			return
		/* since synths have oil/coolant streams now, it only makes sense that you should be able to inject stuff. preserved for posterity.
		else if(affected.robotic >= ORGAN_ROBOT)
			to_chat(user, span_danger("You cannot inject a robotic limb."))
			return
		*/

	if(M.can_inject(user, 1, ignore_thickness = bypass_protection))
		to_chat(user, span_notice("You inject [M] with the injector."))
		to_chat(M, span_notice("You feel a tiny prick!"))

		if(M.reagents)
			var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
			M.reagents.add_reagent(reagent_ids[mode], t)
			reagent_volumes[reagent_ids[mode]] -= t
			add_attack_logs(user, M, "Borg injected with [reagent_ids[mode]]")
			to_chat(user, span_notice("[t] units injected. [reagent_volumes[reagent_ids[mode]]] units remaining."))
	return

/obj/item/reagent_containers/borghypo/attack_self(mob/user as mob) //Change the mode
	var/t
	for(var/i = 1 to reagent_ids.len)
		if(t)
			t += ", "
		if(mode == i)
			t += span_bold("[reagent_names[i]]")
		else
			t += "<a href='?src=\ref[src];reagent=[reagent_ids[i]]'>[reagent_names[i]]</a>"
	t = "Available reagents: [t]."
	to_chat(user,span_infoplain(t))

	return

/obj/item/reagent_containers/borghypo/Topic(var/href, var/list/href_list)
	if(href_list["reagent"])
		var/t = reagent_ids.Find(href_list["reagent"])
		if(t)
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			mode = t
			var/datum/reagent/R = SSchemistry.chemical_reagents[reagent_ids[mode]]
			to_chat(usr, span_notice("Synthesizer is now producing '[R.name]'."))

/obj/item/reagent_containers/borghypo/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		var/datum/reagent/R = SSchemistry.chemical_reagents[reagent_ids[mode]]
		. += span_notice("It is currently producing [R.name] and has [reagent_volumes[reagent_ids[mode]]] out of [volume] units left.")

/obj/item/reagent_containers/borghypo/service
	name = "cyborg drink synthesizer"
	desc = "A portable drink dispencer."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"
	charge_cost = 20
	recharge_time = 3
	volume = 60
	possible_transfer_amounts = list(5, 10, 20, 30)
	reagent_ids = list("ale",
		"beer",
		"berryjuice",
		"bitters",
		"cider",
		"coffee",
		"cognac",
		"cola",
		"cream",
		"dr_gibb",
		"egg",
		"gin",
		"gingerale",
		"hot_coco",
		"ice",
		"icetea",
		"kahlua",
		"lemonjuice",
		"lemon_lime",
		"limejuice",
		"mead",
		"milk",
		"mint",
		"orangejuice",
		"redwine",
		"rum",
		"sake",
		"sodawater",
		"soymilk",
		"space_up",
		"spacemountainwind",
		"spacespice",
		"specialwhiskey",
		"sugar",
		"tea",
		"tequilla",
		"tomatojuice",
		"tonic",
		"vermouth",
		"vodka",
		"water",
		"watermelonjuice",
		"whiskey")

/obj/item/reagent_containers/borghypo/service/attack(var/mob/M, var/mob/user)
	return

/obj/item/reagent_containers/borghypo/service/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return

	if(!target.is_open_container() || !target.reagents)
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, span_notice("[src] is out of this reagent, give it some time to refill."))
		return

	if(!target.reagents.get_free_space())
		to_chat(user, span_notice("[target] is full."))
		return

	var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
	target.reagents.add_reagent(reagent_ids[mode], t)
	reagent_volumes[reagent_ids[mode]] -= t
	to_chat(user, span_notice("You transfer [t] units of the solution to [target]."))
	return
