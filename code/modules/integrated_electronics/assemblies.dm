/obj/item/device/electronic_assembly
	name = "electronic assembly"
	desc = "It's a case, for building electronics with."
	w_class = 2
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "setup_small"
	var/max_components = 10
	var/max_complexity = 40
	var/opened = 0

/obj/item/device/electronic_assembly/medium
	name = "electronic mechanism"
	icon_state = "setup_medium"
	w_class = 3
	max_components = 20
	max_complexity = 80

/obj/item/device/electronic_assembly/large
	name = "electronic machine"
	icon_state = "setup_large"
	w_class = 4
	max_components = 30
	max_complexity = 120

/obj/item/device/electronic_assembly/drone
	name = "electronic drone"
	icon_state = "setup_drone"
	w_class = 3
	max_components = 25
	max_complexity = 100

/obj/item/device/electronic_assembly/interact(mob/user)
	if(get_dist(get_turf(src), user) > 1)
		user.unset_machine(src)
		return
	var/total_parts = 0
	var/total_complexity = 0
	for(var/obj/item/integrated_circuit/part in contents)
		total_parts++
		total_complexity = total_complexity + part.complexity
	var/HTML = "<html><head><title>[src.name]</title></head><body>"

	HTML += "<br><a href='?src=\ref[src];user=\ref[user]'>\[Refresh\]</a>  |  "
	HTML += "<a href='?src=\ref[src];user=\ref[user];rename=1'>\[Rename\]</a><br>"
	HTML += "[total_parts]/[max_components] ([round((total_parts / max_components) * 100, 0.1)]%) space taken up in the assembly.<br>"
	HTML += "[total_complexity]/[max_complexity] ([round((total_complexity / max_complexity) * 100, 0.1)]%) maximum complexity."
	HTML += "<br><br>"
	HTML += "Components;<br>"
	for(var/obj/item/integrated_circuit/circuit in contents)
		HTML += "<a href=?src=\ref[circuit];examine=1;user=\ref[user]>[circuit.name]</a> | "
		HTML += "<a href=?src=\ref[circuit];rename=1;user=\ref[user]>\[Rename\]</a>"
		HTML += "<br>"

	HTML += "</body></html>"
	user << browse(HTML, "window=assembly-\ref[src];size=600x350;border=1;can_resize=1;can_close=1;can_minimize=1")

/obj/item/device/electronic_assembly/Topic(href, href_list[])
	var/mob/living/user = locate(href_list["user"]) in mob_list

	if(..())
		return 1

	if(!user.canmove || user.stat || user.restrained())
		return

	if(href_list["rename"])
		rename(user)

	interact(user) // To refresh the UI.

/obj/item/device/electronic_assembly/verb/rename()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr

	if(!M.canmove || M.stat || M.restrained())
		return

	var/input = sanitizeSafe(input("What do you want to name this?", "Rename", src.name), MAX_NAME_LEN)

	if(src && input)
		M << "<span class='notice'>The machine now has a label reading '[input]'.</span>"
		name = input

/obj/item/device/electronic_assembly/update_icon()
	if(opened)
		icon_state = initial(icon_state) + "-open"
	else
		icon_state = initial(icon_state)

/obj/item/device/electronic_assembly/examine(mob/user)
	..()
	if(user.Adjacent(src))
		if(!opened)
			for(var/obj/item/integrated_circuit/output/screen/S in contents)
				if(S.stuff_to_display)
					user << "There's a little screen labeled '[S.name]', which displays '[S.stuff_to_display]'."
		else
			interact(user)
	//		var/obj/item/integrated_circuit/IC = input(user, "Which circuit do you want to examine?", "Examination") as null|anything in contents
	//		if(IC)
	//			IC.examine(user)

/obj/item/device/electronic_assembly/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/integrated_circuit))
		if(!opened)
			user << "<span class='warning'>\The [src] isn't opened, so you can't put anything inside.  Try using a crowbar.</span>"
			return 0
		var/obj/item/integrated_circuit/IC = I
		var/total_parts = 0
		var/total_complexity = 0
		for(var/obj/item/integrated_circuit/part in contents)
			total_parts++
			total_complexity = total_complexity + part.complexity

		if( (total_parts + 1) >= max_components)
			user << "<span class='warning'>You can't seem to add this [IC.name], since there's no more room.</span>"
			return 0
		if( (total_complexity + IC.complexity) >= max_complexity)
			user << "<span class='warning'>You can't seem to add this [IC.name], since this setup's too complicated for the case.</span>"
			return 0

		user << "<span class='notice'>You slide \the [IC] inside \the [src].</span>"
		user.drop_item()
		IC.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(!opened)
			user << "<span class='warning'>\The [src] isn't opened, so you can't remove anything inside.  Try using a crowbar.</span>"
			return 0
		if(!contents.len)
			user << "<span class='warning'>There's nothing inside this to remove!</span>"
			return 0
		var/obj/item/integrated_circuit/option = input("What do you want to remove?", "Component Removal") as null|anything in contents
		if(option)
			option.disconnect_all()
			option.forceMove(get_turf(src))
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
			user << "<span class='notice'>You pop \the [option] out of the case, and slide it out.</span>"
	if(istype(I, /obj/item/weapon/crowbar))
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		opened = !opened
		user << "<span class='notice'>You [opened ? "opened" : "closed"] \the [src].</span>"
		update_icon()
	if(istype(I, /obj/item/device/integrated_electronics/wirer))
		if(opened)
			var/obj/item/integrated_circuit/IC = input(user, "Which circuit do you want to examine?", "Examination") as null|anything in contents
			if(IC)
				IC.examine(user)
		else
			user << "<span class='warning'>\The [src] isn't opened, so you can't fiddle with the internal components.  \
			Try using a crowbar.</span>"

/obj/item/device/electronic_assembly/attack_self(mob/user)
	var/list/available_inputs = list()
	for(var/obj/item/integrated_circuit/input/input in contents)
		if(input.can_be_asked_input)
			available_inputs.Add(input)
	var/obj/item/integrated_circuit/input/choice = input(user, "What do you want to interact with?", "Interaction") as null|anything in available_inputs
	if(choice)
		choice.ask_for_input(user)

/obj/item/device/electronic_assembly/emp_act(severity)
	..()
	for(var/atom/movable/AM in contents)
		AM.emp_act(severity)
