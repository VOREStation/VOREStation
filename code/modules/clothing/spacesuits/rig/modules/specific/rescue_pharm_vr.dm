/obj/item/rig_module/rescue_pharm
	name = "micro-pharmacy"
	desc = "A small chemical dispenser with integrated micro cartridges."
	usable = 0
	selectable = 1
	disruptive = 1
	toggleable = 1

	use_power_cost = 0
	active_power_cost = 5

	activate_string = "Enable Regen"
	deactivate_string = "Disable Regen"

	interface_name = "mounted chem injector"
	interface_desc = "Dispenses loaded chemicals via an arm-mounted injector."

	var/max_reagent_volume = 20 //Regen to this volume
	var/chems_to_use = 5 //Per injection

	charges = list(
		list("inaprovaline",  "inaprovaline",  0, 20),
		list("anti_toxin",  "anti_toxin",  0, 20),
		list("paracetamol",      "paracetamol",      0, 20),
		list("dexalin",  "dexalin",      0, 20)
		)

/obj/item/rig_module/rescue_pharm/process()
	. = ..()
	if(active)
		var/did_work = 0

		for(var/charge in charges)
			var/datum/rig_charge/C = charges[charge]

			//Found one that isn't full
			if(C.charges < max_reagent_volume)
				did_work = 1
				C.charges += 1
				break

		if (!did_work)
			deactivate() //All done

/obj/item/rig_module/rescue_pharm/engage(atom/target)
	if(!target)
		return 1 //You're just toggling the module on, not clicking someone.

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H,"<span class='danger'>You have not selected a chemical type.</span>")
		return 0

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return 0

	if(charge.charges <= 0)
		to_chat(H,"<span class='danger'>Insufficient chems!</span>")
		return 0

	else if(charge.charges < chems_to_use)
		chems_to_use = charge.charges

	var/mob/living/carbon/target_mob
	if(istype(target,/mob/living/carbon))
		target_mob = target
	else
		return 0

	to_chat(H,"<span class='notice'>You inject [target_mob == H ? "yourself" : target_mob] with [chems_to_use] unit\s of [charge.short_name].</span>")
	to_chat(target_mob,"<span class='notice'>You feel a rushing in your veins as you're injected by \the [src].</span>")
	target_mob.reagents.add_reagent(charge.display_name, chems_to_use)

	charge.charges -= chems_to_use
	if(charge.charges < 0) charge.charges = 0

	return 1
