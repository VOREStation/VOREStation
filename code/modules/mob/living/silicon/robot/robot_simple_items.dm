// Robot toolbelts, such as screwdrivers and the like. All contained in one neat little package.
// The code for actually 'how these use the item inside of them instead of
/*
 * Engineering Tools
 */

/obj/item/robotic_multibelt
	name = "Robotic multitool"
	desc = "An integrated toolbelt."

	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_engiborg"
	w_class = ITEMSIZE_HUGE

	var/obj/item/selected_item = null

	var/list/cyborg_integrated_tools = list(
		/obj/item/tool/screwdriver/cyborg = null,
		/obj/item/tool/wrench/cyborg = null,
		/obj/item/tool/crowbar/cyborg = null,
		/obj/item/tool/wirecutters/cyborg = null,
		/obj/item/multitool/cyborg = null,
		/obj/item/weldingtool/electric/mounted/cyborg = null,
		)

	var/list/integrated_tools_by_name

	var/list/integrated_tool_images

/obj/item/robotic_multibelt/Initialize(mapload)
	. = ..()

	if(cyborg_integrated_tools && LAZYLEN(cyborg_integrated_tools))

		integrated_tools_by_name = list()

		integrated_tool_images = list()

		for(var/path in cyborg_integrated_tools)
			if(!cyborg_integrated_tools[path])
				cyborg_integrated_tools[path] = new path(src)
			var/obj/item/I = cyborg_integrated_tools[path]
			I.canremove = FALSE

		for(var/tool in cyborg_integrated_tools)
			var/obj/item/Tool = cyborg_integrated_tools[tool]
			integrated_tools_by_name[Tool.name] = Tool
			integrated_tool_images[Tool.name] = image(icon = Tool.icon, icon_state = Tool.icon_state)

/obj/item/robotic_multibelt/Destroy()
	selected_item = null
	for(var/tool in cyborg_integrated_tools)
		qdel_null(tool)
	qdel_null(cyborg_integrated_tools)
	qdel_null(integrated_tools_by_name)
	qdel_null(integrated_tool_images)
	. = ..()


/obj/item/robotic_multibelt/attack_self(mob/user)

	var/list/options = list()

	for(var/Iname in integrated_tools_by_name)
		options[Iname] = integrated_tool_images[Iname]

	var/list/choice = list()
	if(length(options) == 1)
		for(var/key in options)
			choice = key
	else
		choice = show_radial_menu(user, src, options, radius = 40, require_near = TRUE)
	if(!choice)
		return
	assume_selected_item(integrated_tools_by_name[choice])

	..()

/obj/item/robotic_multibelt/proc/assume_selected_item(obj/item/chosen_item)
	cut_overlays()
	icon = chosen_item.icon
	icon_state = chosen_item.icon_state
	selected_item = chosen_item

/obj/item/robotic_multibelt/dropped(mob/user)
	..()
	//We go back to our initial values.
	original_state()

/obj/item/robotic_multibelt/proc/original_state(mob/user)
	cut_overlays()
	selected_item = null
	icon = initial(icon)
	icon_state = initial(icon_state)

/obj/item/tool/screwdriver/cyborg
	name = "powered screwdriver"
	desc = "An electrical screwdriver, designed to be both precise and quick."
	usesound = 'sound/items/drill_use.ogg'
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_engiborg_screwdriver"
	random_color = FALSE
	toolspeed = 0.5

/obj/item/tool/crowbar/cyborg
	name = "hydraulic crowbar"
	desc = "A hydraulic prying tool, compact but powerful. Designed to replace crowbars in industrial synthetics."
	usesound = 'sound/items/jaws_pry.ogg'
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_engiborg_crowbar"
	force = 10
	toolspeed = 0.5

/obj/item/weldingtool/electric/mounted/cyborg
	name = "integrated electric welding tool"
	desc = "An advanced welder designed to be used in robotic systems."
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "indwelder_cyborg"
	usesound = 'sound/items/Welder2.ogg'
	toolspeed = 0.5
	welding = TRUE

/obj/item/tool/wirecutters/cyborg
	name = "wirecutters"
	desc = "This cuts wires. With science."
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_engiborg_cutters"
	usesound = 'sound/items/jaws_cut.ogg'
	random_color = FALSE
	toolspeed = 0.5

/obj/item/tool/wrench/cyborg
	name = "automatic wrench"
	desc = "An advanced robotic wrench. Can be found in industrial synthetic shells."
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_engiborg_wrench"
	usesound = 'sound/items/drill_use.ogg'
	toolspeed = 0.5

/obj/item/multitool/cyborg
	name = "multitool"
	desc = "Optimised and stripped-down version of a regular multitool."
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_engiborg_multitool"
	toolspeed = 0.5

/obj/item/stack/cable_coil/cyborg
	name = "cable coil synthesizer"
	desc = "A device that makes cable."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(1)

/obj/item/stack/cable_coil/cyborg/verb/set_colour()
	set name = "Change Colour"
	set category = "Object"

	var/selected_type = tgui_input_list(usr, "Pick new colour.", "Cable Colour", possible_cable_coil_colours)
	set_cable_color(selected_type, usr)

/*
 * Surgical Tools
 */
/obj/item/surgical/retractor/cyborg
	icon_state = "cyborg_retractor"
	toolspeed = 0.5

/obj/item/surgical/hemostat/cyborg
	icon_state = "cyborg_hemostat"
	toolspeed = 0.5

/obj/item/surgical/cautery/cyborg
	icon_state = "cyborg_cautery"
	toolspeed = 0.5

/obj/item/surgical/surgicaldrill/cyborg
	icon_state = "cyborg_drill"
	toolspeed = 0.5

/obj/item/surgical/scalpel/cyborg
	icon_state = "cyborg_scalpel"
	toolspeed = 0.5

/obj/item/surgical/circular_saw/cyborg
	icon_state = "cyborg_saw"
	toolspeed = 0.5

/obj/item/surgical/bonegel/cyborg
	toolspeed = 0.5

/obj/item/surgical/FixOVein/cyborg
	toolspeed = 0.5

/obj/item/surgical/bonesetter/cyborg
	icon_state = "cyborg_setter"
	toolspeed = 0.5

/obj/item/surgical/bioregen/cyborg
	icon_state = "cyborg_bioregen"
	toolspeed = 0.5
