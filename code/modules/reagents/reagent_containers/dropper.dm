////////////////////////////////////////////////////////////////////////////////
/// Droppers.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/dropper
	name = "dropper"
	desc = "A dropper. Transfers up to 5 units at a time."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,2,3,4,5)
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	volume = 5
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/reagent_containers/dropper/examine(var/mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		if(reagents && reagents.reagent_list.len)
			. += "<span class='notice'>It contains [reagents.total_volume] units of liquid.</span>"
		else
			. += "<span class='notice'>It is empty.</span>"

/obj/item/reagent_containers/dropper/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!target.reagents || !proximity) return

	if(reagents.total_volume)

		if(!target.reagents.get_free_space())
			to_chat(user, "<span class='notice'>[target] is full.</span>")
			return

		if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_containers/food) && !istype(target, /obj/item/clothing/mask/smokable/cigarette)) //You can inject humans and food but you cant remove the shit.
			to_chat(user, "<span class='notice'>You cannot directly fill this object.</span>")
			return

		var/trans = 0

		if(ismob(target))

			var/time = 20 //2/3rds the time of a syringe
			user.visible_message("<span class='warning'>[user] is trying to squirt something into [target]'s eyes!</span>")

			if(!do_mob(user, target, time))
				return

			if(istype(target, /mob/living/carbon/human))
				var/mob/living/carbon/human/victim = target

				var/obj/item/safe_thing = null
				if(victim.wear_mask)
					if (victim.wear_mask.body_parts_covered & EYES)
						safe_thing = victim.wear_mask
				if(victim.head)
					if (victim.head.body_parts_covered & EYES)
						safe_thing = victim.head
				if(victim.glasses)
					if (!safe_thing)
						safe_thing = victim.glasses

				if(safe_thing)
					trans = reagents.splash(safe_thing, min(amount_per_transfer_from_this, reagents.total_volume), max_spill=30)
					user.visible_message("<span class='warning'>[user] tries to squirt something into [target]'s eyes, but fails!</span>", "<span class='notice'>You transfer [trans] units of the solution.</span>")
					return

			var/contained = reagentlist()
			add_attack_logs(user,target,"Used [src.name] containing [contained]")

			trans += reagents.trans_to_mob(target, min(amount_per_transfer_from_this, reagents.total_volume)/2, CHEM_INGEST) //Half injected, half ingested
			trans += reagents.trans_to_mob(target, min(amount_per_transfer_from_this, reagents.total_volume), CHEM_BLOOD) //I guess it gets into the bloodstream through the eyes or something
			user.visible_message("<span class='warning'>[user] squirts something into [target]'s eyes!</span>", "<span class='notice'>You transfer [trans] units of the solution.</span>")

			return

		else
			trans = reagents.trans_to_obj(target, amount_per_transfer_from_this)
			to_chat(user, "<span class='notice'>You transfer [trans] units of the solution.</span>")

	else // Taking from something

		if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
			to_chat(user, "<span class='notice'>You cannot directly remove reagents from [target].</span>")
			return

		if(!target.reagents || !target.reagents.total_volume)
			to_chat(user, "<span class='notice'>[target] is empty.</span>")
			return

		var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)

		to_chat(user, "<span class='notice'>You fill the dropper with [trans] units of the solution.</span>")

	return

/obj/item/reagent_containers/dropper/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/dropper/update_icon()
	if(reagents.total_volume)
		icon_state = "dropper1"
	else
		icon_state = "dropper0"

/obj/item/reagent_containers/dropper/industrial
	name = "Industrial Dropper"
	desc = "A larger dropper. Transfers up to 10 units at a time."
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(1,2,3,4,5,6,7,8,9,10)
	volume = 10

////////////////////////////////////////////////////////////////////////////////
/// Droppers. END
////////////////////////////////////////////////////////////////////////////////
