/obj/item/weapon/reagent_containers/borghypo
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

/obj/item/weapon/reagent_containers/borghypo/surgeon
	reagent_ids = list("tricordrazine", "inaprovaline", "oxycodone", "dexalin" ,"spaceacillin")

/obj/item/weapon/reagent_containers/borghypo/crisis
	reagent_ids = list("tricordrazine", "inaprovaline", "anti_toxin", "tramadol", "dexalin" ,"spaceacillin")

/obj/item/weapon/reagent_containers/borghypo/lost
	reagent_ids = list("tricordrazine", "bicaridine", "dexalin", "anti_toxin", "tramadol", "spaceacillin")

/obj/item/weapon/reagent_containers/borghypo/merc
	name = "advanced cyborg hypospray"
	desc = "An advanced nanite and chemical synthesizer and injection system, designed for heavy-duty medical equipment.  This type is capable of safely bypassing \
	thick materials that other hyposprays would struggle with."
	bypass_protection = TRUE // Because mercs tend to be in spacesuits.
	reagent_ids = list("healing_nanites", "hyperzine", "tramadol", "oxycodone", "spaceacillin", "peridaxon", "osteodaxon", "myelamine", "synthblood")

/obj/item/weapon/reagent_containers/borghypo/Initialize()
	. = ..()

	for(var/T in reagent_ids)
		reagent_volumes[T] = volume
		var/datum/reagent/R = SSchemistry.chemical_reagents[T]
		reagent_names += R.name

	START_PROCESSING(SSobj, src)

/obj/item/weapon/reagent_containers/borghypo/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/reagent_containers/borghypo/process() //Every [recharge_time] seconds, recharge some reagents for the cyborg+
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

/obj/item/weapon/reagent_containers/borghypo/attack(var/mob/living/M, var/mob/user)
	if(!istype(M))
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, "<span class='warning'>The injector is empty.</span>")
		return

	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
		if(!affected)
			to_chat(user, "<span class='danger'>\The [H] is missing that limb!</span>")
			return
		else if(affected.robotic >= ORGAN_ROBOT)
			to_chat(user, "<span class='danger'>You cannot inject a robotic limb.</span>")
			return

	if(M.can_inject(user, 1, ignore_thickness = bypass_protection))
		to_chat(user, "<span class='notice'>You inject [M] with the injector.</span>")
		to_chat(M, "<span class='notice'>You feel a tiny prick!</span>")

		if(M.reagents)
			var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
			M.reagents.add_reagent(reagent_ids[mode], t)
			reagent_volumes[reagent_ids[mode]] -= t
			add_attack_logs(user, M, "Borg injected with [reagent_ids[mode]]")
			to_chat(user, "<span class='notice'>[t] units injected. [reagent_volumes[reagent_ids[mode]]] units remaining.</span>")
	return

/obj/item/weapon/reagent_containers/borghypo/attack_self(mob/user as mob) //Change the mode
	var/t = ""
	for(var/i = 1 to reagent_ids.len)
		if(t)
			t += ", "
		if(mode == i)
			t += "<b>[reagent_names[i]]</b>"
		else
			t += "<a href='?src=\ref[src];reagent=[reagent_ids[i]]'>[reagent_names[i]]</a>"
	t = "Available reagents: [t]."
	to_chat(user,t)

	return

/obj/item/weapon/reagent_containers/borghypo/Topic(var/href, var/list/href_list)
	if(href_list["reagent"])
		var/t = reagent_ids.Find(href_list["reagent"])
		if(t)
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			mode = t
			var/datum/reagent/R = SSchemistry.chemical_reagents[reagent_ids[mode]]
			to_chat(usr, "<span class='notice'>Synthesizer is now producing '[R.name]'.</span>")

/obj/item/weapon/reagent_containers/borghypo/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		var/datum/reagent/R = SSchemistry.chemical_reagents[reagent_ids[mode]]
		. += "<span class='notice'>It is currently producing [R.name] and has [reagent_volumes[reagent_ids[mode]]] out of [volume] units left.</span>"

/obj/item/weapon/reagent_containers/borghypo/service
	name = "cyborg drink synthesizer"
	desc = "A portable drink dispencer."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"
	charge_cost = 20
	recharge_time = 3
	volume = 60
	possible_transfer_amounts = list(5, 10, 20, 30)
	reagent_ids = list("ale", "cider", "beer", "berryjuice", "bitters", "coffee", "cognac", "cola", "dr_gibb", "egg", "gin", "gingerale", "hot_coco", "ice", "icetea", "kahlua", "lemonjuice", "lemon_lime", "limejuice", "mead", "milk", "mint", "orangejuice", "rum", "sake", "sodawater", "soymilk", "space_up", "spacemountainwind", "specialwhiskey", "sugar", "tea", "tequilla", "tomatojuice", "tonic", "vermouth", "vodka", "water", "watermelonjuice", "whiskey", "wine")

/obj/item/weapon/reagent_containers/borghypo/service/attack(var/mob/M, var/mob/user)
	return

/obj/item/weapon/reagent_containers/borghypo/service/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return

	if(!target.is_open_container() || !target.reagents)
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, "<span class='notice'>[src] is out of this reagent, give it some time to refill.</span>")
		return

	if(!target.reagents.get_free_space())
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return

	var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
	target.reagents.add_reagent(reagent_ids[mode], t)
	reagent_volumes[reagent_ids[mode]] -= t
	to_chat(user, "<span class='notice'>You transfer [t] units of the solution to [target].</span>")
	return
