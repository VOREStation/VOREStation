/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal and glass."
	icon = 'icons/obj/stationobjs_vr.dmi'
	icon_state = "autolathe"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/weapon/circuitboard/autolathe
	var/datum/category_collection/autolathe/machine_recipes
	var/list/stored_material =  list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0)
	var/list/storage_capacity = list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0)
	var/datum/category_group/autolathe/current_category

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/busy = 0

	var/mat_efficiency = 1
	var/build_time = 50

	var/datum/wires/autolathe/wires = null

/obj/machinery/autolathe/New()
	..()
	wires = new(src)
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

/obj/machinery/autolathe/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/autolathe/proc/update_recipe_list()
	if(!machine_recipes)
		if(!autolathe_recipes)
			autolathe_recipes = new()
		machine_recipes = autolathe_recipes
		current_category = machine_recipes.categories[1]

/obj/machinery/autolathe/interact(mob/user as mob)
	update_recipe_list()

	if(..() || (disabled && !panel_open))
		to_chat(user, "<span class='danger'>\The [src] is disabled!</span>")
		return

	if(shocked)
		shock(user, 50)
	var/list/dat = list()
	dat += "<center><h1>Autolathe Control Panel</h1><hr/>"

	if(!disabled)
		dat += "<table width = '100%'>"
		var/list/material_top = list("<tr>")
		var/list/material_bottom = list("<tr>")

		for(var/material in stored_material)
			material_top += "<td width = '25%' align = center><b>[material]</b></td>"
			material_bottom += "<td width = '25%' align = center>[stored_material[material]]<b>/[storage_capacity[material]]</b></td>"

		dat += "[material_top.Join()]</tr>[material_bottom.Join()]</tr></table><hr>"
		dat += "<h2>Printable Designs</h2><h3>Showing: <a href='?src=\ref[src];change_category=1'>[current_category]</a>.</h3></center><table width = '100%'>"

		for(var/datum/category_item/autolathe/R in current_category.items)
			if(R.hidden && !hacked)
				continue
			var/can_make = 1
			var/list/material_string = list()
			var/list/multiplier_string = list()
			var/max_sheets
			var/comma
			if(!R.resources || !R.resources.len)
				material_string += "No resources required.</td>"
			else
				//Make sure it's buildable and list requires resources.
				for(var/material in R.resources)
					var/coeff = (R.no_scale ? 1 : mat_efficiency) //stacks are unaffected by production coefficient
					var/sheets = round(stored_material[material]/round(R.resources[material]*coeff))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(!isnull(stored_material[material]) && stored_material[material] < round(R.resources[material]*coeff))
						can_make = 0
					if(!comma)
						comma = 1
					else
						material_string += ", "
					material_string += "[round(R.resources[material] * coeff)] [material]"
				material_string += ".<br></td>"
				//Build list of multipliers for sheets.
				if(R.is_stack)
					if(max_sheets && max_sheets > 0)
						max_sheets = min(max_sheets, R.max_stack) // Limit to the max allowed by stack type.
						multiplier_string += "<br>"
						for(var/i = 5;i<max_sheets;i*=2) //5,10,20,40...
							multiplier_string  += "<a href='?src=\ref[src];make=\ref[R];multiplier=[i]'>\[x[i]\]</a>"
						multiplier_string += "<a href='?src=\ref[src];make=\ref[R];multiplier=[max_sheets]'>\[x[max_sheets]\]</a>"

			dat += "<tr><td width = 180>[R.hidden ? "<font color = 'red'>*</font>" : ""]<b>[can_make ? "<a href='?src=\ref[src];make=\ref[R];multiplier=1'>" : ""][R.name][can_make ? "</a>" : ""]</b>[R.hidden ? "<font color = 'red'>*</font>" : ""][multiplier_string.Join()]</td><td align = right>[material_string.Join()]</tr>"

		dat += "</table><hr>"
	//Hacking.
	if(panel_open)
		dat += "<h2>Maintenance Panel</h2>"
		dat += wires.GetInteractWindow()

		dat += "<hr>"

	user << browse(dat.Join(), "window=autolathe")
	onclose(user, "autolathe")

/obj/machinery/autolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return

	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	if(stat)
		return

	if(panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(istype(O, /obj/item/device/multitool) || O.is_wirecutter())
			attack_hand(user)
			return

	if(O.loc != user && !(istype(O,/obj/item/stack)))
		return 0

	if(is_robot_module(O))
		return 0

	if(istype(O,/obj/item/ammo_magazine/clip) || istype(O,/obj/item/ammo_magazine/s357) || istype(O,/obj/item/ammo_magazine/s38) || istype (O,/obj/item/ammo_magazine/s44)/* VOREstation Edit*/) // Prevents ammo recycling exploit with speedloaders.
		to_chat(user, "\The [O] is too hazardous to recycle with the autolathe!")
		return
		/*  ToDo: Make this actually check for ammo and change the value of the magazine if it's empty. -Spades
		var/obj/item/ammo_magazine/speedloader = O
		if(speedloader.stored_ammo)
			to_chat(user, "\The [speedloader] is too hazardous to put back into the autolathe while there's ammunition inside of it!")
			return
		else
			speedloader.matter = list(DEFAULT_WALL_MATERIAL = 75) // It's just a hunk of scrap metal now.
	if(istype(O,/obj/item/ammo_magazine)) // This was just for immersion consistency with above.
		var/obj/item/ammo_magazine/mag = O
		if(mag.stored_ammo)
			to_chat(user, "\The [mag] is too hazardous to put back into the autolathe while there's ammunition inside of it!")
			return*/

	//Resources are being loaded.
	var/obj/item/eating = O
	if(!eating.matter)
		to_chat(user, "\The [eating] does not contain significant amounts of useful materials and cannot be accepted.")
		return

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.

	for(var/material in eating.matter)

		if(isnull(stored_material[material]) || isnull(storage_capacity[material]))
			continue

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = eating.matter[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating,/obj/item/stack))
			var/obj/item/stack/stack = eating
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
			filltype = 1
		else
			filltype = 2

		stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += eating.matter[material]

	if(!filltype)
		to_chat(user, "<span class='notice'>\The [src] is full. Please remove material from the autolathe in order to insert more.</span>")
		return
	else if(filltype == 1)
		to_chat(user, "You fill \the [src] to capacity with \the [eating].")
	else
		to_chat(user, "You fill \the [src] with \the [eating].")

	flick("autolathe_o", src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1, round(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else
		user.remove_from_mob(O)
		qdel(O)

	updateUsrDialog()
	return

/obj/machinery/autolathe/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if(busy)
		to_chat(usr, "<span class='notice'>The autolathe is busy. Please wait for completion of previous operation.</span>")
		return

	if(href_list["change_category"])

		var/choice = input("Which category do you wish to display?") as null|anything in machine_recipes.categories
		if(!choice) return
		current_category = choice

	if(href_list["make"] && machine_recipes)
		var/multiplier = text2num(href_list["multiplier"])
		var/datum/category_item/autolathe/making = locate(href_list["make"]) in current_category.items

		//Exploit detection, not sure if necessary after rewrite.
		if(!making || multiplier < 0 || multiplier > 100)
			var/turf/exploit_loc = get_turf(usr)
			message_admins("[key_name_admin(usr)] tried to exploit an autolathe to duplicate an item! ([exploit_loc ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[exploit_loc.x];Y=[exploit_loc.y];Z=[exploit_loc.z]'>JMP</a>" : "null"])", 0)
			log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe to duplicate an item!")
			return

		busy = 1
		update_use_power(2)

		//Check if we still have the materials.
		var/coeff = (making.no_scale ? 1 : mat_efficiency) //stacks are unaffected by production coefficient
		for(var/material in making.resources)
			if(!isnull(stored_material[material]))
				if(stored_material[material] < round(making.resources[material] * coeff) * multiplier)
					return

		//Consume materials.
		for(var/material in making.resources)
			if(!isnull(stored_material[material]))
				stored_material[material] = max(0, stored_material[material] - round(making.resources[material] * coeff) * multiplier)

		update_icon() // So lid closes

		sleep(build_time)

		busy = 0
		update_use_power(1)
		update_icon() // So lid opens

		//Sanity check.
		if(!making || !src) return

		//Create the desired item.
		var/obj/item/I = new making.path(src.loc)
		if(multiplier > 1)
			if(istype(I, /obj/item/stack))
				var/obj/item/stack/S = I
				S.amount = multiplier
			else
				for(multiplier; multiplier > 1; --multiplier) // Create multiple items if it's not a stack.
					new making.path(src.loc)

	updateUsrDialog()

/obj/machinery/autolathe/update_icon()
	if(panel_open)
		icon_state = "autolathe_t"
	else if(busy)
		icon_state = "autolathe_n"
	else
		if(icon_state == "autolathe_n")
			flick("autolathe_u", src) // If lid WAS closed, show opening animation
		icon_state = "autolathe"

//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	..()
	var/mb_rating = 0
	var/man_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	storage_capacity[DEFAULT_WALL_MATERIAL] = mb_rating  * 25000
	storage_capacity["glass"] = mb_rating  * 12500
	build_time = 50 / man_rating
	mat_efficiency = 1.1 - man_rating * 0.1// Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.6. Maximum rating of parts is 5

/obj/machinery/autolathe/dismantle()
	for(var/mat in stored_material)
		var/material/M = get_material_by_name(mat)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = new M.stack_type(get_turf(src))
		if(stored_material[mat] > S.perunit)
			S.amount = round(stored_material[mat] / S.perunit)
		else
			qdel(S)
	..()
	return 1
