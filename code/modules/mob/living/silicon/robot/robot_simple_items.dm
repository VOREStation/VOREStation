// Robot toolbelts, such as screwdrivers and the like. All contained in one neat little package.
// The code for actually 'how these use the item inside of them instead of the item itself' can be found in code\modules\mob\living\silicon\robot\inventory.dm (yes, click code, gross, I know.)
/*
 * Engineering Tools
 */

/obj/item/robotic_multibelt
	name = "Robotic multitool"
	desc = "An integrated toolbelt that holds various tools."
	description_info = "Pressing Z will interact with the item the multibelt has selected.<br>\
	Pressing Ctrl+Z will open the radial menu to allow item swapping!<br>\
	Clicking on the selected object will also open the radial menu."
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

/obj/item/robotic_multibelt/CtrlClick(mob/user)
	if(selected_item)
		selected_item.attack_self(user)
	return

/obj/item/robotic_multibelt/examine(mob/user)
	. = ..()
	if(selected_item)
		. += span_notice("\The [src] is currently set to \the [selected_item].")
		. += selected_item.examine(user)

/obj/item/robotic_multibelt/proc/get_module()
	var/obj/item/robot_module/module
	if(isrobot(loc)) //We're in a robot (in hands)
		var/mob/living/silicon/robot/our_robot = loc
		module = our_robot.module
	else if(istype(loc, /obj/item/robot_module)) //We're inside the module itself (in inventory)
		module = loc
	else //Admin spawned us outside of a module.
		CRASH("Robotic Multibelt is not in a robot or module. This should not happen.")
	return module


//'Alterate Tools' means we do special tool handling in Init
/obj/item/robotic_multibelt/Initialize(mapload, custom_handling = FALSE)
	. = ..()
	generate_tools()

/obj/item/robotic_multibelt/proc/generate_tools()
	integrated_tools_by_name = list()

	integrated_tool_images = list()

	for(var/path in cyborg_integrated_tools)
		if(ispath(path)) //Some things like the materials printer makes its own tools and it won't be a path.
			if(!cyborg_integrated_tools[path])
				cyborg_integrated_tools[path] = new path(src)
		else
			cyborg_integrated_tools[path] = path
		var/obj/item/I = cyborg_integrated_tools[path]
		I.canremove = FALSE

	for(var/tool in cyborg_integrated_tools)
		var/obj/item/real_tool = cyborg_integrated_tools[tool]
		integrated_tools_by_name[real_tool.name] = real_tool
		integrated_tool_images[real_tool.name] = image(icon = real_tool.icon, icon_state = real_tool.icon_state)

/obj/item/robotic_multibelt/Destroy()
	selected_item = null
	QDEL_LIST_ASSOC_VAL(cyborg_integrated_tools)
	integrated_tools_by_name.Cut()
	integrated_tool_images.Cut()
	. = ..()


/obj/item/robotic_multibelt/attack_self(mob/user)
	if(!cyborg_integrated_tools || !LAZYLEN(cyborg_integrated_tools))
		to_chat(user, "Your multibelt is empty!")
		return

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
	if(!chosen_item)
		return
	icon = chosen_item.icon
	icon_state = chosen_item.icon_state
	selected_item = chosen_item

/obj/item/robotic_multibelt/dropped(mob/user)
	..()
	//We go back to our initial values.
	original_state()

/obj/item/robotic_multibelt/proc/original_state(mob/user)
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

/obj/item/tool/crowbar/cyborg/jaws
	name = "puppy jaws"
	desc = "The jaws of a small dog. Still strong enough to pry things."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "smalljaws_textless"
	hitsound = 'sound/weapons/bite.ogg'
	attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
	force = 15

/obj/item/weldingtool/electric/mounted/cyborg
	name = "integrated electric welding tool"
	desc = "An advanced welder designed to be used in robotic systems."
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "indwelder_cyborg"
	usesound = 'sound/items/Welder2.ogg'
	toolspeed = 0.5
	welding = TRUE
	no_passive_burn = TRUE

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

/obj/item/stack/cable_coil/cyborg/attack_self(mob/user)
	set_colour(user)

/obj/item/stack/cable_coil/cyborg/proc/set_colour(mob/user)
	set name = "Change Colour"
	set category = "Object"

	var/selected_type = tgui_input_list(user, "Pick new colour.", "Cable Colour", GLOB.possible_cable_coil_colours)
	set_cable_color(selected_type, user)

/*
 * Surgical Tools
 */

/obj/item/robotic_multibelt/medical
	name = "Robotic surgical multitool"
	desc = "An integrated surgical toolbelt."
	icon_state = "toolkit_medborg"

	cyborg_integrated_tools = list(
		/obj/item/surgical/retractor/cyborg = null,
		/obj/item/surgical/hemostat/cyborg = null,
		/obj/item/surgical/cautery/cyborg = null,
		/obj/item/surgical/surgicaldrill/cyborg = null,
		/obj/item/surgical/scalpel/cyborg = null,
		/obj/item/surgical/circular_saw/cyborg = null,
		/obj/item/surgical/bonegel/cyborg = null,
		/obj/item/surgical/FixOVein/cyborg = null,
		/obj/item/surgical/bonesetter/cyborg = null,
		/obj/item/surgical/bioregen/cyborg = null,
		/obj/item/autopsy_scanner = null
		)

/obj/item/surgical/retractor/cyborg
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_medborg_retractor"
	toolspeed = 0.5

/obj/item/surgical/hemostat/cyborg
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_medborg_hemostat"
	toolspeed = 0.5

/obj/item/surgical/cautery/cyborg
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_medborg_cautery"
	toolspeed = 0.5

/obj/item/surgical/surgicaldrill/cyborg
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_medborg_drill"
	toolspeed = 0.5

/obj/item/surgical/scalpel/cyborg
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_medborg_scalpel"
	toolspeed = 0.5

/obj/item/surgical/circular_saw/cyborg
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_medborg_saw"
	toolspeed = 0.5

/obj/item/surgical/bonegel/cyborg
	toolspeed = 0.5

/obj/item/surgical/FixOVein/cyborg
	toolspeed = 0.5

/obj/item/surgical/bonesetter/cyborg
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "toolkit_medborg_bonesetter"
	toolspeed = 0.5

/obj/item/surgical/bioregen/cyborg
	icon_state = "cyborg_bioregen"
	toolspeed = 0.5

//Service multibelt!
/obj/item/robotic_multibelt/service
	name = "Service multitool"
	desc = "An integrated service toolbelt."
	icon_state = "toolkit_medborg"

	cyborg_integrated_tools = list(
		/obj/item/material/minihoe/cyborg  = null,
		/obj/item/material/knife/machete/hatchet/cyborg  = null,
		/obj/item/analyzer/plant_analyzer/cyborg  = null,
		/obj/item/material/knife/cyborg  = null,
		/obj/item/robot_harvester = null,
		/obj/item/material/kitchen/rollingpin/cyborg  = null,
		/obj/item/tool/wirecutters/cyborg = null,
		/obj/item/multitool/cyborg = null,
		/obj/item/reagent_containers/spray = null
		)

//Botanical multibelt!
/obj/item/robotic_multibelt/botanical
	name = "Botanical multitool"
	desc = "An integrated botanical toolbelt."
	icon_state = "toolkit_medborg"

	cyborg_integrated_tools = list(
		/obj/item/material/minihoe/cyborg  = null,
		/obj/item/material/knife/machete/hatchet/cyborg  = null,
		/obj/item/analyzer/plant_analyzer/cyborg = null,
		/obj/item/robot_harvester = null,
		/obj/item/tool/wirecutters/cyborg = null,
		/obj/item/multitool/cyborg = null,
		/obj/item/reagent_containers/spray = null
		)

/obj/item/material/minihoe/cyborg
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "sili_cultivator"

/obj/item/material/knife/machete/hatchet/cyborg
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "sili_hatchet"

/obj/item/analyzer/plant_analyzer/cyborg
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "sili_secateur"


/obj/item/material/knife/cyborg
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "sili_knife"

/obj/item/material/kitchen/rollingpin/cyborg
	icon = 'icons/obj/tools_robot.dmi'
	icon_state = "sili_rolling_pin"

//Admin proc to add new materials to their fabricator
/mob/living/silicon/robot/proc/add_new_material(mat_to_add) //Allows us to add a new material to the borg's synth and then make their multibelt refresh.
	if(!module)
		return

	if(!mat_to_add)
		return

	var/datum/matter_synth/synth_path = ispath(mat_to_add) ? mat_to_add : GLOB.material_synth_list[mat_to_add]

	if(!can_install_synth(synth_path))
		return

	var/amount
	switch(mat_to_add)
		if(/datum/matter_synth/metal)
			amount = 40000
		if(/datum/matter_synth/plasteel)
			amount = 20000
		if(/datum/matter_synth/glass)
			amount = 40000
		if(/datum/matter_synth/wood)
			amount = 40000
		if(/datum/matter_synth/plastic)
			amount = 40000
		if(/datum/matter_synth/wire)
			amount = 50
		if(/datum/matter_synth/cloth)
			amount = 40000

	if(!amount)
		return

	module.synths += new synth_path(amount)
	update_material_multibelts()

/mob/living/silicon/robot/proc/update_material_multibelts()
	for(var/obj/item/robotic_multibelt/materials/mat_belt in module.contents) //If it's stowed in our inventory
		mat_belt.generate_tools()
	for(var/obj/item/robotic_multibelt/materials/mat_belt in contents) //If it's in our handstory
		mat_belt.generate_tools()

/mob/living/silicon/robot/proc/can_install_synth(var/datum/matter_synth/type_to_check)
	if(!ispath(type_to_check, /datum/matter_synth))
		return FALSE
	for(var/datum/matter_synth/synth in module.synths)
		if(istype(synth, type_to_check))
			return FALSE
	return TRUE

/mob/living/silicon/robot/proc/remove_material(mat_to_remove)
	if(!module)
		return

	if(!mat_to_remove)
		return

	var/datum/matter_synth/synth_path = ispath(mat_to_remove) ? mat_to_remove : GLOB.material_synth_list[mat_to_remove]

	for(var/datum/matter_synth/synth in module.synths)
		if(istype(synth, synth_path))
			module.synths -= synth
			qdel(synth)
	update_material_multibelts()

//The Material Dispenser Multibelt
//This thing is uh...Bulky. And took a lot of effort to get to work.

/obj/item/robotic_multibelt/materials
	name = "Robotic Material Dispenser"
	desc = "An integrated material dispenser! Click once to select your material. Use Ctrl + Click to open the menu for the selected material."
	icon_state = "toolkit_material"

	cyborg_integrated_tools = list()

/obj/item/robotic_multibelt/materials/generate_tools()
	var/obj/item/robot_module/module = get_module()
	if(!module || !module.synths || !LAZYLEN(module.synths)) //We have a synths list and it has contents within it!
		return

	var/datum/matter_synth/has_steel //Steel synth. For generating Rglass
	var/datum/matter_synth/has_glass //Glass synth. For generating Rglass
	for(var/datum/matter_synth/our_synth in module.synths)
		if(our_synth.name == METAL_SYNTH)
			has_steel = our_synth
			continue
		if(our_synth.name == GLASS_SYNTH)
			has_glass = our_synth
			continue

	var/list/possible_synths = list()
	for(var/datum/matter_synth/our_synth in module.synths)
		switch(our_synth.name)
			if(METAL_SYNTH)
				possible_synths += list(/obj/item/stack/material/cyborg/steel = list(our_synth))
				possible_synths += list(/obj/item/stack/tile/floor/cyborg = list(our_synth))
				possible_synths += list(/obj/item/stack/rods/cyborg = list(our_synth))
				possible_synths += list(/obj/item/stack/tile/roofing/cyborg = list(our_synth))
				if(has_glass)
					possible_synths |= list(/obj/item/stack/material/cyborg/glass/reinforced = list(our_synth, has_glass))
			if(PLASTEEL_SYNTH)
				possible_synths += list(/obj/item/stack/material/cyborg/plasteel = list(our_synth))
			if(GLASS_SYNTH)
				possible_synths += list(/obj/item/stack/material/cyborg/glass = list(our_synth))
				if(has_steel)
					possible_synths |= list(/obj/item/stack/material/cyborg/glass/reinforced = list(our_synth, has_steel))
			if(WOOD_SYNTH)
				possible_synths += list(/obj/item/stack/tile/wood/cyborg = list(our_synth))
				possible_synths += list(/obj/item/stack/material/cyborg/wood = list(our_synth))
			if(PLASTIC_SYNTH)
				possible_synths += list(/obj/item/stack/material/cyborg/plastic = list(our_synth))
			if(WIRE_SYNTH)
				possible_synths += list(/obj/item/stack/cable_coil/cyborg = list(our_synth))
			if(CLOTH_SYNTH)
				possible_synths += list(/obj/item/stack/sandbags/cyborg = list(our_synth))

	for(var/obj/item/stack/our_item in cyborg_integrated_tools)
		if(is_type_in_list(our_item, possible_synths))
			possible_synths -= our_item.type
		else
			cyborg_integrated_tools -= our_item
			integrated_tools_by_name -= our_item
			integrated_tool_images -= our_item
			qdel(our_item)

	for(var/stack_to_add in possible_synths)
		var/obj/item/stack/current_stack = new stack_to_add(src)
		current_stack.synths = possible_synths[stack_to_add]
		cyborg_integrated_tools += current_stack

	. = ..()

///Allows the material fabricator to pick up materials if they hit an appropriate stack.
/obj/item/robotic_multibelt/materials/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(istype(target, /obj/item/stack)) //We are targeting a stack.
		if(!selected_item)
			to_chat(user, span_warning("You need to select a material first!"))
			return
		var/obj/item/stack/target_stack = target
		if(istype(selected_item, /obj/item/stack))
			target_stack.attackby(selected_item, user)

/*
 * Grippers
 */

//Simple borg hand.
//Limited use.
//If you want to add more items to the gripper, add them to the global define list for that gripper.
/obj/item/gripper
	name = "magnetic gripper"
	desc = "A simple grasping tool specialized in construction and engineering work."
	description_info = "Ctrl-Clicking on the gripper will interact with whatever it is holding.<br>\
	Alt-Clicking on the gripper will drop the item it is holding.<br>\
	Using an object on the gripper will interact with the item inside it, if it exists, instead."
	icon = 'icons/obj/device.dmi'
	icon_state = "gripper"

	flags = NOBLUDGEON

	//Has a list of items that it can hold.
	var/list/can_hold = list(BASIC_GRIPPER)

	var/obj/item/wrapped = null // Item currently being held.

	var/total_pockets = 5 //How many total inventory slots we want to have in the gripper

	var/list/pockets = list() //List of the pockets we have. This is used to store the items inside of the gripper.

	var/obj/item/current_pocket = null //What pocket (or item!) we currently have selected

	var/list/pockets_by_name

	var/list/photo_images

	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/storage/internal/gripper
	max_w_class = ITEMSIZE_HUGE
	max_storage_space = ITEMSIZE_COST_HUGE

/obj/item/gripper/Initialize(mapload)
	. = ..()

	if(total_pockets)
		for(var/i = 1, i <= total_pockets, i++)
			var/obj/new_pocket = new /obj/item/storage/internal/gripper(src)
			new_pocket.name = "Pocket [i]"
			pockets += new_pocket
	current_pocket = peek(pockets)

/obj/item/gripper/Destroy()
	current_pocket = null
	qdel_null(wrapped)
	qdel_null(pockets)
	. = ..()


/obj/item/gripper/examine(mob/user)
	. = ..()
	if(wrapped)
		. += span_notice("\The [src] is holding \the [wrapped].")
		. += wrapped.examine(user)

/obj/item/gripper/CtrlClick(mob/user)
	if(wrapped)
		wrapped.attack_self(user)
	return

/obj/item/gripper/AltClick(mob/user)
	drop_item()
	return


//This is the code that updates our pockets and decides if they should have icons or not.
//This should be called every time we use the gripper and our wrapped item is used up.
/obj/item/gripper/proc/generate_icons()
	if(LAZYLEN(pockets))

		pockets_by_name = list()

		photo_images = list()

		for(var/obj/item/storage/internal/pocket_to_check in pockets)
			if(!LAZYLEN(pocket_to_check.contents))
				pockets_by_name[pocket_to_check.name] = pocket_to_check
				photo_images[pocket_to_check.name] = image(icon = 'icons/effects/effects.dmi', icon_state = "nothing")
				continue
			var/obj/item/pocket_content = pocket_to_check.contents[1]
			pockets_by_name["[pocket_to_check.name]" + "[pocket_content.name]"] = pocket_content
			var/image/pocket_image = image(icon = pocket_content.icon, icon_state = pocket_content.icon_state)
			if(pocket_content.color)
				pocket_image.color = pocket_content.color
			if(pocket_content.overlays)
				for(var/overlay in pocket_content.overlays)
					pocket_image.overlays += overlay
			photo_images["[pocket_to_check.name]" + "[pocket_content.name]"] = pocket_image

/obj/item/gripper/attack_self(mob/user as mob)
	generate_icons()
	var/list/options = list()

	for(var/Iname in pockets_by_name)
		options[Iname] = photo_images[Iname]

	var/list/choice = list()
	choice = show_radial_menu(user, src, options, radius = 40, require_near = TRUE, autopick_single_option = FALSE)
	if(choice)
		current_pocket = pockets_by_name[choice]
		if(!istype(current_pocket,/obj/item/storage/internal/gripper)) //The pocket we're selecting is NOT a gripper storage
			if(!istype(current_pocket.loc, /obj/item/storage/internal/gripper)) //We kept the radial menu opened, used the item, then selected it again.
				current_pocket = pick(pockets) //Just pick a random pocket.
				wrapped = null
			else
				wrapped = current_pocket
		else
			wrapped = null
	else if(wrapped)
		return wrapped.attack_self(user)
	return ..()

/obj/item/gripper/attackby(var/obj/item/O, var/mob/user)
	if(wrapped)
		wrapped.loc = src.loc //Place it in to the robot.
		var/resolved = wrapped.attackby(O, user)
		if(QDELETED(wrapped) || (wrapped.loc != src.loc && !istype(wrapped.loc,/obj/item/storage/internal/gripper)))
			wrapped = null
		if(!resolved && wrapped && O)
			O.afterattack(wrapped,user,1)
			if(QDELETED(wrapped) || (wrapped.loc != src.loc && !istype(wrapped.loc,/obj/item/storage/internal/gripper)))	 // I don't know of a nicer way to do this.
				wrapped = null
		if(wrapped && wrapped != current_pocket)
			wrapped.loc = current_pocket
		else if(wrapped)
			for(var/obj/item/storage/internal/gripper/our_pocket in pockets)
				if(LAZYLEN(our_pocket.contents))
					continue
				current_pocket = our_pocket
				wrapped.loc = current_pocket

		return resolved
	return ..()

/obj/item/gripper/verb/drop_gripper_item()

	set name = "Drop Item"
	set desc = "Release an item from your magnetic gripper."
	set category = "Abilities.Silicon"

	drop_item()

/obj/item/gripper/proc/drop_item()
	if(!wrapped)
		to_chat(src, span_warning("You have nothing to drop!"))
		return
	if((wrapped == current_pocket && !istype(wrapped.loc, /obj/item/storage/internal/gripper))) //We have wrapped selected as our current_pocket AND wrapped is not in a gripper storage
		wrapped = null
		current_pocket = pick(pockets)
		generate_icons()
		return

	to_chat(src.loc, span_notice("You drop \the [wrapped]."))
	wrapped.loc = get_turf(src)
	wrapped = null
	generate_icons()
	//update_icon()

/obj/item/gripper/proc/drop_item_nm()
	if((wrapped == current_pocket && !istype(wrapped.loc, /obj/item/storage/internal/gripper))) //We have wrapped selected as our current_pocket AND wrapped is not in a gripper storage
		wrapped = null
		current_pocket = pick(pockets)
		return

	wrapped.loc = get_turf(src)
	wrapped = null

/obj/item/gripper/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(wrapped) 	//The force of the wrapped obj gets set to zero during the attack() and afterattack().
		if(QDELETED(wrapped) || (wrapped.loc != src.loc && !istype(wrapped.loc,/obj/item/storage/internal/gripper))) //If our wrapper was deleted OR it's no longer in our internal gripper storage
			wrapped = null //we become null
		else
			wrapped.attack(M,user)
			M.attackby(wrapped, user)	//attackby reportedly gets procced by being clicked on, at least according to Anewbe.
			if(QDELETED(wrapped) || (wrapped.loc != src.loc && !istype(wrapped.loc,/obj/item/storage/internal/gripper))) //If our wrapper was deleted OR it's no longer in our internal gripper storage
				wrapped = null
			if(wrapped) //In the event nothing happened to wrapped, go back into the gripper.
				wrapped.loc = current_pocket
			return 1
	return 0

/obj/item/gripper/afterattack(var/atom/target, var/mob/living/user, proximity, params)

	if(!proximity)
		return // This will prevent them using guns at range but adminbuse can add them directly to modules, so eh.
	var/current_pocket_full = FALSE
	//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
	if(wrapped == current_pocket)
		current_pocket_full = TRUE
	if(!wrapped && current_pocket)
		if(LAZYLEN(current_pocket.contents))
			wrapped = current_pocket.contents[1]
			current_pocket_full = TRUE

	if(current_pocket && !LAZYLEN(current_pocket.contents)) //We have a pocket selected and it has no contents! This means we're an item OR we need to null our wrapper!
		if(istype(current_pocket.loc,/obj/item/storage/internal/gripper) && !LAZYLEN(current_pocket.loc.contents)) //If our pocket is a gripper, AND we have no contents, wrapped = null
			wrapped = null
		else if(!istype(current_pocket.loc,/obj/item/storage/internal/gripper)) //If our pocket is an item and we are not in the gripper, wrapped = null
			wrapped = null

	if(!LAZYLEN(pockets)) //Shouldn't happen, but safety first.
		to_chat(user, span_danger("Your gripper has nowhere to hold \the [target]."))
		return

	var/obj/item/storage/internal/gripper/selected_pocket //Find an open pocket to use in case we're trying to pick something up.
	for(var/obj/item/storage/internal/gripper/available_pocket in pockets)
		if(LAZYLEN(available_pocket.contents))
			continue
		selected_pocket = available_pocket
		break

	if(wrapped) //Already have an item.
		//Temporary put wrapped into user so target's attackby() checks pass.
		var/obj/previous_pocket = wrapped.loc
		wrapped.loc = user

		//Pass the attack on to the target. This might delete/relocate wrapped.
		var/resolved = target.attackby(wrapped,user)
		if(!resolved && wrapped && target)
			wrapped.afterattack(target,user,1)

		//If wrapped was neither deleted nor put into target, put it back into the gripper.
		if(wrapped && user && ((wrapped.loc == user) || wrapped.loc == previous_pocket))
			wrapped.loc = previous_pocket
		else
			wrapped = null
			return
		if((QDELETED(wrapped) || (wrapped.loc != current_pocket))) //We put our wrapped thing INTO something!
			wrapped = null
			current_pocket = pick(pockets)
			return
	else if(current_pocket_full) //Pocket is full. No grabbing more things.
		to_chat(user, "Your gripper is currently full! You can't pick anything else up!")
		return

	else if(istype(target,/obj/item)) //Check that we're not pocketing a mob.

		//...and that the item is not in a container.
		if(!isturf(target.loc))
			return

		var/obj/item/I = target

		if(I.anchored)
			to_chat(user,span_notice("You are unable to lift \the [I] from \the [I.loc]."))
			return

		//Check if the item is blacklisted.
		var/grab = 0
		for(var/typepath in can_hold)
			if(istype(I,typepath))
				grab = 1
				break

		//We can grab the item, finally.
		if(grab)
			to_chat(user, "You collect \the [I].")
			I.loc = selected_pocket
			wrapped = I
			return
		else
			to_chat(user, span_danger("Your gripper cannot hold \the [target]."))

	else if(istype(target,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = target
		if(A.opened)
			if(A.cell && is_type_in_list(A.cell, can_hold))

				wrapped = A.cell

				A.cell.add_fingerprint(user)
				A.cell.update_icon()
				A.cell.loc = selected_pocket
				A.cell = null

				A.charging = 0
				A.update_icon()

				user.visible_message(span_danger("[user] removes the power cell from [A]!"), "You remove the power cell.")

	else if(istype(target,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/A = target
		if(A.opened)
			if(A.cell && is_type_in_list(A.cell, can_hold))

				wrapped = A.cell

				A.cell.add_fingerprint(user)
				A.cell.update_icon()
				A.update_icon()
				A.cell.loc = current_pocket
				A.cell = null

				user.visible_message(span_danger("[user] removes the power cell from [A]!"), "You remove the power cell.")

//Different types of grippers!

/obj/item/gripper/engineering
	name = "Engineering Gripper"
	desc = "An integrated Engineering Gripper."
	icon_state = "gripper-omni"
	can_hold = list(BASIC_GRIPPER, CIRCUIT_GRIPPER, SHEET_GRIPPER)

/obj/item/gripper/drone
	name = "Drone Gripper"
	desc = "An integrated Drone Gripper."
	icon_state = "gripper-old"
	can_hold = list(BASIC_GRIPPER, SHEET_GRIPPER)

/obj/item/gripper/omni
	name = "omni gripper"
	desc = "A strange grasping tool that can hold anything a human can, but still maintains the limitations of application its more limited cousins have."
	icon_state = "gripper-omni"

	can_hold = list(OMNI_GRIPPER) // Testing and Event gripper.

// VEEEEERY limited version for mining borgs. Basically only for swapping cells and upgrading the drills.
/obj/item/gripper/miner
	name = "drill maintenance gripper"
	desc = "A simple grasping tool for the maintenance of heavy drilling machines."
	icon_state = "gripper-mining"

	can_hold = list(MINER_GRIPPER)

/obj/item/gripper/security
	name = "security gripper"
	desc = "A simple grasping tool for corporate security work."
	icon_state = "gripper-sec"

	can_hold = list(SECURITY_GRIPPER)

/obj/item/gripper/paperwork
	name = "paperwork gripper"
	desc = "A simple grasping tool for clerical work."

	can_hold = list(PAPERWORK_GRIPPER)

/obj/item/gripper/medical
	name = "medical gripper"
	desc = "A simple grasping tool for medical work."
	icon_state = "gripper-flesh"

	can_hold = list(BASIC_GRIPPER, ORGAN_GRIPPER, MEDICAL_GRIPPER)

/obj/item/gripper/research //A general usage gripper, used for toxins/robotics/xenobio/etc
	name = "scientific gripper"
	icon_state = "gripper-sci"
	desc = "A simple grasping tool suited to assist in a wide array of research applications."

	can_hold = list(BASIC_GRIPPER, CIRCUIT_GRIPPER, SHEET_GRIPPER, EXOSUIT_GRIPPER, ROBOTICS_ORGAN_GRIPPER, RESEARCH_GRIPPER)

/obj/item/gripper/circuit
	name = "circuit assembly gripper"
	icon_state = "gripper-circ"
	desc = "A complex grasping tool used for working with circuitry."

	can_hold = list(CIRCUIT_GRIPPER)

/obj/item/gripper/service //Used to handle food, drinks, and seeds.
	name = "service gripper"
	icon_state = "gripper-sheet"
	desc = "A simple grasping tool used to perform tasks in the service sector, such as handling food, drinks, and seeds."

	can_hold = list(SERVICE_GRIPPER)

/obj/item/gripper/gravekeeper	//Used for handling grave things, flowers, etc.
	name = "grave gripper"
	icon_state = "gripper-old"
	desc = "A specialized grasping tool used in the preparation and maintenance of graves."

	can_hold = list(GRAVEYARD_GRIPPER)

/obj/item/gripper/scene
	name = "misc gripper"
	desc = "A simple grasping tool that can hold a variety of 'general' objects..."

	can_hold = list(SCENE_GRIPPER)

/obj/item/gripper/no_use/organ
	name = "organ gripper"
	icon_state = "gripper-flesh"
	desc = "A specialized grasping tool used to preserve and manipulate organic material."

	can_hold = list(ORGAN_GRIPPER)

/obj/item/gripper/no_use/organ/Entered(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 1
		for(var/obj/item/organ/organ in O)
			organ.preserved = 1
	..()

/obj/item/gripper/no_use/organ/Exited(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 0
		for(var/obj/item/organ/organ in O)
			organ.preserved = 0
	..()

/obj/item/gripper/no_use/organ/robotics
	name = "robotics organ gripper"
	icon_state = "gripper-flesh"
	desc = "A specialized grasping tool used in robotics work."

	can_hold = list(ROBOTICS_ORGAN_GRIPPER)

/obj/item/gripper/no_use/mech
	name = "exosuit gripper"
	icon_state = "gripper-mech"
	desc = "A large, heavy-duty grasping tool used in construction of mechs."

	can_hold = list(EXOSUIT_GRIPPER)

/obj/item/gripper/no_use //Used when you want to hold and put items in other things, but not able to 'use' the item

/obj/item/gripper/no_use/attack_self(mob/user as mob)
	return

/obj/item/gripper/no_use/loader //This is used to disallow building with metal.
	name = "sheet loader"
	desc = "A specialized loading device, designed to pick up and insert sheets of materials inside machines."
	icon_state = "gripper-sheet"

	can_hold = list(SHEET_GRIPPER)

/*
 * Misc tools
 */
/obj/item/reagent_containers/glass/bucket/cyborg
	var/mob/living/silicon/robot/R
	var/last_robot_loc

/obj/item/reagent_containers/glass/bucket/cyborg/Initialize(mapload)
	. = ..()
	R = loc.loc
	RegisterSignal(src, COMSIG_OBSERVER_MOVED, PROC_REF(check_loc))

/obj/item/reagent_containers/glass/bucket/cyborg/proc/check_loc(atom/movable/mover, atom/old_loc, atom/new_loc)
	if(old_loc == R || old_loc == R.module)
		last_robot_loc = old_loc
	if(!istype(loc, /obj/machinery) && loc != R && loc != R.module)
		if(last_robot_loc)
			forceMove(last_robot_loc)
			last_robot_loc = null
		else
			forceMove(R)
		if(loc == R)
			hud_layerise()

/obj/item/reagent_containers/glass/bucket/cyborg/Destroy()
	UnregisterSignal(src, COMSIG_OBSERVER_MOVED)
	R = null
	last_robot_loc = null
	..()
