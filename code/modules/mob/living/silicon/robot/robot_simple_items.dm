// Robot toolbelts, such as screwdrivers and the like. All contained in one neat little package.
// The code for actually 'how these use the item inside of them instead of the item itself' can be found in _onclick/cyborg.dm (yes, click code, gross, I know.)
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

/*
 * Grippers
 */

//Simple borg hand.
//Limited use.
//If you want to add more items to the gripper, add them to the global define list for that gripper.
/obj/item/gripper
	name = "magnetic gripper"
	desc = "A simple grasping tool specialized in construction and engineering work."
	description_info = "Ctrl-Clicking on the gripper will drop whatever it is holding.<br>\
	Using an object on the gripper will interact with the item inside it, if it exists, instead."
	icon = 'icons/obj/device.dmi'
	icon_state = "gripper-omni"

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
	current_pocket = pick(pockets) //Pick a random pocket!

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
	drop_item()
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
			photo_images["[pocket_to_check.name]" + "[pocket_content.name]"] = image(icon = pocket_content.icon, icon_state = pocket_content.icon_state)

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
	if(wrapped) // We're interacting with the item inside. If you can hold a cup with 2 fingers and stick a straw in it, you could do that with a gripper and another robotic arm.
		wrapped.loc = src.loc
		var/resolved = wrapped.attackby(O, user)
		if(QDELETED(wrapped) || wrapped.loc != src.loc)	 //Juuuust in case.
			wrapped = null
		if(!resolved && wrapped && O)
			O.afterattack(wrapped,user,1)
			if(QDELETED(wrapped) || wrapped.loc != src.loc)	 // I don't know of a nicer way to do this.
				wrapped = null
		if(wrapped)
			wrapped.loc = current_pocket
		return resolved
	return ..()

/obj/item/gripper/verb/drop_gripper_item()

	set name = "Drop Item"
	set desc = "Release an item from your magnetic gripper."
	set category = "Abilities.Silicon"

	drop_item()

/obj/item/gripper/proc/drop_item()
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
		if(QDELETED(wrapped) || !istype(wrapped.loc, /obj/item/storage/internal/gripper)) //If our wrapper was deleted OR it's no longer in our internal gripper storage
			wrapped = null //we become null
		else
			wrapped.attack(M,user)
			M.attackby(wrapped, user)	//attackby reportedly gets procced by being clicked on, at least according to Anewbe.
			if(QDELETED(wrapped) || !istype(wrapped.loc, /obj/item/storage/internal/gripper))
				wrapped = null
			if(wrapped) //In the event nothing happened to wrapped, go back into the gripper.
				wrapped.loc = current_pocket
			return 1
	return 0

/obj/item/gripper/afterattack(var/atom/target, var/mob/living/user, proximity, params)

	if(!proximity)
		return // This will prevent them using guns at range but adminbuse can add them directly to modules, so eh.

	//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
	if(!wrapped && current_pocket)
		if(LAZYLEN(current_pocket.contents))
			wrapped = current_pocket.contents[1]

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
	can_hold = list(BASIC_GRIPPER, CIRCUIT_GRIPPER, SHEET_GRIPPER)

/obj/item/gripper/drone
	name = "Drone Gripper"
	desc = "An integrated Drone Gripper."
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
	icon_state = "gripper"
	desc = "A simple grasping tool used to perform tasks in the service sector, such as handling food, drinks, and seeds."

	can_hold = list(SERVICE_GRIPPER)

/obj/item/gripper/gravekeeper	//Used for handling grave things, flowers, etc.
	name = "grave gripper"
	icon_state = "gripper"
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
