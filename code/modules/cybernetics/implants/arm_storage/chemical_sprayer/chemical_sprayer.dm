/obj/item/endoware/item_storage/chem_sprayer //wrist bidet for all my european pals
	name = "Integrated Chemical Sprayer"
	desc = "A sleek module containing a reagent tank, small generation module, and minimalist dispensing nozzle. TODO."
	icon_state = "sprayer"
	starts_with = list(/obj/item/reagent_containers/spray/endoware)

	var/refill_with = REAGENT_ID_CLEANER
	var/refill_cost = 0.2 //hunger per unit
	var/refill_speed = 5 //units refilled per life tick

/obj/item/endoware/item_storage/chem_sprayer/added_to_human(mob/living/carbon/human/human)
	. = ..()
	RegisterSignal(human,COMSIG_LIVING_LIFE,PROC_REF(owner_life_tick))

/obj/item/endoware/item_storage/chem_sprayer/removed_from_human(mob/living/carbon/human/human)
	. = ..()
	UnregisterSignal(human,COMSIG_LIVING_LIFE)

/obj/item/endoware/item_storage/chem_sprayer/proc/owner_life_tick()
	var/obj/item/reagent_containers/spray/endoware/target = LAZYACCESS(stored_items,1)
	if(!target) return //hmm

	var/mob/living/carbon/human/owner = host
	if(!owner) return //HMMM

	var/room = target.reagents.maximum_volume-target.reagents.total_volume
	if(room < 1) return //small threshold

	var/volume = min(room,refill_speed)
	var/spent_energy = refill_cost * volume
	target.reagents.add_reagent(refill_with, volume)
	owner.nutrition = max(host.nutrition - spent_energy, 0)
