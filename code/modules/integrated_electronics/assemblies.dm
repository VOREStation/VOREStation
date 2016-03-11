/obj/item/device/electronic_assembly
	name = "electronic assembly"
	desc = "It's a case, for building electronics with."
	w_class = 2
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "setup"
	var/max_components = 10
	var/max_complexity = 30

/obj/item/device/electronic_assembly/medium
	name = "electronic setup"
	w_class = 3
	max_components = 20
	max_complexity = 50

/obj/item/device/electronic_assembly/large
	name = "electronic device"
	w_class = 4
	max_components = 30
	max_complexity = 60

/*

/obj/item/device/electronic_assembly/New()
	..()
	processing_objects |= src

/obj/item/device/electronic_assembly/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/device/electronic_assembly/process()
	for(var/obj/item/integrated_circuit/IC in contents)
		IC.work()
*/

/obj/item/device/electronic_assembly/examine(mob/user)
	..()
	for(var/obj/item/integrated_circuit/output/screen/S in contents)
		if(S.stuff_to_display)
			user << "There's a little screen which displays '[S.stuff_to_display]'."

/obj/item/device/electronic_assembly/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/integrated_circuit))
		var/obj/item/integrated_circuit/IC = I
		var/total_parts = 0
		var/total_complexity = 0
		for(var/obj/item/integrated_circuit/part in contents)
			total_parts++
			total_complexity = total_complexity + part.complexity

		if( (total_parts + 1) >= max_components)
			user << "<span class='warning'>You can't seem to add this [IC.name], since this setup's too complicated for the case.</span>"
			return 0
		if( (total_complexity + IC.complexity) >= max_complexity)
			user << "<span class='warning'>You can't seem to add this [IC.name], since there's no more room.</span>"
			return 0

		user << "<span class='notice'>You slide \the [IC] inside \the [src].</span>"
		user.drop_item()
		IC.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	if(istype(I, /obj/item/weapon/crowbar))
		if(!contents.len)
			user << "<span class='warning'>There's nothing inside this to remove!</span>"
			return 0
		var/obj/item/integrated_circuit/option = input("What do you want to remove?", "Component Removal") as null|anything in contents
		if(option)
			option.disconnect_all()
			option.forceMove(get_turf(src))
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)

/obj/item/device/electronic_assembly/attack_self(mob/user)
	var/list/available_inputs = list()
	for(var/obj/item/integrated_circuit/input/input in contents)
		available_inputs.Add(input)
	var/obj/item/integrated_circuit/input/choice = input(user, "What do you want to interact with?", "Interaction") as null|anything in available_inputs
	if(choice)
		choice.ask_for_input(user)
